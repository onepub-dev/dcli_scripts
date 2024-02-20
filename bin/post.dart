#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:dcli_core/dcli_core.dart' as core;

/// dpath appname
/// print the systems PATH variable contents and validates each path.

// ignore: unreachable_from_main
const String tick = '''\xE2\x9C\x93''';

// ignore: unreachable_from_main
const String posixTick = '''\u2714''';

// ignore: unreachable_from_main
const String cross = 'x';

void main(List<String> args) async {
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
  await core.withTempFileAsync((file) async {
    await fetch(
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
