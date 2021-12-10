#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

const String tick = '''\xE2\x9C\x93''';

const String posixTick = '''\u2714''';

const String cross = 'x';

void main(List<String> args) {
  final parser = ArgParser()..addFlag('verbose', abbr: 'v', negatable: false);

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

  final url = parsed.rest[0];
  withTempFile((file) {
    fetch(
        url: url,
        method: FetchMethod.post,
        saveToPath: file,
        fetchProgress: showProgress);
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
      print('$key=>${value.join(',')}');
    });
  }
}

void showUsage(ArgParser parser) {
  print('Post a post url');
  print('post <url>');

  print(parser.usage);
}
