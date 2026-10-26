#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:dcli_scripts/src/private_temp.dart';
import 'package:path/path.dart' as path;
import 'package:settings_yaml/settings_yaml.dart';

/// Imports the repos listed in repo.list.csv without exposing credentials in
/// Git arguments, remote URLs, or retained temporary clones.
Future<void> main() async {
  const list = 'repo.list.csv';
  if (!File(list).existsSync()) {
    stderr.writeln('List not found: $list');
    exitCode = 1;
    return;
  }
  const settingsPath = 'bitbucket.yaml';
  if (FileSystemEntity.typeSync(settingsPath, followLinks: false) !=
      FileSystemEntityType.file) {
    throw FileSystemException(
      'Credential file is missing or linked',
      settingsPath,
    );
  }
  if (!Platform.isWindows &&
      Process.runSync('chmod', ['600', settingsPath]).exitCode != 0) {
    throw StateError('Could not protect Bitbucket credentials');
  }
  final settings = SettingsYaml.load(pathToSettings: settingsPath);
  final bitbucketPassword = settings['password'] as String;
  final githubToken = settings['gittoken'] as String;
  final githubUser = settings['gitusername'] as String;
  final owner = settings['gitowner'] as String;
  _validateName(owner);

  Settings().setVerbose(enabled: false);
  for (final row in File(list).readAsLinesSync()) {
    if (row.trim().isEmpty) continue;
    final separator = row.indexOf(',');
    if (separator < 1) throw FormatException('Invalid repository row');
    final name = _unquote(row.substring(0, separator));
    final source = Uri.parse(_unquote(row.substring(separator + 1)));
    _validateName(name);
    if (source.scheme != 'https' || source.host != 'bitbucket.org') {
      throw FormatException('Only HTTPS Bitbucket URLs are supported');
    }
    if (source.userInfo.contains(':')) {
      throw FormatException(
        'Bitbucket password must not appear in the CSV URL',
      );
    }
    final bitbucketUser = Uri.decodeComponent(source.userInfo);
    if (bitbucketUser.isEmpty) {
      throw FormatException('Bitbucket URL must include a user name');
    }
    final sanitizedSource = source.replace(userInfo: '').toString();
    final destination = 'https://github.com/$owner/$name.git';

    await _run('gh', ['repo', 'create', '$owner/$name', '--private']);
    final temp = createPrivateTemporaryDirectory(
      Directory.systemTemp.path,
      'bitbucket-import-',
    );
    try {
      final clone = path.join(temp.path, '$name.git');
      await _git(
        ['clone', '--bare', '--', sanitizedSource, clone],
        bitbucketUser,
        bitbucketPassword,
      );
      await _git(
        ['-C', clone, 'push', '--mirror', destination],
        githubUser,
        githubToken,
      );
    } finally {
      temp.deleteSync(recursive: true);
    }
  }
}

String _unquote(String value) {
  final text = value.trim();
  return text.startsWith('"') && text.endsWith('"')
      ? text.substring(1, text.length - 1).replaceAll('""', '"')
      : text;
}

void _validateName(String name) {
  if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$').hasMatch(name) || name == '..') {
    throw FormatException('Invalid repository or owner name');
  }
}

Future<void> _git(List<String> args, String user, String password) async {
  final helper = path.join(
    DartScript.self.pathToScriptDirectory,
    'git_askpass.dart',
  );
  if (!File(helper).existsSync()) {
    throw StateError('Git credential helper is missing');
  }
  await _run(
    'git',
    args,
    environment: {
      'GIT_ASKPASS': helper,
      'GIT_TERMINAL_PROMPT': '0',
      'GIT_CONFIG_COUNT': '1',
      'GIT_CONFIG_KEY_0': 'credential.helper',
      'GIT_CONFIG_VALUE_0': '',
      'DCLI_IMPORT_USERNAME': user,
      'DCLI_IMPORT_PASSWORD': password,
    },
  );
}

Future<void> _run(
  String executable,
  List<String> args, {
  Map<String, String> environment = const {},
}) async {
  final process = await Process.start(
    executable,
    args,
    environment: environment,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0) {
    throw StateError('$executable ${args.first} failed with status $code');
  }
}
