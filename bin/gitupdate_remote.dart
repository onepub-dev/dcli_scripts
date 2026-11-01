#! /usr/bin/env dcli

/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// Updated a git 'remote' to a new owner.
///
/// Scans all subdirs for git projects
/// and then updates the remote to point the new owner.
/// git_update_remote --owner noojee
/// Handy if you move repos between owners.
void main(List<String> args) {
  final parser = ArgParser()
    ..addOption(
      'owner',
      abbr: 'o',
      mandatory: true,
      help: 'The owner/organisation of the repo',
    );

  ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));

    print(parser.usage);
    exit(1);
  }
  if (!results.wasParsed('owner')) {
    printerr(parser.usage);
    exitCode = 1;
    return;
  }
  final owner = results['owner'] as String;
  if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$').hasMatch(owner) ||
      owner == '..') {
    throw FormatException('Invalid GitHub owner name');
  }

  find('.git', includeHidden: true, types: [Find.directory]).forEach((gitPath) {
    final repoDir = dirname(gitPath);
    // print('Considering $repoDir');
    var remote = 'git remote -v'
        .start(workingDirectory: repoDir, progress: Progress.capture())
        .toList()
        .first;
    remote = remote.replaceAll(RegExp(r'\s+'), ' ');

    if (remote.contains('bitbucket')) {
      print(blue('remote $remote'));
      final parts = remote.split(' ');
      if (parts.length != 3) {
        printerr('Unexpected response: $remote');
        exit(1);
      }

      print('parts 1 ${parts[1]}');
      final repoParts = parts[1].split(':');
      if (repoParts.length != 2) {
        printerr('Unexpected response: ${parts[1]}');
        exit(1);
      }
      if (!repoParts[1].contains('$owner/')) {
        printerr(red("Skipping $remote as it isn't on the $owner repo"));
      } else {
        final repo = basenameWithoutExtension(repoParts[1]);

        print(
          orange(
            'updating remote for $repoDir to git@github.com:$owner/$repo.git',
          ),
        );

        final result = Process.runSync('git', [
          'remote',
          'set-url',
          'origin',
          'git@github.com:$owner/$repo.git',
        ], workingDirectory: repoDir);
        if (result.exitCode != 0) {
          throw StateError('Could not update $repoDir: ${result.stderr}');
        }
        'git pull'.start(workingDirectory: repoDir, progress: Progress.print());
        'git push'.start(workingDirectory: repoDir, progress: Progress.print());
      }
    } else {
      // print(blue('Skipping $repoDir'));
    }
  });
}
