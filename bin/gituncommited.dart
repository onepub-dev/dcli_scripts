#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

/// Search all subdirectories looking for git projects
/// It then reports any that have uncommited files or which
/// need to be pushed.
void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('detail',
      abbr: 'd', help: 'Shows a list of any uncommited files');

  ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    print(parser.usage);
    exit(1);
  }
  var detail = results['detail'] as bool;

  find('.git', includeHidden: true, types: [Find.directory]).forEach((gitPath) {
    var uncommited = <String>[];
    gitPath = dirname(gitPath);
    // print('testing $gitPath');
    try {
      uncommited = 'git status --porcelain'
          .start(workingDirectory: gitPath, progress: Progress.capture())
          .toList();

      if (uncommited.isNotEmpty) {
        print('Uncommited files in $gitPath');
        if (detail) {
          for (var line in uncommited) {
            print(line);
          }
        }
      } else {
        /// check if code has been pushed
        var status = 'git status'
            .start(workingDirectory: gitPath, progress: Progress.capture())
            .toList()
            .join('\n');

        if (!status.contains('Your branch is up to date with')) {
          print('Push required on $gitPath');
        }
      }
    } catch (e) {
      print('error: ${e.toString()}');
      print(uncommited);
    }
  });
}