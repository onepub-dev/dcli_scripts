#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

/// Connects you to a mysql cli pulling settings (username/password)
/// from a local settings file.
/// Use

String pathToDMysql = '$HOME/.dmysql';

void main(List<String> args) {
  final parser = ArgParser()
    ..addFlag('config',
        abbr: 'c',
        help: 'starts dmysql in configuration mode so you can enter the '
            'settings for the given db');

  final results = parser.parse(args);
  final rest = results.rest;

  if (rest.length != 1) {
    printerr(red('You must provide the database name'));
    showUsage(parser);
  }

  if (which('mysqldump').notfound) {
    printerr(red('You must install mysqldump first'));
    exit(1);
  }

  final dbname = rest[0];
  final pathToDbSettings = join(pathToDMysql, dbname);

  if (results['config'] as bool) {
    config(dbname, pathToDbSettings);
  } else {
    if (!exists(pathToDbSettings)) {
      printerr(red('You must first configure your database using --config'));
      showUsage(parser);
    }
    backup(pathToDbSettings);
  }
}

void backup(String pathToDbSettings) {
  final settings = SettingsYaml.load(pathToSettings: pathToDbSettings);
  final host = settings['host'] as String?;
  final port = settings['port'] as int?;
  final user = settings['user'] as String?;
  final password = settings['password'] as String?;
  final dbname = settings['dbname'] as String?;

  'mysqldump -h $host --port=$port -u $user --password="$password" $dbname'
      .start(nothrow: true);
}

void config(String dbname, String pathToDbSettings) {
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
}

void showUsage(ArgParser parser) {
  print('''
Backs up a MySql database pulling settings (username/password...) from a local settings file.

${green('To backup a db:')}
   mysql_backup <dbname>

${green('To configure settings for a db:')}
  mysql_backup --config <dbname>
  ''');
  print(parser.usage);
  exit(1);
}
