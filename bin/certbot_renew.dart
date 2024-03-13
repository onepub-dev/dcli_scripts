#! /usr/bin/env dart
/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:io';

import 'package:args/args.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart';

//const tomcatPath = '$HOME/apps/tomcat vi ./apache-tomcat-9.0.16/conf/server.xml';

void main(List<String> args) {
  final parser = ArgParser()..addFlag('production', abbr: 'p');
  final result = parser.parse(args);

  if (result.rest.length != 2) {
    print('''
You must provide a certificate name like 'host.somedomain.org' and your email address.
''');
    usage();
    exit(0);
  }

  final certName = result.rest[0];
  final emailaddress = result.rest[1];
  final useProduction = result['production'] as bool;

  const letsStaging = 'https://acme-staging-v02.api.letsencrypt.org/directory';

  const letsProduction = 'https://acme-v02.api.letsencrypt.org/directory';

  var server = letsStaging;
  if (useProduction) {
    server = letsProduction;
  }

  // check that docker is installed
  if (which('docker').notfound) {
    printerr(red('You need to install docker first'));
    exit(1);
  }

  print('Using: $server');

  // namecheap api user and key.
  final username = read('namecheap_username').firstLine;
  final key = read('namecheap_key').firstLine;

  final saveDir = join(pwd, 'certificates');

  env['NAMECHEAP_API_USER'] = username;
  env['NAMECHEAP_API_KEY'] = key;
  'docker run -v $saveDir:/.lego --env NAMECHEAP_API_USER --env NAMECHEAP_API_KEY goacme/lego --server=$server --dns namecheap --email $emailaddress --domains "$certName" --accept-tos run'
      .run;
  print('keys have been saved to $saveDir');
}

void usage() {
  print('''
Usage:
      certbot_renew.dart [--production|-p] <cert doman> <email address> 

      If the production switch isn't passed then a trial cert is obtained from the
      staging server.

      e.g.
        certbot_renew.dart host.somedomain.org myemail@somedomain.org 
      ''');
}
