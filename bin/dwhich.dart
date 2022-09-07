#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';
import 'package:dcli/dcli.dart' hide ExitException;
import 'package:dcli_scripts/src/dwhich/args.dart';
import 'package:dcli_scripts/src/dwhich/exit_exception.dart';

bool found = false;
bool execuable = false;
bool pathIsValid = false;

/// dwhich appname - searches for 'appname' on the path
void main(List<String> cliArgs) {
  final Args args;
  var found = false;
  var exectuable = false;

  try {
    args = Args.parse(cliArgs);

    Settings().setVerbose(enabled: args.debug);

    // validation(args, () => 'Path: ${env['PATH']}');

    final paths = dedupPaths(args);

    String? priorPath;

    for (final path in paths) {
      // validation(args, () => 'Searching: ${truepath(path)}');
      if (!validatePath(path, args, priorPath)) {
        continue;
      }

      final pathToCmd = containsCommand(truepath(path, args.command));
      if (pathToCmd != null) {
        found = true;
        if (!isExecutable(pathToCmd)) {
          print('Found at: $pathToCmd but it is not executable.');
          continue;
        }
        exectuable = true;

        print('Found at: $pathToCmd');

        // found an exectuable.
        if (args.first) {
          break;
        }
      }
      priorPath = path;
    }
  } on ExitException catch (e) {
    printerr(red(e.message));
    if (e.exitCode == ExitException.invalidArgs) {
      Args.showUsage();
    }
    exit(e.exitCode);
  }
  final goodPath = printProblems(args);

  exit(ExitException.mapExitCode(
      found: found, exectuable: exectuable, goodPath: goodPath));
}

bool validatePath(String path, Args args, String? lastPath) {
  var valid = true;
  var _path = path;
  // validation(args, () => 'Searching: ${truepath(path)}');
  if (_path.isEmpty) {
    validation(args, () => 'Empty path found');
    if (Platform.isLinux) {
      _path = '.';

      /// current
      validation(
          args,
          () => orange('WARNING: current directory is on your path due '
              'to an empty path '
              '${lastPath == null ? '' : 'after $lastPath'} .'));
    } else {
      validation(args, () => red(
          // ignore: lines_longer_than_80_chars
          'Found empty path ${lastPath == null ? '' : 'after $lastPath'}.'));
      valid = false;
    }
  }

  if (valid && !exists(_path)) {
    validation(args, () => red('The path $_path does not exist.'));
    valid = false;
  }
  return valid;
}

/// Returns true if there we no problems dectected with PATH
bool printProblems(Args args) {
  if (problems.isNotEmpty) {
    print('');
    print(orange('Problems:'));
    for (final problem in problems) {
      printerr('    ${orange(problem)}');
    }
  }
  return problems.isEmpty;
}

/// reports any duplicate path entries.
Set<String> dedupPaths(Args args) {
  final paths = <String>{};

  for (final path in PATH) {
    if (paths.contains(path)) {
      validation(args, () => orange('Found duplicated path: $path in PATH'));
    } else {
      paths.add(path);
    }
  }
  return paths;
}

String? containsCommand(String cmd) {
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

final problems = <String>[];
// ignore: avoid_positional_boolean_parameters
void validation(Args args, String Function() message) {
  if (args.validate) {
    problems.add(message());
  }
}
