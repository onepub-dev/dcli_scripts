import 'package:args/args.dart';
import 'package:dcli/dcli.dart';

import 'exit_exception.dart';

class Args {
  late final ArgResults results;

  late final bool debug;

  late bool validate;

  late final bool first;

  late final String command;

  static final parser = ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Displays this usage message.',
    )
    // validate the path
    ..addFlag(
      'validate',
      abbr: 'v',
      defaultsTo: true,
      help: '''
Performs validation on the PATH environment variable
such as checking for:
  * duplicates
  * empty paths
  * paths to non-existant directories
''',
    )
// only display the first result - also disabled validation
// unless you explicitly pass --validation
    ..addFlag(
      'first',
      abbr: 'f',
      negatable: false,
      help: '''
Restricts the output to the first path containing the command.
''',
    )
// dump debugging outpu
    ..addFlag('debug',
        abbr: 'd',
        negatable: false,
        hide: true,
        help: 'Dumps detailed logging.');

  Args.parse(List<String> args) {
    try {
      results = parser.parse(args);
    } on FormatException catch (e) {
      throw ExitException(ExitException.invalidArgs, e.message);
    }

    debug = results['debug'] as bool;
    validate = results['validate'] as bool;
    first = results['first'] as bool;

    // first turns off validation unless it was explicitly passed
    if (first && !results.wasParsed('validate')) {
      validate = false;
    }

    extractCommand();

    if (results['help'] as bool) {
      showUsage();
      throw ExitException(
          0, 'You must pass the name of the executable to search for.');
    }
  }

  void extractCommand() {
    if (results.rest.length != 1) {
      throw ExitException(
          6, 'You must pass the name of the executable to search for.');
    }

    // the command we are going to try and find.
    command = results.rest[0];
  }

  static void showUsage() {
    print(blue('Locates a command on the PATH whilst validationg your PATH.'));
    print(green('''

Description:
                  searches the PATH environment variable for any directories
                  that contains the passed command and prints those directory in the
                  order they appear in PATH.
                  As dwhich searches your PATH it also validates it checking for
                  common problems.
'''));
    print('''
Usage:
${blue('which [-d][-f][-h][-v] <command>')}

${parser.usage}

Exit Status:
                  0 - the command was found and exectuable, and the PATH was valid.
                  1 - the command was found and exectuable, but the PATH was invalid.
                  2 - the command was found but not exectuable, and the PATH was valid.
                  3 - the command was found but not exectuable, but the PATH was invalid.
                  4 - the command was not found but the PATH was valid.
                  5 - the command was not found and the PATH was valid.
                  6 - an invalid arguments were passed.
''');
  }
}
