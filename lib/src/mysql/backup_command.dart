import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class BackupCommand extends Command<void> {
  BackupCommand() {
    argParser.addFlag('overwrite',
        abbr: 'w',
        help: 'If the backup file already exist then overwrite the file.');
  }
  @override
  String get description => '''
Backups up a database.

${blue('dmysql backup <dbname> [<path to backup file>]')}

If you don't provide the path of a backup file (or path is a directory)
then one will be generated in the form:

<dbname>.backup.<nnnn>.sql''';

  @override
  String get name => 'backup';

  @override
  void run() {
    if (which('mysqldump').notfound) {
      throw ExitException(1, 'You must install mysqldump first');
    }

    final args = getArgs(argResults);

    final dbName = args[0];

    final overwrite = argResults!['overwrite'] as bool;

    String pathToBackupFile;
    if (argResults!.rest.length == 2) {
      final backupArg = argResults!.rest[1];
      if (isDirectory(backupArg)) {
        final backupFileName = getBackupFileSequence(backupArg, dbName);
        pathToBackupFile = join(backupArg, backupFileName);
      } else {
        pathToBackupFile = backupArg;
      }
    } else {
      // no backuparg
      final backupFileName = getBackupFileSequence(pwd, dbName);

      pathToBackupFile = join(pwd, backupFileName);
    }

    // , additionalArgs: ['Path to backup file'])

    if (extension(pathToBackupFile) != '.sql') {
      pathToBackupFile += '.sql';
    }
    if (exists(pathToBackupFile) && !overwrite) {
      printerr('The backup file ${truepath(pathToBackupFile)} already exists.  '
          'Delete it or use --overwrite');
    }
    backup(MySqlSettings.load(dbName), pathToBackupFile);
    print(blue('Backed up database to $pathToBackupFile'));
    print('');
  }

  void backup(MySqlSettings settings, String pathToBackupfile) {
    var columnStatistics = '--column-statistics=0 ';
    var success = false;
    while (!success) {
      final result = 'mysqldump --host ${settings.host} '
              '--port=${settings.port} '
              '--user ${settings.user} '
              // so we can backup a v5 db using v8 tools. For large table this
              // is also recommended.
              '$columnStatistics'
              '--password="${settings.password}" '
              '--databases ${settings.dbname} '
              '--result-file=$pathToBackupfile '
          .start(nothrow: true, progress: Progress.capture());

      if (result.toParagraph().contains('column-statistics=0')) {
        /// retry without --column-statistics.
        columnStatistics = '';
      } else {
        success = true;
      }
    }
  }
}

String getBackupFileSequence(String path, String dbName) {
  final backups =
      find('$dbName.backup.*.sql', workingDirectory: path, recursive: false)
          .toList()
        ..sort((lhs, rhs) => _extractVersion(rhs) - _extractVersion(lhs));

  if (backups.isEmpty) {
    return '$dbName.backup.0001.sql';
  }

  final first = backups.first;
  final version = '${_extractVersion(first) + 1}'.padLeft(4, '0');

  return '$dbName.backup.$version.sql';
}

int _extractVersion(String backupName) {
  final parts = backupName.split('.');
  if (parts.length != 4) {
    throw ExitException(
        1, 'Invalid backup seqence name found ${basename(backupName)}');
  }
  final version = int.tryParse(parts[2]);
  if (version == null) {
    throw ExitException(
        1, 'Invalid backup seqence name found ${basename(backupName)}');
  }
  return version;
}

// class InvalidBackupName implements Exception {
//   InvalidBackupName(this.backupName);
//   String backupName;

//   @override
//   String toString() => backupName;
// }

class ExitException implements Exception {
  ExitException(this.exitCode, this.message);

  int exitCode;
  String message;

  @override
  String toString() => 'Error: $exitCode $message';
}
