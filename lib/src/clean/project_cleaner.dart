import 'dart:io';

import 'package:path/path.dart';

/// Deletes generated artifacts from projects beneath [root].
///
/// A `target` directory is deleted only when its parent contains a
/// `Cargo.toml`, and a `node_modules` directory is deleted only when its parent
/// contains a `package.json`.
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

    if (File(join(directory.path, 'Cargo.toml')).existsSync()) {
      deleteArtifact(Directory(join(directory.path, 'target')));
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

/// Deletes stale directory entries directly beneath [root].
int cleanStaleDirectories(
  Directory root, {
  Duration minimumAge = const Duration(days: 7),
  DateTime? now,
  void Function(String path)? onDelete,
  void Function(String path, Object exception)? onError,
}) {
  if (!root.existsSync()) {
    return 0;
  }

  var deleted = 0;
  final currentTime = now ?? DateTime.now();
  List<FileSystemEntity> entries;
  try {
    entries = root.listSync(followLinks: false);
  } on FileSystemException catch (exception) {
    onError?.call(root.path, exception);
    return 0;
  }

  for (final entry in entries) {
    if (entry is! Directory) {
      continue;
    }

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
