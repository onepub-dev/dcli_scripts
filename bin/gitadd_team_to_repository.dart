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
///
/// You need to provide a 'github.yaml' file (in the cwd)
/// that contains a git personal access token
/// ```yaml
///   gittoken: ASDFZcvaskjwerf
/// ```
library;

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

/// Adds the given team to every repo owned by the passed organisation.
void main(List<String> args) {
  final argParser = ArgParser()
    ..addOption('team',
        abbr: 't',
        mandatory: true,
        help: 'Name of the team to assign to the repos')
    ..addOption('owner',
        abbr: 'o',
        mandatory: true,
        help: 'Name of owner/org that owns the repos')
    ..addOption('permission',
        abbr: 'p',
        allowed: ['admin', 'push', 'pull'],
        defaultsTo: 'pull',
        help: 'Sets the permission the team has on the repos.');

  ArgResults results;

  try {
    results = argParser.parse(args);
  } on FormatException catch (e) {
    printerr(e.message);
    print(argParser.usage);
    exit(1);
  }

  final team = results['team'] as String;
  final owner = results['owner'] as String;
  final permission = results['permission'] as String;

  final json = 'gh repo list --json "owner,name,url" $owner -L 10000'
      .parser()
      .jsonDecode() as List<dynamic>;

  for (final repo in json) {
    final map = repo as Map<String, dynamic>;
    final name = map['name'] as String;
    final ownerMap = map['owner'] as Map<String, dynamic>;
    final owner = ownerMap['login'] as String;
    // final url = repo['url'] as String;

    addToTeam(owner, team, name, permission: permission);
  }
}

void addToTeam(String owner, String team, String repoName,
    {required String permission}) {
  final settings = SettingsYaml.load(pathToSettings: 'github.yaml');
  final token = settings['gittoken'] as String;
  print('adding $team to $owner/$repoName');
  '''
curl -X PUT 
--header "authorization: Bearer $token" 
-H "Accept: application/vnd.github.v3+json" 
https://api.github.com/orgs/$owner/teams/$team/repos/$owner/$repoName 
-d '{"permission":"$permission"}'''
      .run;
}
