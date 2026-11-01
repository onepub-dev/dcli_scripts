#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// this is a main.
// ignore: prefer_relative_imports
import 'dart:convert';
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/clean/mariadb_cleaner.dart';
import 'package:dcli_scripts/src/clean/project_cleaner.dart';
import 'package:dcli_scripts/src/clean/workspace_report.dart';
import 'package:dcli_scripts/src/git/git_gc.dart';
import 'package:dcli_scripts/src/hog/disk_hog.dart';
import 'package:path/path.dart';

const _minimumUnusedAge = Duration(hours: 8);
const _mariaDbUnusedAge = Duration(days: 30);

/// Cleans up disk space usage.
/// Cleans unused entries, including hidden entries, out of /tmp and local caches.
/// Cleans out unused docker objects
/// Performs a git clean
/// Finally runs hog to highlight directories that
/// take up lots of space.

void main(List<String> args) {
  if (!Shell.current.isPrivilegedProcess) {
    printerr(red('Run clean with sudo: sudo clean'));
    exitCode = 1;
    return;
  }
  Shell.current.releasePrivileges();

  _cleanCodexMariaDbData();
  _reportWorkspaces();
  _cleanCaches();

  final projectRoot = Directory(join(HOME, 'git'));
  print(blue('Cleaning Node project artifacts..'));
  final deletedArtifacts = cleanProjectArtifacts(
    projectRoot,
    onDelete: (path) => print('Deleting $path'),
    onError: (path, exception) =>
        printerr(yellow('Unable to clean $path: $exception')),
    onPermissionDenied: (artifact) {
      if (basename(artifact.path) != 'node_modules' ||
          !isWithin(projectRoot.path, artifact.path) ||
          FileSystemEntity.typeSync(artifact.path, followLinks: false) !=
              FileSystemEntityType.directory ||
          !File(join(artifact.parent.path, 'package.json')).existsSync()) {
        throw FileSystemException('Invalid Node artifact', artifact.path);
      }
      try {
        Shell.current.withPrivileges(
          () => artifact.deleteSync(recursive: true),
        );
      } finally {
        Shell.current.releasePrivileges();
      }
    },
  );
  print('Deleted $deletedArtifacts project artifact directories');

  print(blue('Cleaning Rust deps unused for more than three days..'));
  var deletedRustDeps = 0;
  for (final root in [
    projectRoot,
    Directory(join(HOME, 'Documents', 'Codex')),
    Directory(join(HOME, 'pretemp', 'tmp')),
    Directory(join(HOME, '.codex', 'workspaces')),
  ]) {
    deletedRustDeps += cleanStaleRustDepsDirectories(
      root,
      onDelete: (path) => print('Deleting $path'),
      onError: (path, exception) =>
          printerr(yellow('Unable to clean $path: $exception')),
    );
  }
  print('Deleted $deletedRustDeps stale Rust deps directories');

  print(blue('Cleaning stale .dart_tool directories..'));
  final deletedDartTools = cleanStaleDartToolDirectories(
    projectRoot,
    onDelete: (path) => print('Deleting $path'),
    onError: (path, exception) =>
        printerr(yellow('Unable to clean $path: $exception')),
  );
  print('Deleted $deletedDartTools stale .dart_tool directories');

  print(blue('Cleaning unused docker containers'));
  'docker container prune  -f'.run;

  print(blue('Pruning unused docker volumes '));
  'docker volume prune -f'.run;

  print(blue('Pruning docker objects'));
  'docker system prune -a -f'.run;

  print(blue('Running git clean'));
  late final List<Directory> gitDirectories;
  try {
    Shell.current.withPrivileges(() {
      gitDirectories = findGitDirectories(
        projectRoot,
        onError: (path, exception) =>
            printerr(yellow('Unable to scan $path: $exception')),
      ).toList();
    });
  } finally {
    Shell.current.releasePrivileges();
  }
  runGitGcDirectories(gitDirectories);

  print(blue('Running hog'));
  final home = Directory(HOME);
  final mountedDirectories = mountedDirectoriesUnder(home);
  try {
    Shell.current.withPrivileges(() {
      runDiskHog(
        home,
        excludedPaths: mountedDirectories,
        onError: (path, exception) =>
            printerr(yellow('Unable to scan $path: $exception')),
      );
    });
  } finally {
    Shell.current.releasePrivileges();
  }
}

void _cleanCodexMariaDbData() {
  print(blue('Cleaning Codex MariaDB data unused for 30 days..'));
  List<String>? bindSources;
  try {
    try {
      Shell.current.withPrivileges(() {
        bindSources = _dockerBindSources();
      });
    } finally {
      Shell.current.releasePrivileges();
    }
  } on ProcessException catch (exception) {
    printerr(yellow('Skipping MariaDB cleanup: $exception'));
    return;
  }
  if (bindSources == null || which('lsof').notfound) {
    printerr(yellow('Skipping MariaDB cleanup: Docker or lsof is unavailable'));
    return;
  }

  var deleted = 0;
  final cutoff = DateTime.now().subtract(_mariaDbUnusedAge);
  try {
    for (final data in findCodexMariaDbData(Directory(HOME))) {
      try {
        try {
          Shell.current.withPrivileges(() {
            if (deleteStaleMariaDbData(
              data,
              cutoff: cutoff,
              isInUse: (candidate) =>
                  _isDockerMounted(candidate, bindSources!) ||
                  _hasOpenFiles(candidate),
            )) {
              deleted++;
              print('Deleting ${data.path}');
            }
          });
        } finally {
          Shell.current.releasePrivileges();
        }
      } on FileSystemException catch (exception) {
        printerr(yellow('Unable to clean ${data.path}: $exception'));
      }
    }
  } on FileSystemException catch (exception) {
    printerr(yellow('Unable to discover Codex MariaDB data: $exception'));
  }
  print('Deleted $deleted stale MariaDB data directories');
}

List<String>? _dockerBindSources() {
  final containers = Process.runSync('docker', ['ps', '-aq']);
  if (containers.exitCode != 0) {
    return null;
  }
  final ids = (containers.stdout as String)
      .split('\n')
      .where((id) => id.isNotEmpty)
      .toList();
  if (ids.isEmpty) {
    return <String>[];
  }
  final inspection = Process.runSync('docker', ['inspect', ...ids]);
  if (inspection.exitCode != 0) {
    return null;
  }
  Object? decoded;
  try {
    decoded = jsonDecode(inspection.stdout as String);
  } on FormatException {
    return null;
  }
  if (decoded is! List) {
    return null;
  }
  final sources = <String>[];
  for (final container in decoded) {
    if (container is! Map || container['Mounts'] is! List) {
      return null;
    }
    for (final mount in container['Mounts'] as List) {
      if (mount is Map &&
          mount['Type'] == 'bind' &&
          mount['Source'] is String) {
        sources.add(mount['Source'] as String);
      }
    }
  }
  return sources;
}

bool _isDockerMounted(Directory data, List<String> bindSources) =>
    bindSources.any((source) =>
        source == data.path ||
        isWithin(source, data.path) ||
        isWithin(data.path, source));

bool _hasOpenFiles(Directory data) {
  final result = Process.runSync('lsof', ['-w', '-Fn', '+D', data.path]);
  return result.exitCode != 1 ||
      (result.stdout as String).trim().isNotEmpty ||
      (result.stderr as String).trim().isNotEmpty;
}

void _reportWorkspaces() {
  print(blue('Codex workspace review (report only; nothing retired)..'));
  print('The optional .clean-keep marker hides a workspace from this report. '
      'Known cache cleanup remains independent.');
  print(
      'Git evidence uses local upstream refs, which may be stale; no fetch is '
      'performed. Likely finished does not establish safe deletion.');
  try {
    final reports = reportOldCodexWorkspaces(
      Directory(HOME),
      onError: (path, exception) =>
          printerr(yellow('Unable to inspect $path: $exception')),
    );
    for (final classification in WorkspaceClassification.values) {
      final group =
          reports.where((report) => report.classification == classification);
      print(blue('${classification.label} (${group.length})'));
      for (final report in group) {
        final age = DateTime.now().difference(report.latestModification).inDays;
        final size = (report.bytes / (1024 * 1024)).toStringAsFixed(1);
        print(
            '${report.path}: ${age}d since latest change, $size MiB apparent');
        if (report.git.isEmpty) {
          print('  No Git repository found; may contain non-Git work.');
        }
        for (final status in report.git.take(5)) {
          print('  $status');
        }
        if (report.git.length > 5) {
          print('  ${report.git.length - 5} additional nested repositories');
        }
        for (final reason in report.reasons.take(10)) {
          print('  $reason');
        }
        if (report.reasons.length > 10) {
          print('  ${report.reasons.length - 10} additional '
              'investigation reasons');
        }
      }
    }
    print('${reports.length} workspaces older than 30 days for manual review; '
        'age and Git status do not establish safe deletion.');
  } on FileSystemException catch (exception) {
    printerr(yellow('Unable to discover Codex workspaces: $exception'));
  }
}

void _cleanCaches() {
  // Resolve the invoking user's paths before temporarily restoring root's HOME.
  final paths = [
    '/tmp',
    join(HOME, '.gradle', 'caches'),
    join(HOME, '.dartServer'),
    join(HOME, '.cache'),
  ];
  for (final path in paths) {
    try {
      // Both lsof and deletion need access to protected cache entries.
      Shell.current.withPrivileges(() => _cleanDirectory(path));
    } finally {
      Shell.current.releasePrivileges();
    }
  }
}

void _cleanDirectory(String path) {
  print(blue('Cleaning $path'));

  final directory = Directory(path);
  if (!directory.existsSync()) {
    return;
  }

  final openPaths = _findOpenPaths(path);
  if (openPaths == null) {
    printerr(yellow('Skipping $path because open files cannot be checked'));
    return;
  }

  final now = DateTime.now();
  for (final entry in directory.listSync(followLinks: false)) {
    try {
      final age = now.difference(entry.statSync().modified);
      final isOpen = openPaths.any((openPath) =>
          openPath == entry.path || isWithin(entry.path, openPath));

      if (age < _minimumUnusedAge || isOpen) {
        print('Keeping active entry ${entry.path}');
        continue;
      }

      entry.deleteSync(recursive: true);
    } on FileSystemException catch (exception) {
      printerr(yellow('Unable to delete ${entry.path}: ${exception.message}'));
    }
  }
}

Set<String>? _findOpenPaths(String path) {
  if (which('lsof').notfound) {
    return null;
  }

  try {
    final result = Process.runSync('lsof', ['-w', '-Fn', '+D', path]);
    return (result.stdout as String)
        .split('\n')
        .where((line) => line.startsWith('n'))
        .map((line) => line.substring(1))
        .toSet();
  } on ProcessException {
    return null;
  }
}
