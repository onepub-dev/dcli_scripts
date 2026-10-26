#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/private_temp.dart';
import 'package:path/path.dart' as path;

/// Creates a desktop launcher for a selected Eclipse installation.
void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    print('Selects an Eclipse installation and creates eclipse.desktop');
    return;
  }
  final installs = find(
    '*',
    recursive: false,
    workingDirectory: path.join(HOME, 'apps', 'eclipse'),
    types: [FileSystemEntityType.directory],
  ).toList();
  final install = menu('Select eclipse version to use: ', options: installs);
  final executable = path.join(install, 'eclipse');
  final icon = path.join(install, 'icon.xpm');
  if (!RegExp(r'^[A-Za-z0-9_./ +\-]+$').hasMatch(executable) ||
      !RegExp(r'^[A-Za-z0-9_./ +\-]+$').hasMatch(icon)) {
    throw FormatException('Eclipse path contains unsafe launcher characters');
  }

  final applicationDir = path.join(HOME, '.local', 'share', 'applications');
  Directory(applicationDir).createSync(recursive: true);
  final destination = path.join(applicationDir, 'eclipse.desktop');
  if (FileSystemEntity.typeSync(destination, followLinks: false) ==
      FileSystemEntityType.link) {
    throw FileSystemException('Refusing linked launcher', destination);
  }
  final stagedDir = createPrivateTemporaryDirectory(
    applicationDir,
    '.launcher-',
  );
  try {
    final staged = File(path.join(stagedDir.path, 'eclipse.desktop'));
    staged.writeAsStringSync('''[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse
Comment=Java IDE
Categories=Development;IDE;
Terminal=false
Icon=$icon
Exec=env GTK_THEME=Adwaita "$executable"
''');
    staged.renameSync(destination);
  } finally {
    stagedDir.deleteSync(recursive: true);
  }
  print('Created: $destination');
}
