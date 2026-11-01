import 'dart:io';

import 'package:path/path.dart';

import 'workspace_report.dart';

/// Finds MariaDB data directories directly inside known Codex workspaces.
/// Links and unrelated directories are never candidates.
Iterable<Directory> findCodexMariaDbData(Directory home) sync* {
  for (final workspace in discoverCodexWorkspaces(home)) {
    if (File(join(workspace.path, '.clean-keep')).existsSync()) {
      continue;
    }
    for (final entry in workspace.listSync(followLinks: false)) {
      if (entry is Directory && isMariaDbDataDirectory(entry)) {
        yield entry;
      }
    }
  }
}

bool isMariaDbDataDirectory(Directory directory) {
  final name = basename(directory.path);
  return name == 'mariadb-data' || name.startsWith('mariadb-data-');
}

/// Deletes a candidate only when every file and directory is older than the
/// cutoff, there are no links or keep markers, and [isInUse] is false.
/// The caller must check and delete in one scoped privilege call.
bool deleteStaleMariaDbData(
  Directory data, {
  required DateTime cutoff,
  required bool Function(Directory data) isInUse,
}) {
  if (!isMariaDbDataDirectory(data) ||
      FileSystemEntity.typeSync(
            data.path,
            followLinks: false,
          ) !=
          FileSystemEntityType.directory ||
      !_isUnusedSince(data, cutoff) ||
      isInUse(data)) {
    return false;
  }
  data.deleteSync(recursive: true);
  return true;
}

bool _isUnusedSince(Directory directory, DateTime cutoff) {
  if (!directory.statSync().modified.isBefore(cutoff)) {
    return false;
  }
  for (final entry in directory.listSync(followLinks: false)) {
    if (basename(entry.path) == '.clean-keep') {
      return false;
    }
    if (entry is Directory) {
      if (!_isUnusedSince(entry, cutoff)) {
        return false;
      }
    } else if (entry is File) {
      final stat = entry.statSync();
      if (!stat.modified.isBefore(cutoff) ||
          !stat.accessed.isBefore(cutoff)) {
        return false;
      }
    } else {
      return false;
    }
  }
  return true;
}
