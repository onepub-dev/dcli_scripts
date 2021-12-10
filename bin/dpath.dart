#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

const String tick = '''\xE2\x9C\x93''';

const String posixTick = '''\u2714''';

const String cross = 'x';

void main(List<String> args) {
  ArgParser().addFlag('verbose', abbr: 'v', negatable: false);

  for (final path in PATH) {
    final pathexists = exists(path);

    if (pathexists == true) {
      print('Test:  $posixTick ${normalize(path)}');
    } else {
      print(red('Test: $cross ${normalize(path)}'));
    }
  }
}
