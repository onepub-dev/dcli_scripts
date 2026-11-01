#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  if (args.length != 2) {
    printerr('Usage: gitrename_tag <oldTag> <newTag>');
    exitCode = 1;
    return;
  }
  final oldTag = args[0];
  final newTag = args[1];
  for (final tag in [oldTag, newTag]) {
    if (tag.startsWith('-') ||
        Process.runSync('git', [
              'check-ref-format',
              'refs/tags/$tag',
            ]).exitCode !=
            0) {
      throw FormatException('Invalid Git tag name');
    }
  }
  _git(['tag', newTag, 'refs/tags/$oldTag']);
  _git(['push', 'origin', 'refs/tags/$newTag:refs/tags/$newTag']);
  _git(['push', 'origin', ':refs/tags/$oldTag']);
  _git(['tag', '-d', oldTag]);
}

void _git(List<String> args) {
  final result = Process.runSync('git', args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw StateError('git ${args.first} failed with ${result.exitCode}');
  }
}
