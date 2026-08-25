import 'dart:io';

import 'package:dcli_scripts/src/git/git_gc.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('git_gc_test');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('finds repositories recursively', () {
    final first = Directory(join(root.path, 'first', '.git'))
      ..createSync(recursive: true);
    final second = Directory(join(root.path, 'nested', 'second', '.git'))
      ..createSync(recursive: true);

    expect(
      findGitDirectories(root).map((directory) => directory.path),
      containsAll(<String>[first.path, second.path]),
    );
  });

  test('does not scan volatile generated directories', () {
    Directory(join(root.path, 'target', 'crate', '.git'))
        .createSync(recursive: true);
    Directory(join(root.path, 'node_modules', 'package', '.git'))
        .createSync(recursive: true);
    final repository = Directory(join(root.path, 'project', '.git'))
      ..createSync(recursive: true);

    expect(
      findGitDirectories(root).map((directory) => directory.path),
      <String>[repository.path],
    );
  });

  test('reports a missing scan root without throwing', () {
    final missing = Directory(join(root.path, 'missing'));
    final errors = <Object>[];

    expect(
      findGitDirectories(
        missing,
        onError: (path, exception) => errors.add(exception),
      ),
      isEmpty,
    );
    expect(errors, hasLength(1));
  });
}
