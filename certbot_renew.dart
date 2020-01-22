#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';

void main(List<String> args) {
  var parser = ArgParser();
  var result = parser.parse(args);

  if (result.rest.length != 2) {
    print(
        "You must provide a certificate name like 'brett.noojee.org' and your email address");
    usage();
    exit(0);
  }

  var certName = result.rest[0];

  // ar certbot_domain = env('CERTBOT_DOMAIN');

  // var parts = certbot_domain.split('.');

  // var domain = parts.sublist(1).join('.');

  // var challenge = '_acme-challenge.$certbot_domain';

  var lets_staging = 'https://acme-staging-v02.api.letsencrypt.org/directory';

  var lets_production = 'https://acme-v02.api.letsencrypt.org/directory';

  var server = lets_staging;

  // namecheap api user and key.
  var user;
  var key;

  setEnv('NAMECHEAP_API_USER', user);
  setEnv('NAMECHEAP_API_KEY', key);
  'docker run goacme/lego --server=$server --dns namecheap --email bsutton@noojee.com.au --domains "$certName" run'
      .run;

  // give the dns a moment to propagate
  sleep(25);
}

void usage() {
  print('''Usage:
      certbot_renew.dart <email address> <cert doman>

      e.g.
        certbot_renew.dart bsutton@noojee.org bsutton.noojee.org
      ''');
}
