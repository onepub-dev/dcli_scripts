#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

/// dcli script generated by:
/// dcli create dnsflush.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main() {
  'systemd-resolve --flush-caches'.start(privileged: true);
  'systemd-resolve --statistics'.start(privileged: true);
}
