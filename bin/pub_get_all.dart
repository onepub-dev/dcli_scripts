#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// Recursively runs pub get on all subdirectories.
void main() {
  for (final project in find('pubspec.yaml').toList()) {
    try {
      var pubspec = PubSpec.fromFile(project);

      if (pubspec.dependencies.keys.contains('flutter')) {
        print(blue('Flutter project: ${dirname(project)}'));
        if (which('flutter').notfound) {
          printerr(red('You need to install flutter to pub get this project'));
        } else {
          'flutter pub get'.start(
              workingDirectory: dirname(project), progress: Progress.devNull());
        }
      } else {
        print(blue('Dart: project: ${dirname(project)}'));
        'dart pub get'.start(
            workingDirectory: dirname(project), progress: Progress.devNull());
      }
    } catch (e) {
      printerr(red('pub get of ${dirname(project)} failed: $e'));
    }
    print('');
  }
}
