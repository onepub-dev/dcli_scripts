#! /usr/bin/env dcli

/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:ffi';
import 'dart:io';

import 'package:args/args.dart';
import 'package:crypto/crypto.dart';
import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/private_temp.dart';
import 'package:path/path.dart';

const _assetUrl =
    'https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64';
const _assetSha256 =
    'ba921e04438e176c474d533447ae64707ffcdd1230f0153f86cb188d348f25c0';

/// installs (if necessary) and runs mailhog

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', help: 'Shows this help message')
    ..addFlag('shutdown', abbr: 'd', help: 'Shutdown mailhog');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  if (parsed['help'] as bool) {
    showUsage(parser);
    exit(1);
  }

  if (parsed['shutdown'] as bool) {
    shutdownMailHog();
  } else {
    await install();
    await startMailHog();
  }
}

void shutdownMailHog() {
  final processes = ProcessHelper().getProcessesByName('mailhog');
  if (processes.isNotEmpty) {
    final result = Process.runSync('killall', ['mailhog']);
    if (result.exitCode != 0) {
      throw StateError('Could not stop MailHog: ${result.stderr}');
    }
  }
}

void showUsage(ArgParser parser) {
  print('Runs and if required installs mailhog ');
  print(parser.usage);
}

Future<void> startMailHog() async {
  print(green('Starting mailhog'));

  print(orange('Access mail hog at: http://localhost:8025'));
  final process = await Process.start(
    mailHogAppPath,
    [],
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) throw StateError('MailHog exited with status $code');
}

Future<void> install() async {
  if (Abi.current() != Abi.linuxX64) {
    throw UnsupportedError('Bundled MailHog asset requires Linux amd64');
  }
  if (!exists(mailHogDirectoryPath)) {
    createDir(mailHogDirectoryPath, recursive: true);
  }

  final installedType = FileSystemEntity.typeSync(
    mailHogAppPath,
    followLinks: false,
  );
  if (installedType == FileSystemEntityType.link) {
    throw FileSystemException(
      'Refusing linked MailHog executable',
      mailHogAppPath,
    );
  }
  if (installedType == FileSystemEntityType.notFound) {
    print(orange('Installing mailhog'));
    final stage = createPrivateTemporaryDirectory(
      mailHogDirectoryPath,
      '.mailhog-download-',
    );
    try {
      final downloaded = join(stage.path, 'mailhog');
      final client = HttpClient();
      try {
        final request = await client.getUrl(Uri.parse(_assetUrl));
        final response = await request.close();
        if (response.statusCode != HttpStatus.ok) {
          throw HttpException(
            'MailHog download failed',
            uri: Uri.parse(_assetUrl),
          );
        }
        final sink = File(downloaded).openWrite();
        try {
          var received = 0;
          await for (final chunk in response) {
            received += chunk.length;
            if (received > 12 * 1024 * 1024) {
              throw StateError('MailHog download exceeds expected size');
            }
            sink.add(chunk);
          }
        } finally {
          await sink.close();
        }
      } finally {
        client.close();
      }
      final digest = sha256.convert(File(downloaded).readAsBytesSync());
      if (digest.toString() != _assetSha256) {
        throw StateError('MailHog download checksum mismatch');
      }
      if (Process.runSync('chmod', ['700', downloaded]).exitCode != 0) {
        throw StateError('Could not mark MailHog executable');
      }
      File(downloaded).renameSync(mailHogAppPath);
    } finally {
      stage.deleteSync(recursive: true);
    }
  }
}

String get mailHogDirectoryPath => join(HOME, 'apps', 'mailhog');

String get mailHogAppPath => join(mailHogDirectoryPath, mailHogAppname);

String get mailHogAppname => 'mailhog';
