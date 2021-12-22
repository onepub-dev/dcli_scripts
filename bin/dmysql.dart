#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/mysql/mysql.dart';

/// Connects you to a mysql cli pulling settings (username/password)
/// from a local settings file.
/// Use

String pathToDMysql = '$HOME/.dmysql';

Future<void> main(List<String> args) async {
  await mysqlRun(args);
}
