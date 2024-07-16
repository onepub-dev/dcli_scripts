#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

/// dfind <glob>
/// Recursively search for files that match the passed glob pattern.

void main(List<String> args) {
  final parser = ArgParser();
  // ignore: cascade_invocations
  parser
    ..addFlag('help', abbr: 'h', help: 'Display this help information.')
    ..addOption('text', abbr: 't', help: 'Search for text within files.')
    ..addOption('pattern',
        abbr: 'p',
        help: 'Limit search to files matching the provided glob (pattern).');

  final results = parser.parse(args);

  if (results['help'] as bool) {
    print(parser.usage);
    exit(0);
  }

  final pattern = results['pattern'] as String? ?? '*';
  final searchText = results['text'] as String?;

  if (searchText == null && results.rest.isEmpty) {
    printerr(
        '''You must provide a filename (glob pattern) to search for or text to search within files.''');
    exit(1);
  }

  if (searchText != null) {
    print(
        '''Searching for text "$searchText" within files matching pattern "$pattern"''');

    find(pattern, includeHidden: true).forEach((file) {
      if (File(file).readAsStringSync().contains(searchText)) {
        print('Found "$searchText" in $file');
      }
    });
  } else {
    final globPattern = results.rest[0];
    print('Searching for files matching pattern $globPattern');

    find(globPattern, includeHidden: true).forEach(print);
  }
}
