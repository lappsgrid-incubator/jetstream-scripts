#!/usr/bin/env bash

# This is the port that Galaxy will listen on.
export PORT=80

source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)

curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | bash
curl -sSL http://downloads.lappsgrid.org/scripts/install-lsd.sh | bash

set -e

# Install Galaxy (checkout from GitHub).
if [[ $OS = ubuntu ]] ; then
	adduser galaxy --system --group
elif [[ $OS = redhat* || $OS = centos ]] ; then
	adduser --system galaxy
else
	echo "Unknown Linux flavor: $OS"
	exit 1
fi

cd /home/galaxy
git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods

# Generate a random database password and ID secret for Galaxy
export PASSWORD=$(curl -sSL http://api.lappsgrid.org/password?length=24)
export SECRET=$(curl -sSL http://api.lappsgrid.org/password?length=32\&type=hex)

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

# Patch the galaxy.ini file with the port number, installation directory, database 
# password, and id_secret.
wget http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh
chmod +x patch-galaxy-ini.sh
./patch-galaxy-ini.sh /home/galaxy

# Make sure everything in /home/galaxy is owned by the galaxy user.
chown -R galaxy:galaxy /home/galaxy

#HOME=/home/galaxy sudo -u galaxy ./run.sh

