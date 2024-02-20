# 3.2.0-alpha.2
- fixed some async calls after upgrading to dcli 4.x
- Fixed a bug in dockerPublish that was incorrectly getting the pubspec name object rather then the string name.

# 3.2.0-alpha.1
- upgraded to dcli 4.0.0-alpha.1

# 3.1.1
- upgraded to pub_release to fix problems with the tool scripts
- migrated to using pubspec_manager

# 3.1.0
- upgraded dependencies.

# 3.0.0
- upgraded to dcli 3.x
# 2.1.1
- upgraded to docker2 4.0

# 2.1.0
- Updated dependencies.

# 2.0.0
Upgraded to dart 3.0.0

# 1.6.0
- updated dependencies
- Added better error handling for gactivate.
- clean now delete .dart_tools directories.

# 1.5.0
- gactivate can now aot compile a package from .pub-cache and add it to the 
dcli path.  This is usefuly if you switch dart versions a lot and also speeds
up the exection of any cli tool.

# 1.4.0
- Added gactivate. cleaned out lintes.
- Improved dwhich path dedupliation so we don't get the same error twice.

# 1.3.0
- Added --routines to the mysql backup so that storedprocs and functions are backed up.
- Improved mysql restore. It now drops and re-creates the db.
- added copyright notices.

# 1.2.10
- added code to the clean command to prune unused docker volumes
- updated dnsflush to work on ubuntu 22.04
- upgraded to latest version of dcli.
- changed kill_tomcat to try without priviliged escalation and then with if required.
- improved the tomcat killed message.

# 1.2.8

# 1.2.7

# 1.2.6
- changed hog disk to output the total size of scanned files.

# 1.2.4
- added usage statement to dcompress if the arg parsing fails.
- added nothrow so that a failed git gc doesn't stop the clean process.

# 1.2.3
- dfind now searches hidden directories.

# 1.2.2
- changed the backup command to discard a backup if it isdentical to the prior backup. Use the --always option to force it to retain the backup regardless.

# 1.2.1
- Fixed bug in dmysql when the directory path had a '.' in it.

# 1.2.0
- updated dcli version.
- Added option to dmysql so it auto generates a sequence of backup files if you don't provide a name. Improved the usage message.

# 1.1.22
- Added additional optoins and error handling to dmysql.  When configuring a db we now check if it exists. We report missing config file rather than trying to use defaults. We won't overwrite an existing backup file. option to remove a config for a db.

# 1.1.21
Fixed a bug in dmysql when running using the mariad client which doesn't support --column-statistics.
We just retry the command without the switch if it fails.


# 1.1.20
- Added doco on the dockerPublish command.

# 1.1.19
- doco improvements in the readme.

# 1.1.18
Added --column-statistics=0 to dmysql backup so we can backup a v5 db using v8 tools.
# 1.1.17
- fix: bug in dsetver. It was always trying to set the version of the dcli_scripts package.

# 1.1.16
- fix: improved error messages when an invalid arg passed to dsetver

# 1.1.15
- enh: change find_text to output relative paths.

# 1.1.14
- enh: find_text now otuputing the file name.
- removed debug statement.

# 1.1.13
- enh: attempt two to publish with find_text as an exe.

# 1.1.12
Added find_text app to recursively search for text in a file.
# 1.1.11
Improved the DockerPublish api documentation.

# 1.1.10
Fixed an import.

# 1.1.9
- restructured the mysql commands into one apps with commands.
- add hook to activate dcli_scripts after doing a pub_relase.
- added check that mysqldump was installed when running mysql_backup

# 1.1.8
- updated the eclipse desktop launcher builder to work with changes to eclipse paths.
- added mysql_backup and renamed dmysql to mysql_cli

# 1.1.7
Added no-cofirm option to dockerPublish api.
# 1.1.5
- Added no-push option to the dockerPublish api.

# 1.1.4
- applied lint_hard
- created barrel file and dockerPublish

# 1.1.3
- Added logic to check for duplicate path entries when --verbose switch passed.

# 1.1.2

# 1.1.1
- Fixed a bug in clean that tries to run hog.dart rather than hog.

# 1.1.0
- created pub_get_all to run pub get on all subprojects.
- improved dwhich to correctly deal with empty paths.

# 1.0.10
 - added dsetver as an exe.

# 1.0.9
 - added dsetver command which updates pubspec.yaml version from the cli.

# 1.0.8
- upgraded to dcli 1.11.0
- removed excess logging when running in non-verbose mode.

# 1.0.7
- Fixed a bug in dwc where it failed if passed a file with a space in the name.
- Added fetch command.

# 1.0.6
- added test that dcli directory exists. cleanedup home paths.

# 1.0.5
- upgraded dcli version.
- Add command line flag to shutdown mailhog.
- changed clean to look for gitgc on the path.
- added help option to mailhog.
- Fixed the paths to other scripts which are now in the bin directory.
- moved to lints/recommended lint cleanup
- new app to post an http request and report progress.

# 1.0.4
Added option to suppress the ascii output and -h to show help.


# 1.0.3
* Exposed hexdump as a executable.
* upgraded to dcli 1.8
* Added search for differnt file extensions as windows users expect.

# 1.0.2

# 1.0.1
added logic to skip blank lines in the bitbucket_import csv file.

# 1.0.0
First release.
