#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';
import 'package:dcli/dcli.dart';

/// dwhich appname - searches for 'appname' on the path
void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', negatable: false)
    ..addFlag('scan',
        abbr: 's',
        negatable: false,
        help: 'Does an extended search of your path for all occurances of '
            'the app and validates the path');

  final results = parser.parse(args);
  final _verbose = results['verbose'] as bool;
  final scan = results['scan'] as bool;

  if (results.rest.length != 1) {
    print(red('You must pass the name of the executable to search for.'));
    print(green('Usage:'));
    print(green('   which ${parser.usage}<exe>'));
    exit(1);
  }

  final command = results.rest[0];

  Settings().setVerbose(enabled: _verbose);

  log(_verbose, () => 'Path: ${env['PATH']}');

  if (_verbose) {
    _checkDuplicates();
  }

  String? lastPath;
  for (var path in PATH) {
    log(scan, () => 'Searching: ${truepath(path)}');
    if (path.isEmpty) {
      verbose(() => 'Empty path found');
      if (Platform.isLinux) {
        path = '.';

        /// current
        printerr(orange(
            'WARNING: current directory is on your path due to an empty path '
            '${lastPath == null ? '' : 'after $lastPath'} .'));
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
    final pathToCmd = checkPath(truepath(path, command));
    if (pathToCmd != null) {
      print(red('Found at: $pathToCmd'));
    }
    lastPath = path;
  }
}

/// reports any duplicate path entries.
void _checkDuplicates() {
  final paths = <String>{};

  for (final path in PATH) {
    if (paths.contains(path)) {
      printerr(orange('Found duplicated path: $path in PATH'));
    } else {
      paths.add(path);
    }
  }
}

String? checkPath(String cmd) {
  if (!Platform.isWindows || extension(cmd).isNotEmpty) {
    return exists(cmd) ? cmd : null;
  }

  for (final ext in env['PATHEXT']!.split(';')) {
    final fullCmd = '$cmd$ext';
    if (exists(fullCmd)) {
      return fullCmd;
    }
  }
  return null;
}

// ignore: avoid_positional_boolean_parameters
void log(bool verbose, String Function() message) {
  if (verbose) {
    print(message());
  }
}
