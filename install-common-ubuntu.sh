#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.
for package in git zip unzip emacs24-nox ; do
	if [ ! `which $package` ] ; then
		apt-get install -y $package
	fi
fi

