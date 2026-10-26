/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart';
import 'package:settings_yaml/settings_yaml.dart';

import 'backup_command.dart';
import 'mysql_defaults.dart';

/// Connects you to a mysql cli pulling settings (username/password)
/// from a local settings file.
/// Use

var pathToDMysql = '$HOME/.dmysql';

class MySqlSettings {
  final String host;

  final int port;

  final String user;

  final String password;

  final String dbname;

  final String? sslMode;
  final String? sslCa;
  final String? sslCert;
  final String? sslKey;
  final bool sslVerifyServerCert;

  MySqlSettings({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.dbname,
    this.sslMode,
    this.sslCa,
    this.sslCert,
    this.sslKey,
    this.sslVerifyServerCert = false,
  }) {
    validateDbName(dbname);
    if (sslMode != null &&
        !const {'REQUIRED', 'VERIFY_CA', 'VERIFY_IDENTITY'}.contains(sslMode)) {
      throw ArgumentError.value(sslMode, 'sslMode', 'Invalid TLS mode');
    }
    if ((sslCa != null || sslCert != null || sslKey != null) &&
        sslMode == null &&
        !sslVerifyServerCert) {
      throw ArgumentError(
        'TLS certificates require an explicit verification mode',
      );
    }
  }

  static void validateDbName(String dbname) {
    if (!RegExp(r'^[A-Za-z0-9_][A-Za-z0-9_-]*$').hasMatch(dbname)) {
      throw ArgumentError.value(dbname, 'dbname', 'Invalid database name');
    }
  }

  factory MySqlSettings.load(String dbname) {
    final pathToDbSettings = pathToSettings(dbname);
    if (!exists(pathToDbSettings)) {
      throw MissingConfigurationException('''
No configuration exists for $dbname at ${truepath(pathToDbSettings)}. 
Check your database name or run dmysql config $dbname''');
    }
    _protectConfigPath(pathToDbSettings);
    final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);
    final host = settings['host'] as String? ?? 'localhost';
    final port = settings['port'] as int? ?? 3306;
    final user = settings['user'] as String? ?? 'root';
    final password = settings['password'] as String? ?? '';

    return MySqlSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      dbname: dbname,
      sslMode: settings['sslMode'] as String?,
      sslCa: settings['sslCa'] as String?,
      sslCert: settings['sslCert'] as String?,
      sslKey: settings['sslKey'] as String?,
      sslVerifyServerCert: settings['sslVerifyServerCert'] as bool? ?? false,
    );
  }

  static Future<MySqlSettings> config(String dbname) async {
    final pathToDbSettings = MySqlSettings.pathToSettings(dbname);

    if (!exists(dirname(pathToDbSettings))) {
      createDir(dirname(pathToDbSettings), recursive: true);
    }
    _protectConfigPath(pathToDbSettings);
    final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);

    settings['dbname'] = dbname;
    settings['host'] = ask(
      'host:',
      defaultValue: settings['host'] as String?,
      validator: Ask.any([
        Ask.fqdn,
        Ask.ipAddress(),
        Ask.inList(['localhost', '127.0.0.1']),
      ]),
    );

    settings['port'] = int.parse(
      ask(
        'port:',
        defaultValue: (settings['port'] as int? ?? 3306).toString(),
        validator: Ask.integer,
      ),
    );

    settings['user'] = ask(
      'user:',
      defaultValue: settings['user'] as String?,
      validator: Ask.required,
    );

    settings['password'] = ask(
      'password:',
      defaultValue: settings['password'] as String?,
      validator: Ask.required,
      hidden: true,
    );

    if (!_checkDbExists(settings)) {
      if (!confirm(
        orange("The database $dbname doesn't exist. Do you want to continue?"),
      )) {
        throw ExitException(1, '');
      }
    }

    await savePrivateSettings(pathToDbSettings, settings);
    return MySqlSettings.load(dbname);
  }

  static String pathToSettings(String dbname) {
    validateDbName(dbname);
    return join(pathToDMysql, dbname);
  }

  static Future<void> savePrivateSettings(
    String destination,
    SettingsYaml settings,
  ) async {
    _protectConfigPath(destination);
    final directory = Directory(dirname(destination));
    if (FileSystemEntity.typeSync(directory.path, followLinks: false) !=
        FileSystemEntityType.directory) {
      throw FileSystemException(
        'Configuration directory is not safe',
        directory.path,
      );
    }
    if (!Platform.isWindows) {
      final chmod = Process.runSync('chmod', ['700', directory.path]);
      if (chmod.exitCode != 0) {
        throw StateError('Could not protect MySQL configuration directory');
      }
    }
    final staged = File(
      join(
        directory.path,
        '.dmysql-${DateTime.now().microsecondsSinceEpoch}-$pid',
      ),
    );
    try {
      final data = StringBuffer();
      for (final key in [
        'dbname',
        'host',
        'port',
        'user',
        'password',
        'sslMode',
        'sslCa',
        'sslCert',
        'sslKey',
        'sslVerifyServerCert',
      ]) {
        final value = settings[key];
        if (value == null) continue;
        if (value is String) {
          data.writeln('$key: ${_yamlString(value)}');
        } else {
          data.writeln('$key: $value');
        }
      }
      staged.writeAsStringSync(data.toString(), mode: FileMode.writeOnly);
      if (!Platform.isWindows) {
        final chmod = Process.runSync('chmod', ['600', staged.path]);
        if (chmod.exitCode != 0) {
          throw StateError('Could not protect MySQL configuration file');
        }
      }
      if (Platform.isWindows && File(destination).existsSync()) {
        final previous = File('$destination.previous-$pid');
        File(destination).renameSync(previous.path);
        try {
          staged.renameSync(destination);
          previous.deleteSync();
        } catch (_) {
          previous.renameSync(destination);
          rethrow;
        }
      } else {
        staged.renameSync(destination);
      }
    } finally {
      if (staged.existsSync()) staged.deleteSync();
    }
  }

  static void _protectConfigPath(String destination) {
    final directory = dirname(destination);
    if (FileSystemEntity.typeSync(directory, followLinks: false) !=
        FileSystemEntityType.directory) {
      throw FileSystemException(
        'Configuration directory is not safe',
        directory,
      );
    }
    final entryType = FileSystemEntity.typeSync(
      destination,
      followLinks: false,
    );
    if (entryType != FileSystemEntityType.notFound &&
        entryType != FileSystemEntityType.file) {
      throw FileSystemException('Configuration file is not safe', destination);
    }
    if (!Platform.isWindows) {
      for (final entry in [
        (directory, '700'),
        if (entryType == FileSystemEntityType.file) (destination, '600'),
      ]) {
        if (Process.runSync('chmod', [entry.$2, entry.$1]).exitCode != 0) {
          throw StateError('Could not protect MySQL configuration');
        }
      }
    }
  }

  static String _yamlString(String value) {
    if (value.contains('\x00')) throw ArgumentError('Invalid setting value');
    return '"${value.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n').replaceAll('\r', '\\r')}"';
  }

  static bool _checkDbExists(SettingsYaml settings) {
    final host = settings['host'] as String;
    final port = settings['port'] as int;
    final database = settings['dbname'] as String;
    final user = settings['user'] as String;
    final password = settings['password'] as String;
    final connectionSettings = MySqlSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      dbname: database,
      sslMode: settings['sslMode'] as String?,
      sslCa: settings['sslCa'] as String?,
      sslCert: settings['sslCert'] as String?,
      sslKey: settings['sslKey'] as String?,
      sslVerifyServerCert: settings['sslVerifyServerCert'] as bool? ?? false,
    );
    final defaults = MySqlDefaults(connectionSettings);
    late final ProcessResult result;
    try {
      result = Process.runSync('mysqlshow', [
        ...defaults.connectionOptions(connectionSettings),
        database,
      ], environment: defaults.environment);
    } finally {
      defaults.dispose();
    }

    if (result.exitCode != 0) {
      final text = '${result.stdout}\n${result.stderr}';

      if (text.contains('Unknown database')) {
        return false;
      } else {
        throw ExitException(result.exitCode, text);
      }
    }

    return true;
  }
}

class MissingConfigurationException implements Exception {
  String message;

  MissingConfigurationException(this.message);

  @override
  String toString() => message;
}
