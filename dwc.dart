#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:args/args.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser..addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  var parsed = parser.parse(args);
  if (parsed.wasParsed('verbose')) {
    Settings().setVerbose(enabled: true);
  }

  if (parsed.rest.length != 1) {
    printerr(red('You must pass a wildcard for the files you want counted'));
    exit(1);
  }

  var total = 0;
  find(parsed.rest[0], root: pwd, recursive: true).forEach((file) {
    var line = 'wc -l $file'.firstLine;
    var parts = line.split(' ');
    if (parts.isEmpty) {
      printerr('Invalid line: $line');
    } else {
      var count = int.tryParse(parts[0]);
      total += count;
    }
  });

  print('Total lines: $total');
}
