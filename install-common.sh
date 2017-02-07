#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.
common="git zip unzip emacs23-nox"

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

if [[ $OS = redhat ]] ; then
	install="yum install -y"
elif [[ $OS = ubuntu ]] ; then
	install="apt-get install -y"
else
	echo "Unknown Linux flavor $OS"
	exit 1
fi
for package in $common ; do
	if [[ ! `which $package` ]] ; then
		$install $package
	fi
done

#apt-get install -y apt-transport-https ca-certificates

# I am not sure what needs this, but including it causes installation to fail on 
# some systems. Excluding it does not seem to have any negative effects.
#apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual