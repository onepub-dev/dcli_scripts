#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';

void main(List<String> args) {
  var parser = ArgParser();
  var result = parser.parse(args);

  if (result.rest.length != 2) {
    print(
        '''You must provide a certificate name like \'brett.noojee.org\' and your email address
we current have two certs domains
roberts.noojee.org
brett.noojee.org
''');
    usage();
    exit(0);
  }

  var certName = result.rest[0];
  var emailaddress = result.rest[1];

  var lets_staging = 'https://acme-staging-v02.api.letsencrypt.org/directory';

  var lets_production = 'https://acme-v02.api.letsencrypt.org/directory';

  var server = lets_staging;

  // namecheap api user and key.
  var user;
  var key;

  setEnv('NAMECHEAP_API_USER', read('namecheap_username').toList()[0]);
  setEnv('NAMECHEAP_API_KEY', read('namecheap_key').toList()[0]);
  'docker run -v /home/bsutton/git/dscripts/lego:/.lego --env NAMECHEAP_API_USER --env NAMECHEAP_API_KEY goacme/lego --server=$server --dns namecheap --email $emailaddress --domains "$certName" --accept-tos run'.run;
  // 'docker run --mount 'type=volume,src= :${join(HOME,git/dscripts/lego)}:/.lego --env NAMECHEAP_API_USER --env NAMECHEAP_API_KEY goacme/lego --server=$server --dns namecheap --email $emailaddress --domains "$certName" --accept-tos run'
      //.run;
  print('keys have been saved to ${join(HOME, 'git/dscripts/lego')}');
}

void usage() {
  print('''Usage:
      certbot_renew.dart <cert doman> <email address> 

      e.g.
        certbot_renew.dart bsutton.noojee.org bsutton@noojee.org 
      ''');
}
