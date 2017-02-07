#!/usr/bin/env sh

curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh | sh

if [[ -n "$OS" ]] ; then
	echo "OS is $OS"
else
	echo "OS is not set."
fi

