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
