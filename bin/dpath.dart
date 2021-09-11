#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:args/args.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

const String tick = '''\xE2\x9C\x93''';

const String posixTick = '''\u2714''';

const String cross = 'x';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  for (var path in PATH) {
    var pathexists = exists(path);

    if (pathexists == true) {
      print('Test:  $posixTick ${normalize(path)}');
    } else {
      print(red('Test: $cross ${normalize(path)}'));
    }
  }
}
