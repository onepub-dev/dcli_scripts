#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

/// installs (if necessary) and runs mailhog

void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Shows this help message')
    ..addFlag('shutdown', abbr: 'd', help: 'Shutdown mailhog');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  if (parsed['help'] as bool) {
    showUsage(parser);
    exit(1);
  }

  if (parsed['shutdown'] as bool) {
    shutdownMailHog();
  } else {
    install();

    startMailHog();
  }
}

void shutdownMailHog() {
  final processes = ProcessHelper().getProcessesByName('mailhog');
  if (processes.isNotEmpty) {
    'killall ${processes.first.name}'.run;
  }
}

void showUsage(ArgParser parser) {
  print('Runs and if required installs mailhog ');
  print(parser.usage);
}

void startMailHog() {
  print(green('Starting mailhog'));

  print(orange('Access mail hog at: http://localhost:8025'));
  mailHogAppPath.run;
}

void install() {
  if (!exists(mailHogDirectoryPath)) {
    createDir(mailHogDirectoryPath, recursive: true);
  }

  if (!exists(mailHogAppPath)) {
    print(orange('Installing mailhog'));
    'wget https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64'
        .start(workingDirectory: mailHogDirectoryPath);
    'cp MailHog_linux_amd64 $mailHogAppPath'
        .start(privileged: true, workingDirectory: mailHogDirectoryPath);
    'chmod +x $mailHogAppPath'.start(privileged: true, detached: true);
  }
}

String get mailHogDirectoryPath => join(HOME, 'apps', 'mailhog');

String get mailHogAppPath => join(mailHogDirectoryPath, mailHogAppname);

String get mailHogAppname => 'mailhog';
