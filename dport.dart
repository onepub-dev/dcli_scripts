#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

///
/// Finds and displays details of any process which is listening on the given port no.
void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);

  // matchLine();

  var results = parser.parse(args);

  var verbose = results['verbose'] as bool;
  Settings().setVerbose(enabled: verbose);

  if (results.rest.length != 1) {
    print(red('You must pass the port no to search for.'));
    print(green('Usage:'));
    print(green('   dport <port no>'));
    exit(1);
  }

  var port = results.rest[0];

  var portNo = int.tryParse(port);
  if (portNo == null) {
    printerr(red('Invalid port No. $port'));
    print(parser.usage);
    exit(1);
  }

  var found = viaNetstat(portNo);

  if (!found) {
    print('No process found to be running on $portNo.');
  }
}


bool viaNetstat(int? portNo) {
  var found = false;
  var lines = <String>[];
  'netstat -pnat'
      .start(privileged: true, progress: Progress((line) => lines.add(line)));

  for (var line in lines.skip(1)) {
    if (line.contains(':$portNo ') && line.contains('LISTEN')) {
      final columns = line.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
      if (columns.length == 7) {
        var parts = columns[6].split('/');
        var pid = parts[0];
        var name = parts[1];
        if (name.endsWith(':')) {
          name = name.substring(0, name.length - 1);
        }

        parts = line.split(' ');
        var protocol = parts[0];

        var parentPID = ProcessHelper().getParentPID(int.tryParse(pid) ?? 0);
        final parentName = ProcessHelper().getProcessName(parentPID);

        print(
            '${orange('PID: $pid Process: $name Protocol: $protocol')} ${blue('Parent: $parentPID Parent PID: $parentName')}');
        found = true;
      } else {
        print(line);
      }
    }
  }

  return found;
}

bool viaLsof(int portNo) {
  // 'ss -tulpn src :$portNo'.start(privileged: true);

  var processes = 'lsof -n -P -i +c 13'.toList(skipLines: 1);
  var found = false;

  for (var process in processes) {
    var regexp = RegExp(r':\d+');

    var match = regexp.firstMatch(process);
    if (match != null) {
      var port = match.group(0)!.substring(1);

      var processPortNo = int.tryParse(port);

      if (processPortNo == null) {
        print(orange("Couldn't parse $process"));
        continue;
      }

      if (processPortNo == portNo) {
        var parts = process.split(' ');
        var processName = parts[0];
        var processPID = parts[1];
        print('$processName $processPID');
      }
    }
  }
  return found;
}
