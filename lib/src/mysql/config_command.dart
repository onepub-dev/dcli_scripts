/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class ConfigCommand extends Command<void> {
  ConfigCommand() {
    argParser.addFlag('remove',
        abbr: 'r',
        help: 'Removes a database config. Does not touch the actual db');
  }
  @override
  String get description => 'configures credentials for a database.';

  @override
  String get name => 'config';

  @override
  Future<void> run() async {
    final args = getArgs(this, argResults);

    final dbname = args[0];

    if (argResults!['remove'] as bool) {
      final pathTo = MySqlSettings.pathToSettings(dbname);
      if (exists(pathTo)) {
        delete(pathTo);
      } else {
        printerr(red('No config for $dbname exits at $pathTo'));
      }
    } else {
      await config(dbname);
    }
  }

  Future<void> config(String dbname) async {
    await MySqlSettings.config(dbname);
  }
}
