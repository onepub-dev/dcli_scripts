#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';

///
/// Provides access to a clean ubuntu cli.
///
/// You can run this script in to modes
///
/// dcli build - builds the docker container
/// dcli - launches the container with your pwd mounted into /home

void main(List<String> args) {
  Settings().setVerbose(enabled: false);
  var parser = ArgParser();
  parser.addCommand('build');

  var results = parser.parse(args);
  var build = false;

  if (results.command != null) {
    build = results.command.name == 'build';
    if (build != true) {
      throw ArgumentError('The command arg must be "build" or nothing.');
    }
  }

  if (build) {
    // mount the local dshell files from ..
    'sudo docker build -f ./dcli.docker  -t dcli:dcli .'.run;
  }

  print('$pwd');

  /// mount the current working directory
  var cmd = 'docker run -v $pwd:/home --network host -it dcli:dcli /bin/bash';

  // print(cmd);
  cmd.run;
}
