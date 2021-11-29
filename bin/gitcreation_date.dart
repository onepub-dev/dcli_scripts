#! /usr/bin/env dcli

import 'dart:convert';
import 'dart:io';
import 'package:dcli/dcli.dart';


/// Retrives the date a github repo was created.
void main(List<String> args) {
  final parser = ArgParser();
  parser.addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Logs additional details to the cli',
  );

  parser.addOption('owner', abbr: 'o', help: 'The github owner of the  repo.');
  parser.addOption('repo',
      abbr: 'r', help: 'The github repo name of the  repo.');

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

  withTempFile((jsonFile) {
    var url = 'https://api.github.com/repos/$owner/$repo';
    print('fetching $url');
    fetch(url: url, saveToPath: jsonFile);

    var json =
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
