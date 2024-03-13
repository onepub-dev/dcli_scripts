#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:dcli/dcli.dart';

void main() {
  // find all java processes
  var killed = false;
  'ps aux'.forEach((line) {
    if (line.contains('java') && line.contains('tomcat')) {
      final parts = line.split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        final pidPart = parts[1];
        final pid = int.tryParse(pidPart) ?? -1;
        if (pid != -1) {
          try {
            'kill -9 $pid'.start(progress: Progress.devNull());
          } on RunException {
            'kill -9 $pid'.start(privileged: true);
          }
          print('Killed tomcat with pid=$pid');
          killed = true;
        }
      }
    }
  });

  if (killed == false) {
    print('tomcat process not found.');
  }
}
