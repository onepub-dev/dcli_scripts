import 'dart:io';
import 'dart:math';

import 'package:dcli/dcli.dart';

/// Recursively finds directories while tolerating entries which disappear.
Iterable<Directory> findDirectoriesSafely(
  Directory root, {
  void Function(String path, Object exception)? onError,
}) sync* {
  List<FileSystemEntity> entries;
  try {
    entries = root.listSync(followLinks: false);
  } on FileSystemException catch (exception) {
    onError?.call(root.path, exception);
    return;
  }

  for (final entry in entries) {
    if (entry is Directory) {
      yield entry;
      yield* findDirectoriesSafely(entry, onError: onError);
    }
  }
}

/// Prints the largest directories beneath [root].
void runDiskHog(
  Directory root, {
  void Function(String path, Object exception)? onError,
}) {
  print(green('Scanning...'));
  final directories = findDirectoriesSafely(root, onError: onError).toList();
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

  final lines = 'df -h "$path"'.toList();
  if (lines.length != 2) {
    throw FileSystemException(
      'An error occurred retrieving the device path: ${lines.join('\n')}',
    );
  }

  final parts = lines[1].split(RegExp(r'\s+'));
  if (parts.length != 6) {
    throw FileSystemException('An error parsing line: ${lines[1]}');
  }

  final humanAvailable = parts[3];
  if (humanAvailable == '0') {
    return 0;
  }

  final factors = <String, int>{
    'G': 1000000000,
    'M': 1000000,
    'K': 1000,
    'B': 1,
  };
  final factorLetter = humanAvailable.substring(humanAvailable.length - 1);
  final factor = factors[factorLetter];
  if (factor == null) {
    throw FileSystemException(
      "Unrecognized size factor '$factorLetter' in $humanAvailable",
    );
  }

  final size = humanAvailable.substring(0, humanAvailable.length - 1);
  return (int.tryParse(size) ?? 0) * factor;
}
