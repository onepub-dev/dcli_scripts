#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

/// Syncs the current fork with a named GitHub upstream.
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', negatable: false)
    ..addOption('owner', abbr: 'o')
    ..addOption('repo', abbr: 'r');
  final parsed = parser.parse(args);
  if (!parsed.wasParsed('owner') || !parsed.wasParsed('repo')) {
    printerr('Usage: gitsyncfork --owner OWNER --repo REPO');
    exitCode = 1;
    return;
  }
  if (parsed['verbose'] as bool) Settings().setVerbose(enabled: true);
  final owner = parsed['owner'] as String;
  final repo = parsed['repo'] as String;
  for (final part in [owner, repo]) {
    if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$').hasMatch(part) ||
        part == '..') {
      throw FormatException('Invalid GitHub owner or repository name');
    }
  }

  final expected = 'https://github.com/$owner/$repo.git';
  final existing = Process.runSync('git', ['remote', 'get-url', 'upstream']);
  if (existing.exitCode != 0) {
    _git(['remote', 'add', 'upstream', expected]);
  } else {
    final current = (existing.stdout as String).trim();
    if (current != expected &&
        current != 'https://github.com/$owner/$repo' &&
        current != 'git@github.com:$owner/$repo.git') {
      throw StateError('Existing upstream remote is different: $current');
    }
  }
  _git(['fetch', 'upstream']);

  final head = Process.runSync('git', [
    'symbolic-ref',
    '--short',
    'refs/remotes/origin/HEAD',
  ]);
  late final String branch;
  if (head.exitCode == 0) {
    final full = (head.stdout as String).trim();
    if (!full.startsWith('origin/')) {
      throw StateError('Unexpected origin default branch');
    }
    branch = full.substring('origin/'.length);
  } else {
    final remote = Process.runSync('git', ['remote', 'show', 'origin']);
    if (remote.exitCode != 0) {
      throw StateError('Could not determine origin default branch');
    }
    final matches = RegExp(
      r'^\s*HEAD branch:\s*(\S+)\s*$',
      multiLine: true,
    ).firstMatch(remote.stdout as String);
    if (matches == null) {
      throw StateError('Could not determine origin default branch');
    }
    branch = matches.group(1)!;
  }
  if (Process.runSync('git', [
        'check-ref-format',
        '--branch',
        branch,
      ]).exitCode !=
      0) {
    throw FormatException('Invalid default branch');
  }
  _git(['switch', branch]);
  _git(['merge', 'upstream/$branch']);
}

void _git(List<String> args) {
  final result = Process.runSync('git', args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw StateError('git ${args.first} failed with ${result.exitCode}');
  }
}
