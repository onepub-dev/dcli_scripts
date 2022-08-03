#! /bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

// ignore_for_file: file_names
import 'dart:io';

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  final parser = ArgParser()
    ..addOption('repo',
        abbr: 'r',
        mandatory: true,
        help: 'The name of the docker repository to publish to.');
  final project = DartProject.fromPath('.');
  final projectRootPath = project.pathToProjectRoot;
  print('projectRoot $projectRootPath');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red('Invalid CLI argument: ${e.message}'));
    exit(1);
  }

  final repo = parsed['repo'] as String;
  final projectName = project.pubSpec.name;
  final version = project.pubSpec.version;
  final name = '$repo/$projectName';

  final imageTag = '$name:$version';
  print('Pushing Docker image $imageTag.');

  print('docker path: ${findDockerFilePath()}');
  print(green('Building $projectName docker image'));
  'docker build -t$imageTag .'.start(workingDirectory: findDockerFilePath());
  print(green('Pushing docker image: $imageTag and latest'));
  final latestTag = '$name:latest';
  'docker image tag $imageTag $latestTag'.run;
  'docker push $imageTag'.run;
  'docker push $latestTag'.run;
}

String findDockerFilePath() {
  var current = pwd;
  while (current != rootPath) {
    if (exists(join(current, 'Dockerfile'))) {
      return current;
    }
    current = dirname(current);
  }
  return '.';
}
