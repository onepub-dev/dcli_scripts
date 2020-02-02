#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';
import 'package:args/args.dart';

/// denv appname
/// print the systems PATH variable contents and validates each path.


void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('print', abbr: 'p', defaultsTo: false, negatable: false, help: 'prints all environment variables');

  var results = parser.parse(args);

  var doPrint = results['print'] as bool;

  Map<String, String> envVars = Platform.environment;

  if (doPrint == true)
  {
    envVars.forEach((key, value) => print('$key:$value'));
    exit(0);
  }

  if (results.rest.length != 1)
  {
    print('You must pass the name (or the begining) of an envionment variable');
    exit(1);
  }
  var name = results.rest[0];
  name = name.toLowerCase();


  envVars.forEach((key, value) {
   
   if (key.toLowerCase().startsWith(name))
   {
     print('$key=$value');
   }
  });
}
