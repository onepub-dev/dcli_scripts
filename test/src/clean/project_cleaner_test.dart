import 'dart:io';

import 'package:dcli_scripts/src/clean/project_cleaner.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('project_cleaner_test');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('deletes Rust target and Node node_modules directories', () {
    final rustProject = Directory(join(root.path, 'rust'))..createSync();
    File(join(rustProject.path, 'Cargo.toml')).writeAsStringSync('[package]');
    Directory(join(rustProject.path, 'target', 'debug'))
        .createSync(recursive: true);

    final nodeProject = Directory(join(root.path, 'node'))..createSync();
    File(join(nodeProject.path, 'package.json')).writeAsStringSync('{}');
    Directory(join(nodeProject.path, 'node_modules', 'dependency'))
        .createSync(recursive: true);

    expect(cleanProjectArtifacts(root), 2);
    expect(Directory(join(rustProject.path, 'target')).existsSync(), isFalse);
    expect(
      Directory(join(nodeProject.path, 'node_modules')).existsSync(),
      isFalse,
    );
  });

  test('keeps matching directories that have no project manifest', () {
    final ordinaryDirectory = Directory(join(root.path, 'ordinary'))
      ..createSync();
    Directory(join(ordinaryDirectory.path, 'target')).createSync();
    Directory(join(ordinaryDirectory.path, 'node_modules')).createSync();

    expect(cleanProjectArtifacts(root), 0);
    expect(
        Directory(join(ordinaryDirectory.path, 'target')).existsSync(), isTrue);
    expect(
      Directory(join(ordinaryDirectory.path, 'node_modules')).existsSync(),
      isTrue,
    );
  });

  test('deletes .dart_tool only when its contents are over a week old', () {
    final stale = Directory(join(root.path, 'stale', '.dart_tool'))
      ..createSync(recursive: true);
    final staleFile = File(join(stale.path, 'package_config.json'))
      ..writeAsStringSync('{}');
    final recent = Directory(join(root.path, 'recent', '.dart_tool'))
      ..createSync(recursive: true);
    final recentFile = File(join(recent.path, 'package_config.json'))
      ..writeAsStringSync('{}');
    final now = DateTime.now().add(const Duration(days: 8));
    staleFile.setLastModifiedSync(now.subtract(const Duration(days: 8)));
    recentFile.setLastModifiedSync(now.subtract(const Duration(days: 6)));

    expect(
      cleanStaleDartToolDirectories(root, now: now),
      1,
    );
    expect(stale.existsSync(), isFalse);
    expect(recent.existsSync(), isTrue);
  });

  test('deletes stale directories directly beneath a workspace root', () {
    final workspaceRoot = Directory(join(root.path, 'workspaces'))
      ..createSync();
    final stale = Directory(join(workspaceRoot.path, 'stale'))
      ..createSync(recursive: true);
    final staleFile = File(join(stale.path, 'state'))..writeAsStringSync('');
    final recent = Directory(join(workspaceRoot.path, 'recent'))
      ..createSync(recursive: true);
    final recentFile = File(join(recent.path, 'state'))..writeAsStringSync('');
    final now = DateTime.now().add(const Duration(days: 8));
    staleFile.setLastModifiedSync(now.subtract(const Duration(days: 8)));
    recentFile.setLastModifiedSync(now.subtract(const Duration(days: 6)));

    expect(cleanStaleDirectories(workspaceRoot, now: now), 1);
    expect(stale.existsSync(), isFalse);
    expect(recent.existsSync(), isTrue);
  });
}
