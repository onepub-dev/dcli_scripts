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

void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show usage')
    ..addOption(
      'repo',
      abbr: 'r',
      mandatory: true,
      help: 'The name of the docker repository to publish to.',
    );
  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red('Invalid CLI argument: ${e.message}'));
    exit(1);
  }

  if (parsed['help'] as bool || !parsed.wasParsed('repo')) {
    print(parser.usage);
    exitCode = parsed['help'] as bool ? 0 : 1;
    return;
  }

  final project = DartProject.fromPath('.');

  final repo = parsed['repo'] as String;
  final projectName = project.pubSpec.name.value;
  final version = project.pubSpec.version;
  final name = '$repo/$projectName';

  final imageTag = '$name:$version';
  print('Pushing Docker image $imageTag.');

  print('docker path: ${findDockerFilePath()}');
  print(green('Building $projectName docker image'));
  _docker([
    'build',
    '-t',
    imageTag,
    '.',
  ], workingDirectory: findDockerFilePath());
  print(green('Pushing docker image: $imageTag and latest'));
  final latestTag = '$name:latest';
  _docker(['image', 'tag', imageTag, latestTag]);
  _docker(['push', imageTag]);
  _docker(['push', latestTag]);
}

void _docker(List<String> args, {String? workingDirectory}) {
  final result = Process.runSync(
    'docker',
    args,
    workingDirectory: workingDirectory,
  );
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw StateError('docker ${args.first} exited with ${result.exitCode}');
  }
}

String findDockerFilePath() {
  var current = pwd;
  while (current != rootPath) {
    if (exists(join(current, 'Dockerfile'))) {
      return current;
    }
    current = dirname(current);
  }
  throw StateError('No Dockerfile found in this directory or its parents');
}
