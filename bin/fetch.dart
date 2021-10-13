#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:args/args.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  late final ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  if (parsed.rest.length != 1) {
    printerr(red('You must pass the url as the one and only arg'));
    showUsage(parser);
    exit(1);
  }

  var url = parsed.rest[0];
  withTempFile((file) {
    fetch(
        url: url,
        method: FetchMethod.get,
        saveToPath: file,
        fetchProgress: (progress) {
          showProgress(progress);
        });
    print(green('Data Recieved'));
    cat(file);
  }, create: false);
}

void showProgress(FetchProgress progress) {
  if (progress.status == FetchStatus.response) {
    print(blue('Response: ${progress.responseCode}'));
  }

  if (progress.headers != null) {
    print(blue('Headers'));
    progress.headers?.forEach((key, value) {
      print('$key=>' + value.join(','));
    });
  }
}

void showUsage(ArgParser parser) {
  print('Gets url');
  print('fetch <url>');

  print(parser.usage);
}
