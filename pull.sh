#!/usr/bin/env bash
set -e

dir=
case $1 in
    manager|service-manager)
		dir=/var/lib/downloads/service-manager
		;;
    scripts) 
		dir=/var/lib/downloads/scripts 
		;;
    groovlets)
		dir=/var/lib/groovlets
		;;
    *)
		echo "Invalid directory"
		exit 1
		;;
esac
set -u

cd $dir
git pull origin master
