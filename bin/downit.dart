#! /usr/bin/env dcli

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

  if (!Shell.current.isPrivilegedProcess) {
    printerr('Run downit with sudo: sudo ./bin/downit.dart <path>...');
    exitCode = 1;
    return;
  }

  final user = Shell.current.loggedInUser;
  Shell.current.releasePrivileges();

  for (final path in rest.toList()) {
    if (FileSystemEntity.typeSync(path, followLinks: false) ==
        FileSystemEntityType.notFound) {
      print(red("The path ${truepath(path)} doesn't exists. Skipped"));
      continue;
    }
    try {
      Shell.current.withPrivileges(() {
        final result = Process.runSync('chown', [
          '-hR',
          '--',
          '$user:$user',
          path,
        ]);
        if (result.exitCode != 0) {
          throw StateError('chown failed for $path: ${result.stderr}');
        }
      });
    } finally {
      Shell.current.releasePrivileges();
    }
  }
}
