#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

/// This script runs chown for the given path(s) making the calling user the owner.
/// The script uses sudo.

void main(List<String> args) {
  var parser = ArgParser();

  var results = parser.parse(args);
  var rest = results.rest;

  if (rest.isEmpty) {
    printerr('You must provide at least one path');
    exit(1);
  }

  var user = Shell.current.loggedInUser;

  for (var path in rest.toList()) {
    if (!exists(path)) {
      print(red("The path ${truepath(path)} doesn't exists. Skipped"));
    }
    'chown -R $user:$user $path'.start(privileged: true);
  }
}
