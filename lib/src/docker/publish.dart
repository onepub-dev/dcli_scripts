/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:dcli/dcli.dart' hide confirm;
import 'package:dcli/dcli.dart' as dcli;
import 'package:uuid/uuid.dart';

/// Designed to build and publish a Docker file built using dcli and
/// some fairly opinionated setup.
///
/// Your docker file should have the following line just before
/// the packages git clone line.
/// ```docker
/// RUN mkdir -p /BUILD_TOKEN/
/// ```
/// We will run a:
/// * dcli pack
/// * git add *
/// * git commit -m 'release'
/// * git push
///
/// You need to provide the path to your dockerfile via [pathToDockerFile].
/// The repository name will be generated from your pubspec.yaml and
/// the [repository] argument in the form:
///
/// <repository>/<pubspec.name>:<pubspec.version>
///
/// If you pass the [clean] = true then the image will be rebuilt from scratch
/// If you pass the [fresh] = true then we search for the BUILD_TOKEN line
/// in your docker file and update the token UUID. This will cause the docker
/// image to be rebuilt from the BUILD_TOKEN line. This can be used if you need
/// to re-clone a git repo (or any similar action).
/// By default the image will be pushed to docker hub unless
/// you pass [push] = false.
/// By default we ask you to confirm the build process. Pass [confirm] = false
/// to skip the question.
/// If you pass [pack] = true then the 'dcli pack' command will be run
/// before the build starts.
///
/// The [buildArgs] is a list of arguments that are passed to the docker build
/// command.
void dockerPublish(
    {required String pathToDockerFile,
    required String repository,
    bool pack = false,
    bool clean = false,
    bool fresh = false,
    bool push = true,
    bool confirm = true,
    List<String> buildArgs = const <String>[]}) {
  final project = DartProject.self;
  final name = project.pubSpec.name.value;
  final version = project.pubSpec.version.toString();

  var _fresh = fresh;

  if (confirm && !dcli.confirm('Building $name $version')) {
    printerr(red('Stopping build'));
    exit(1);
  }

  if (pack) {
    'dcli pack'.run;
    _fresh = true;
  }

  print(blue('Building $name $version'));

  final tag = '$repository/$name:$version';
  final latest = '$repository/$name:latest';

  var cleanArg = '';
  if (clean) {
    cleanArg = ' --no-cache';
  }

  if (_fresh) {
    final uuid = const Uuid().v4().replaceAll('-', '');
    replace(pathToDockerFile, RegExp('RUN mkdir -p /BUILD_TOKEN/.*'),
        'RUN mkdir -p /BUILD_TOKEN/$uuid');
  }

  'docker  build ${buildArgs.join(' ')}$cleanArg -t $tag '
          '-t $latest -f $pathToDockerFile .'
      .run;

  if (push) {
    'docker push $tag'.run;
    'docker push $latest'.run;
  }
}
