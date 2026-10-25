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

  test('preserves Rust target and deletes Node node_modules directories', () {
    final rustProject = Directory(join(root.path, 'rust'))..createSync();
    File(join(rustProject.path, 'Cargo.toml')).writeAsStringSync('[package]');
    Directory(join(rustProject.path, 'target', 'debug'))
        .createSync(recursive: true);

    final nodeProject = Directory(join(root.path, 'node'))..createSync();
    File(join(nodeProject.path, 'package.json')).writeAsStringSync('{}');
    Directory(join(nodeProject.path, 'node_modules', 'dependency'))
        .createSync(recursive: true);

    expect(cleanProjectArtifacts(root), 1);
    expect(Directory(join(rustProject.path, 'target')).existsSync(), isTrue);
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

  group('stale Rust deps', () {
    late DateTime now;

    Directory createDeps(String path, {bool cargo = true}) {
      final deps = Directory(join(root.path, path))
        ..createSync(recursive: true);
      if (cargo) {
        Directory(join(deps.parent.path, '.fingerprint')).createSync();
      }
      File(join(deps.path, 'libexample.rlib')).writeAsStringSync('artifact');
      return deps;
    }

    setUp(() {
      now = DateTime.now().add(const Duration(days: 4));
    });

    test('finds standard, hidden, custom and cross-compiled output', () {
      final deps = [
        createDeps('project/target/debug/deps'),
        createDeps('project/target/release/deps'),
        createDeps('.codex.cargo-targets/monitor/debug/deps'),
        createDeps('issue165-target/debug/deps'),
        createDeps('nested/custom/aarch64-unknown-linux-gnu/release/deps'),
      ];
      // Cargo's profile lock is sufficient even without fingerprints.
      Directory(join(deps.last.parent.path, '.fingerprint')).deleteSync();
      File(join(deps.last.parent.path, '.cargo-lock')).writeAsStringSync('');
      expect(cleanStaleRustDepsDirectories(root, now: now), deps.length);
      for (final directory in deps) {
        expect(directory.existsSync(), isFalse);
        expect(directory.parent.existsSync(), isTrue);
      }
    });

    test('keeps unrelated deps and nonstandard profiles', () {
      final unrelated = createDeps('application/debug/deps', cargo: false);
      final customProfile = createDeps('target/custom/deps');
      final plainDeps = createDeps('application/deps');
      expect(cleanStaleRustDepsDirectories(root, now: now), 0);
      for (final directory in [unrelated, customProfile, plainDeps]) {
        expect(directory.existsSync(), isTrue);
      }
    });

    test('keeps recently accessed, modified and exact-cutoff files', () {
      final accessed = createDeps('accessed/target/debug/deps');
      final modified = createDeps('modified/target/debug/deps');
      final boundary = createDeps('boundary/target/debug/deps');
      File(join(accessed.path, 'libexample.rlib'))
          .setLastAccessedSync(now.subtract(const Duration(days: 2)));
      File(join(modified.path, 'libexample.rlib'))
          .setLastModifiedSync(now.subtract(const Duration(days: 2)));
      File(join(boundary.path, 'libexample.rlib'))
          .setLastAccessedSync(now.subtract(const Duration(days: 3)));
      expect(cleanStaleRustDepsDirectories(root, now: now), 0);
    });

    test('nested recent files protect deps until they become stale', () {
      final deps = createDeps('target/debug/deps');
      final nested = Directory(join(deps.path, 'nested', 'deeper'))
        ..createSync(recursive: true);
      final file = File(join(nested.path, 'artifact'))
        ..writeAsStringSync('')
        ..setLastAccessedSync(now);
      expect(cleanStaleRustDepsDirectories(root, now: now), 0);
      file.setLastAccessedSync(now.subtract(const Duration(days: 4)));
      expect(cleanStaleRustDepsDirectories(root, now: now), 1);
    });

    test('retains newly created empty deps', () {
      final deps = createDeps('target/debug/deps');
      File(join(deps.path, 'libexample.rlib')).deleteSync();
      expect(cleanStaleRustDepsDirectories(root), 0);
      expect(cleanStaleRustDepsDirectories(root, now: now), 1);
    });

    test('never follows directory links or deletes linked contents', () {
      final outside = Directory.systemTemp.createTempSync('rust_deps_external');
      try {
        final profile = Directory(join(outside.path, 'debug'))..createSync();
        Directory(join(profile.path, '.fingerprint')).createSync();
        final externalDeps = Directory(join(profile.path, 'deps'))
          ..createSync();
        Link(join(root.path, 'linked-target')).createSync(outside.path);
        final deps = createDeps('target/debug/deps');
        Link(join(deps.path, 'linked-file')).createSync(outside.path);
        expect(cleanStaleRustDepsDirectories(root, now: now), 0);
        expect(externalDeps.existsSync(), isTrue);
        expect(deps.existsSync(), isTrue);
        expect(
          cleanStaleRustDepsDirectories(
            Directory(join(root.path, 'linked-target')),
            now: now,
          ),
          0,
        );
      } finally {
        outside.deleteSync(recursive: true);
      }
    });
  });
}
