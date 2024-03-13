#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// ignore: prefer_relative_imports
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// Cleans up disk space usage.
/// Cleans out unused docker objects
/// Performs a git clean
/// Finally runs hog to highlight directories that
/// take up lots of space.

void main(List<String> args) {
  print(blue('cleaning .dart_tools..'));
  find('pubspec.yaml').forEach((path) {
    final tools = join(dirname(path), '.dart_tools');
    if (exists(tools)) {
      print('Deleting $tools');
      deleteDir(tools);
    }
  });

  print(blue('Cleaning unused docker containers'));
  'docker container prune  -f'.run;

  print(blue('Pruning unused docker volumes '));
  'docker volume prune'.run;

  print(blue('Pruning docker objects'));
  'docker system prune -a -f'.run;

  print(blue('Running git clean'));
  if (which('gitgc').notfound) {
    printerr(red('gitgc not found. Run dart pub global activate dcli_scripts'));
    exit(1);
  }
  'gitgc'.start(terminal: true, workingDirectory: join(HOME, 'git'));

  print(blue('cleaning dcli test directories..'));
  if (exists('/tmp/dcli')) {
    deleteDir('/tmp/dcli');
  }

  print(blue('Running hog'));
  'hog disk'.start(terminal: true, workingDirectory: HOME);
}
