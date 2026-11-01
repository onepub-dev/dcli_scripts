/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:io';

import 'package:args/command_runner.dart';

import 'mysql.dart';
import 'mysql_defaults.dart';
import 'mysql_settings.dart';

class CliCommand extends Command<void> {
  @override
  String get description => 'Connects the MySql client.';

  @override
  String get name => 'cli';

  @override
  Future<void> run() async {
    final args = getArgs(this, argResults);
    await cli(args[0]);
  }

  Future<void> cli(String dbName) async {
    final settings = MySqlSettings.load(dbName);
    final defaults = MySqlDefaults(settings);
    try {
      final process = await Process.start(
        'mysql',
        [
          ...defaults.connectionOptions(settings),
          '--database',
          settings.dbname,
        ],
        mode: ProcessStartMode.inheritStdio,
        environment: defaults.environment,
      );
      final code = await process.exitCode;
      if (code != 0) throw StateError('mysql exited with status $code');
    } finally {
      defaults.dispose();
    }
  }
}
