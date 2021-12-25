import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class RestoreCommand extends Command<void> {
  @override
  String get description => 'restores up a database.';

  @override
  String get name => 'restore';

  @override
  void run() {
    final args = getArgs(argResults, additionalArgs: ['backup file.sql']);
    final dbname = args[0];
    final sqlFile = args[1];

    restore(MySqlSettings.load(dbname), sqlFile);
  }

  void restore(MySqlSettings settings, String sqlFile) {
    'mysql --host ${settings.host} --port=${settings.port} '
            '--user ${settings.user} --password="${settings.password}" '
            '--database ${settings.dbname} '
            '-e "source $sqlFile"'
        .start(nothrow: true);
  }
}