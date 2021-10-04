#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

/// installs (if necessary) and runs mailhog

void main(List<String> args) {
  var parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Shows this help message');

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
  install();

  run();
}

void showUsage(ArgParser parser) {
  print('Runs and if required installs mailhog ');
  print(parser.usage);
}

void run() {
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

String get mailHogDirectoryPath {
  return join(HOME, 'apps', 'mailhog');
}

String get mailHogAppPath => join(mailHogDirectoryPath, mailHogAppname);

String get mailHogAppname => 'mailhog';
