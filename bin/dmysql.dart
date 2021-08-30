#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';
import 'package:args/args.dart';
import 'package:settings_yaml/settings_yaml.dart';

/// Connects you to a mysql cli pulling settings (username/password)
/// from a local settings file.
/// Use

var pathToDMysql = '$HOME/.dmysql';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('config',
      abbr: 'c',
      defaultsTo: false,
      help: 'starts dmysql in configuration mode so you can enter the settings for the given db');

  var results = parser.parse(args);
  var rest = results.rest;

  if (rest.length != 1) {
    printerr(red('You must provide the database name'));
    showUsage(parser);
  }

  var dbname = rest[0];
  var pathToDbSettings = join(pathToDMysql, dbname);

  if (results['config'] as bool) {
    config(dbname, pathToDbSettings);
  } else {
    if (!exists(pathToDbSettings)) {
      printerr(red('You must first configure your database using --config'));
      showUsage(parser);
    }
    launch(pathToDbSettings);
  }
}

void launch(String pathToDbSettings) {
  var settings = SettingsYaml.load(pathToSettings: pathToDbSettings);
  var host = settings['host'] as String?;
  var port = settings['port'] as int?;
  var user = settings['user'] as String?;
  var password = settings['password'] as String?;
  var dbname = settings['dbname'] as String?;

  'mysql -h $host --port=$port -u $user --password="$password" $dbname'.run;
}

void config(String dbname, String pathToDbSettings) {
  if (!exists(dirname(pathToDbSettings))) {
    createDir(dirname(pathToDbSettings), recursive: true);
  }
  var settings = SettingsYaml.load(pathToSettings: pathToDbSettings);

  settings['dbname'] = dbname;
  settings['host'] = ask('host:',
      defaultValue: settings['host'] as String?,
      validator: Ask.any([
        Ask.fqdn,
        Ask.ipAddress(),
        Ask.inList(['localhost', '127.0.0.1'])
      ]));

  settings['port'] =
      int.parse(ask('port:', defaultValue: (settings['port'] as int? ?? 3306).toString(), validator: Ask.integer));

  settings['user'] = ask('user:', defaultValue: settings['user'] as String?, validator: Ask.required);

  settings['password'] =
      ask('password:', defaultValue: settings['password'] as String?, validator: Ask.required, hidden: true);

  settings.save();
}

void showUsage(ArgParser parser) {
  print('''
Connects you to a mysql cli pulling settings (username/password...) from a local settings file.

${green('To connect to a db:')}
   dmysql <dbname>

${green('To connfigure settings for a db:')}
  dmysql --config <dbname>
  ''');
  print(parser.usage);
  exit(1);
}
