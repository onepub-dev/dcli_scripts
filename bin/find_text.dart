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

/// Search for text within files with the given glob
void main(List<String> args) {
  final parser = ArgParser();

  final results = parser.parse(args);

  if (results.rest.length != 2) {
    printerr('You must provide a filename and text to search for.');
    print('find_text <match text> "glob"');
    print(orange('Note: the glob MUST be enclosed in quotes'));
    exit(1);
  }

  final text = results.rest[0];
  final glob = results.rest[1];
  print('Looking for $text in $glob');

  final reg = RegExp(text);
  find(glob).forEach((file) {
    var count = 0;
    read(file).forEach((line) {
      count++;
      if (reg.hasMatch(line)) {
        print('${relative(file)}($count): $line');
      }
    });
  });
}
