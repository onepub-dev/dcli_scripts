#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create compile_all.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main() {
  find('*.dart', recursive: false).forEach((file) {
    'dcli compile -i $file'.run;
  });
}