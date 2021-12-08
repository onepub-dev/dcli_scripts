#! /usr/bin/env dcli

// ignore: prefer_relative_imports
import 'dart:io';

import 'package:dcli/dcli.dart';

/// Cleans up disk space usage.
/// Cleans out unused docker objects
/// Performs a git clean
/// Finally runs hog to highlight directories that
/// take up lots of space.

void main(List<String> args) {
  print(blue('Cleaning unused docker containers'));
  'docker container prune  -f'.run;

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
    deleteDir('/tmp/dcli', recursive: true);
  }

  print(blue('Running hog'));
  'hog disk'.start(terminal: true, workingDirectory: HOME);
}
