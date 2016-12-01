#!/usr/bin/env bash

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
	SECRET=$(python -c 'import time; print time.time()' | md5sum | cut -f1 -d ' ')
fi

if [ -z $PORT ] ; then
	PORT=8000
fi

cat mods/config/galaxy.ini | \
	sed "s/__DB_PASSWORD__/$PASSWORD/" | \
	sed "s/__ID_SECRET__/$SECRET/" | \
	sed "s/__PORT__/$PORT/" | \
	sed "s/__INSTALL_DIR__/$DIR/g" > galaxy/config/galaxy.ini
	

	
