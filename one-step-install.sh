#!/bin/bash
set -u

scripts=http://downloads.lappsgrid.org/keith

function usage()
{
	echo
	echo "USAGE"
	echo "   sudo ./one-step-install.sh"
	echo
	echo
}

source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)

if [[ -z $OS ]] ; then
	echo "The variable OS has not been set!"
	exit 1
fi

if [[ $OS = ubuntu ]] ; then
	apt-get update
fi

set +u
if [[ -z "$EDITOR" ]] ; then
	EDITOR=emacs
fi
set -u

# Installs the packages required to install and run the Service Grid.
set -e
curl -sSL $scripts/install-common.sh | bash
curl -sSL $scripts/install-java.sh | bash
curl -sSL $scripts/install-postgres.sh | bash

# Edit the Service Manager config file. The config file is used
# to generate then Tomcat config files.
echo "Configuring the Service Manager"
wget $scripts/ServiceManager.config
wget http://downloads.lappsgrid.org/smg-1.0.0.tgz
tar xzf smg-1.0.0.tgz
chmod +x smg
$EDITOR ServiceManager.config
./smg ServiceManager.config

# Now install Tomcat and create the PostgreSQL database.
echo "Starting Tomcat installation."
MANAGER=/usr/share/tomcat/service-manager
BPEL=/usr/share/tomcat/active-bpel
curl -sSL $scripts/install-tomcat.sh | bash

cp tomcat-users.xml $MANAGER/conf
cp service_manager.xml $MANAGER/conf/Catalina/localhost

cp tomcat-users-bpel.xml $BPEL/conf/tomcat-users.xml
cp active-bpel.xml $BPEL/conf/Catalina/localhost
cp langrid.ae.properties $BPEL/bpr

if [[ $OS = RedHat ]] ; then
	systemctl start tomcat
else
	service tomcat start
fi

echo "The Service Grid is now running."
echo
