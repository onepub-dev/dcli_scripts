#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:dcli_core/dcli_core.dart' as core;

/// Retrives the date a github repo was created.
void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Logs additional details to the cli',
    )
    ..addOption('owner', abbr: 'o', help: 'The github owner of the  repo.')
    ..addOption('repo', abbr: 'r', help: 'The github repo name of the  repo.');

  final parsed = parser.parse(args);

  if (parsed.wasParsed('verbose')) {
    Settings().setVerbose(enabled: true);
  }

  if (!parsed.wasParsed('owner')) {
    printerr(red('You must pass a owner'));
    showUsage(parser);
  }

  final owner = parsed['owner'] as String;

  if (!parsed.wasParsed('repo')) {
    printerr(red('You must pass a repo'));
    showUsage(parser);
  }

  final repo = parsed['repo'] as String;

  await core.withTempFileAsync((jsonFile) async {
    final url = 'https://api.github.com/repos/$owner/$repo';
    print('fetching $url');
    await fetch(url: url, saveToPath: jsonFile);

    final json =
        jsonDecode(read(jsonFile).toList().join('\n')) as Map<String, dynamic>;
    if (json.containsKey('created_at')) {
      print(json['created_at']);
    } else {
      print(json);
    }
  }, create: false);
}

void showUsage(ArgParser parser) {
  print('Usage: gitsyncfork.dart -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}
