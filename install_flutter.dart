#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

void main() {
  print('https://flutter.dev/docs/get-started/install/linux');

  'sudo apt install dart'.run;

  //var dartPaths = 'which dart'.toList();
  //if (dartPaths.length != 1)
  //{
  //print('unable to find dart on the path. Please check the install)';
  //exit(1);
  //}
//
  //var dartPath = dartPaths[0];

  // find a way to search for this.
  var dartPath = '/usr/lib/dart/bin';

  addPathToProfile(dartPath);

  var pubCachePath = '$HOME/.pub-cache/bin';
  addPathToProfile(pubCachePath);

  // todo add support for 'export' to dcli which then
  // pass  the environment vars to any called app
  '$dartPath/pub global activate dcli'.run;
  '$pubCachePath/dcli install'.run;

  var appsPath = join('$HOME', 'apps');

  if (!exists(appsPath)) {
    createDir(appsPath);
  }

  'git clone https://github.com/flutter/flutter.git'
      .start(workingDirectory: appsPath);

  'flutter/bin/flutter precache'.start(workingDirectory: appsPath);

  'flutter/bin/flutter doctor -v'.start(workingDirectory: appsPath);

  addPathToProfile('$appsPath/flutter/bin');

  which('flutter');

  print('now install Android Stdio');
  print('https://developer.android.com/studio');

  print('now setup and android emulator as per:');
  print('https://flutter.dev/docs/get-started/install/linux');
}

void addPathToProfile(String path) {
  var profileLines = read('$HOME/.profile').toList();
  var found = false;
  for (var line in profileLines) {
    if (line.contains(path)) {
      found = true;
      break;
    }
  }

  if (!found) {
    print('"adding $path to $HOME/.profile');
    '$HOME/.profile'.append('export PATH="\$PATH:$path"');
    print('You will need to logout for your  path to be available');
  }
}
