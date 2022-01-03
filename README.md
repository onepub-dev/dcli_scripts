An eclectic collection of CLI scripts that help me manage my dev environment.

Some of my favourites:

# commands

| command | description | Example|
| --- | --- | --- |
| dport | finds what process has a tcp port open.| dport 80|
| clean | cleans out stale docker and git files and highlights large directories. | clean|
| dmailhog | installs and starts/stops mailhog. | dmailhog \| dmailhog --shutdown |
| dmysql |  Backup/Restore and connects you to a mysql cli pulling settings (username/password) from a per database local settings file. | dmysql mydb backup \| dmysql mydb restore `<path>`
| dwhich | an improved which command that also highlights invalid paths
| gitgc | runs garbage collection on all your git projects.
| hog | finds system resource hogs.
| ipaddr | shows the ip address on your local machine.
| docker_push | builds a docker file and pushes it to docker.hub. 
| kill_tomcat | kills any java tomcat instances.
| pub_get_all | recursively runs `dart pub get` 
| hex_dump | dumps the contents of a file in hex and ascii.
| find_text | Find a file that contains the given text|




# dfind
Recursively searches for a file with a matching glob pattern
## Example
```bash
dfind '*.dart'
```

# dport
Prints out the name of the process that is listening on the passed tcp port.

## Example
```bash
dport 80
```

# dmysql
Allows you to store the username/password for a mysql database in a configure file and then run a number of mysql commands against that database withouth continuously re-entering the username/password.

## Example

To create a configuration file for a given database run:
```bash
dmysql config <dbname>
 host: <enter host>
 port: <enter port>
 user: <enter user>
 password: <enter password>
```

Once you have created a config you can run any of the following commands.
### backup
Backup the database via:

```bash
dmysql backup <path to backup file>
```

### restore
Restore a database 

WARNING: this will delete you existing schema.

```bash
dmysql restore <path to backup file>
```

### cli
Connect to the mysql cli

```bash
dmysql cli <database name>
```

# find_text

List each file that matches the pass text. The search is run recursively from the current directory.

## Example

Search all dart files for a line that contains 'final String'.
```bash
find_text 'final String' '*.dart'
```

# apis
The dcli_scripts package also includes some handy apis.

## dockerPublish

Designed to build and publish a docker image which contains a Dart project built with dcli.

The api assumes that you are cloning a git repo into your docker image and that you need to rebuild you image each time the git repo changes.

The api allows you to rebuild you docker image from the clone step rather than having to rebuild the entire docker image.

Your docker file should have the following line just before
the package's git clone line.

```docker
RUN mkdir -p /BUILD_TOKEN/
```

We will run a:
* dcli pack
* git add *
* git commit -m 'release'
* git push

You need to provide the path to your dockerfile via [pathToDockerFile].

The docker tag will be generated from your pubspec.yaml and
the [repository] argument in the form:

`<repository>/<pubspec.name>:<pubspec.version>`

So if you pass in 'noojee' as the repository and your package is dcli then you might get:

```
noojee/dcli:1.16.0
```

If you pass the [clean] = true then the image will be rebuilt from scratch.

If you pass the [fresh] = true then the Docker image will be rebuilt from the line 
that contains `BUILD_TOKEN`.

We search for the BUILD_TOKEN line in your docker file and update the token UUID. This will cause the docker image to be rebuilt from the BUILD_TOKEN line. This can be used if you need to re-clone a git repo (or any similar action).

By default the image will be pushed to docker hub unless
you pass [push] = false.

By default we ask you to confirm the build process. Pass [confirm] = false
to skip the question.

If you pass [pack] = true then the 'dcli pack' command will be run
and any changes committed to your git repo before the build starts.
If you pass [pack] = true then [fresh] will automatically be set to true to force a fresh git clone.

Here is an example Dockerfile that builds for an arm64 target ( I use this for raspberry pi testing.)

```docker
# used to build the dart exes in a docker arm image
# trying to build dart execs on a pi is just to slow
# hence we do the build in a docker image on our
# development box.

# docker image instructions came from.
# https://hub.docker.com/r/balenalib/raspberrypi4-64-debian


# FROM balenalib/raspberrypi4-64-ubuntu:latest
FROM balenalib/raspberrypi4-64-ubuntu-openjdk:latest
# replace this with your application


# install build tools
# && apt install --no-install-recommends -y openjdk-8-jdk-headless maven git \

RUN apt update \
    && apt install --no-install-recommends -y \
    wget \
    git \
    maven \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-arm64-release.zip --output-document=dart.zip
RUN unzip dart.zip

# add dart to the path.
ENV PATH="$PATH:/dart-sdk/bin"


RUN mkdir -p /BUILD_TOKEN/
RUN git clone https://github.com/bsutton/IrrigationForPi.git



WORKDIR IrrigationForPi/build_tools

RUN dart pub get
RUN dart bin/pig_build.dart --current --no-tools --no-full

```

