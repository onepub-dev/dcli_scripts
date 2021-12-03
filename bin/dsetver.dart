#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:args/args.dart';
import 'package:pub_release/pub_release.dart' as pub;

/// Updates the version no. on your dart package by changing pubspec.yaml
/// version and genearating src/version/version.g.dart which
/// contains a globl variable packageVersion with the version no.
/// Usage:
///  dsetver --version=x.x.x
///  dsetver to display a menu to with suggested version nos.
void main(List<String> args) {
  var parser = ArgParser();

  parser.addOption('version', abbr: 'v', help: 'Set the version no.');

  var results = parser.parse(args);

  var version = results['version'] as String?;

  pub.Version? parsedVersion;

  final pathToPubspec = DartProject.self.pathToPubSpec;
  if (version != null) {
    try {
      parsedVersion = pub.Version.parse(version);
    } on FormatException catch (_) {
      printerr(red(
          'The version no. "$version" passed to setVersion is not a valid version.'));
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

    pub.updateVersion(
        parsedVersion, PubSpec.fromFile(pathToPubspec), pathToPubspec);
  }
}
