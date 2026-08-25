#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// this is a main.
// ignore: prefer_relative_imports
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/clean/project_cleaner.dart';
import 'package:path/path.dart';

const _minimumUnusedAge = Duration(hours: 8);

/// Cleans up disk space usage.
/// Cleans unused entries, including hidden entries, out of /tmp and local caches.
/// Cleans out unused docker objects
/// Performs a git clean
/// Finally runs hog to highlight directories that
/// take up lots of space.

void main(List<String> args) {
  _cleanCaches();

  print(blue('Cleaning Rust and Node project artifacts..'));
  cleanProjectArtifacts(
    Directory.current,
    onDelete: (path) => print('Deleting $path'),
    onError: (path, exception) =>
        printerr(yellow('Unable to clean $path: $exception')),
  );

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

  print(blue('Running hog'));
  'hog disk'.start(terminal: true, workingDirectory: HOME);
}

void _cleanCaches() {
  _cleanDirectory('/tmp');
  _cleanDirectory(join(HOME, '.gradle', 'caches'));
  _cleanDirectory(join(HOME, '.dartServer'));
  _cleanDirectory(join(HOME, '.cache'));
}

void _cleanDirectory(String path) {
  print(blue('Cleaning $path'));

  final directory = Directory(path);
  if (!directory.existsSync()) {
    return;
  }

  final openPaths = _findOpenPaths(path);
  if (openPaths == null) {
    printerr(yellow('Skipping $path because open files cannot be checked'));
    return;
  }

  final now = DateTime.now();
  for (final entry in directory.listSync(followLinks: false)) {
    try {
      final age = now.difference(entry.statSync().modified);
      final isOpen = openPaths.any((openPath) =>
          openPath == entry.path || isWithin(entry.path, openPath));

      if (age < _minimumUnusedAge || isOpen) {
        print('Keeping active entry ${entry.path}');
        continue;
      }

      entry.deleteSync(recursive: true);
    } on FileSystemException catch (exception) {
      printerr(yellow('Unable to delete ${entry.path}: ${exception.message}'));
    }
  }
}

Set<String>? _findOpenPaths(String path) {
  if (which('lsof').notfound) {
    return null;
  }

  try {
    final result = Process.runSync('lsof', ['-w', '-Fn', '+D', path]);
    return (result.stdout as String)
        .split('\n')
        .where((line) => line.startsWith('n'))
        .map((line) => line.substring(1))
        .toSet();
  } on ProcessException {
    return null;
  }
}
