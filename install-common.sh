#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.
common="sudo curl wget git zip unzip"

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

if [[ $OS = redhat* || $OS = centos ]] ; then
	install="yum install -y"
	common="$common emacs-nox.x86_64"
elif [[ $OS = ubuntu20 || $OS = ubuntu18 ]] ; then
    #install="DEBIAN_FRONTEND=\"noninteractive\" apt install -y"
    install="apt install -y"
    common="$common emacs lsb-release gnupg"
elif [[ $OS = ubuntu ]] ; then
	install="apt-get install -y"
	common="$common emacs24-nox"
else
	echo "Unknown Linux flavor $OS"
	exit 1
fi

echo "Installing common packages."
for package in $common ; do
	if [[ ! `which $package` ]] ; then
		$install $package
	fi
done

#apt-get install -y apt-transport-https ca-certificates

# I am not sure what needs this, but including it causes installation to fail on 
# some systems. Excluding it does not seem to have any negative effects.
#apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
