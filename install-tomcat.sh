#!/usr/bin/env bash

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

if [[ $OS = redhat* || $OS = centos ]] ; then
	add=useradd
elif [[ $OS = ubuntu ]] ; then
	add=adduser
else
	echo "Unknown Linux flavor"
	exit 1
fi

$add --system --home /usr/share/tomcat --shell /usr/bin/bash
wget http://downloads.lappsgrid.org/tomcat.tgz
tar xzf tomcat.tgz
mv tomcat /usr/share
chown -R tomcat:tomcat /usr/share/tomcat

wget http://downloads.lappsgrid.org/keith/tomcat.sh
mv tomcat.sh /etc/init.d

if [[ $OS = centos ]] ; then
	systemctl enable tomcat
elif [[ $OS = ubuntu || $OS = redhat* ]] ; then
	update-rc.d tomcat defaults
else
	echo "Unknown Linux flavor... we should have failed already."
	exit 1
fi

echo "Tomcat installed to /usr/share/tomcat"
