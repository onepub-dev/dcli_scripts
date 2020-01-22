#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';
import 'package:args/args.dart';

/// dpath appname
/// print the systems PATH variable contents and validates each path.

const String tick = '''\xE2\x9C\x93''';

const String posixTick = '''\u2714''';

const String cross = 'x';

void main(List<String> args) {
  var parser = ArgParser();
  parser..addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  var results = parser.parse(args);

  var verbose = results['verbose'] as bool;


  for (var path in PATH) {
    var pathexists = exists(path);
 
    if (pathexists == true)
    {
    print('Test:  $posixTick ${canonicalize(path)}');
    }
    else
    {
    print(red('Test: $cross ${canonicalize(path)}'));
    }
  }
}
