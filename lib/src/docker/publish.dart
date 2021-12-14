#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart' hide confirm;
import 'package:dcli/dcli.dart' as dcli;
import 'package:uuid/uuid.dart';

/// Designed to build and publish a Docker file built using dcli and
/// some fairly opionated setup.
///
/// Your docker file should have the following line just before
/// the packages git clone line.
/// ```docker
/// RUN mkdir -p /BUILD_TOKEN/
/// ```
///
/// Your Docker file should be in:
///
/// docker/Dockerfile
///
/// We will run a:
/// dcli pack
/// git add *
/// git commit -m 'release'
/// git push
///
void dockerPublish(
    {required String pathToDockerFile,
    required String repository,
    bool pack = false,
    bool clean = false,
    bool clone = false,
    bool push = true,
    bool confirm = true}) {
  join(DartProject.self.pathToProjectRoot, 'docker', 'Dockerfile');

  final project = DartProject.self;
  final name = project.pubSpec.name;
  final version = project.pubSpec.version.toString();

  if (confirm && !dcli.confirm('Building $name $version')) {
    printerr(red('Stopping build'));
    exit(1);
  }

  if (pack) {
    'dcli pack'.run;
  }

  print(blue('Building $name $version'));

  final tag = '$repository/$name:$version';
  final latest = '$repository/$name:latest';

  var cleanArg = '';
  if (clean) {
    cleanArg = ' --no-cache';
  }

  if (clone) {
    final uuid = const Uuid().v4().replaceAll('-', '');
    replace(pathToDockerFile, RegExp('RUN mkdir -p /BUILD_TOKEN/.*'),
        'RUN mkdir -p /BUILD_TOKEN/$uuid');
  }

  'docker  build $cleanArg -t $tag -t $latest -f $pathToDockerFile .'.run;

  if (push) {
    'docker push $tag'.run;
    'docker push $latest'.run;
  }
}
