#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// this is a main.
// ignore: prefer_relative_imports
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/clean/project_cleaner.dart';
import 'package:dcli_scripts/src/clean/workspace_report.dart';
import 'package:dcli_scripts/src/git/git_gc.dart';
import 'package:dcli_scripts/src/hog/disk_hog.dart';
import 'package:path/path.dart';

const _minimumUnusedAge = Duration(hours: 8);

/// Cleans up disk space usage.
/// Cleans unused entries, including hidden entries, out of /tmp and local caches.
/// Cleans out unused docker objects
/// Performs a git clean
/// Finally runs hog to highlight directories that
/// take up lots of space.

void main(List<String> args) {
  if (!Shell.current.isPrivilegedProcess) {
    printerr(red('Run clean with sudo: sudo ./bin/clean.dart'));
    exitCode = 1;
    return;
  }
  Shell.current.releasePrivileges();

  _reportWorkspaces();
  _cleanCaches();

  final projectRoot = Directory(join(HOME, 'git'));
  print(blue('Cleaning Node project artifacts..'));
  final deletedArtifacts = cleanProjectArtifacts(
    projectRoot,
    onDelete: (path) => print('Deleting $path'),
    onError: (path, exception) =>
        printerr(yellow('Unable to clean $path: $exception')),
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
  runGitGc(
    projectRoot,
    onError: (path, exception) =>
        printerr(yellow('Unable to scan $path: $exception')),
  );

  print(blue('Running hog'));
  runDiskHog(
    Directory(HOME),
    onError: (path, exception) =>
        printerr(yellow('Unable to scan $path: $exception')),
  );
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
