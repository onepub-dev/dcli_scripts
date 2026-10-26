/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

import '../private_temp.dart';
import 'mysql.dart';
import 'mysql_defaults.dart';
import 'mysql_settings.dart';

class BackupCommand extends Command<void> {
  BackupCommand() {
    argParser
      ..addFlag(
        'overwrite',
        abbr: 'w',
        help: 'If the backup file already exist then overwrite the file.',
      )
      ..addFlag(
        'always',
        abbr: 'a',
        help:
            'Create the backup file even if the db '
            "content hasn't changed since the last backup.",
      );
  }
  @override
  String get description =>
      '''
Backups up a database.

${blue('dmysql backup <dbname> [<path to backup file>]')}

If you don't provide the path of a backup file (or path is a directory)
then one will be generated in the form:

<dbname>.backup.<nnnn>.sql''';

  @override
  String get name => 'backup';

  @override
  Future<void> run() async {
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
    if (FileSystemEntity.typeSync(pathToBackupFile, followLinks: false) !=
            FileSystemEntityType.notFound &&
        !overwrite) {
      printerr(
        'The backup file ${truepath(pathToBackupFile)} already exists.  '
        'Delete it or use --overwrite',
      );
      throw ExitException(1, 'Backup destination already exists');
    }
    if (await backup(
      MySqlSettings.load(dbName),
      pathToBackupFile,
      pathToMostRecent,
      always: always,
      overwrite: overwrite,
    )) {
      print(blue('Backed up database to $pathToBackupFile'));
    }
    print('');
  }

  Future<bool> backup(
    MySqlSettings settings,
    String pathToBackupfile,
    String? pathToPriorBackup, {
    required bool always,
    bool overwrite = false,
  }) async {
    final temp = createPrivateTemporaryDirectory(
      dirname(absolute(pathToBackupfile)),
      '.dmysql-backup-',
    );
    MySqlDefaults? defaults;
    final tmpFile = join(temp.path, 'backup.sql');
    try {
      defaults = MySqlDefaults(settings);
      if (!Platform.isWindows && (temp.statSync().mode & 0x3f) != 0) {
        throw StateError('Temporary backup directory is not private');
      }
      for (final columnStatistics in [true, false]) {
        final result = await Process.run('mysqldump', [
          ...defaults.connectionOptions(settings),
          if (columnStatistics) '--column-statistics=0',
          '--databases',
          settings.dbname,
          '--routines',
          '--result-file=$tmpFile',
        ], environment: defaults.environment);
        if (result.exitCode == 0) break;
        if (columnStatistics &&
            '${result.stdout}\n${result.stderr}'.contains(
              'column-statistics',
            )) {
          if (File(tmpFile).existsSync()) File(tmpFile).deleteSync();
          continue;
        }
        throw ExitException(
          result.exitCode,
          'mysqldump failed: ${result.stderr}',
        );
      }
      if (!File(tmpFile).existsSync()) {
        throw StateError('mysqldump did not create a backup');
      }
      if (!Platform.isWindows &&
          Process.runSync('chmod', ['600', tmpFile]).exitCode != 0) {
        throw StateError('Could not protect temporary database backup');
      }
      if (pathToPriorBackup != null &&
          !always &&
          diff(tmpFile, pathToPriorBackup)) {
        print(
          orange(
            "Database hasn't changed. No backup created. "
            'Use --always to force a backup',
          ),
        );
        return false;
      }
      if (!overwrite &&
          FileSystemEntity.typeSync(pathToBackupfile, followLinks: false) !=
              FileSystemEntityType.notFound) {
        throw ExitException(1, 'Backup destination already exists');
      }
      if (Platform.isWindows &&
          overwrite &&
          File(pathToBackupfile).existsSync()) {
        File(pathToBackupfile).deleteSync();
      }
      File(tmpFile).renameSync(pathToBackupfile);
      return true;
    } finally {
      defaults?.dispose();
      temp.deleteSync(recursive: true);
    }
  }

  /// Compares two files to see if they have the same content.
  bool diff(String pathTobackup, String pathToPriorBackup) {
    /// skip the diff if the files sizes are different.
    if (stat(pathTobackup).size != stat(pathToPriorBackup).size) {
      return false;
    }
    final backupFile = FileSync(pathTobackup, fileMode: FileMode.read);
    final priorFile = FileSync(pathToPriorBackup, fileMode: FileMode.read);

    var count = 0;
    String? line;
    var same = true;
    try {
      while ((line = backupFile.readLine()) != null) {
        count++;
        final other = priorFile.readLine();

        /// The dump completed is the last line and contains a date stamp
        /// so it will always be different so we ignore it.
        if (line!.startsWith('-- Dump completed on ')) {
          continue;
        }

        if (line != other) {
          print(orange('found diff at line $count'));
          same = false;
          break;
        }
      }

      /// check that we also hit the eof for prior
      if (same && priorFile.readLine() != null) {
        print(orange('prior has more lines at $count'));
        same = false;
      }
      return same;
    } finally {
      backupFile.close();
      priorFile.close();
    }
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
    final backups = find(
      '$dbName.backup.*.sql',
      workingDirectory: path,
      recursive: false,
    ).toList()..sort((lhs, rhs) => _extractVersion(rhs) - _extractVersion(lhs));

    if (backups.isEmpty) {
      return null;
    }

    return join(path, backups.first);
  }

  int _extractVersion(String backupName) {
    final parts = basename(backupName).split('.');
    if (parts.length != 4) {
      throw ExitException(
        1,
        'Invalid backup sequence name found ${basename(backupName)}',
      );
    }
    final version = int.tryParse(parts[2]);
    if (version == null) {
      throw ExitException(
        1,
        'Invalid backup sequence name found ${basename(backupName)}',
      );
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
  int exitCode;

  String message;

  ExitException(this.exitCode, this.message);

  @override
  String toString() => 'Error: $exitCode $message';
}
