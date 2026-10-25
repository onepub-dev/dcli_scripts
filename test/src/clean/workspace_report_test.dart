import 'dart:io';

import 'package:dcli_scripts/src/clean/workspace_report.dart';
import 'package:path/path.dart';
import 'package:test/test.dart';

void main() {
  late Directory home;
  late DateTime now;

  Directory workspace(String path) =>
      Directory(join(home.path, path))..createSync(recursive: true);

  void git(Directory directory, List<String> args) {
    final result = Process.runSync('git', ['-C', directory.path, ...args]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
  }

  setUp(() {
    home = Directory.systemTemp.createTempSync('workspace_report');
    now = DateTime.now().add(const Duration(days: 31));
  });
  tearDown(() => home.deleteSync(recursive: true));

  Directory committedRepo(String name) {
    final repo = workspace('.codex/workspaces/$name');
    git(repo, ['init', '-b', 'task']);
    File(join(repo.path, 'source')).writeAsStringSync('initial');
    git(repo, ['add', '.']);
    git(repo, [
      '-c',
      'user.name=Test',
      '-c',
      'user.email=test@example.com',
      'commit',
      '-m',
      'initial'
    ]);
    git(repo, ['branch', 'upstream']);
    git(repo, ['branch', '--set-upstream-to=upstream']);
    return repo;
  }

  void commit(Directory repo) {
    git(repo, ['add', '.']);
    git(repo, [
      '-c',
      'user.name=Test',
      '-c',
      'user.email=test@example.com',
      'commit',
      '-m',
      'change'
    ]);
  }

  WorkspaceReport report() => reportOldCodexWorkspaces(home, now: now).single;

  test('clean merged work uses local upstream refs, including when behind', () {
    final repo = committedRepo('merged');
    expect(report().classification, WorkspaceClassification.likelyFinished);
    git(repo, ['checkout', 'upstream']);
    File(join(repo.path, 'later')).writeAsStringSync('upstream change');
    commit(repo);
    git(repo, ['checkout', 'task']);
    expect(report().classification, WorkspaceClassification.likelyFinished);
    expect(report().git.single,
        contains('0 commits not in local upstream ref, 1 behind'));
  });

  test('dirty and untracked work are unfinished independently', () {
    final repo = committedRepo('dirty');
    File(join(repo.path, 'source')).writeAsStringSync('dirty');
    expect(report().classification, WorkspaceClassification.unfinished);
    git(repo, ['checkout', '--', 'source']);
    File(join(repo.path, 'notes')).writeAsStringSync('unfinished notes');
    expect(report().classification, WorkspaceClassification.unfinished);
  });

  test('ahead and diverged commits are unfinished', () {
    final repo = committedRepo('ahead');
    File(join(repo.path, 'local')).writeAsStringSync('local');
    commit(repo);
    expect(report().classification, WorkspaceClassification.unfinished);
    git(repo, ['checkout', 'upstream']);
    File(join(repo.path, 'remote')).writeAsStringSync('other');
    commit(repo);
    git(repo, ['checkout', 'task']);
    expect(report().classification, WorkspaceClassification.unfinished);
    expect(report().git.single,
        contains('1 commits not in local upstream ref, 1 behind'));
  });

  test('missing upstream and missing repository need investigation', () {
    final repo = committedRepo('unknown');
    git(repo, ['branch', '--unset-upstream']);
    expect(report().classification, WorkspaceClassification.investigation);
    Directory(join(repo.path, '.git')).deleteSync(recursive: true);
    expect(report().classification, WorkspaceClassification.investigation);
    expect(report().reasons, contains('No Git repository found'));
  });

  test('ignored valuable data needs investigation; manifest caches do not', () {
    final repo = committedRepo('ignored');
    File(join(repo.path, '.gitignore'))
        .writeAsStringSync('target/\nsecrets/\n');
    File(join(repo.path, 'Cargo.toml')).writeAsStringSync('[package]');
    commit(repo);
    git(repo, ['branch', '-f', 'upstream', 'HEAD']);
    Directory(join(repo.path, 'target')).createSync();
    File(join(repo.path, 'target', 'cache')).writeAsStringSync('generated');
    expect(report().classification, WorkspaceClassification.likelyFinished);
    Directory(join(repo.path, 'secrets')).createSync();
    File(join(repo.path, 'secrets', 'valuable')).writeAsStringSync('retain');
    expect(report().classification, WorkspaceClassification.investigation);
    expect(report().reasons.single, contains('Unexplained ignored file'));
    File(join(repo.path, 'Cargo.toml')).deleteSync();
    commit(repo);
    git(repo, ['branch', '-f', 'upstream', 'HEAD']);
    expect(report().reasons.any((reason) => reason.contains('target/cache')),
        isTrue);
  });

  test('outside evidence and symlinks need investigation; dirty repo wins', () {
    final repo = committedRepo('container');
    final nested = Directory(join(repo.path, 'repo'))..createSync();
    for (final entry in repo
        .listSync()
        .where((entry) => entry.path != nested.path)
        .toList()) {
      entry.renameSync(join(nested.path, basename(entry.path)));
    }
    final evidence = File(join(repo.path, 'evidence.txt'))
      ..writeAsStringSync('keep');
    expect(report().classification, WorkspaceClassification.investigation);
    evidence.deleteSync();
    Link(join(repo.path, 'evidence-link')).createSync(home.path);
    expect(report().classification, WorkspaceClassification.investigation);
    File(join(nested.path, 'source')).writeAsStringSync('dirty');
    expect(report().classification, WorkspaceClassification.unfinished);
  });

  test('multiple repositories aggregate conservatively', () {
    final first = committedRepo('first');
    final second = committedRepo('second');
    final task = workspace('Documents/Codex/2026-09-01/multi');
    final movedFirst = first.renameSync(join(task.path, 'first'));
    final movedSecond = second.renameSync(join(task.path, 'second'));
    expect(report().classification, WorkspaceClassification.likelyFinished);
    git(movedSecond, ['branch', '--unset-upstream']);
    expect(report().classification, WorkspaceClassification.investigation);
    File(join(movedFirst.path, 'source')).writeAsStringSync('unfinished');
    expect(report().classification, WorkspaceClassification.unfinished);
    expect(report().git, hasLength(2));
  });

  test('broken Git metadata needs investigation', () {
    final repo = workspace('.codex/workspaces/broken');
    File(join(repo.path, '.git')).writeAsStringSync('gitdir: /missing/repo');
    expect(report().classification, WorkspaceClassification.investigation);
    expect(report().git.single, contains('Git status unavailable'));
  });

  test('discovers bounded direct and date/task units, never symlinks', () {
    final direct = workspace('.codex/workspaces/first');
    final worktree = workspace('git/.codex.workspaces/second');
    final task = workspace('Documents/Codex/2026-09-01/task');
    workspace('Documents/Codex/2026-09-01/task/workspace/repo');
    workspace('Documents/Codex/arbitrary/old');
    workspace('git/ordinary');
    workspace('git/.codex.workspaces/.cipd');
    Link(join(home.path, '.codex/workspaces/link')).createSync(task.path);
    expect(discoverCodexWorkspaces(home).map((entry) => entry.path),
        unorderedEquals([direct.path, worktree.path, task.path]));
  });

  test('marker in a nested repo protects entire task and all contents remain',
      () {
    final task = workspace('Documents/Codex/2026-09-01/task/repo');
    final marker = File(join(task.path, '.clean-keep'))..writeAsStringSync('');
    expect(reportOldCodexWorkspaces(home, now: now), isEmpty);
    expect(marker.existsSync(), isTrue);
    marker.deleteSync();
    expect(reportOldCodexWorkspaces(home, now: now), hasLength(1));
    expect(task.existsSync(), isTrue);
  });

  test('strict cutoff and recent source protect; caches only add size', () {
    final root = workspace('.codex/workspaces/first');
    final source = File(join(root.path, 'Cargo.toml'))
      ..writeAsStringSync('[package]');
    final target = Directory(join(root.path, 'target'))..createSync();
    final artifact = File(join(target.path, 'artifact'))
      ..writeAsStringSync('cache')
      ..setLastModifiedSync(now);
    final report = reportOldCodexWorkspaces(home, now: now).single;
    expect(report.bytes, source.lengthSync() + artifact.lengthSync());
    source.setLastModifiedSync(now.subtract(const Duration(days: 30)));
    expect(reportOldCodexWorkspaces(home, now: now), isEmpty);
    source.setLastModifiedSync(now);
    expect(reportOldCodexWorkspaces(home, now: now), isEmpty);
    expect(artifact.existsSync(), isTrue);
  });

  test(
      'reports nested Git dirty/untracked status and preserves nonrepo evidence',
      () {
    final repo = workspace('Documents/Codex/2026-09-01/task/workspace/repo');
    git(repo, ['init', '-b', 'review-branch']);
    final source = File(join(repo.path, 'source'))
      ..writeAsStringSync('initial');
    git(repo, ['add', 'source']);
    git(repo, [
      '-c',
      'user.name=Test',
      '-c',
      'user.email=test@example.com',
      'commit',
      '-m',
      'initial',
    ]);
    source.writeAsStringSync('changed');
    File(join(repo.path, 'notes')).writeAsStringSync('untracked');
    final evidence = File(join(repo.parent.parent.path, 'evidence.txt'))
      ..writeAsStringSync('keep');
    final report = reportOldCodexWorkspaces(home, now: now).single;
    expect(report.git.single, contains('review-branch'));
    expect(
        report.git.single, contains('1 tracked changes, 1 untracked entries'));
    expect(evidence.readAsStringSync(), 'keep');
    expect(source.readAsStringSync(), 'changed');
  });

  test('external linked-worktree index activity protects candidate', () {
    final main = workspace('main');
    git(main, ['init']);
    File(join(main.path, 'source')).writeAsStringSync('initial');
    git(main, ['add', 'source']);
    git(main, [
      '-c',
      'user.name=Test',
      '-c',
      'user.email=test@example.com',
      'commit',
      '-m',
      'initial',
    ]);
    final linked = join(home.path, '.codex/workspaces/linked');
    git(main, ['worktree', 'add', '-b', 'linked', linked]);
    expect(reportOldCodexWorkspaces(home, now: now), hasLength(1));
    final result = Process.runSync(
        'git', ['-C', linked, 'rev-parse', '--absolute-git-dir']);
    File(join((result.stdout as String).trim(), 'index'))
        .setLastModifiedSync(now);
    expect(reportOldCodexWorkspaces(home, now: now), isEmpty);
  });
}
