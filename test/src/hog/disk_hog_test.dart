import 'dart:async';
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

  test('silently skips a missing directory', () {
    final missing = Directory(join(root.path, 'temporary'));
    final errors = <Object>[];

    expect(
      findDirectoriesSafely(
        missing,
        onError: (path, exception) => errors.add(exception),
      ),
      isEmpty,
    );
    expect(errors, isEmpty);
  });

  test('continues after a directory disappears during traversal', () {
    Directory(join(root.path, 'first')).createSync();
    Directory(join(root.path, 'second')).createSync();
    final errors = <Object>[];
    final iterator = findDirectoriesSafely(
      root,
      onError: (path, exception) => errors.add(exception),
    ).iterator;

    expect(iterator.moveNext(), isTrue);
    iterator.current.deleteSync();
    expect(iterator.moveNext(), isTrue);
    expect(iterator.current.existsSync(), isTrue);
    expect(iterator.moveNext(), isFalse);
    expect(errors, isEmpty);
  });

  test('reports listing errors other than missing paths', () {
    final file = File(join(root.path, 'file'))..writeAsStringSync('data');
    final errors = <Object>[];
    final paths = <String>[];

    expect(
      findDirectoriesSafely(
        Directory(file.path),
        onError: (path, exception) {
          paths.add(path);
          errors.add(exception);
        },
      ),
      isEmpty,
    );
    expect(paths, <String>[file.path]);
    expect(errors, <Matcher>[isA<FileSystemException>()]);
  });

  test('silently skips directories removed before size calculation', () {
    final temporary = Directory(join(root.path, 'temporary'))..createSync();
    final retained = Directory(join(root.path, 'retained'))..createSync();
    File(join(retained.path, 'file')).writeAsStringSync('retained data');
    final errors = <Object>[];
    final output = <String>[];

    runZoned(
      () => runDiskHog(
        root,
        onError: (path, exception) => errors.add(exception),
      ),
      zoneSpecification: ZoneSpecification(
        print: (self, parent, zone, line) {
          output.add(line);
          if (line.contains('Calculating sizes...')) {
            temporary.deleteSync();
          }
        },
      ),
    );

    expect(errors, isEmpty);
    expect(output.any((line) => line.contains(retained.path)), isTrue);
    expect(output.any((line) => line.contains(temporary.path)), isFalse);
  });

  test('parses terabyte-scale available space from df blocks', () {
    const output = 'Filesystem 1024-blocks Used Available Capacity Mounted on\n'
        '/dev/dm-1 2000000000 389387264 1610612736 20% /home\n';

    expect(parseAvailableSpace(output), 1610612736 * 1024);
  });

  test('rejects invalid available space instead of reporting zero', () {
    const output = 'Filesystem 1024-blocks Used Available Capacity Mounted on\n'
        '/dev/dm-1 2000000000 0 unknown 20% /home\n';

    expect(
      () => parseAvailableSpace(output),
      throwsA(isA<FileSystemException>()),
    );
  });

  test('reads available space for an existing directory', () {
    expect(availableSpace(root.path), greaterThanOrEqualTo(0));
  });
}
