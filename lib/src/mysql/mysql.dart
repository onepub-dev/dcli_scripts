#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
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

  runner.argParser
      .addFlag('debug', abbr: 'd', help: 'Output debug information');

  try {
    await runner.run(args);
  } on MissingConfigurationException catch (e) {
    printerr(red(e.message));
    showUsage(runner);
  } on UsageException catch (e) {
    printerr(e.message);
    showUsage(runner);
  } on ExitException catch (e) {
    if (e.message.isNotEmpty) {
      printerr(red(e.message));
    }
    exit(e.exitCode);
  }
}

void showUsage(CommandRunner<void> runner) {
  print('''
  
${blue('dmysql')}
Runs various mysql command using a settings file containing the user credentials.

${green('To run:')}
   ${DartScript.self.basename} <dbname>

${green('To configure settings for a db:')}
   ${DartScript.self.basename} --config <dbname>
  ''');
  print(runner.usage);
  exit(1);
}

List<String> getArgs(Command<void> command, ArgResults? argResults,
    {List<String> additionalArgs = const <String>[]}) {
  Settings().setVerbose(enabled: command.globalResults!['debug'] as bool);
  if (argResults!.rest.isEmpty) {
    printerr('You must pass a database name.');
    showUsage(runner);
    throw ExitException(1, '');
  }
  final results = <String>[argResults.rest[0]];

  for (var i = 1; i < additionalArgs.length + 1; i++) {
    final arg = additionalArgs[i - 1];
    if (argResults.rest.length < i + 1) {
      printerr("You must pass '$arg'.\n");
      showUsage(runner);
      throw ExitException(1, '');
    }
    results.add(argResults.rest[i]);
  }
  return results;
}

String getDbArg(ArgResults? argResults, {required int position}) =>
    argResults!.rest[position];
