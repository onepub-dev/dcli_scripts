An eclectic collection of CLI scripts that help me manage my dev environment.

Some of my favourites:

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
