#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

/// dwhich appname - searches for 'appname' on the path
void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);
  parser.addFlag('scan',
      abbr: 's',
      defaultsTo: false,
      negatable: false,
      help:
          'Does an extended search of your path for all occurances of the app and validates the path');

  var results = parser.parse(args);

  print('hi');

  var _verbose = results['verbose'] as bool;
  var scan = results['scan'] as bool;

  if (results.rest.length != 1) {
    print(red('You must pass the name of the executable to search for.'));
    print(green('Usage:'));
    print(green('   which ${parser.usage}<exe>'));
    exit(1);
  }

  var command = results.rest[0];

  Settings().setVerbose(enabled: _verbose);
  print('Verbose: $_verbose');

  log(_verbose, () => 'Path: ${env['PATH']}');

  String? lastPath;
  for (var path in PATH) {
    log(scan, () => 'Searching: ${truepath(path)}');
    if (path.isEmpty) {
      verbose(() => 'Empty path found');
      if (Platform.isLinux) {
        path = '.';

        /// current
        printerr(orange(
            'WARNING: current directory is on your path due to an empty path ${lastPath == null ? '' : 'after $lastPath'} .'));
      } else {
        printerr(red(
            'Found empty path ${lastPath == null ? '' : 'after $lastPath'}.'));
        continue;
      }
    }
    if (!exists(path)) {
      printerr(red('The path $path does not exist.'));
      continue;
    }
    var pathToCmd = checkPath(truepath(path, command));
    if (pathToCmd != null) {
      print(red('Found at: $pathToCmd'));
    }
    lastPath = path;
  }
}

String? checkPath(String cmd) {
  if (!Platform.isWindows || extension(cmd).isNotEmpty) {
    return exists(cmd) ? cmd : null;
  }

  for (var ext in env['PATHEXT']!.split(';')) {
    var fullCmd = '$cmd$ext';
    if (exists(fullCmd)) return fullCmd;
  }
  return null;
}

void log(bool verbose, String Function() message) {
  if (verbose) print(message());
}
