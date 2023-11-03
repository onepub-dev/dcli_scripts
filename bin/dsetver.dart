#! /usr/bin/env dcli
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:pub_release/pub_release.dart' as pub;
import 'package:pubspec_manager/pubspec_manager.dart';

/// Updates the version no. on your dart package by changing pubspec.yaml
/// version and genearating src/version/version.g.dart which
/// contains a globl variable packageVersion with the version no.
/// Usage:
///  dsetver --version=x.x.x
///  dsetver to display a menu to with suggested version nos.
void main(List<String> args) {
  final parser = ArgParser()
    ..addOption('version', abbr: 'v', help: 'Set the version no.');

  final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  final version = results['version'] as String?;

  pub.Version? parsedVersion;

  final project = DartProject.findProject('.');
  if (project == null) {
    printerr(red(
        'Unable to find a project in the current directory or any parent.'));
    exit(1);
  }

  final pathToPubspec = DartProject.fromPath('.').pathToPubSpec;

  if (version != null) {
    try {
      parsedVersion = pub.Version.parse(version);
    } on FormatException catch (_) {
      printerr(red('The version no. "$version" passed to setVersion is not a '
          'valid version.'));
      exit(1);
    }
  } else {
    final currentVersion = pub.version(pubspecPath: pathToPubspec);
    if (currentVersion == null) {
      printerr(red('Unable to get the current version.'));
      printerr('Check that you are running from the projects root diretory');
      exit(1);
    }

    parsedVersion = pub.askForVersion(currentVersion);
  }

  pub.updateVersion(
      parsedVersion, PubSpec.loadFromPath(pathToPubspec), pathToPubspec);
}

void showUsage(ArgParser parser) {
  print('');
  print(green('Usage:'));
  print(green('dsetver [--version]'));
  print('');
  print("If the --version switch isn't passed "
      'then you are prompted to enter a version.');
  print(parser.usage);
}
