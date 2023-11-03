#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:pubspec_manager/pubspec_manager.dart';

/// Recursively runs pub get on all subdirectories.
void main() {
  for (final project in find('pubspec.yaml').toList()) {
    try {
      final pubspec = PubSpec.loadFromPath(project);

      if (pubspec.dependencies.exists('flutter')) {
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
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      printerr(red('pub get of ${dirname(project)} failed: $e'));
    }
    print('');
  }
}
