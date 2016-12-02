#!/usr/bin/env bash

mkdir /var/lib/lsd
cd /var/lib/lsd
wget http://downloads.lappsgrid.org/lsd-latest.tgz
tar xzf lsd-latest.tgz
rm lsd-latest.tgz
chmod +x lsd
cd /usr/local/bin
ln -s /var/lib/lsd/lsd
cd $HOME
lsd -version
