#! /usr/bin/env dcli

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:settings_yaml/settings_yaml.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('team', abbr: 't', mandatory: true)
    ..addOption('owner', abbr: 'o', mandatory: true)
    ..addOption(
      'permission',
      abbr: 'p',
      allowed: ['admin', 'push', 'pull'],
      defaultsTo: 'pull',
    );
  late final ArgResults parsed;
  try {
    parsed = parser.parse(args);
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    stderr.writeln(parser.usage);
    exitCode = 1;
    return;
  }
  if (!parsed.wasParsed('team') || !parsed.wasParsed('owner')) {
    stderr.writeln(parser.usage);
    exitCode = 1;
    return;
  }
  final team = parsed['team'] as String;
  final owner = parsed['owner'] as String;
  final permission = parsed['permission'] as String;
  _validateSegment(team);
  _validateSegment(owner);

  const settingsPath = 'github.yaml';
  if (FileSystemEntity.typeSync(settingsPath, followLinks: false) !=
      FileSystemEntityType.file) {
    throw FileSystemException(
      'Credential file is missing or linked',
      settingsPath,
    );
  }
  if (!Platform.isWindows &&
      Process.runSync('chmod', ['600', settingsPath]).exitCode != 0) {
    throw StateError('Could not protect GitHub credentials');
  }
  final token =
      SettingsYaml.load(pathToSettings: settingsPath)['gittoken'] as String;

  final repos = await Process.run('gh', [
    'repo',
    'list',
    owner,
    '--json',
    'owner,name',
    '--limit',
    '10000',
  ]);
  if (repos.exitCode != 0) {
    throw StateError('Could not list GitHub repositories: ${repos.stderr}');
  }
  final entries = jsonDecode(repos.stdout as String) as List<dynamic>;
  final client = HttpClient();
  try {
    for (final entry in entries) {
      final repo = entry as Map<String, dynamic>;
      final name = repo['name'] as String;
      final repoOwner =
          (repo['owner'] as Map<String, dynamic>)['login'] as String;
      _validateSegment(name);
      _validateSegment(repoOwner);
      if (repoOwner.toLowerCase() != owner.toLowerCase()) continue;
      await addToTeam(client, token, repoOwner, team, name,
          permission: permission);
    }
  } finally {
    client.close();
  }
}

Future<void> addToTeam(
  HttpClient client,
  String token,
  String owner,
  String team,
  String repoName, {
  required String permission,
}) async {
  final uri = Uri.https(
    'api.github.com',
    '/orgs/$owner/teams/$team/repos/$owner/$repoName',
  );
  final request = await client.putUrl(uri);
  request.headers
    ..set(HttpHeaders.authorizationHeader, 'Bearer $token')
    ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
    ..set(HttpHeaders.contentTypeHeader, 'application/json');
  request.write(jsonEncode({'permission': permission}));
  final response = await request.close();
  await response.drain<void>();
  if (response.statusCode != HttpStatus.noContent) {
    throw HttpException(
      'GitHub team update failed (${response.statusCode})', uri: uri);
  }
  print(green('Added $team to $owner/$repoName'));
}

void _validateSegment(String value) {
  if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9_.-]*$').hasMatch(value) ||
      value == '..') {
    throw FormatException('Invalid GitHub owner, team, or repository name');
  }
}
