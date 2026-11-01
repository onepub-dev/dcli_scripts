import 'dart:io';

import 'package:dcli_scripts/src/mysql/mysql_defaults.dart';
import 'package:dcli_scripts/src/mysql/mysql_settings.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:test/test.dart';

void main() {
  test('database names cannot escape the private config directory', () {
    for (final name in [
      '../other',
      '/tmp/other',
      'db name',
      'db`name',
      '--all-databases',
      '-x',
    ]) {
      expect(() => MySqlSettings.pathToSettings(name), throwsArgumentError);
    }
    expect(MySqlSettings.pathToSettings('db-name_1'), endsWith('db-name_1'));
  });

  test('MySQL password is held in a private temporary option file', () {
    final settings = MySqlSettings(
      host: 'localhost',
      port: 3306,
      user: 'example',
      password: 'a"b\\c',
      dbname: 'example',
      sslVerifyServerCert: true,
      sslCa: '/tmp/test-ca.pem',
    );
    final defaults = MySqlDefaults(settings);
    final path = defaults.option.substring('--defaults-file='.length);
    try {
      expect(defaults.option, isNot(contains(settings.password)));
      expect(defaults.connectionOptions(settings), contains('--protocol=TCP'));
      expect(defaults.connectionOptions(settings), contains('--port=3306'));
      expect(File(path).readAsStringSync(), contains(r'password="a\"b\\c"'));
      if (!Platform.isWindows &&
          Process.runSync('which', ['my_print_defaults']).exitCode == 0) {
        final otherHome = Directory.systemTemp.createTempSync('mysql-home-');
        try {
          File('${otherHome.path}/.my.cnf')
              .writeAsStringSync('[client]\nhost=wrong.example\nuser=wrong\n');
          final parsed = Process.runSync(
            'my_print_defaults',
            [defaults.option, 'client'],
            environment: {...defaults.environment, 'HOME': otherHome.path},
          );
          expect(parsed.exitCode, 0);
          expect(parsed.stdout, contains('--password=${settings.password}'));
          expect(parsed.stdout, contains('--host=localhost'));
          expect(parsed.stdout, isNot(contains('wrong.example')));
        } finally {
          otherHome.deleteSync(recursive: true);
        }
      }
      if (!Platform.isWindows) {
        expect(Directory(File(path).parent.path).statSync().mode & 0x3f, 0);
        expect(File(path).statSync().mode & 0x3f, 0);
      }
    } finally {
      defaults.dispose();
    }
    expect(File(path).existsSync(), isFalse);
  });

  test('inherited TLS policy cannot be silently dropped', () {
    if (Platform.isWindows ||
        Process.runSync('which', ['my_print_defaults']).exitCode != 0) {
      return;
    }
    final otherHome = Directory.systemTemp.createTempSync('mysql-tls-home-');
    try {
      const host = 'localhost';
      final settings = MySqlSettings(
        host: host,
        port: 3307,
        user: 'example',
        password: 'example',
        dbname: 'example',
      );
      for (final inherited in [
        '[client]\nssl-ca=/tmp/test-ca.pem\n',
        '[client-mariadb]\nssl-verify-server-cert\n',
        '[mariadb-client]\nssl-ca=/tmp/test-ca.pem\n',
        '[client]\nloose-ssl-mode=VERIFY_IDENTITY\n',
      ]) {
        File('${otherHome.path}/.my.cnf').writeAsStringSync(inherited);
        expect(
          () => MySqlDefaults(
            settings,
            lookupEnvironment: {'HOME': otherHome.path},
          ),
          throwsStateError,
        );
      }
      final verified = MySqlSettings(
        host: host,
        port: 3307,
        user: 'example',
        password: 'example',
        dbname: 'example',
        sslMode: 'VERIFY_IDENTITY',
        sslCa: '/tmp/test-ca.pem',
      );
      final defaults = MySqlDefaults(
        verified,
        lookupEnvironment: {'HOME': otherHome.path},
      );
      try {
        final data = File(defaults.option.substring('--defaults-file='.length))
            .readAsStringSync();
        expect(data, contains('protocol=tcp'));
        expect(data, contains('ssl-mode=VERIFY_IDENTITY'));
        expect(data, contains('ssl-ca="/tmp/test-ca.pem"'));
        expect(defaults.connectionOptions(verified), contains('--port=3307'));
      } finally {
        defaults.dispose();
      }
    } finally {
      otherHome.deleteSync(recursive: true);
    }
  });

  test('resaving a database keeps explicit TLS policy', () async {
    final directory = Directory.systemTemp.createTempSync('mysql-save-');
    try {
      final source = File('${directory.path}/source.yml')
        ..writeAsStringSync(
          'dbname: "example"\n'
          'host: "localhost"\n'
          'port: 3307\n'
          'user: "example"\n'
          'password: "example"\n'
          'sslMode: "VERIFY_IDENTITY"\n'
          'sslCa: "/tmp/test-ca.pem"\n',
        );
      final settings = SettingsYaml.load(pathToSettings: source.path);
      final destination = '${directory.path}/example';
      await MySqlSettings.savePrivateSettings(destination, settings);
      final saved = File(destination).readAsStringSync();
      expect(saved, contains('sslMode: "VERIFY_IDENTITY"'));
      expect(saved, contains('sslCa: "/tmp/test-ca.pem"'));
    } finally {
      directory.deleteSync(recursive: true);
    }
  });
}
