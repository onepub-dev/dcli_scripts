#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';
import 'package:args/args.dart';

/// denv appname
/// print the systems PATH variable contents and validates each path.


void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  var results = parser.parse(args);

  var verbose = results['verbose'] as bool;

  if (results.rest.length != 1)
  {
    print('You must pass the name (or the begining) of an envionment variable');
    exit(1);
  }
  var name = results.rest[0];

  Map<String, String> envVars = Platform.environment;

  envVars.forEach((key, value) {
   if (key.startsWith(name))
   {
     print('$key=$value');
   }
  });
}
