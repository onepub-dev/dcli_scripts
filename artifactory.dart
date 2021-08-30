#! /usr/bin/env dcli


import 'package:dcli/dcli.dart';
import 'package:docker2/docker2.dart';

/// The port that artifactory will listen on.
var port = '8081';
var port2 = '8082';
var bind = '127.0.0.1';
var name = 'artifactory';

var imageName = 'docker.bintray.io/jfrog/artifactory-oss:latest';

/// installs, starts/stops the artifactory docker container.
void main(List<String> args) {
  // if (!DartScript.self.isCompiled) {
  //   printerr('You must run this as a compiled dart script as sudo is required');
  //   exit(1);
  // }
  // if (!Shell.current.isPrivilegedUser) {
  //   printerr('You must run this command as sudo.');
  //   exit(1);
  // }

  Settings().setVerbose(enabled: true);
  var parser = ArgParser()
    ..addFlag('install',
        abbr: 'i', help: 'Install the artifactory OSS docker image')
    ..addFlag('run',
        abbr: 'r',
        help: 'Run the artifactory docker image. This is the default action ')
    ..addFlag('delete',
        abbr: 'd',
        help:
            'Delete the artifactory docker container. The volume will be unaffected.')
    ..addFlag('start',
        abbr: 's', help: 'Runs artifactory docker image as a daemon.')
    ..addFlag('stop', abbr: 't', help: 'Stops the artifactory docker process')
    ..addFlag('attach',
        abbr: 'a', help: 'Attach to the artifactory docker cli');

  var parsed = parser.parse(args);
  if (parsed['install'] as bool) {
    install();
  } else if (parsed['delete'] as bool) {
    delete();
  } else if (parsed['start'] as bool) {
    start(daemon: true);
  } else if (parsed['stop'] as bool) {
    stop();
  } else if (parsed['attach'] as bool) {
    attach();
  } else {
    /// default action is run.
    start(daemon: false);
  }
}

void stop() {
  print(blue('Stopping Artifactory'));
  final container = Docker().findContainerByName(name);
  if (container == null) {
    printerr(red("The artifactory container doesn't exist. Run '$name -i'"));
  } else {
    container.stop();
  }
}

void attach() {
  print(blue('Attaching to the Artifactory cli'));
  final container = Docker().findContainerByName(name);
  if (container == null) {
    printerr(red("The artifactory container doesn't exist. Run '$name -i'"));
  } else {
    container.cli();
  }
}

void start({required bool daemon}) {
  final container = Docker().findContainerByName(name);
  if (container != null && container.isRunning) {
    printerr(orange('The $name container is already running.'));
    return;
  }

  if (daemon == false) {
    print(blue('Starting Artifactory in interactive mode.'));
  }

  var image = Docker().findImageByName(imageName);
  if (image == null) {
    printerr(red(
        "The artificatory image isn't installed. Run ./artifactory.dart --install"));
    return;
  }

  //Shell.current.withPrivileges(() {
  // 'chown -R 1030:1030 /var/opt/jfrog/artifactory'.run;
  // chown('/var/opt/jfrog/artifactory',
  //     user: '1030', group: '1030', recursive: true);
  // });
  Docker().run(image,
      argString:

          /// list on primary and secondary artifactory ports and mount a host volume.
          '-p $bind:$port:8081 -p $bind:$port2:8082 -v /var/opt/jfrog/artifactory:/var/opt/jfrog/artifactory',
      daemon: daemon);

  if (daemon == true) {
    print(blue('Artifactory daemon has started'));
  }

  // 'docker start --name artifactory -d -p 8081:8081 docker.bintray.io/jfrog/artifactory-oss:latest'
  //     .run;
}

void install() {
  print(blue('Installing the Artifactory OSS docker image'));
  Docker().pull(imageName);
  print(blue('Creating the $name container'));

  print(blue('Installing Nginx-LE'));
  DartSdk().globalActivate('nginx_le');
  
}

void delete() {
  print(blue('deleting the docker container'));

  final container = Docker().findContainerByName(name);
  if (container != null) {
    if (container.isRunning) {
      printerr(orange('Stopping the $name container.'));
      container.stop();
    }
    printerr(orange('Deleting the $name container.'));
    container.delete();
  }
}
