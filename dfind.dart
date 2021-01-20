#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:args/args.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

void main(List<String> args) {
  var parser = ArgParser();

  var results = parser.parse(args);
  if (results.rest.isEmpty) {
    printerr('You must provide a filename to find');
    exit(1);
  }

  var pattern = results.rest[0];
  print('looking for $pattern');

  find(pattern, root: '.').forEach((file) => print(file));
}
