#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

/// Syncs the current git repo with the upstream repo it was forked from.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Logs additional details to the cli',
    )
    ..addOption('owner',
        abbr: 'o', help: 'The github owner of the upstream repo.')
    ..addOption('repo',
        abbr: 'r', help: 'The github repo name of the upstream repo.');

  final parsed = parser.parse(args);

  if (parsed.wasParsed('verbose')) {
    Settings().setVerbose(enabled: true);
  }

  if (!parsed.wasParsed('owner')) {
    printerr(red('You must pass a owner'));
    showUsage(parser);
  }

  final upstreamOwner = parsed['owner'] as String;

  if (!parsed.wasParsed('repo')) {
    printerr(red('You must pass a repo'));
    showUsage(parser);
  }

  final upstreamRepo = parsed['repo'] as String;

  if (!hasUpstream(upstreamOwner, upstreamRepo)) {
    addUpstream(upstreamOwner, upstreamRepo);
  }

  'git fetch upstream'.run;

  final defaultBranch = getDefaultBranch();

  'git checkout $defaultBranch'.run;

  'git merge upstream/$defaultBranch'.run;
}

bool hasUpstream(String upstreamOwner, String upstreamRepo) {
  final remotes = getRemotes();
  var found = false;
  for (final remote in remotes) {
    if (remote.contains('upstream') &&
        remote.contains(upstreamOwner) &&
        remote.contains(upstreamRepo)) {
      found = true;
      break;
    }
  }

  return found;
}

void addUpstream(String upstreamOwner, String upstreamRepo) {
  'git remote add upstream https://github.com/$upstreamOwner/$upstreamRepo'.run;
  'git remote -v'.run;
}

List<String> getRemotes() => 'git remote -v'.toList();

String getDefaultBranch() {
  final lines = 'git remote show origin'.toList(skipLines: 3);

  if (lines.isEmpty) {
    throw Exception('Unable to get default branch name');
  }

  final line = lines.first.trim();

  final parts = line.split(' ');

  return parts[2];
}

// ignore: unreachable_from_main
String getBranch() {
  final line = 'git status'.firstLine;

  if (line == null) {
    throw Exception('Unable to get branch name');
  }

  final parts = line.trim().split(' ');

  return parts[2];
}

void showUsage(ArgParser parser) {
  print('Usage: gitsyncfork.dart -v -prompt <a questions>');
  print(parser.usage);
  exit(1);
}
