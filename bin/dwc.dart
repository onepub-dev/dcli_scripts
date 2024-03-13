#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

void main(List<String> args) {
  final parser = ArgParser()..addFlag('verbose', abbr: 'v', negatable: false);

  final parsed = parser.parse(args);
  if (parsed.wasParsed('verbose')) {
    Settings().setVerbose(enabled: true);
  }

  if (parsed.rest.length != 1) {
    printerr(red('You must pass a wildcard for the files you want counted'));
    exit(1);
  }

  var total = 0;
  find(parsed.rest[0], workingDirectory: pwd).forEach((file) {
    final line = 'wc -l "$file"'.firstLine!;
    final parts = line.split(' ');
    if (parts.isEmpty) {
      printerr('Invalid line: $line');
    } else {
      final count = int.tryParse(parts[0])!;
      total += count;
    }
  });

  print('Total lines: $total');
}
