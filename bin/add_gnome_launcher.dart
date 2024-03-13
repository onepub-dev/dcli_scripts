#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

String? name;
List<String>? categories;
late bool terminal;
String? comment;
String? iconPath;
String? exePath;

ArgParser parser = ArgParser();

///
/// Creates a gnome launcher.
///
void main(List<String> args) {
  Settings().setVerbose(enabled: false);

  parser
    ..addOption('name',
        help: 'Name of the application to be displayed in the gnome menu')
    ..addMultiOption('categories',
        defaultsTo: ['Development'],
        help:
            "Gnome list of categories. ''Controls where in the gnome menu the "
            "entry appears. e.g. 'Development'")
    ..addOption('terminal',
        defaultsTo: 'true',
        help: 'If true (the default) then the app is launched '
            'in a terminal window.')
    ..addOption('comment', help: 'Adds a comment to the Gnome menu item')
    ..addOption('iconPath', help: 'Path to an icon for the Gnome menu')
    ..addOption('exePath', help: 'Path to an executable to be run');

  final parsed = parser.parse(args);

  name = getRequiredString(parsed, 'name');
  comment = parsed['comment'] as String?;
  terminal = getBool(parsed, 'terminal');
  categories = getList(parsed, 'categories');
  iconPath = getPath(parsed, 'iconPath');
  exePath = getRequiredPath(parsed, 'exePath');

  writeDesktopEntry();
}

String getRequiredPath(ArgResults parsed, String option) {
  final path = getRequiredString(parsed, option)!;

  if (!exists(path)) {
    print(red('The provided path for $option does not exists.'));
    showUsage();
  }

  return truepath(path);
}

String? getPath(ArgResults parsed, String option) {
  if (!parsed.wasParsed(option)) {
    return null;
  }

  final path = parsed[option] as String;

  if (!exists(path)) {
    print(red('The provided path for $option does not exists.'));
    showUsage();
  }

  return truepath(path);
}

String? getRequiredString(ArgResults parsed, String option) {
  if (!parsed.wasParsed(option)) {
    print(red('You must provide the --$option argument'));
    showUsage();
  }
  return parsed[option] as String?;
}

// ignore: unreachable_from_main
bool getRequiredBool(ArgResults parsed, String option) {
  if (!parsed.wasParsed(option)) {
    print(red('You must provide the --$option argument'));
    showUsage();
  }
  return parsed[option] == 'true';
}

bool getBool(ArgResults parsed, String option) => parsed[option] == 'true';

// ignore: unreachable_from_main
List<String>? getRequiredList(ArgResults parsed, String option) {
  if (!parsed.wasParsed(option)) {
    print(red('You must provide the --$option argument'));
    showUsage();
  }

  return parsed[option] as List<String>?;
}

List<String>? getList(ArgResults parsed, String option) =>
    parsed[option] as List<String>?;

void showUsage() {
  print('');
  print(green('Usage:'));
  print('./add_gnome_laucher.dart [options]');
  print(parser.usage);
  exit(-1);
}

void writeDesktopEntry() {
  final path = join(HOME, '.local', 'share', 'applications',
      '${name!.replaceAll(RegExp('[^a-zA-Z0-9_]'), '_')}.desktop');
  // create desktop.ini
  if (exists(path)) {
    delete(path);
  }

  final content = StringBuffer()..write('''
[Desktop Entry]
Version=1.0
Type=Application
Name=$name
''');

  if (comment != null) {
    content.write('Comment=$comment\n');
  }

  content
    ..write('Categories=${categories!.join(';')}\n')
    ..write('Terminal=$terminal\n');

  if (iconPath != null) {
    content.write('Icon=$iconPath\n');
  }

  if (terminal) {
    content.write('''gnome-terminal -e 'bash -c "$exePath;bash"' ''');
  } else {
    content.write('Exec=$exePath\n');
  }

  path.write(content.toString());

  print('Created: (in ${truepath(path)})\n');

  cat(path);
}
