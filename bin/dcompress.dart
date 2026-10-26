#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';
import 'package:darchive/src/safe_extractor.dart';
import 'package:path/path.dart' as path;

/// Extracts a TAR or tar.gz archive into a separate destination directory.
/// The archive is validated and staged before any destination is installed.
Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('to', abbr: 't', help: 'Destination directory');
  late final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    stderr.writeln(parser.usage);
    exitCode = 1;
    return;
  }
  if (results.rest.length != 1) {
    stderr.writeln('Usage: dcompress [--to directory] <archive.tar[.gz]>');
    exitCode = 1;
    return;
  }

  final archive = path.absolute(results.rest.single);
  if (!File(archive).existsSync()) {
    stderr.writeln('Archive does not exist: $archive');
    exitCode = 1;
    return;
  }
  final name = path.basename(archive);
  final stem = name.endsWith('.tar.gz')
      ? name.substring(0, name.length - '.tar.gz'.length)
      : path.basenameWithoutExtension(name);
  if (stem.isEmpty || stem == '.' || stem == '..') {
    stderr.writeln('Invalid archive name');
    exitCode = 1;
    return;
  }
  final destination = path.absolute(results['to'] as String? ?? stem);
  try {
    await extractSafely(
      archivePath: archive,
      destination: destination,
      overwrite: false,
    );
    stdout.writeln('Expanded into $destination');
  } on Object catch (error) {
    stderr.writeln('Could not expand archive: $error');
    exitCode = 1;
  }
}
