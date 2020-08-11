#! /usr/bin/env dshell

import 'dart:io';
import 'package:args/args.dart';
import 'package:dshell/dshell.dart';
import 'package:dshell/src/util/file_sort.dart';

/// dsort
///
/// dsort --field-delimiter=<FD> --linedelimiter=<LD> --key=<columns> --output output <file>
///
/// <columns>=1[type][direction],3,7,1-7
/// <type>=<s|n|m>
/// s - case sensitive string sort - the default
/// S - case insensitive string sort
/// n - numeric sort
/// m - month name sort
///
/// [direction]=<a|d>
/// a - ascending - the default
/// d - descending
///
/// e.g.
///
/// dsort -fd=, -ld=\n --sortkey=1nd,2,3sd,1-7nd unsorted.txt
///
///

const String fieldDelimiterOption = 'field-delimiter';
const String lineDelimiterOption = 'line-delimiter';
const String sortkeyOption = 'sortkey';
const String outputOption = 'output';

void main(List<String> args) {
  dsort(args);
}

void dsort(List<String> args) async {
  var columns = <Column>[];
  String fieldDelimiter;
  String lineDelimiter;
  String outputPath;
  bool verbose;

  var parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', callback: (value) => verbose = value)
    ..addOption(fieldDelimiterOption, abbr: 'f', defaultsTo: ',', callback: (String value) => fieldDelimiter = value)
    ..addOption(lineDelimiterOption, abbr: 'l', defaultsTo: '\n', callback: (String value) => lineDelimiter = value)
    ..addMultiOption(sortkeyOption,
        abbr: 's', callback: (List<String> values) => columns.addAll(FileSort.expandColumns(values)))
    ..addOption(outputOption, abbr: 'o');

  var results = parser.parse(args);

  if (results.rest.length != 1) {
    usageError('Expected an input_file to sort.');
  }

  var inputPath = absolute(results.rest[0]);

  if (results[outputOption] != null) {
    outputPath = results[outputOption].toString();
  }
  outputPath ??= inputPath;

  outputPath = absolute(outputPath);

  if (columns.isEmpty) {
    /// if no columns defined we sort by the whole line.
    columns.add(Column(0, CaseInsensitiveSort(), SortDirection.ascending));
  }

  if (verbose) {
    print('Columns: ${columns.join("\n")}');
    print('Input File: ${inputPath}, Output File: ${outputPath}');
    print("Field Delimiter: '$fieldDelimiter'");
    print("Line Delimiter: '$lineDelimiter'");
  }

  if (!exists(inputPath)) {
    usageError('The input file $inputPath does not exist');
  }

  if (exists(outputPath) && outputPath != inputPath) {
    usageError('The output_file $outputPath already exist. Delete the file and try again.');
  }

  var sort = FileSort(inputPath, outputPath, columns, fieldDelimiter, lineDelimiter, verbose: verbose);

  await sort.sort();
}

void usageError(String error) {
  print(red(error));
  print('');
  print('''
Example:

dsort --sortkey=1n unsorted.txt

Usage Details:

dsort --field-delimiter=<fd> --linedelimiter=<ld> --sortkey=<columns> --output=output_file <input_file>

  -f, --field-delimiter=<fd>     (defaults to ,)
  -l, --line-delimiter=<ld>      (defaults to \n)
  -s, --sortkey=<columns>        (defaults to 0) 
  -o, --output=<output>          (defaults to <file>)

  --field-delimiter
     defines the field delimiter for columns in the file
   
  --line-delimiter
     defines the line delimiter for the input file and the output file.
   
  --sortkey defines columns to sort on and how each column is sorted.
    columns=<column-range>[<type>][<direction>],<columns>
    column-range=[<column>|<column>-<column>]
    column=int

    e.g. --sortkey=1 
        --sortkey=1,2-5,3

    Define the sort type for a <column-range>
    type=<s|n|m>
    s - case sensitive string sort - the default
    S - case insensitive string sort
    n - numeric sort
    m - month name sort

    e.g. --sortkey=1s
        --sortkey=1s,2-5n,3m

    Define the sort direction for a <column-range>
    [direction]=<a|d>
    a - ascending - the default
    d - descending

    e.g. --sortkey=1sd
        --sortkey=1sd,2-5na,3md

  --output
    Defines the file to write the sorted output to. If not provided then we do an insitu sort.

${green("Examples:")}
 String sort, ascending, sort using the whole line
 ${green("dsort unsorted.txt")}

 Numeric sort, desending on the first column only, using the default column delimiter ','
 ${green("dsort --sortkey=1nd unsorted.txt")}

 Descending, Numeric sort on col 1, 
   then Ascending string sort on col 2, 
  then Descending Case Sensitive String sort on col 3, 
  then Descending numeric sort on cols 5-7 inclusive
  using the column delimter ':'
 ${green("dsort -f=: --sortkey=1nd,2,3Sd,5-7nd unsorted.txt")}
''');

  exit(-1);
}
