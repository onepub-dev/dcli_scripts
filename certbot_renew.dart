#! /usr/bin/env dshell
import 'dart:io';
import 'package:dshell/dshell.dart';

static const tomcatPath = '$HOME/apps/tomcat$ vi ./apache-tomcat-9.0.16/conf/server.xml';
void main(List<String> args) {
  var parser = ArgParser();
  var result = parser.parse(args);

  if (result.rest.length != 2) {
    print(
        '''You must provide a certificate name like \'host.somedomain.org\' and your email address
we current have two certs domains
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
  'docker run -v $pwd/lego:/.lego --env NAMECHEAP_API_USER --env NAMECHEAP_API_KEY goacme/lego --server=$server --dns namecheap --email $emailaddress --domains "$certName" --accept-tos run'.run;
  print('keys have been saved to ${join(HOME, 'git/dscripts/lego')}');
}

void usage() {
  print('''Usage:
      certbot_renew.dart <cert doman> <email address> 

      e.g.
        certbot_renew.dart host.somedomain.org myemail@somedomain.org 
      ''');
}
