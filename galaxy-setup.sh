#!/usr/bin/env bash

# This is the port that Galaxy will listen on.
export PORT=80

curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-lsd.sh | sh

set -e

# Install Galaxy (checkout from GitHub).
adduser galaxy --system --group
cd /home/galaxy
git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods

# Generate a random database password and ID secret for Galaxy
PASSWORD=$(curl -sSL http://grid.anc.org:9080/password?length=24)
SECRET=$(curl -sSL http://grid.anc.org:9080/password?length=32\&chars=abcdef0123456789)

# Save the database password in a safe location so the database can be accessed
# later if needed.
echo $PASSWORD > /root/postgres.passwd
echo "PASSWORD: $PASSWORD"
echo "SECRET  : $SECRET"

# Now create the database using `sed` to inject the database password into the SQL script.
curl -sSL http://downloads.lappsgrid.org/scripts/db-setup.sql | sed "s/__DB_PASSWORD__/$PASSWORD/" | sudo -u postgres psql

# Ensure we are using the correct branch for Galaxy.
cd /home/galaxy/galaxy
git checkout lapps

# Patch the galaxy.ini file with the port number , installation directory, database 
# password, and id_secret.
wget http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh
chmod +x patch-galaxy-ini.sh
./patch-galaxy-ini.sh /home/galaxy

# Make sure everything in /home/galaxy is owned by the galaxy user.
chown -R galaxy:galaxy /home/galaxy

#HOME=/home/galaxy sudo -u galaxy ./run.sh

