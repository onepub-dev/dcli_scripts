import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class BackupCommand extends Command<void> {
  @override
  String get description => 'backups up a database.';

  @override
  String get name => 'backup';

  @override
  void run() {
    if (which('mysqldump').notfound) {
      printerr(red('You must install mysqldump first'));
      throw ExitException(1);
    }

    final args = getArgs(argResults, additionalArgs: ['Path to backup file']);

    backup(MySqlSettings.load(args[0]), args[1]);
  }

  void backup(MySqlSettings settings, String pathToBackupfile) {
    'mysqldump --host ${settings.host} '
            '--port=${settings.port} '
            '--user ${settings.user} '
            // so we can backup a v5 db using v8 tools. For large table this
            // is also recommended.
            '--column-statistics=0 '
            '--password="${settings.password}" '
            '--databases ${settings.dbname} '
            '--result-file=$pathToBackupfile '
        .start(nothrow: true);
  }
}

class ExitException implements Exception {
  ExitException(this.exitCode);

  int exitCode;

  @override
  String toString() => 'Application ended with exitCode $exitCode';
}
