import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// Finds Git metadata directories beneath [root].
///
/// Directories which disappear during the scan are silently skipped. Other
/// filesystem errors are reported through [onError] without stopping the scan.
Iterable<Directory> findGitDirectories(
  Directory root, {
  void Function(String path, Object exception)? onError,
}) sync* {
  List<FileSystemEntity> entries;
  try {
    entries = root.listSync(followLinks: false);
  } on PathNotFoundException {
    return;
  } on FileSystemException catch (exception) {
    onError?.call(root.path, exception);
    return;
  }

  for (final entry in entries) {
    if (entry is! Directory) {
      continue;
    }

    final name = basename(entry.path);
    if (name == '.git') {
      yield entry;
      continue;
    }

    // Generated trees are both large and prone to changing while builds and
    // package managers are running. They cannot contain repositories to clean.
    if (name == 'target' || name == 'node_modules') {
      continue;
    }

    yield* findGitDirectories(entry, onError: onError);
  }
}

/// Runs `git gc` for every repository found beneath [root].
void runGitGc(
  Directory root, {
  void Function(String path, Object exception)? onError,
}) {
  for (final gitDirectory in findGitDirectories(root, onError: onError)) {
    print('cleaning ${gitDirectory.path}');
    'git gc'.start(
      workingDirectory: gitDirectory.path,
      progress: Progress.print(),
      nothrow: true,
    );
  }
}
