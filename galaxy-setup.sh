#!/usr/bin/env bash
set -e

PORT=80

curl -sSL http://downloads.lappsgrid.org/scripts/install-common.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-java.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-postgres.sh | sh
curl -sSL http://downloads.lappsgrid.org/scripts/install-lsd.sh | sh

# Install Galaxy (checkout from GitHub) as the Galaxy user.
adduser galaxy --system --group
cd /home/galaxy
git clone http://github.com/lappsgrid-incubator/Galaxy.git galaxy
git clone http://github.com/lappsgrid-incubator/GalaxyMods.git mods

# Generate a random database password and ID secret for Galaxy
PASSWORD=$(curl -sSL http://grid.anc.org:9080/password?length=24)
SECRET=$(curl -sSL http://grid.anc.org:9080/password?length=32\&chars=abcdef0123456789)

# Save the database password in a safe location so the database can be accessed
# if needed.
echo $PASSWORD > /root/postgres.passwd
echo "PASSWORD: $PASSWORD"
echo "SECRET  : $SECRET"

# Now create the database
curl -sSL http://downloads.lappsgrid.org/scripts/db-setup.sql | sed "s/__DB_PASSWORD__/$PASSWORD/" | sudo -u postgres psql

# Switch to the correct branch
cd /home/galaxy/galaxy
git checkout lapps

# Patch the galaxy.ini file with the installation directory, database password, and
# id_secret.
wget http://downloads.lappsgrid.org/scripts/patch-galaxy-ini.sh
chmod +x patch-galaxy-ini.sh
./patch-galaxy-ini.sh /home/galaxy

# Make sure everything is owned by the galaxy user.
chown -R galaxy:galaxy /home/galaxy

#HOME=/home/galaxy sudo -u galaxy ./run.sh

