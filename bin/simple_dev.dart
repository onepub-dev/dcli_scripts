#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

void main() {
  if (!Shell.current.isPrivilegedProcess) {
    printerr(red('You must run this with sudo'));
    exit(1);
  }

  'apt-get update'.run;
  'apt-get install apt-transport-https'.run;
  'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub |  gpg --dearmor -o /usr/share/keyrings/dart.gpg'
      .run;
  '''echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list'''
      .run;

  final installList = <String>['dart', 'git', 'gh'];

  if (which('curl').notfound) {
    installList.add('curl');
  }

// pipe commands won't work.
  'curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg'
      .run;
  'chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg'.run;
  'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list'
      .run;

  'apt-get update'.run;
  'apt-get install -y ${installList.join(' ')}'.run;

  final email = ask('Your email address:');
  final name = ask('Your name');
  'git config --global user.email "$email"'.run;
  'git config --global user.name "$name"'.run;

  'dart pub global activate dcli'.run;
  'dart pub global activate onepub'.run;
}
