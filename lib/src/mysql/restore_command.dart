/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

import 'mysql.dart';
import 'mysql_defaults.dart';
import 'mysql_settings.dart';

class RestoreCommand extends Command<void> {
  @override
  String get description => '''
restores a database.
dmysql restore <db name> [path to backup]''';

  @override
  String get name => 'restore';

  @override
  Future<void> run() async {
    final args = getArgs(
      this,
      argResults,
      additionalArgs: ['<path to backup file>'],
    );
    final dbname = args[0];
    final sqlFile = args[1];

    await restore(MySqlSettings.load(dbname), sqlFile);
  }

  Future<void> restore(MySqlSettings settings, String sqlFile) async {
    if (!File(sqlFile).existsSync()) {
      throw FileSystemException('Backup file does not exist', sqlFile);
    }
    print('restoring $sqlFile to ${settings.dbname}');
    final defaults = MySqlDefaults(settings);
    try {
      final db = '`${settings.dbname}`';
      for (final statement in [
        'DROP DATABASE IF EXISTS $db',
        'CREATE DATABASE $db',
      ]) {
        final result = await Process.run('mysql', [
          ...defaults.connectionOptions(settings),
          '-e',
          statement,
        ], environment: defaults.environment);
        if (result.exitCode != 0) {
          throw StateError('mysql failed: ${result.stderr}');
        }
      }
      final process = await Process.start('mysql', [
        ...defaults.connectionOptions(settings),
        '--database',
        settings.dbname,
      ], environment: defaults.environment);
      final stdoutDone = process.stdout.drain<void>();
      final stderrText = process.stderr.transform(utf8.decoder).join();
      await File(sqlFile).openRead().pipe(process.stdin);
      final code = await process.exitCode;
      await stdoutDone;
      final error = await stderrText;
      if (code != 0) throw StateError('mysql restore failed: $error');
    } finally {
      defaults.dispose();
    }
  }
}
