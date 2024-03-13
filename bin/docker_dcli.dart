#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

///
/// Provides access to a clean ubuntu cli.
///
/// You can run this script in two modes
///
/// docker_dcli build - builds the docker container
/// docker_dcli - launches the container with your pwd mounted into /home

void main(List<String> args) {
  Settings().setVerbose(enabled: false);
  final parser = ArgParser()..addCommand('build');

  var build = false;
  ArgResults results;

  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(e.toString());
    print('docker_dcli - starts the cli');
    print('docker_dcli build - builds the docker image');
    print(parser.usage);
    exit(1);
  }

  if (results.command != null) {
    build = results.command!.name == 'build';
    if (build != true) {
      throw ArgumentError('The command arg must be "build" or nothing.');
    }
  }

  if (build) {
    // mount the local dcli files from ..
    'sudo docker build -f ./dcli.docker  -t dcli:dcli .'.run;
    print('Build complete. Run docker_dcli to start the docker cli');
    exit(0);
  }

  print('Mounting host ${green(pwd)} into the container at '
      '${orange('/home/local')}');

  /// mount the current working directory
  'docker run -v $pwd:/home/local --network host -it dcli:dcli /bin/bash'.run;
}
