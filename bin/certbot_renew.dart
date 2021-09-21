#! /usr/bin/env dcli

import 'dart:io';
import 'package:dcli/dcli.dart';

//const tomcatPath = '$HOME/apps/tomcat vi ./apache-tomcat-9.0.16/conf/server.xml';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('production', abbr: 'p', defaultsTo: false);
  var result = parser.parse(args);

  if (result.rest.length != 2) {
    print(
        '''You must provide a certificate name like 'host.somedomain.org' and your email address.
''');
    usage();
    exit(0);
  }

  var certName = result.rest[0];
  var emailaddress = result.rest[1];
  var useProduction = result['production'] as bool;

  var letsStaging = 'https://acme-staging-v02.api.letsencrypt.org/directory';

  var letsProduction = 'https://acme-v02.api.letsencrypt.org/directory';

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
  var username = read('namecheap_username').firstLine;
  var key = read('namecheap_key').firstLine;

  var saveDir = join(pwd, 'certificates');

  env['NAMECHEAP_API_USER'] = username;
  env['NAMECHEAP_API_KEY'] = key;
  'docker run -v $saveDir:/.lego --env NAMECHEAP_API_USER --env NAMECHEAP_API_KEY goacme/lego --server=$server --dns namecheap --email $emailaddress --domains "$certName" --accept-tos run'
      .run;
  print('keys have been saved to $saveDir');
}

void usage() {
  print('''Usage:
      certbot_renew.dart [--production|-p] <cert doman> <email address> 

      If the production switch isn't passed then a trial cert is obtained from the
      staging server.

      e.g.
        certbot_renew.dart host.somedomain.org myemail@somedomain.org 
      ''');
}
