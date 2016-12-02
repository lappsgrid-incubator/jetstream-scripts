#!/usr/bin/env bash

root=$1

digest=md5sum

if [ ! `which $digest` ] ; then
	if [ `which md5` ] ; then
		digest=md5
	else
		echo "No md5sum/md5 command available to generate a MD5 hash."
		exit 1
	fi
fi

if [ -z $root ] ; then
	echo "No installation directory specified."
	exit 1
fi

source=$root/mods/config/galaxy.ini
dest=$root/galaxy/config/galaxy.ini

passwd_file=/root/postgres.passwd

if [ -z $PASSWORD ] ; then
	if [ -f $passwd_file ] ; then
		PASSWORD=$(cat $passwd_file)
	else
		echo "Unable to determine the Postgres password. Either set \$PASSWORD"
		echo "or create the file $passwd_file"
		exit 1
	fi
fi

if [ -z $SECRET ] ; then
	SECRET=$(python -c 'import time; print time.time()' | $digest | cut -f1 -d ' ')
fi

if [ -z $PORT ] ; then
	PORT=8000
fi

cat $source | \
	sed "s/__DB_PASSWORD__/$PASSWORD/" | \
	sed "s/__ID_SECRET__/$SECRET/" | \
	sed "s/__PORT__/$PORT/" | \
	sed "s|__INSTALL_DIR__|$root|g" > $dest
	

	
