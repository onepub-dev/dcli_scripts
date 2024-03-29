/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class RestoreCommand extends Command<void> {
  @override
  String get description => '''
restores a database.
dmysql restore <db name> [path to backup]''';

  @override
  String get name => 'restore';

  @override
  void run() {
    final args =
        getArgs(this, argResults, additionalArgs: ['<path to backup file>']);
    final dbname = args[0];
    final sqlFile = args[1];

    restore(MySqlSettings.load(dbname), sqlFile);
  }

  void restore(MySqlSettings settings, String sqlFile) {
    print('restoring $sqlFile to ${settings.dbname}');

    'mysql --host ${settings.host} --port=${settings.port} '
            '--user ${settings.user} --password="${settings.password}" '
            '-e "drop database ${settings.dbname}"'
        .start(nothrow: true);

    'mysql --host ${settings.host} --port=${settings.port} '
            '--user ${settings.user} --password="${settings.password}" '
            '-e "create database ${settings.dbname}"'
        .start(nothrow: true);

    'mysql --host ${settings.host} --port=${settings.port} '
            '--user ${settings.user} --password="${settings.password}" '
            '--database ${settings.dbname} '
            '-e "source $sqlFile"'
        .start(nothrow: true);
  }
}
