#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

/// This script runs chown for the given path(s) making the calling
/// user the owner.
/// The script uses sudo.

void main(List<String> args) {
  final parser = ArgParser();

  final results = parser.parse(args);
  final rest = results.rest;

  if (rest.isEmpty) {
    printerr('You must provide at least one path');
    exit(1);
  }

  final user = Shell.current.loggedInUser;

  for (final path in rest.toList()) {
    if (!exists(path)) {
      print(red("The path ${truepath(path)} doesn't exists. Skipped"));
    }
    'chown -R $user:$user $path'.start(privileged: true);
  }
}
