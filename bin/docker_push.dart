#! /bin/env dcli

// ignore_for_file: file_names
import 'dart:io';

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  var parser = ArgParser()
    ..addOption('repo',
        abbr: 'r',
        mandatory: true,
        help: 'The name of the docker repository to publish to.');
  var project = DartProject.fromPath('.', search: true);
  var projectRootPath = project.pathToProjectRoot;
  print('projectRoot $projectRootPath');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red('Invalid CLI argument: ${e.message}'));
    exit(1);
  }

  var repo = parsed['repo'] as String;
  var projectName = project.pubSpec.name;
  var version = project.pubSpec.version;
  var name = '$repo/$projectName';

  var imageTag = '$name:$version';
  print('Pushing Docker image $imageTag.');

  print('docker path: ${findDockerFilePath()}');
  print(green('Building $projectName docker image'));
  'docker build -t$imageTag .'.start(workingDirectory: findDockerFilePath());
  print(green('Pushing docker image: $imageTag and latest'));
  var latestTag = '$name:latest';
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
