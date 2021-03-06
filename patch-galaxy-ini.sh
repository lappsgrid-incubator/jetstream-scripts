#!/usr/bin/env bash

root=$1
if [ -z $root ] ; then
	echo "No installation directory specified."
	exit 1
fi

src=$root/mods/config/galaxy.ini
dest=$root/galaxy/config/galaxy.ini

if [ -z $PASSWORD ] ; then
	PASSWORD=$(curl -sSL http://api.lappsgrid.org/password?length=24)	
fi

if [ -z $SECRET ] ; then
	SECRET=$(curl -sSL http://api.lappsgrid.org/password?length=32\&chars=abcdef0123456789)
fi

if [ -z $PORT ] ; then
	PORT=8000
fi

echo "Password: $PASSWORD"
echo "Secret  : $SECRET"
echo "Port    : $PORT"

cat $src | \
	sed "s/__DB_PASSWORD__/$PASSWORD/" | \
	sed "s/__ID_SECRET__/$SECRET/" | \
	sed "s/__PORT__/$PORT/" | \
	sed "s|__INSTALL_DIR__|$root|g" > $dest

echo "Wrote $dest"
	

	
