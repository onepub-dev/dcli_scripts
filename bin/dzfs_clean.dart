#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

void main() {
  print('clean automatically generated zfs snapshots');
  // check if there are any to delete.

  final snapshots = <String>[];

  final progress = Progress(snapshots.add, stderr: snapshots.add);
  'zfs list -t snapshot -o name -S creation'
      .start(privileged: true, progress: progress);

  for (final snapshot in snapshots) {
    if (snapshot.contains('@auto')) {
      'zfs destroy -vr $snapshot'.start(privileged: true);
    }
  }
}
