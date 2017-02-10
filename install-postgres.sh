#!/usr/bin/env bash

if [ `which psql `]; then 
    log "PostgreSQL is found, skipping installation"
    exit 0
fi

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

set -eu
echo "Installing PostgreSQL"
if [[ $OS = redhat || $OS = centos ]] ; then
	yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
	yum install -y postgresql96-server
elif [[ $OS = ubuntu ]] ; then
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

	sudo apt-get update
	sudo apt-get install -y postgresql postgresql-contrib
else
	echo "Unrecognized Linux flavor."
	exit 1
fi
