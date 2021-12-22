import 'package:args/command_runner.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class ConfigCommand extends Command<void> {
  @override
  String get description => 'configures credentials for a database.';

  @override
  String get name => 'config';

  @override
  void run() {
    final args = getArgs(argResults);
    config(args[0]);
  }

  void config(String dbname) {
    MySqlSettings.config(dbname);
  }
}
