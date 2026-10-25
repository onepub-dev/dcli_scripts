import 'dart:io';

import 'package:path/path.dart';

/// Deletes Node dependency directories from projects beneath [root].
///
/// A `node_modules` directory is deleted only when its parent contains a
/// `package.json`. Rust artifacts use [cleanStaleRustDepsDirectories]. Deleting
/// a whole target must not bypass its age protection.
int cleanProjectArtifacts(
  Directory root, {
  void Function(String path)? onDelete,
  void Function(String path, Object exception)? onError,
}) {
  var deleted = 0;

  void deleteArtifact(Directory artifact) {
    if (!artifact.existsSync()) {
      return;
    }

    try {
      artifact.deleteSync(recursive: true);
      deleted++;
      onDelete?.call(artifact.path);
    } on FileSystemException catch (exception) {
      onError?.call(artifact.path, exception);
    }
  }

  void visit(Directory directory) {
    List<FileSystemEntity> entries;
    try {
      entries = directory.listSync(followLinks: false);
    } on FileSystemException catch (exception) {
      onError?.call(directory.path, exception);
      return;
    }

    if (File(join(directory.path, 'package.json')).existsSync()) {
      deleteArtifact(Directory(join(directory.path, 'node_modules')));
    }

    for (final entry in entries) {
      if (entry is! Directory) {
        continue;
      }

      final name = basename(entry.path);
      // Never inspect dependency/build trees. Apart from being very large,
      // they contain manifests belonging to dependencies rather than projects.
      if (name == 'target' || name == 'node_modules') {
        continue;
      }
      visit(entry);
    }
  }

  if (root.existsSync()) {
    visit(root);
  }
  return deleted;
}

/// Deletes Cargo debug/release `deps` directories unused for [minimumAge].
///
/// A sibling `.fingerprint` directory or `.cargo-lock` file identifies Cargo
/// output, including custom target paths and cross-compilation profiles.
/// Regular files must have both access and modification times older than the
/// cutoff. Directory modification times count, but directory access times do
/// not: listing a directory during this scan refreshes its access time on many
/// filesystems and would otherwise prevent subsequent cleanup indefinitely.
/// Links are never followed; candidates with links or unreadable entries stay.
int cleanStaleRustDepsDirectories(
  Directory root, {
  Duration minimumAge = const Duration(days: 3),
  DateTime? now,
  void Function(String path)? onDelete,
  void Function(String path, Object exception)? onError,
}) {
  var deleted = 0;
  final cutoff = (now ?? DateTime.now()).subtract(minimumAge);

  bool isStale(Directory directory) {
    final stat = directory.statSync();
    if (stat.type != FileSystemEntityType.directory ||
        !stat.modified.isBefore(cutoff)) {
      return false;
    }
    for (final entry in directory.listSync(followLinks: false)) {
      if (entry is Link) {
        return false;
      }
      if (entry is Directory) {
        if (!isStale(entry)) {
          return false;
        }
      } else {
        final stat = entry.statSync();
        if (stat.type != FileSystemEntityType.file ||
            !stat.accessed.isBefore(cutoff) ||
            !stat.modified.isBefore(cutoff)) {
          return false;
        }
      }
    }
    return true;
  }

  void visit(Directory directory) {
    try {
      final profile = basename(directory.path);
      final cargoProfile = (profile == 'debug' || profile == 'release') &&
          (FileSystemEntity.typeSync(join(directory.path, '.fingerprint'),
                      followLinks: false) ==
                  FileSystemEntityType.directory ||
              FileSystemEntity.typeSync(join(directory.path, '.cargo-lock'),
                      followLinks: false) ==
                  FileSystemEntityType.file);
      for (final entry in directory.listSync(followLinks: false)) {
        if (entry is! Directory) {
          continue;
        }
        if (cargoProfile && basename(entry.path) == 'deps') {
          try {
            if (isStale(entry)) {
              entry.deleteSync(recursive: true);
              deleted++;
              onDelete?.call(entry.path);
            }
          } on FileSystemException catch (exception) {
            onError?.call(entry.path, exception);
          }
          continue;
        }
        // Dependencies and VCS internals are not independent build roots.
        if (basename(entry.path) != 'node_modules' &&
            basename(entry.path) != '.git') {
          visit(entry);
        }
      }
    } on FileSystemException catch (exception) {
      onError?.call(directory.path, exception);
    }
  }

  if (FileSystemEntity.typeSync(root.path, followLinks: false) ==
      FileSystemEntityType.directory) {
    visit(root);
  }
  return deleted;
}

/// Deletes `.dart_tool` directories beneath [root] whose newest entry is older
/// than [minimumAge].
int cleanStaleDartToolDirectories(
  Directory root, {
  Duration minimumAge = const Duration(days: 7),
  DateTime? now,
  void Function(String path)? onDelete,
  void Function(String path, Object exception)? onError,
}) {
  var deleted = 0;
  final currentTime = now ?? DateTime.now();

  void visit(Directory directory) {
    List<FileSystemEntity> entries;
    try {
      entries = directory.listSync(followLinks: false);
    } on FileSystemException catch (exception) {
      onError?.call(directory.path, exception);
      return;
    }

    for (final entry in entries) {
      if (entry is! Directory) {
        continue;
      }

      if (basename(entry.path) == '.dart_tool') {
        try {
          final newest = _newestModification(entry, onError);
          if (currentTime.difference(newest) > minimumAge) {
            entry.deleteSync(recursive: true);
            deleted++;
            onDelete?.call(entry.path);
          }
        } on FileSystemException catch (exception) {
          onError?.call(entry.path, exception);
        }
        continue;
      }

      visit(entry);
    }
  }

  if (root.existsSync()) {
    visit(root);
  }
  return deleted;
}

DateTime _newestModification(
  Directory directory,
  void Function(String path, Object exception)? onError,
) {
  var newest = directory.statSync().modified;

  for (final entry in directory.listSync(followLinks: false)) {
    try {
      final modified = entry.statSync().modified;
      if (modified.isAfter(newest)) {
        newest = modified;
      }

      if (entry is Directory) {
        final childNewest = _newestModification(entry, onError);
        if (childNewest.isAfter(newest)) {
          newest = childNewest;
        }
      }
    } on FileSystemException catch (exception) {
      onError?.call(entry.path, exception);
    }
  }
  return newest;
}
