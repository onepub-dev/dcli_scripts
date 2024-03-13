#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// Search all subdirectories looking for git projects
/// It then reports any that have uncommited files or which
/// need to be pushed.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('detail',
        abbr: 'd', help: 'Shows a list of any uncommited files');

  ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    print(parser.usage);
    exit(1);
  }
  final detail = results['detail'] as bool;

  find('.git', includeHidden: true, types: [Find.directory]).forEach((gitPath) {
    var uncommited = <String>[];
    gitPath = dirname(gitPath);
    // print('testing $gitPath');
    try {
      uncommited = 'git status --porcelain'
          .start(workingDirectory: gitPath, progress: Progress.capture())
          .toList();

      if (uncommited.isNotEmpty) {
        print('Uncommited files in $gitPath');
        if (detail) {
          uncommited.forEach(print);
        }
      } else {
        /// check if code has been pushed
        final status = 'git status'
            .start(workingDirectory: gitPath, progress: Progress.capture())
            .toList()
            .join('\n');

        if (!status.contains('Your branch is up to date with')) {
          print('Push required on $gitPath');
        }
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('error: $e');
      print(uncommited);
    }
  });
}
