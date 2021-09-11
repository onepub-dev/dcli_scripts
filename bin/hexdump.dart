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
        help: 'Controls no. of hex characters output per line');

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
  dump(file, width, parser);
}

void dump(String file, int width, ArgParser parser) {
  withOpenFile(file, (openFile) {
    var buffer = List.filled(width, 0);

    try {
      var read = 0;
      while ((read = openFile.readIntoSync(buffer)) != 0) {
        var count = 0;
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
          var char = String.fromCharCode(val);
          if (char == '\n') char = ' ';
          if (char == '\r') char = ' ';
          if (char == '\t') char = ' ';
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

void showUsage(ArgParser parser) {
  print('Usage:');
  print('hexdump <file>');
  print('Outputs a hexidecimal representation of the passed file.');
  print(parser.usage);
}
