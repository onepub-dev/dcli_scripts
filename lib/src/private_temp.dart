import 'dart:io';

import 'package:path/path.dart' as path;

/// Creates a temporary directory inaccessible to other local users.
Directory createPrivateTemporaryDirectory(String parent, String prefix) {
  if (Platform.isWindows) {
    return Directory(parent).createTempSync(prefix);
  }
  final result = Process.runSync('mktemp', [
    '-d',
    path.join(parent, '${prefix}XXXXXX'),
  ]);
  if (result.exitCode != 0) {
    throw StateError('Could not create private temporary directory');
  }
  final directory = Directory((result.stdout as String).trim());
  if (!directory.existsSync() || (directory.statSync().mode & 0x3f) != 0) {
    throw StateError('Temporary directory is not private');
  }
  return directory;
}
