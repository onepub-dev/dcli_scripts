#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

Map<String, String> extensionToCommand = <String, String>{
  '.tar.gz': 'tar -zxvf %F',
  '.tar': 'tar -xvf %F',
  '.xz': 'tar -xvf %F',
  '.rar': 'unrar e %F',
  '.zip': 'unzip %F'
};

/// dcompress <compress file.>
/// de-compresses a variety of file formats.
void main(List<String> args) {
  final parser = ArgParser();

  ArgResults results;

  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    return;
  }

  if (results.rest.length != 1) {
    print('Expands a compressed file.');
    print('');
    printerr(red('You must provide the name of the file to expand.'));
    print('The file will be expanded in the current working directory.');
    exit(1);
  }

  final tarFile = results.rest[0];

  if (!exists(tarFile)) {
    printerr(red("The passed file ${truepath(tarFile)} doesn't exist"));
    exit(2);
  }

  var cmd = getCommand(tarFile);

  if (cmd != null) {
    cmd = cmd.replaceAll('%F', tarFile);
    try {
      cmd.run;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (e is RunException && e.exitCode == 2) {
        printerr(red('The extractor for $tarFile $cmd could not be found.'));
      }
      // otherwise supress the exception as the command will print
      // its own error.
    }
  } else {
    printerr(red('The file $tarFile does not have a know extension.'));
    printerr(green('Supported extensions are:'));
    for (final key in extensionToCommand.keys) {
      printerr('  $key');
    }
    exit(1);
  }
}

void showUsage(ArgParser parser) {
  print('Expands a compress file, support a wide variety of file types. ');
  print(parser.usage);
}

String? getCommand(String tarFile) {
  for (final extension in extensionToCommand.keys) {
    if (tarFile.endsWith(extension)) {
      return extensionToCommand[extension];
    }
  }
  return null;
}
