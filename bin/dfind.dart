#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:strings/strings.dart';

/// dfind <glob>
/// Recursively search for files that match the passed glob pattern.

void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Display this help information.')
    ..addOption('text', abbr: 't', help: 'Search for text within files.')
    ..addFlag('warnings', abbr: 'w', help: 'Show skipped files.');

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print('''
dfind [options] <glob>
Finds files that match the passed glob pattern
If you pass in --text <text> then dfind will search within the matched files

${parser.usage}
''');
    exit(0);
  }

  final searchText = results['text'] as String?;
  final showWarnings = results['warnings'] as bool;

  if (results.rest.isEmpty) {
    printerr('''You must provide a filename (glob pattern) to match on.''');
    exit(1);
  }

  final pattern = results.rest[0];

  if (Strings.isNotBlank(searchText)) {
    print(green(
        '''Searching for text "$searchText" within files matching pattern "$pattern"'''));

    find(pattern, includeHidden: true).forEach((file) {
      try {
        if (File(file).readAsStringSync().contains(searchText!)) {
          print(orange('Found "$searchText" in $file'));
        }
      } on FileSystemException catch (e) {
        if (e.message == "Failed to decode data using encoding 'utf-8'") {
          if (showWarnings) {
            print('Skipping binary file: $file');
          }
        } else {
          print('Error reading file $file: ${e.message}');
        }
      }
    });
  } else {
    print('Searching for files matching pattern $pattern');

    find(pattern, includeHidden: true).forEach(print);
  }
}
