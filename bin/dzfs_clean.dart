#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

void main() {
  print('clean automatically generated zfs snapshots');
  // check if there are any to delete.

  var snapshots = <String>[];

  var progress = Progress((line) => snapshots.add(line), stderr: (line) => snapshots.add(line));
  'zfs list -t snapshot -o name -S creation'.start(privileged: true, progress: progress);

  for (var snapshot in snapshots) {
    if (snapshot.contains('@auto')) {
      'zfs destroy -vr $snapshot'.start(privileged: true);
    }
  }
}
