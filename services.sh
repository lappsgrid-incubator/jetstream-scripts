#!/usr/bin/env bash

# A simple script to start/stop docker images on our services instance.
#
# These images used to be controlled via Docker Compose, but since they are
# independent services and do not form a single application coupling them with
# Compose simply made updating and restarting more awkward than it should be.
#

# Need to mount from /private on MacOS
etc_lapps=/etc/lapps
if [ "$OSTYPE" = "darwin16" ] ; then
	etc_lapps=/private/etc/lapps
fi

# Images used
api=lappsgrid/api-service:latest
image=lappsgrid/generic-datasource:latest
pubannotation=docker.lappsgrid.org/lappsgrid/pubannotation

# Directory configuration
target=/var/lib/datasource
base=/var/lib/corpora
bionlp=$base/BIONLP2016

# Data (corpus) directories
coref=$bionlp/bionlp-st-ge-2016-coref
reference=$bionlp/bionlp-st-ge-2016-reference
proteins=$bionlp/bionlp-st-ge-2016-test-proteins
semeval=$base/SEMEVAL2017

# Container lists
DATASOURCES="coref reference proteins semeval"
CONTAINERS="$DATASOURCES api pubannotation"

function start() {
	port=$1
	name=$2
	dir=$3
	
	docker run -d -p $port:8080 --name $name -v $dir:$target $image
}

function start_api() {
	docker run -d -p 8084:8080 --name api -v $etc_lapps:/etc/lapps $api
}

function start_pubannotation() {
	docker run -d -p 8085:8080 --name pubannotation $pubannotation
}

function start_all() {
	start 8080 coref $coref
	start 8081 reference $reference
	start 8082 proteins $proteins
	start 8083 semeval $semeval
	start_api
	start_pubannotation
}

function stop() {
	docker rm -f $1
}

case $1 in
    start)
    	case $2 in
    		all)
    			start_all
				;;
			coref)
				start 8080 coref $coref
				;;
			reference)
				start 8081 reference $reference
				;;
			proteins)
				start 8082 proteins $proteins
				;;
			semeval)
				start 8083 semeval $semeval
				;;
			api)
				start_api
				;;
			pubannotation)
				start_pubannotation
				;;
			*)
				echo "Invalid image name: $2"
		esac
		;;
	stop)
		case $2 in
			all)
				for image in $CONTAINERS ; do
					stop $image
				done
				;;
			coref|reference|proteins|semeval|api|pubannotation)
				stop $2
				;;
			*)
				echo "Invalid image name: $2"
				;;
		esac
		;;
	update)
		case $2 in
			all)
				for image in $CONTAINERS ; do
					stop $image
				done
				docker pull $api
				docker pull $image
				docker pull $pubannotation
				start_all
				;;	
			coref)
				stop $2
				docker pull $image
				start 8080 coref $coref
				;;
			reference)
				stop $2
				docker pull $image
				start 8081 reference $reference
				;;
			proteins)
				stop $2
				docker pull $image
				start 8082 proteins $proteins
				;;
			semeval)
				stop $2
				docker pull $image
				start 8083 semeval $semeval
				;;
			api)
				stop $2
				docker pull $api
				start_api
				;;
			pubannotation)
				stop $2
				docker pull $pubannotation
				start_pubannotation
				;;
			*)
				echo "Unknow repository $2"
				;;
		esac
		;;
    *)
		echo "Unknown command $1"
		;;
esac
