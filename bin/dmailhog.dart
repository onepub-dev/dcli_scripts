#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// installs (if necessary) and runs mailhog

void main() {
  install();

  run();
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
