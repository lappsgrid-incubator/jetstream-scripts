#!/bin/bash
set -u

function usage()
{
	echo
	echo "USAGE"
	echo "   sudo ./one-step-install.sh [OPTION]"
	echo
	echo
}

export OS=$(head -1 /etc/os-release | cut -d\" -f2)
if  [ "$OS" = "CentOS Linux" ] ; then
	# Add CentOS specific configuration here.
	echo "Found CentOS"
	INSTALL="yum -y"
	java_package=java-1.8.0-openjdk-devel
	yum-config-manager --add-repo https://docs.docker.com/engine/installation/linux/repo_files/centos/docker.repo
	yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
	yum install postgresql96-server
elif [ "$OS" = "Ubuntu" ] ; then
	# Add Ubuntu specific configuration here.
	echo "Running on Ubuntu"
	INSTALL="apt-get -y"
	apt-get update
	java_package=openjdk-8-jdk
else
	echo "Unknown Linux Flavor"
	exit 1
fi
export INSTALL
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

which unzip
if [ $? -ne 0 ] ; then
	$INSTALL unzip
fi

# Installs the packages required to install and run the Service Grid.
#set -e
#$INSTALL java postgres
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh

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
