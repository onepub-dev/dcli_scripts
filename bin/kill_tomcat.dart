#! /usr/bin/env dcli

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
          'kill -9 $pid'.run;
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
