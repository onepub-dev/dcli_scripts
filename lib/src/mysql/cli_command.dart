/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class CliCommand extends Command<void> {
  @override
  String get description => 'Connects the MySql client.';

  @override
  String get name => 'cli';

  @override
  void run() {
    final args = getArgs(this, argResults);
    cli(args[0]);
  }

  void cli(String dbName) {
    final settings = MySqlSettings.load(dbName);
    'mysql --host ${settings.host} --port=${settings.port} '
            '--user ${settings.user} --password="${settings.password}" '
            '--database ${settings.dbname}'
        .start(nothrow: true, terminal: true);
  }
}
