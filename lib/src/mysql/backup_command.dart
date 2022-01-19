import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';

import 'mysql.dart';
import 'mysql_settings.dart';

class BackupCommand extends Command<void> {
  BackupCommand() {
    argParser
      ..addFlag('overwrite',
          abbr: 'w',
          help: 'If the backup file already exist then overwrite the file.')
      ..addFlag('always',
          abbr: 'a',
          help: 'Create the backup file even if the db '
              "content hasn't changed since the last backup.");
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

    final args = getArgs(this, argResults);

    final dbName = args[0];

    final overwrite = argResults!['overwrite'] as bool;
    final always = argResults!['always'] as bool;

    String pathToBackupFile;
    String? pathToMostRecent;
    if (argResults!.rest.length == 2) {
      final backupArg = argResults!.rest[1];
      if (isDirectory(backupArg)) {
        final backupDir = backupArg;
        pathToBackupFile = getBackupFileSequence(backupDir, dbName);
        pathToMostRecent = getMostRecent(backupDir, dbName);
      } else {
        pathToBackupFile = backupArg;
      }
    } else {
      // no backuparg
      pathToBackupFile = getBackupFileSequence(pwd, dbName);
      pathToMostRecent = getMostRecent(pwd, dbName);
    }

    // , additionalArgs: ['Path to backup file'])

    if (extension(pathToBackupFile) != '.sql') {
      pathToBackupFile += '.sql';
    }
    if (exists(pathToBackupFile) && !overwrite) {
      printerr('The backup file ${truepath(pathToBackupFile)} already exists.  '
          'Delete it or use --overwrite');
    }
    if (backup(MySqlSettings.load(dbName), pathToBackupFile, pathToMostRecent,
        always: always)) {
      print(blue('Backed up database to $pathToBackupFile'));
    }
    print('');
  }

  bool backup(MySqlSettings settings, String pathToBackupfile,
      String? pathToPriorBackup,
      {required bool always}) {
    var created = false;
    var columnStatistics = '--column-statistics=0 ';
    var success = false;
    withTempFile((tmpFile) {
      while (!success) {
        final result = 'mysqldump --host ${settings.host} '
                '--port=${settings.port} '
                '--user ${settings.user} '
                // so we can backup a v5 db using v8 tools. For large table this
                // is also recommended.
                '$columnStatistics'
                '--password="${settings.password}" '
                '--databases ${settings.dbname} '
                '--result-file=$tmpFile '
            .start(nothrow: true, progress: Progress.capture());

        if (result.toParagraph().contains('column-statistics=0')) {
          /// retry without --column-statistics.
          columnStatistics = '';
        } else {
          success = true;
        }
      }
      if (success) {
        if (pathToPriorBackup != null) {
          /// If the new backup is identical then we don't create a backup
          if (always || !diff(tmpFile, pathToPriorBackup)) {
            move(tmpFile, pathToBackupfile);
            created = true;
          } else {
            print(orange("Database hasn't changed. No backup created. "
                'Use --always to force a backup'));
          }
        } else {
          move(tmpFile, pathToBackupfile);
          created = true;
        }
      }
    }, keep: true);
    return created;
  }

  /// Compares two files to see if they have the same content.
  bool diff(String pathTobackup, String pathToPriorBackup) {
    final backupFile = FileSync(pathTobackup, fileMode: FileMode.read);
    final priorFile = FileSync(pathToPriorBackup, fileMode: FileMode.read);

    var count = 0;
    String? line;
    var same = true;
    while ((line = backupFile.readLine()) != null) {
      count++;
      final other = priorFile.readLine();

      /// The dump completed is the last line and contains a date stamp
      /// so it will always be different so we ignore it.
      if (line!.startsWith('-- Dump completed on ')) {
        continue;
      }

      if (line != other) {
        print(orange('found diff at $count: $line'));
        same = false;
        break;
      }
    }

    /// check that we also hit the eof for prior
    if (same && priorFile.readLine() != null) {
      print(orange('prior is shorter at $count'));
      same = false;
    }
    return same;
  }

  /// Gets the path to the next backup file in the sequence.
  String getBackupFileSequence(String path, String dbName) {
    final mostRecent = getMostRecent(path, dbName);
    if (mostRecent == null) {
      return join(path, '$dbName.backup.0001.sql');
    }

    final version = '${_extractVersion(mostRecent) + 1}'.padLeft(4, '0');

    return join(path, '$dbName.backup.$version.sql');
  }

  /// Returns the most recent backup file in the sequence.
  String? getMostRecent(String path, String dbName) {
    final backups =
        find('$dbName.backup.*.sql', workingDirectory: path, recursive: false)
            .toList()
          ..sort((lhs, rhs) => _extractVersion(rhs) - _extractVersion(lhs));

    if (backups.isEmpty) {
      return null;
    }

    return join(path, backups.first);
  }

  int _extractVersion(String backupName) {
    final parts = basename(backupName).split('.');
    if (parts.length != 4) {
      throw ExitException(
          1, 'Invalid backup sequence name found ${basename(backupName)}');
    }
    final version = int.tryParse(parts[2]);
    if (version == null) {
      throw ExitException(
          1, 'Invalid backup sequence name found ${basename(backupName)}');
    }
    return version;
  }
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
