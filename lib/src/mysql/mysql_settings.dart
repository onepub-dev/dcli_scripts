import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

/// Connects you to a mysql cli pulling settings (username/password)
/// from a local settings file.
/// Use

String pathToDMysql = '$HOME/.dmysql';

class MySqlSettings {
  MySqlSettings(
      {required this.host,
      required this.port,
      required this.user,
      required this.password,
      required this.dbname});

  factory MySqlSettings.load(String dbname) {
    final pathToDbSettings = pathToSettings(dbname);
    final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);
    final host = settings['host'] as String? ?? 'localhost';
    final port = settings['port'] as int? ?? 3306;
    final user = settings['user'] as String? ?? 'root';
    final password = settings['password'] as String? ?? '';

    return MySqlSettings(
        host: host, port: port, user: user, password: password, dbname: dbname);
  }

  factory MySqlSettings.config(String dbname) {
    final pathToDbSettings = MySqlSettings.pathToSettings(dbname);

    if (!exists(dirname(pathToDbSettings))) {
      createDir(dirname(pathToDbSettings), recursive: true);
    }
    final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);

    settings['dbname'] = dbname;
    settings['host'] = ask('host:',
        defaultValue: settings['host'] as String?,
        validator: Ask.any([
          Ask.fqdn,
          Ask.ipAddress(),
          Ask.inList(['localhost', '127.0.0.1'])
        ]));

    settings['port'] = int.parse(ask('port:',
        defaultValue: (settings['port'] as int? ?? 3306).toString(),
        validator: Ask.integer));

    settings['user'] = ask('user:',
        defaultValue: settings['user'] as String?, validator: Ask.required);

    settings['password'] = ask('password:',
        defaultValue: settings['password'] as String?,
        validator: Ask.required,
        hidden: true);

    settings.save();
    return MySqlSettings.load(dbname);
  }

  final String host;
  final int port;
  final String user;
  final String password;
  final String dbname;

  static String pathToSettings(String dbname) => join(pathToDMysql, dbname);
}
