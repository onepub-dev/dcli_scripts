#! /usr/bin/env dshell
import 'package:dshell/dshell.dart';

void main() {
  var certbot_domain = env('CERTBOT_DOMAIN');

  var parts = certbot_domain.split('.');

  var domain = parts.sublist(1).join('.');

  var challenge = '_acme-challenge.$certbot_domain';

  var lets_staging = 'https://acme-staging-v02.api.letsencrypt.org/directory';
  var lets_production = '';

  var server = lets_staging;

  // namecheap api user and key.
  var user;
  var key;

  setEnv('NAMECHEAP_API_USER', user);
  setEnv('NAMECHEAP_API_KEY', key);
  'docker run goacme/lego --server=$server --dns namecheap --email bsutton@noojee.com.au --domains "$certbot_domain" run'
      .run;

  // give the dns a moment to propagate
  sleep(25);
}
