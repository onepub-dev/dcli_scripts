#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

/// Search for text within files with the given glob
void main(List<String> args) {
  final parser = ArgParser();

  final results = parser.parse(args);

  print(results.rest);

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
        print('file($count): $line');
      }
    });
  });
}