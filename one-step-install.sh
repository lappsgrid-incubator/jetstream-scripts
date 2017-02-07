#!/bin/bash
set -u

#VERSION=__VERSION__
VERSION=1.2.3
PACKAGE=LappsPackages-$VERSION
ZIP=$PACKAGE.zip

function usage()
{
	echo
	echo "USAGE"
	echo "   sudo ./one-step-install.sh [OPTION]"
	echo
	echo "OPTIONS"
	echo "   -d"
	echo "      install the Service Grid on Debian"
	echo "   -u"
	echo "      install the Service Grid on Ubuntu"
	echo "   -r"
	echo "      install the Service Grid on RedHat/CentOS"
	echo
	echo "If the operating system is not specified /etc/issue will"
	echo "be examined to see if the OS can be determined." 
	echo
}

function select_os()
{
	cat /etc/issue | grep Ubuntu
	if [ $? -eq 0 ] ; then
		echo "Found Ubuntu"
		OS="Ubuntu"
		return
	fi
	cat /etc/issue | grep Debian
	if [ $? -eq 0 ] ; then
		echo "Found Debian"
		OS="Debian"
		return
	fi
	cat /etc/issue | grep RedHat
	if [ $? -eq 0 ] ; then
		echo "Found Red Hat"
		OS="RedHat"
		return
	fi
	# If we made it this far we couldn't determine the OS.
	echo "Unknown operating system.  Please use one of the command"
	echo "options to specify the operating system type."
	usage 
	exit 1
}

export OS="Unknown"
while getopts "dru" arg ; do
	case $arg in
		d|D) OS="Debian" ;;
		u|U) OS="Ubuntu" ;;
		r|R) OS="RedHat" ;;
		*)
			echo "Unknown OS Type $arg"
			usage
			exit 1
			;;
	esac
done

if [ "$OS" = "Unknown" ] ; then
	# Try to determine the OS (Debian or Ubuntu). This is far from bullet proof.
	if [ ! -f /etc/issue ] ; then
		echo "/etc/issue not found.  Please use one of the command line"
		echo "options to specify the operating system type."
		usage
		exit 1
	fi
	select_os
fi

export INSTALL=
export PURGE=
export UPDATE=

case $OS in
	Debian|Ubuntu)
		INSTALL="apt-get install"
		PURGE="apt-get purge"
		UPDATE="apt-get update"
		;;
	Centos|Redhat)
		INSTALL="yum install"
		;;
esac

set +u
if [ -z "$EDITOR" ] ; then
	EDITOR=emacs
fi
set -u

# Make sure the desired text editor is installed.
which $EDITOR
if [ $? -ne 0 ] ; then
	# The editor was found so there is no need to install one. 
	# Clear the EDITOR variable.
	#EDITOR=
	EDITOR=emacs
	$INSTALL emacs
fi

which unzip
if [ $? -ne 0 ] ; then
	$INSTALL unzip
fi

if [ ! -d $PACKAGE ] ; then
	if [ ! -f $ZIP ] ; then
		wget http://www.anc.org/downloads/langrid/$ZIP
		if [ $? -ne 0 ] ; then
			echo "Unable to download $ZIP"
			exit 1
		fi
	fi
	unzip $ZIP
fi

chmod a+rw $PACKAGE
cd $PACKAGE

# Installs the packages required to install and run the Service Grid.
set -e
bin/setup.sh emacs java postgres
#curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | sh
#curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh

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
