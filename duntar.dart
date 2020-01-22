#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';
import 'package:args/args.dart';

/// duntar <tarfile>
/// untars a file

void main(List<String> args) {
  var parser = ArgParser();
  parser..addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  var results = parser.parse(args);

  var verbose = results['verbose'] as bool;

  if (results.rest.length != 1)
  {
    print('untars a .tar or .tar.gz file');
    print('');
    print_err('You must provide the name of the file to untar');
    print('The file will be untared in the current working directory');
    exit(1);
  }

  var tarFile = results.rest[0];

  if (tarFile.endsWith('.tar.gz'))
  {
    'tar -zxvf $tarFile'.run;
  }
  else if (tarFile.endsWith('.tar'))
  {
    'tar -xvf $tarFile'.run;
  }
  else
  {
    print("The tar file $tarFile does not have a know extension of '.tar.gz' or '.tar'");
  }
}
