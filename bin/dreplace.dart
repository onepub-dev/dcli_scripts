#! /usr/bin/env dcli
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

void main(List<String> args) {
  var parser = ArgParser()
    ..addOption('dir', abbr: 'd', help: 'root directory to start search from')
    ..addOption('find', abbr: 'f', help: 'The text to find')
    ..addOption('replace', abbr: 'r', help: 'The text to replace "find" with');

  var parsed = parser.parse(args);

  if (parsed.rest.isEmpty) {
    printerr(red('You must provide a list of files or globs to process'));
    showUsage(parser);
  }

  var workingDir = pwd;

  if (parsed.wasParsed('dir')) {
    workingDir = parsed['dir'] as String;
  }

  if (!parsed.wasParsed('find')) {
    printerr(red('You must provide a "find" argument'));
    showUsage(parser);
  }

  if (!parsed.wasParsed('replace')) {
    printerr(red('You must provide a "replace" argument'));
    showUsage(parser);
  }

  final from = parsed['find'] as String;
  final to = parsed['replace'] as String;

  workingDir = parsed['dir'] as String;

  var patterns = parsed.rest;

  for (var pattern in patterns) {
    print('scanning for $pattern');
    find(pattern, workingDirectory: workingDir)
        .forEach((file) => update(file, from, to));
  }
}

void update(String path, String from, String to) {
  print('processing $path');
  replace(path, from, to, all: true);
}

void showUsage(ArgParser parser) {
  print(
      'Searches for and replaces a text string in matching file patterns recursively');
  print(parser.usage);
  exit(1);
}
