#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';

/// prints  environment variables that match a passed prefix or
/// all environment variables if the --print flag is passed
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('print',
        abbr: 'p', negatable: false, help: 'prints all environment variables');

  final results = parser.parse(args);

  final doPrint = results['print'] as bool;

  final envVars = Platform.environment;

  if (doPrint) {
    envVars.forEach((key, value) => print('$key:$value'));
    exit(0);
  }

  if (results.rest.length != 1) {
    print(
        'You must pass the name (or the begining) of an environment variable');
    exit(1);
  }
  var name = results.rest[0];
  name = name.toLowerCase();

  envVars.forEach((key, value) {
    if (key.toLowerCase().startsWith(name)) {
      print('$key=$value');
    }
  });
}
