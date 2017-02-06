#!/usr/bin/env bash

os=$(head -1 /etc/os-release | cut -f\" -f2)
if [ "$os" = "CentOS Linux" ] ; then
	yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
	yum install postgresql96-server
elif [ "$os" = "Ubuntu" ] ; then
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

	sudo apt-get update
	sudo apt-get install -y postgresql postgresql-contrib
else
	echo "Unrecognized Linux flavor."
	exit 1
fi