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
}
