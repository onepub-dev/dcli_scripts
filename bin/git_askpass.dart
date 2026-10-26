#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  Settings().setVerbose(enabled: false);
  final prompt = args.isEmpty ? '' : args.first.toLowerCase();
  if (prompt.contains('username')) {
    stdout.write(Platform.environment['DCLI_IMPORT_USERNAME'] ?? '');
  } else if (prompt.contains('password')) {
    stdout.write(Platform.environment['DCLI_IMPORT_PASSWORD'] ?? '');
  }
}
