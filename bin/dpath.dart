#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

// for future use.
// ignore: unreachable_from_main
const tick = '''\xE2\x9C\x93''';

const posixTick = '''\u2714''';

const cross = 'x';

void main(List<String> args) {
  ArgParser().addFlag('verbose', abbr: 'v', negatable: false);

  for (final path in PATH) {
    final pathexists = exists(path);

    if (pathexists) {
      print('Test:  $posixTick ${normalize(path)}');
    } else {
      print(red('Test: $cross ${normalize(path)}'));
    }
  }
}
