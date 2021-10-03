#! /usr/bin/env dcli

// ignore: prefer_relative_imports
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
  join(DartProject.self.pathToBinDir, 'gitgc.dart')
      .start(terminal: true, workingDirectory: '/home/bsutton/git');

  print(blue('cleaning dcli test directories..'));
  deleteDir('/tmp/dcli', recursive: true);

  print(blue('Running hog'));
  join(DartProject.self.pathToBinDir, 'hog.dart disk')
      .start(terminal: true, workingDirectory: '/home/bsutton');
}
