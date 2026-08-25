import 'dart:io';

import 'package:dcli_scripts/src/hog/disk_hog.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('disk_hog_test');
  });

  tearDown(() {
    if (root.existsSync()) {
      root.deleteSync(recursive: true);
    }
  });

  test('finds nested directories', () {
    final first = Directory(join(root.path, 'first'))..createSync();
    final second = Directory(join(first.path, 'second'))..createSync();

    expect(
      findDirectoriesSafely(root).map((directory) => directory.path),
      <String>[first.path, second.path],
    );
  });

  test('reports a directory that disappears without throwing', () {
    final missing = Directory(join(root.path, 'temporary'));
    final errors = <Object>[];

    expect(
      findDirectoriesSafely(
        missing,
        onError: (path, exception) => errors.add(exception),
      ),
      isEmpty,
    );
    expect(errors, hasLength(1));
  });
}
