#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

/// dcli script generated by:
/// dcli create ipaddr.dart
///
/// See
/// https://pub.dev/packages/dcli#-installing-tab-
///
/// For details on installing dcli.
///

void main() async {
  await NetworkInterface.list().then((interfaces) {
    for (final interface in interfaces) {
      print('name: ${interface.name}');
      var i = 0;
      for (final address in interface.addresses) {
        print('  ${i++}) ${address.address}');
      }
    }
  });
}
