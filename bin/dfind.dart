#! /usr/bin/env dcli

import 'dart:io';
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
