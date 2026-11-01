import 'dart:io';

import 'package:path/path.dart' as path;

import '../private_temp.dart';
import 'mysql_settings.dart';

/// Keeps MySQL credentials out of command arguments and process listings.
class MySqlDefaults {
  late final Directory _directory;
  late final File _file;

  MySqlDefaults(
    MySqlSettings settings, {
    Map<String, String>? lookupEnvironment,
  }) {
    _checkInheritedTls(settings, lookupEnvironment);
    _directory = createPrivateTemporaryDirectory(
      Directory.systemTemp.path,
      'dmysql-',
    );
    try {
      if (!Platform.isWindows && (_directory.statSync().mode & 0x3f) != 0) {
        throw StateError('Temporary credential directory is not private');
      }
      _file = File(path.join(_directory.path, 'client.cnf'));
      _file.writeAsStringSync(
        '[client]\n'
        'host=${_quote(settings.host)}\n'
        'port=${settings.port}\n'
        'protocol=tcp\n'
        'user=${_quote(settings.user)}\n'
        'password=${_quote(settings.password)}\n'
        '${settings.sslMode == null ? '' : 'ssl-mode=${settings.sslMode}\n'}'
        '${settings.sslCa == null ? '' : 'ssl-ca=${_quote(settings.sslCa!)}\n'}'
        '${settings.sslCert == null ? '' : 'ssl-cert=${_quote(settings.sslCert!)}\n'}'
        '${settings.sslKey == null ? '' : 'ssl-key=${_quote(settings.sslKey!)}\n'}'
        '${settings.sslVerifyServerCert ? 'ssl-verify-server-cert\n' : ''}',
      );
      if (!Platform.isWindows) {
        final result = Process.runSync('chmod', ['600', _file.path]);
        if (result.exitCode != 0) {
          throw StateError('Could not protect temporary MySQL credentials');
        }
      }
    } catch (_) {
      _directory.deleteSync(recursive: true);
      rethrow;
    }
  }

  // The extra file is followed by the user's option file, which could override
  // these connection details and send a restore to a different server.
  String get option => '--defaults-file=${_file.absolute.path}';

  List<String> connectionOptions(MySqlSettings settings) => [
    option,
    '--protocol=TCP',
    '--host=${settings.host}',
    '--port=${settings.port}',
    '--user=${settings.user}',
  ];

  // MySQL reads .mylogin.cnf even with --defaults-file. Point it at a missing
  // path in the private directory so inherited login paths cannot override us.
  Map<String, String> get environment => {
    'MYSQL_TEST_LOGIN_FILE': path.join(_directory.path, 'no-login.cnf'),
  };

  void dispose() => _directory.deleteSync(recursive: true);

  static void _checkInheritedTls(
    MySqlSettings settings,
    Map<String, String>? lookupEnvironment,
  ) {
    if (settings.sslMode != null || settings.sslVerifyServerCert) return;
    late final ProcessResult result;
    try {
      result = Process.runSync('my_print_defaults', [
        'client',
        'client-server',
        'client-mariadb',
        'mariadb-client',
        'mysql',
        'mysqlshow',
        'mysqldump',
        'mariadb',
        'mariadb-show',
        'mariadb-dump',
      ], environment: lookupEnvironment);
    } on ProcessException {
      throw StateError(
        'my_print_defaults is required to check inherited MySQL TLS settings',
      );
    }
    if (result.exitCode != 0) {
      throw StateError('Could not check inherited MySQL TLS settings');
    }
    if (RegExp(
      r'^--[^\s=]*(?:ssl|tls)[^\s=]*(?:=|$)',
      multiLine: true,
      caseSensitive: false,
    ).hasMatch(result.stdout as String)) {
      throw StateError(
        'MySQL TLS options in default files are not inherited. '
        'Move them into this database\'s dmysql settings as sslMode/sslCa '
        '(MySQL) or sslVerifyServerCert/sslCa (MariaDB).',
      );
    }
  }

  static String _quote(String value) {
    if (value.contains('\n') ||
        value.contains('\r') ||
        value.contains('\x00')) {
      throw ArgumentError('Invalid MySQL option value');
    }
    return '"${value.replaceAll('\\', '\\\\').replaceAll('"', '\\"')}"';
  }
}
