#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

const _name = 'artifactory';
const _image = 'docker.bintray.io/jfrog/artifactory-oss:latest';
const _volume = '/var/opt/jfrog/artifactory:/var/opt/jfrog/artifactory';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Show help')
    ..addFlag('install', abbr: 'i', help: 'Install the image')
    ..addFlag('delete', abbr: 'd', help: 'Delete the container')
    ..addFlag('start', abbr: 's', help: 'Start in the background')
    ..addFlag('stop', abbr: 't', help: 'Stop the container')
    ..addFlag('attach', abbr: 'a', help: 'Open a shell in the container');
  final parsed = parser.parse(args);

  if (parsed['help'] as bool) {
    print(parser.usage);
    return;
  }

  if (parsed['install'] as bool) {
    _docker(['pull', _image]);
    PubCache().globalActivate('nginx_le');
  } else if (parsed['delete'] as bool) {
    if (_containerExists()) {
      if (_isRunning()) _docker(['stop', _name]);
      _docker(['rm', _name]);
    }
  } else if (parsed['stop'] as bool) {
    if (_containerExists() && _isRunning()) _docker(['stop', _name]);
  } else if (parsed['attach'] as bool) {
    if (!_containerExists() || !_isRunning()) {
      throw StateError('Artifactory is not running');
    }
    await _dockerInteractive(['exec', '-it', _name, '/bin/sh']);
  } else {
    await _start(daemon: parsed['start'] as bool);
  }
}

Future<void> _start({required bool daemon}) async {
  if (_isRunning()) {
    print(orange('Artifactory is already running.'));
    return;
  }
  if (_containerExists()) {
    if (daemon) {
      _docker(['start', _name]);
    } else {
      await _dockerInteractive(['start', '-ai', _name]);
    }
    return;
  }
  if (Process.runSync('docker', ['image', 'inspect', _image]).exitCode != 0) {
    throw StateError('Artifactory image is missing. Run --install first.');
  }
  final command = [
    'run',
    if (daemon) '-d' else '-it',
    '--name',
    _name,
    '-p',
    '127.0.0.1:8081:8081',
    '-p',
    '127.0.0.1:8082:8082',
    '-v',
    _volume,
    _image,
  ];
  if (daemon) {
    _docker(command);
  } else {
    await _dockerInteractive(command);
  }
}

bool _containerExists() =>
    Process.runSync('docker', ['container', 'inspect', _name]).exitCode == 0;

bool _isRunning() {
  final result = Process.runSync('docker', [
    'container',
    'inspect',
    '--format',
    '{{.State.Running}}',
    _name,
  ]);
  return result.exitCode == 0 && (result.stdout as String).trim() == 'true';
}

void _docker(List<String> args) {
  final result = Process.runSync('docker', args);
  if ((result.stdout as String).isNotEmpty) stdout.write(result.stdout);
  if ((result.stderr as String).isNotEmpty) stderr.write(result.stderr);
  if (result.exitCode != 0) {
    throw StateError('docker ${args.first} failed with ${result.exitCode}');
  }
}

Future<void> _dockerInteractive(List<String> args) async {
  final process = await Process.start(
    'docker',
    args,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) throw StateError('docker ${args.first} failed with $code');
}
