#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:dcli/dcli.dart';

/// copies the source directory to the target directory
void main(List<String> args) {
  if (args.length != 2) {
    printerr(red('Expected 2 arguments found ${args.length}'));
    showUsage();
  }

  final source = args[0];
  final dest = args[1];

  if (!exists(source)) {
    printerr(red('The source directory "$source" does not exist.'));
    showUsage();
  }

  if (exists(dest)) {
    printerr(red('The destination directory "$dest" already exists.'));
    showUsage();
  }

  if (confirm('Continue?')) {
    createDir(dest, recursive: true);
    print(green('Copying $source to $dest'));
    copyTree(source, dest, includeHidden: true);
    print(green('Done'));
  }
}

void showUsage() {
  print(blue('dcopydir <source_dir> <target_dir>'));
  print('Recursively copies the source directory to target directory.');
  print('Hidden files are included.');
  print('The dest directory must NOT already exist');
  exit(1);
}
