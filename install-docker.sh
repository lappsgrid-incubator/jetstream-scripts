#!/bin/bash

COMPOSE_VERSION=1.8.1

echo "Installing Docker."
#apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
#apt-get update
#apt-get install -y docker-engine

# This installs the experimental/beta version of docker which is needed for some of the
# newer docker compose / docker swarm features.
curl -sSL https://experimental.docker.com/ | sh

echo "Installing Docker Compose."
curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

