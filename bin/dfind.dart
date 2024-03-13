#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

void main(List<String> args) {
  final parser = ArgParser();

  final results = parser.parse(args);
  if (results.rest.isEmpty) {
    printerr('You must provide a filename to find');
    exit(1);
  }

  final pattern = results.rest[0];
  print('looking for $pattern');

  find(pattern, includeHidden: true).forEach(print);
}
