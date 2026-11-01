import 'dart:io';

import 'package:dcli_scripts/src/clean/mariadb_cleaner.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late Directory home;
  late Directory workspace;
  late Directory data;
  late DateTime cutoff;

  void setDirectoryModified(DateTime when) {
    final result = Process.runSync('touch', [
      '-m',
      '-d',
      '@${when.millisecondsSinceEpoch ~/ 1000}',
      data.path,
    ]);
    expect(result.exitCode, 0);
  }

  void makeOld() {
    final old = cutoff.subtract(const Duration(days: 1));
    final file = File(join(data.path, 'ibdata1'));
    file
      ..setLastModifiedSync(old)
      ..setLastAccessedSync(old);
    setDirectoryModified(old);
  }

  setUp(() {
    home = Directory.systemTemp.createTempSync('mariadb_cleaner_test');
    workspace = Directory(join(home.path, 'git', '.codex.workspaces', 'task'))
      ..createSync(recursive: true);
    data = Directory(join(workspace.path, 'mariadb-data'))..createSync();
    File(join(data.path, 'ibdata1')).writeAsStringSync('database');
    cutoff = DateTime.now().subtract(const Duration(days: 30));
  });

  tearDown(() => home.deleteSync(recursive: true));

  test('deletes old unused Codex MariaDB data', () {
    makeOld();
    expect(findCodexMariaDbData(home).map((directory) => directory.path),
        [data.path]);
    expect(
        deleteStaleMariaDbData(data, cutoff: cutoff, isInUse: (_) => false),
        isTrue);
    expect(data.existsSync(), isFalse);
  });

  test('keeps recently accessed files and active data', () {
    makeOld();
    File(join(data.path, 'ibdata1')).setLastAccessedSync(DateTime.now());
    expect(
        deleteStaleMariaDbData(data, cutoff: cutoff, isInUse: (_) => false),
        isFalse);
    makeOld();
    expect(
        deleteStaleMariaDbData(data, cutoff: cutoff, isInUse: (_) => true),
        isFalse);
    expect(data.existsSync(), isTrue);
  });

  test('keep markers and links prevent cleanup', () {
    makeOld();
    File(join(workspace.path, '.clean-keep')).writeAsStringSync('');
    expect(findCodexMariaDbData(home), isEmpty);
    File(join(workspace.path, '.clean-keep')).deleteSync();
    Link(join(data.path, 'external')).createSync(home.path);
    setDirectoryModified(cutoff.subtract(const Duration(days: 1)));
    expect(
        deleteStaleMariaDbData(data, cutoff: cutoff, isInUse: (_) => false),
        isFalse);
  });
}
