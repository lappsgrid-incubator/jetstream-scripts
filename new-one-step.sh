#! /usr/bin/env bash
set -u

SCRIPTS=http://downloads.lappsgrid.org/keith

function usage()
{
	echo
	echo "USAGE"
	echo "   sudo ./one-step-install.sh [OPTION]"
	echo
	echo
}

source <(curl -sSL $SCRIPTS/sniff.sh)

if [[ $OS = ubuntu ]] ; then
	apt-get update
fi

set +u
if [ -z "$EDITOR" ] ; then
	EDITOR=emacs
fi
set -u

# Make sure the desired text editor is installed.
which $EDITOR
if [ $? -ne 0 ] ; then
	# The editor was not found so attempt to install it
	EDITOR=emacs
	$INSTALL emacs
fi

curl -sSL $SCRIPTS/install-common.sh | bash

# Installs the packages required to install and run the Service Grid.
#set -e
#$INSTALL java postgres
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | bash

set +e

# Edit the Service Manager config file. The config file is used
# to generate then Tomcat config files.
$EDITOR ServiceManager.config

# Now install Tomcat and create the PostgreSQL database.
echo "Starting Tomcat installation."
set -e
bin/install.sh -a -u tomcat /usr/share

/etc/init.d/tomcat start

echo "The Service Grid is now running.  Go to http://localhost:8080/service_manager"
echo
