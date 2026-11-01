import 'dart:io';
import 'dart:math';

import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as p;

/// Recursively finds directories while tolerating entries which disappear.
Iterable<Directory> findDirectoriesSafely(
  Directory root, {
  void Function(String path, Object exception)? onError,
  Set<String> excludedPaths = const {},
}) sync* {
  if (excludedPaths.contains(root.path)) {
    return;
  }
  List<FileSystemEntity> entries;
  try {
    entries = root.listSync(followLinks: false);
  } on PathNotFoundException {
    return;
  } on FileSystemException catch (exception) {
    onError?.call(root.path, exception);
    return;
  }

  for (final entry in entries) {
    if (entry is Directory && !excludedPaths.contains(entry.path)) {
      yield entry;
      yield* findDirectoriesSafely(
        entry,
        onError: onError,
        excludedPaths: excludedPaths,
      );
    }
  }
}

/// Prints the largest directories beneath [root].
void runDiskHog(
  Directory root, {
  void Function(String path, Object exception)? onError,
  Set<String> excludedPaths = const {},
}) {
  print(green('Scanning...'));
  final directories = findDirectoriesSafely(
    root,
    onError: onError,
    excludedPaths: excludedPaths,
  ).toList();
  print(orange('Found ${directories.length} directories'));

  final directorySizes = <DirectorySize>[];
  var totalSpace = 0;
  print(green('Calculating sizes...'));
  for (final directory in directories) {
    final directorySize = DirectorySize(directory.path);
    try {
      for (final entry in directory.listSync(followLinks: false)) {
        try {
          final fileSize = entry.statSync().size;
          directorySize.size += fileSize;
          totalSpace += fileSize;
        } on FileSystemException catch (exception) {
          onError?.call(entry.path, exception);
        }
      }
      directorySizes.add(directorySize);
    } on PathNotFoundException {
      continue;
    } on FileSystemException catch (exception) {
      onError?.call(directory.path, exception);
    }
  }

  directorySizes.sort((a, b) => b.size - a.size);

  print('${orange('Space Used by ${root.absolute.path}:')} '
      '${green(humanNumber(totalSpace))}');
  print('${orange('Free Space:')} '
      '${green(humanNumber(availableSpace(root.path)))}');

  for (var i = 0; i < min(50, directorySizes.length); i++) {
    if (directorySizes[i].size == 0) {
      continue;
    }
    print(
      Format().row(
        <String>[
          humanNumber(directorySizes[i].size),
          directorySizes[i].pathTo,
        ],
        widths: <int>[10, -1],
        alignments: <TableAlignment>[
          TableAlignment.right,
          TableAlignment.left,
        ],
      ),
    );
  }
}

/// Mounts beneath [root] are separate filesystems and not part of its usage.
Set<String> mountedDirectoriesUnder(Directory root) {
  if (!Platform.isLinux) {
    return {};
  }
  final mountInfo = File('/proc/self/mountinfo');
  if (!mountInfo.existsSync()) {
    return {};
  }
  return mountInfo
      .readAsLinesSync()
      .map((line) {
        final fields = line.split(' ');
        return fields.length > 4
            ? fields[4].replaceAllMapped(RegExp(r'\\([0-7]{3})'),
                (match) => String.fromCharCode(int.parse(match[1]!, radix: 8)))
            : '';
      })
      .where((mountpoint) => p.isWithin(root.path, mountpoint))
      .toSet();
}

class DirectorySize {
  DirectorySize(this.pathTo);

  String pathTo;
  var size = 0;
}

/// Returns [bytes] in a human-readable form such as 10G, 100M, 20K or 10B.
String humanNumber(int bytes) {
  String human;

  final stringValue = '$bytes';
  if (bytes > 1000000000) {
    human = stringValue.substring(0, stringValue.length - 9);
    human += 'G';
  } else if (bytes > 1000000) {
    human = stringValue.substring(0, stringValue.length - 6);
    human += 'M';
  } else if (bytes > 1000) {
    human = stringValue.substring(0, stringValue.length - 3);
    human += 'K';
  } else {
    human = '${stringValue}B';
  }
  return human;
}

int availableSpace(String path) {
  if (!Directory(path).existsSync()) {
    throw FileSystemException("The given path $path doesn't exist");
  }

  // Use fixed-size blocks so values such as 1.5T need no rounding or suffix
  // parsing. -P keeps the filesystem entry on one line.
  final result = Process.runSync('df', ['-Pk', path]);
  if (result.exitCode != 0) {
    throw FileSystemException(
      'Unable to retrieve free space: ${result.stderr}',
      path,
    );
  }

  return parseAvailableSpace(result.stdout as String);
}

/// Parses the available 1024-byte blocks reported by `df -Pk`.
int parseAvailableSpace(String output) {
  final lines = output.trim().split('\n');
  if (lines.length != 2) {
    throw FileSystemException(
      'An error occurred retrieving the device path: ${lines.join('\n')}',
    );
  }

  final parts = lines[1].trim().split(RegExp(r'\s+'));
  if (parts.length < 4) {
    throw FileSystemException('An error parsing line: ${lines[1]}');
  }

  final availableBlocks = int.tryParse(parts[3]);
  if (availableBlocks == null) {
    throw FileSystemException('Invalid available space in line: ${lines[1]}');
  }

  return availableBlocks * 1024;
}
