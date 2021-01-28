#!/usr/bin/env bash

if [ `which psql` ]; then 
    log "PostgreSQL is found, skipping installation"
    exit 0
fi

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

set -eu
echo "Installing PostgreSQL"
if [[ $OS = redhat* || $OS = centos ]] ; then
    if [[ $OS = redhat6 ]] ; then 
        yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
    elif [[ $OS = redhat7 ]] ; then 
        yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm
    elif [[ $OS = centos ]] ; then 
        yum install -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
    fi 
	yum install -y postgresql96-server
elif [[ $OS == *ubuntu* ]] ; then
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

	sudo apt-get update
	sudo apt-get install -y -q postgresql-9.6 postgresql-contrib-9.6
else
	echo "Unrecognized Linux flavor. Unable to install Postgres"
	exit 1
fi

if [[ $OS = redhat7 || $OS = centos ]] ; then 
    /usr/pgsql-9.6/bin/postgresql96-setup initdb

	hba=/var/lib/pgsql/9.6/data/pg_hba.conf
	bak=/var/lib/pgsql/9.6/data/pg_hba.conf.bak
	mv $hba $bak
	cat $bak | sed 's/ident/md5/g' > $hba
	#echo "local all all password" > $hba
	#echo "host all all 127.0.0.1/32 password" >> $hba
	#echo "host all all ::1/128 password" >> $hba

    systemctl enable postgresql-9.6.service
    systemctl start postgresql-9.6
elif [[ $OS = redhat6 ]] ; then 
    service postgresql-9.6 initdb
    chkconfig postgresql-9.6 on
    service postgresql-9.6 start
elif [[ $OS == *ubuntu* ]] ; then 
    service postgresql start
else
	echo "Unrecognized Linux flavor. Unable to start Postgres service"
	exit 1
fi

