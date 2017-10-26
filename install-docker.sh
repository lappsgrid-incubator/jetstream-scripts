#!/usr/bin/env bash

# This script seems to work on CentOS/RedHat and Ubuntu
# 1. The docker service is not started on CentOS. Don't know about RedHat.
# 

if [ -z "$OS" ] ; then
	source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)
fi

COMPOSE_VERSION=1.8.1

echo "Installing Docker."
#apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
#apt-get update
#apt-get install -y docker-engine

# This installs the experimental/beta version of docker which is needed for some of the
# newer docker compose / docker swarm features.
#curl -sSL https://experimental.docker.com/ | sh

#echo "Installing Docker Compose."
#curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
#chmod +x /usr/bin/docker-compose

# Remove old versions.  It is safe to ignore warnings that the packages
# do not exist.
apt-get remove -y docker docker-engine docker.io
apt-get update

# Enable HTTPS
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add the Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository.
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
apt-get update
apt-get install -y docker-ce

if [[ $OS = centos ]] ; then
	systemctl start docker
fi
