#!/usr/bin/env bash

source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)

if [[ $OS = centos ]] ; then
	# New CentOS instances on Jetstream spend a lot of time updating
	# when they are first launched.
	while [ -e /var/run/yum.pid ] ; do
		echo "Waiting for a previous yum installation..."
		sleep 10
	done
fi

curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-groovy.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-docker.sh | bash

wget http://downloads.lappsgrid.org/ToolConfEditor-latest.tgz
tar xzf ToolConfEditor-latest.tgz
chmod +x tce
mv tce ToolConfEditor*.jar /usr/local/bin

git clone -b develop https://github.com/lappsgrid-incubator/galaxy-appliance


