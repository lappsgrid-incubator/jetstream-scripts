#!/usr/bin/env bash

if [[ `cat /etc/*-release | grep -i ubuntu` ]] ; then 
    OS="Ubuntu"
elif [[ `cat /etc/*-release | grep -i "red hat"` ]] ; then 
    OS="RedHat"
elif [[ `cat /etc/*-release | grep -i "centos"` ]] ; then 
    OS="RedHat"
fi

if  [ "$OS" = "RedHat" ] ; then
	# Add CentOS specific configuration here.
	echo "Running RedHat-family"
	yum install -y java-1.8.0-openjdk-devel
elif [ "$OS" = "Ubuntu" ] ; then
	# Add Ubuntu specific configuration here.
	echo "Running on Ubuntu"
	apt-get install -y openjdk-8-jdk
else
	echo "Unknown Linux Flavor"
	exit 1
fi

# Install Oracle Java 8
#sudo aptitude install -y python-software-properties
#echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
#echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
#sudo aptitude update
# Enable silent install
#echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
#echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
#sudo aptitude -y install oracle-java8-installer
#sudo update-java-alternatives -s java-8-oracle
#sudo apt-get install -y oracle-java8-set-default