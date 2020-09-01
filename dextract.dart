#! /usr/bin/env dcli
import 'dart:io';

import 'package:dcli/dcli.dart';

/// duntar <tarfile>
/// untars a file

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('subdir',
      abbr: 'd',
      defaultsTo: false,
      help: 'Extracts the file to a subdirectory');
  var results = parser.parse(args);

  var extensionToCommand = <String, String>{
    '.tar.gz': 'tar -zxvf %F',
    '.tar': 'tar -xvf %F',
    '.xz': 'tar -xvf %F',
    '.rar': 'unrar e %F',
    '.zip': 'unzip %F'
  };

  if (results.rest.length != 1) {
    print('Expands a compressed file.');
    print('');
    printerr(red('You must provide the name of the file to expand.'));
    print('The file will be expanded in the current working directory.');
    exit(1);
  }

  var tarFile = results.rest[0];

  if (!exists(tarFile)) {
    printerr(red("The passed file ${truepath(tarFile)} doesn't exist"));
    exit(2);
  }

  var cmd = extensionToCommand[extension(tarFile)];

  if (cmd != null) {
    cmd = cmd.replaceAll('%F', tarFile);
    try {
      cmd.run;
    } catch (e) {
      if (e is RunException && e.exitCode == 2){
        printerr(red('The extractor for $tarFile $cmd could not be found.'));
      }
      // otherwise supress the exception as the command will print its own error.
    }
  } else {
    printerr(red("The file $tarFile does not have a know extension."));
    printerr(green('Supported extensions are:'));
    for (var key in extensionToCommand.keys) {
      printerr("  $key");
    }
    exit(1);
  }
}
