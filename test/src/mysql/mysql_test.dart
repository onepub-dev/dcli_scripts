/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */
import 'package:dcli_scripts/src/mysql/mysql.dart';
import 'package:test/test.dart';

void main() {
  test('mysql ...', () async {
    await mysqlRun(['backup', 'onepub']);
  });
}
