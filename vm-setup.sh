#! /usr/bin/env bash

if [ -e ./vm-initialize.sh ] ; then
	# If the jetstream script exists we can assume that this machine
	# has already been initialized.
	exit 0
fi

wget http://downloads.lappsgrid.org/vm-initialize.sh
chmod +x vm-initialize.sh
./vm-initialize.sh
