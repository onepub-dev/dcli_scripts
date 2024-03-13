#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

///
/// Finds and displays details of any process which is listening on
/// the given port no.
void main(List<String> args) {
  final parser = ArgParser()..addFlag('verbose', abbr: 'v', negatable: false);

  final results = parser.parse(args);

  final verbose = results['verbose'] as bool;
  Settings().setVerbose(enabled: verbose);

  if (results.rest.length != 1) {
    print(red('You must pass the port no to search for.'));
    print(green('Usage:'));
    print(green('   dport <port no>'));
    exit(1);
  }

  final port = results.rest[0];

  final portNo = int.tryParse(port);
  if (portNo == null) {
    printerr(red('Invalid port No. $port'));
    print(parser.usage);
    exit(1);
  }

  final found = viaNetstat(portNo);

  if (!found) {
    print('No process found to be running on $portNo.');
  }
}

bool viaNetstat(int? portNo) {
  var found = false;
  final lines = <String>[];
  'netstat -pnat'.start(privileged: true, progress: Progress(lines.add));

  for (final line in lines.skip(1)) {
    if (line.contains(':$portNo ') && line.contains('LISTEN')) {
      final columns = line.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
      if (columns.length == 7) {
        var parts = columns[6].split('/');
        final pid = parts[0];
        var name = parts[1];
        if (name.endsWith(':')) {
          name = name.substring(0, name.length - 1);
        }

        parts = line.split(' ');
        final protocol = parts[0];

        final parentPID = ProcessHelper().getParentPID(int.tryParse(pid) ?? 0);
        final parentName = ProcessHelper().getProcessName(parentPID);

        print('${orange('PID: $pid Process: $name Protocol: $protocol')} '
            '${blue('Parent: $parentPID Parent PID: $parentName')}');
        found = true;
      } else {
        print(line);
      }
    }
  }

  return found;
}

// ignore: unreachable_from_main
bool viaLsof(int portNo) {
  // 'ss -tulpn src :$portNo'.start(privileged: true);

  final processes = 'lsof -n -P -i +c 13'.toList(skipLines: 1);
  const found = false;

  for (final process in processes) {
    final regexp = RegExp(r':\d+');

    final match = regexp.firstMatch(process);
    if (match != null) {
      final port = match.group(0)!.substring(1);

      final processPortNo = int.tryParse(port);

      if (processPortNo == null) {
        print(orange("Couldn't parse $process"));
        continue;
      }

      if (processPortNo == portNo) {
        final parts = process.split(' ');
        final processName = parts[0];
        final processPID = parts[1];
        print('$processName $processPID');
      }
    }
  }
  return found;
}
