#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.

function install() {
	cmd=$1
	if [ -n $2 ] ; then
		package=$2
	else
		package=$1
	fi
	if [ ! `which $cmd` ] ; then
		apt-get install -y $package
	fi
}

install git
install zip
install unzip
install emacs emacs24-nox

apt-get install -y apt-transport-https ca-certificates
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual