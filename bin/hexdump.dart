#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';

/// Outputs a hexi-decimal representation of a file
/// allowing with an asci representation.

void main(List<String> args) {
  var parser = ArgParser()
    ..addOption('width',
        abbr: 'w',
        defaultsTo: '16',
        help: 'Controls no. of hex characters output per line')
    ..addFlag('offset',
        abbr: 'o', defaultsTo: true, help: 'Show the offset on each line');

  ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (e) {
    printerr(red(e.message));
    showUsage(parser);
    exit(1);
  }

  if (parsed.rest.length != 1) {
    printerr(red('You must provide one file as an argument.'));
    showUsage(parser);
    exit(1);
  }

  var file = parsed.rest[0];
  if (!exists(file)) {
    printerr(red('The file ${truepath(file)} does not exist.'));
    showUsage(parser);
    exit(1);
  }

  if (!isFile(file)) {
    printerr(red('$truepath(file)} is not a file.'));
    showUsage(parser);
    exit(1);
  }

  var width = int.tryParse(parsed['width'] as String);

  if (width == null) {
    printerr(red('Width must be an integer. Found ${parsed['width']}'));
    showUsage(parser);
    exit(1);
  }

  var showOffset = parsed['offset'] as bool;

  dump(file, width, parser, showOffset: showOffset);
}

void dump(String file, int width, ArgParser parser,
    {required bool showOffset}) {
  withOpenFile(file, (openFile) {
    var buffer = List.filled(width, 0);

    try {
      var read = 0;
      var offset = 0;

      while ((read = openFile.readIntoSync(buffer)) != 0) {
        var count = 0;
        if (showOffset) {
          echo('$offset'.padLeft(6, '0') + ': ');
          offset += width;
        }
        for (var val in buffer) {
          count++;
          if (count > read) {
            echo('  ');
          } else {
            echo(val.toRadixString(16).padLeft(2, '0'));
          }
          if (count % 2 == 0) {
            echo(' ');
          }
        }
        count = 1;
        echo(' ');

        for (var val in buffer) {
          final char = isPrintable(val) ? String.fromCharCode(val) : ' ';
          echo(char);

          count++;
          if (count > read) break;
        }
        print('');
      }
    } on FileSystemException catch (e) {
      printerr(red('Error reading file ${truepath(file)}'));
      printerr(e.osError == null ? e.message : e.osError!.message);
      showUsage(parser);
    }
  }, fileMode: FileMode.read);
}

/// Replaces all non-printable characters in value with a space.
/// tabs, newline etc are all considered non-printable.
String replaceNoPrintable(String value) {
  var charCodes = <int>[];

  for (final codeUnit in value.codeUnits) {
    if (isPrintable(codeUnit)) {
      charCodes.add(codeUnit);
    } else {
      charCodes.add(20);
    }
  }

  return String.fromCharCodes(charCodes);
}

bool isPrintable(int codeUnit) {
  var printable = true;

  if (codeUnit < 33) printable = false;
  if (codeUnit >= 127) printable = false;

  return printable;
}

void showUsage(ArgParser parser) {
  print('Usage:');
  print('hexdump <file>');
  print('Outputs a hexidecimal representation of the passed file.');
  print(parser.usage);
}
