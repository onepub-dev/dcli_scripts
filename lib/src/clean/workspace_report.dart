import 'dart:io';

import 'package:path/path.dart';

enum WorkspaceClassification {
  unfinished('Unfinished work'),
  investigation('Needs investigation'),
  likelyFinished('Likely finished');

  const WorkspaceClassification(this.label);
  final String label;
}

/// A review prompt, never evidence that a workspace is safe to delete.
class WorkspaceReport {
  WorkspaceReport(this.path, this.latestModification, this.bytes, this.git,
      this.classification, this.reasons);

  final String path;
  final DateTime latestModification;

  /// Apparent regular-file bytes, including caches; links are not followed.
  final int bytes;
  final List<String> git;
  final WorkspaceClassification classification;
  final List<String> reasons;
}

/// Only known workspace containers are enumerated, not arbitrary old folders.
/// Documents/Codex uses date/task units, retaining evidence alongside repos.
List<Directory> discoverCodexWorkspaces(Directory home) {
  final result = <Directory>[];
  for (final root in [
    Directory(join(home.path, '.codex', 'workspaces')),
    Directory(join(home.path, 'git', '.codex.workspaces')),
  ]) {
    result.addAll(_children(root));
  }
  for (final date
      in _children(Directory(join(home.path, 'Documents', 'Codex')))) {
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(basename(date.path))) {
      result.addAll(_children(date));
    }
  }
  result.sort((a, b) => a.path.compareTo(b.path));
  return result;
}

Iterable<Directory> _children(Directory root) {
  if (FileSystemEntity.typeSync(root.path, followLinks: false) !=
      FileSystemEntityType.directory) {
    return const [];
  }
  return root.listSync(followLinks: false).whereType<Directory>().where(
        (entry) => !basename(entry.path).startsWith('.'),
      );
}

/// Reports unprotected workspaces strictly older than [minimumAge].
///
/// A `.clean-keep` entry anywhere in a candidate protects the whole candidate.
/// This marker controls retirement reporting only; ordinary cache cleanup is
/// independent. Source/directory mtimes and Git metadata (including a linked
/// worktree's external index/HEAD) determine age. Recognised generated caches
/// contribute size but not age. Errors suppress a candidate, never imply age.
/// No contents are removed, Git is offline, and optional index writes are off.
List<WorkspaceReport> reportOldCodexWorkspaces(
  Directory home, {
  DateTime? now,
  Duration minimumAge = const Duration(days: 30),
  void Function(String path, Object exception)? onError,
}) {
  final reports = <WorkspaceReport>[];
  final cutoff = (now ?? DateTime.now()).subtract(minimumAge);
  for (final workspace in discoverCodexWorkspaces(home)) {
    try {
      var latest = workspace.statSync().modified;
      var bytes = 0;
      var protected = false;
      final repos = <Directory>[];
      final files = <String>[];
      final caches = <String>[];
      final reasons = <String>[];

      void scan(Directory directory,
          {bool cache = false, bool external = false, bool metadata = false}) {
        final modified = directory.statSync().modified;
        if (!cache && modified.isAfter(latest)) {
          latest = modified;
        }
        for (final entry in directory.listSync(followLinks: false)) {
          final name = basename(entry.path);
          if (!external && name == '.clean-keep') {
            protected = true;
          }
          if (entry is Link) {
            if (!external && !cache && !metadata) {
              files.add(entry.path);
            }
            // Link creation/removal is reflected in its parent directory age.
            continue;
          }
          if (!external && !cache && !metadata && name == '.git') {
            repos.add(directory);
          }
          if (entry is Directory) {
            final generated = !metadata && _isCache(entry);
            if (generated && !external) {
              caches.add(entry.path);
            }
            scan(entry,
                cache: cache || generated,
                external: external,
                metadata: metadata || name == '.git');
          } else if (entry is File) {
            if (!external && !cache && !metadata && name != '.git') {
              files.add(entry.path);
            }
            final stat = entry.statSync();
            if (!external) {
              bytes += stat.size;
            }
            if (!cache && stat.modified.isAfter(latest)) {
              latest = stat.modified;
            }
          }
        }
      }

      scan(workspace);
      if (protected) {
        continue;
      }
      // A .git file points outside a linked worktree. Include its index and
      // HEAD timestamps without counting shared repository storage as its size.
      for (final repo in repos) {
        if (FileSystemEntity.typeSync(join(repo.path, '.git'),
                followLinks: false) ==
            FileSystemEntityType.file) {
          final result = _git(repo, ['rev-parse', '--absolute-git-dir']);
          if (result.exitCode != 0) {
            reasons.add('Unable to inspect Git metadata: ${repo.path}');
            continue;
          }
          scan(Directory((result.stdout as String).trim()), external: true);
        }
      }
      if (!latest.isBefore(cutoff)) {
        continue;
      }
      if (repos.isEmpty) {
        reasons.add('No Git repository found');
      }
      final outside = files
          .where((file) => !repos.any((repo) => isWithin(repo.path, file)));
      reasons.addAll(outside.map((file) => 'Non-build entry outside Git: '
          '${relative(file, from: workspace.path)}'));
      var unfinished = false;
      final git = <String>[];
      for (final repo in repos) {
        final inspection = _inspectRepo(repo, caches);
        unfinished = unfinished || inspection.unfinished;
        final label = relative(repo.path, from: workspace.path);
        git.add('$label: ${inspection.status}');
        reasons.addAll(inspection.reasons.map((reason) => '$label: $reason'));
      }
      final classification = unfinished
          ? WorkspaceClassification.unfinished
          : reasons.isNotEmpty
              ? WorkspaceClassification.investigation
              : WorkspaceClassification.likelyFinished;
      reports.add(WorkspaceReport(
          workspace.path, latest, bytes, git, classification, reasons));
    } on FileSystemException catch (exception) {
      onError?.call(workspace.path, exception);
    } on ProcessException catch (exception) {
      onError?.call(workspace.path, exception);
    }
  }
  return reports;
}

bool _isCache(Directory directory) {
  final manifest = switch (basename(directory.path)) {
    'target' => 'Cargo.toml',
    'node_modules' => 'package.json',
    '.dart_tool' => 'pubspec.yaml',
    _ => null,
  };
  return manifest != null &&
      FileSystemEntity.typeSync(join(directory.parent.path, manifest),
              followLinks: false) ==
          FileSystemEntityType.file;
}

({bool unfinished, String status, List<String> reasons}) _inspectRepo(
    Directory repo, List<String> caches) {
  final reasons = <String>[];
  final result = _git(repo, [
    'status',
    '--porcelain=v1',
    '--branch',
    '-z',
    '--untracked-files=all',
    '--ignore-submodules=none'
  ]);
  if (result.exitCode != 0) {
    return (
      unfinished: false,
      status: 'Git status unavailable',
      reasons: ['Git status unavailable']
    );
  }
  final entries = (result.stdout as String).split('\x00');
  final branch = entries.first.replaceFirst('## ', '');
  var tracked = 0;
  var untracked = 0;
  for (var i = 1; i < entries.length; i++) {
    final entry = entries[i];
    if (entry.length < 3) {
      continue;
    }
    if (entry.startsWith('??')) {
      untracked++;
    } else {
      tracked++;
      if (entry.substring(0, 2).contains(RegExp('[RC]'))) {
        i++;
      }
    }
  }
  var unfinished = tracked > 0 || untracked > 0;
  final upstream = _git(repo, ['rev-parse', '--verify', '@{upstream}']);
  var history = 'no upstream';
  if (upstream.exitCode != 0) {
    reasons.add('No resolvable configured upstream');
  } else {
    final counts = _git(
        repo, ['rev-list', '--left-right', '--count', 'HEAD...@{upstream}']);
    final values = (counts.stdout as String).trim().split(RegExp(r'\s+'));
    final ahead = values.isEmpty ? null : int.tryParse(values.first);
    final behind = values.length == 2 ? int.tryParse(values.last) : null;
    if (counts.exitCode != 0 || ahead == null || behind == null) {
      reasons.add('Unable to compare HEAD with local upstream ref');
      history = 'upstream comparison unavailable';
    } else {
      unfinished = unfinished || ahead > 0;
      history = '$ahead commits not in local upstream ref, $behind behind';
    }
  }
  final ignored = _git(
      repo, ['ls-files', '--others', '--ignored', '--exclude-standard', '-z']);
  if (ignored.exitCode != 0) {
    reasons.add('Unable to inspect ignored files');
  } else {
    for (final file in (ignored.stdout as String)
        .split('\x00')
        .where((file) => file.isNotEmpty)) {
      final path = join(repo.path, file);
      if (!caches.any((cache) => isWithin(cache, path))) {
        reasons.add('Unexplained ignored file: $file');
      }
    }
  }
  return (
    unfinished: unfinished,
    status: '$branch; $tracked tracked changes, '
        '$untracked untracked entries; $history',
    reasons: reasons,
  );
}

ProcessResult _git(Directory repo, List<String> arguments) {
  try {
    return Process.runSync(
      'git',
      ['--no-optional-locks', '-C', repo.path, ...arguments],
      environment: {'GIT_OPTIONAL_LOCKS': '0'},
    );
  } on ProcessException catch (exception) {
    return ProcessResult(0, 1, '', exception.message);
  }
}
