#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

/// Updated a git 'remote' to a new owner.
///
/// Scans all subdirs for git projects
/// and then updates the remote to point the new owner.
/// git_update_remote --owner noojee
/// Handy if you move repos between owners.
void main(List<String> args) {
  var parser = ArgParser();
  parser.addOption('owner',
      abbr: 'o', mandatory: true, help: 'The owner/organisation of the repo');

  ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));

    print(parser.usage);
    exit(1);
  }
  var owner = results['owner'] as String;

  find('.git', includeHidden: true, types: [Find.directory]).forEach((gitPath) {
    var repoDir = dirname(gitPath);
    // print('Considering $repoDir');
    var remote = 'git remote -v'
        .start(workingDirectory: repoDir, progress: Progress.capture())
        .toList()
        .first;
    remote = remote.replaceAll(RegExp(r'\s+'), ' ');

    if (remote.contains('bitbucket')) {
      print(blue('remote $remote'));
      var parts = remote.split(' ');
      if (parts.length != 3) {
        printerr('Unexpected response: $remote');
        exit(1);
      }

      print('parts 1 ${parts[1]}');
      var repoParts = parts[1].split(':');
      if (repoParts.length != 2) {
        printerr('Unexpected response: ${parts[1]}');
        exit(1);
      }
      if (!repoParts[1].contains('$owner/')) {
        printerr(red("Skipping $remote as it isn't on the $owner repo"));
      } else {
        var repo = basenameWithoutExtension(repoParts[1]);

        print(orange(
            'updating remote for $repoDir to git@github.com:$owner/$repo.git'));

        'git remote set-url origin git@github.com:$owner/$repo.git'
            .start(workingDirectory: repoDir, progress: Progress.print());
        'git pull'.start(workingDirectory: repoDir, progress: Progress.print());
        'git push'.start(workingDirectory: repoDir, progress: Progress.print());
      }
    } else {
      // print(blue('Skipping $repoDir'));
    }
  });
}
