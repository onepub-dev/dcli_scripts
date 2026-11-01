#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

void main(List<String> args) {
  if (args.contains('--help') || args.contains('-h')) {
    print('Run with sudo to remove ZFS snapshots named @auto*');
    return;
  }
  if (!Shell.current.isPrivilegedProcess) {
    stderr.writeln('Run with sudo: sudo ./bin/dzfs_clean.dart');
    exitCode = 1;
    return;
  }
  Shell.current.releasePrivileges();

  late final ProcessResult listing;
  try {
    Shell.current.withPrivileges(() {
      listing = Process.runSync('zfs', [
        'list',
        '-H',
        '-t',
        'snapshot',
        '-o',
        'name',
        '-S',
        'creation',
      ]);
    });
  } finally {
    Shell.current.releasePrivileges();
  }
  if (listing.exitCode != 0) {
    throw StateError('Could not list ZFS snapshots: ${listing.stderr}');
  }

  for (final snapshot in (listing.stdout as String).split('\n')) {
    final name = snapshot.trim();
    final marker = name.lastIndexOf('@');
    if (marker < 1 || !name.substring(marker + 1).startsWith('auto')) {
      continue;
    }
    if (!RegExp(r'^[A-Za-z0-9_./:-]+@[A-Za-z0-9_.:-]+$').hasMatch(name)) {
      throw FormatException('Unexpected ZFS snapshot name');
    }
    try {
      Shell.current.withPrivileges(() {
        final result = Process.runSync('zfs', ['destroy', '-vr', name]);
        if (result.exitCode != 0) {
          throw StateError('Could not destroy $name: ${result.stderr}');
        }
      });
    } finally {
      Shell.current.releasePrivileges();
    }
  }
}
