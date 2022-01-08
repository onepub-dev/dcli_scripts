#! /usr/bin/env dcli

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'backup_command.dart';
import 'cli_command.dart';
import 'config_command.dart';
import 'mysql_settings.dart';
import 'restore_command.dart';

late CommandRunner<void> runner;

Future<void> mysqlRun(List<String> args) async {
  runner = CommandRunner<void>('dmysql',
      'Run various mysql commands using a config to save the credintials')
    ..addCommand(BackupCommand())
    ..addCommand(RestoreCommand())
    ..addCommand(CliCommand())
    ..addCommand(ConfigCommand());

  try {
    await runner.run(args);
  } on MissingConfigurationException catch (e) {
    printerr(red(e.message));
    showUsage(runner.argParser);
  } on UsageException catch (e) {
    printerr(e.message);
    showUsage(runner.argParser);
  } on ExitException catch (e) {
    exit(e.exitCode);
  }
}

void showUsage(ArgParser parser) {
  print('''
  
${blue('dmysql')}
Runs various mysql command using a settings file containing the user credentials.

${green('To run:')}
   ${DartScript.self.basename} <dbname>

${green('To configure settings for a db:')}
   ${DartScript.self.basename} --config <dbname>
  ''');
  print(parser.usage);
  exit(1);
}

List<String> getArgs(ArgResults? argResults,
    {List<String> additionalArgs = const <String>[]}) {
  if (argResults!.rest.isEmpty) {
    printerr('You must pass a database name.');
    showUsage(runner.argParser);
    throw ExitException(1);
  }
  final results = <String>[argResults.rest[0]];

  for (var i = 1; i < additionalArgs.length + 1; i++) {
    final arg = additionalArgs[i - 1];
    if (argResults.rest.length < i + 1) {
      printerr("You must pass '$arg'.\n");
      showUsage(runner.argParser);
      throw ExitException(1);
    }
    results.add(argResults.rest[i]);
  }
  return results;
}

String getDbArg(ArgResults? argResults, {required int position}) =>
    argResults!.rest[position];
