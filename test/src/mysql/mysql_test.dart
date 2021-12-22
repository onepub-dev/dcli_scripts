import 'package:dcli_scripts/src/mysql/mysql.dart';
import 'package:test/test.dart';

void main() {
  test('mysql ...', () async {
    await mysqlRun(['backup', 'onepub']);
  });
}
