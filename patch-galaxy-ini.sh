#!/usr/bin/env bash

root=$1
if [ -z $root ] ; then
	echo "No installation directory specified."
	exit 1
fi

source=$root/mods/config/galaxy.ini
dest=$root/galaxy/config/galaxy.ini

if [ -z $PASSWORD ] ; then
	PASSWORD=$(curl -sSL http://grid.anc.org:9080/password?length=24)	
fi

if [ -z $SECRET ] ; then
	SECRET=$(curl -sSL http://grid.anc.org:9080/password?length=32\&chars=abcdef0123456789)
fi

if [ -z $PORT ] ; then
	PORT=8000
fi

echo "Password: $PASSWORD"
echo "Secret  : $SECRET"
echo "Port    : $PORT"

cat $source | \
	sed "s/__DB_PASSWORD__/$PASSWORD/" | \
	sed "s/__ID_SECRET__/$SECRET/" | \
	sed "s/__PORT__/$PORT/" | \
	sed "s|__INSTALL_DIR__|$root|g" > $dest

echo "Wrote $dest"
	

	
