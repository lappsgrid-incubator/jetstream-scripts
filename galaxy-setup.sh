#!/usr/bin/env bash

PORT=80

curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | sh

# Install Galaxy (checkout from GitHub) as the Galaxy user.
adduser galaxy --system --group
cd /home/galaxy
HOME=/home/galaxy sudo -u galaxy git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
HOME=/home/galaxy sudo -u galaxy git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods

PASSWORD=$(curl -sSL http://grid.anc.org:9080/password?length=24)
SECRET=$(curl -sSL http://grid.anc.org:9080/password?length=32\&chars=abcdef0123456789)

echo $PASSWORD > /root/postgres.passwd
echo "PASSWORD: $PASSWORD"
echo "SECRET  : $SECRET"

curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/db-setup.sql | sed "s/__DB_PASSWORD__/$PASSWORD" | sudo -u postgres psql

cd /home/galaxy/galaxy
HOME=/home/galaxy sudo -u galaxy git checkout lapps

wget http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh
chmod +x patch-galaxy.sh
./patch-galaxy-ini.sh /home/galaxy
chown galaxy:galaxy /home/galaxy/galaxy/config/galaxy.ini

#HOME=/home/galaxy sudo -u galaxy ./run.sh

