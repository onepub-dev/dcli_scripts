/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:settings_yaml/settings_yaml.dart';

import 'backup_command.dart';

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
    if (!exists(pathToDbSettings)) {
      throw MissingConfigurationException('''
No configuration exists for $dbname at ${truepath(pathToDbSettings)}. 
Check your database name or run dmysql config $dbname''');
    }
    final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);
    final host = settings['host'] as String? ?? 'localhost';
    final port = settings['port'] as int? ?? 3306;
    final user = settings['user'] as String? ?? 'root';
    final password = settings['password'] as String? ?? '';

    return MySqlSettings(
        host: host, port: port, user: user, password: password, dbname: dbname);
  }

  static Future<MySqlSettings> config(String dbname) async {
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

    if (!_checkDbExists(settings)) {
      if (!confirm(orange(
          "The database $dbname doesn't exist. Do you want to continue?"))) {
        throw ExitException(1, '');
      }
    }

    // ignore: discarded_futures
    await settings.save();
    return MySqlSettings.load(dbname);
  }

  final String host;
  final int port;
  final String user;
  final String password;
  final String dbname;

  static String pathToSettings(String dbname) => join(pathToDMysql, dbname);

  static bool _checkDbExists(SettingsYaml settings) {
    final host = settings['host'] as String;
    final port = settings['port'] as int;
    final database = settings['dbname'] as String;
    final user = settings['user'] as String;
    final password = settings['password'] as String;
    final result = 'mysqlshow --host=$host --port=$port '
            '--user=$user --password="$password" $database'
        .start(nothrow: true, progress: Progress.capture());

    if (result.exitCode != 0) {
      final text = result.toParagraph();

      if (text.contains('Unknown database')) {
        return false;
      } else {
        throw ExitException(result.exitCode!, text);
      }
    }

    return true;
  }
}

class MissingConfigurationException implements Exception {
  MissingConfigurationException(this.message);
  String message;

  @override
  String toString() => message;
}
