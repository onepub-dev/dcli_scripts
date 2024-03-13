#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

/// Script to migrate bitbucket repos into github.
/// You need to provide a csv file containing a list of repos on bitbucket
/// The csv file must contain two columns:
/// repo_name, repo_url
/// e.g.
/// adfiler,https://<user>@bitbucket.org/<org>>/<repo_name>.git
library;

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:settings_yaml/settings_yaml.dart';

void main() {
  const list = 'repo.list.csv';
  if (!exists(list)) {
    printerr('List not found');
    exit(1);
  }
  final repos = read(list).toList();

  for (final repo in repos) {
    if (repo.trim().isEmpty) {
      continue;
    }
    final parts = repo.split(',');
    final name = parts[0].replaceAll('"', '');
    final url = parts[1].replaceAll('"', '');
    import(name, url);
  }
}

void import(String name, String url) {
  final settings = SettingsYaml.load(pathToSettings: 'bitbucket.yaml');
  final password = settings['password'] as String;
  final token = settings['gittoken'] as String;
  final username = settings['gitusername'] as String;
  final owner = settings['gitowner'] as String;

  Settings().setVerbose(enabled: false);

  createGithubRepo(owner, name);

  withTempDir((dir) {
    print('Cloning into $dir');
    final _url = url.replaceAll('@', ':$password@');

    'git clone --bare $_url'
        .start(workingDirectory: dir, progress: Progress.print());

    'git push --mirror https://$username:$token@github.com/$owner/$name.git'
        .start(
            workingDirectory: join(dir, '$name.git'),
            progress: Progress.print());
  }, keep: true);
}

void createGithubRepo(String owner, String name) {
  withTempDir((dir) {
    final url = 'git@github.com:$owner/$name.git';
    'gh repo create  $url --confirm --private'
        .start(workingDirectory: dir, progress: Progress.print());
    'git init'.start(workingDirectory: dir, progress: Progress.print());
    touch(join(dir, 'README.md'), create: true);
    'git add README.md'
        .start(workingDirectory: dir, progress: Progress.print());
    'git commit -m "first commit"'
        .start(workingDirectory: dir, progress: Progress.print());

    'git remote add origin $url'
        .start(workingDirectory: dir, progress: Progress.print());

    'git push -u origin master'
        .start(workingDirectory: dir, progress: Progress.print());
  });
}
