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

source ports.sh

# Images used
api=lappsgrid/api-service:latest
image=lappsgrid/generic-datasource:1.2.1
pubannotation=docker.lappsgrid.org/lappsgrid/pubannotation
paconvert=docker.lappsgrid.org/lappsgrid/pubannotation-converter
vaers=docker.lappsgrid.org/cdc/vaers
ctakes=docker.lappsgrid.org/cdc/ctakes
uima2lif=docker.lappsgrid.org/cdc/uima2lif
udpipe=docker.lappsgrid.org/lappsgrid/udpipe:1.0.0
stanford=docker.lappsgrid.org/lappsgrid/stanford:gdd

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
CDC="vaers ctakes uima2lif"
CONTAINERS="$DATASOURCES $CDC api pubannotation paconvert udpipe stanford"

function start_datasource() {
	port=$1
	name=$2
	dir=$3
	
	docker run -d -p $port:8080 --name $name -v $dir:$target $image
}

function start() {
	container=$1
	name=$2
	port=$3
	
	docker run -d -p $port:8080 --name $name $container
}

function start_cdc() {
	port=$1
	name=$2
	
	docker run -d -p $port:8080 --name $name docker.lappsgrid.org/cdc/$name
}

function start_api() {
	docker run -d -p $API_PORT:8080 --name api -v $etc_lapps:/etc/lapps $api
}

#function start_pubannotation() {
#	docker run -d -p $PUBANNOTATION_PORT:8080 --name pubannotation $pubannotation
#}

#function start_udpipe() {
#	docker run -d -p $UDPIPE_PORT:8080 --name udpipe $udpipe
#}

#function start_vaers() {
#    docker run -d -p 8086:8080 --name vaers $vaers
#}

#function start_ctakes() {
#    docker run -d -p 8087:8080 --name ctakes $ctakes
#}

#function start_paconvert() {
#	docker run -d -p $PACONVERT_PORT:8080 --name paconvert $paconvert
#}

function start_all() {
	start_datasource $DATA_COREF_PORT coref $coref
	start_datasource $DATA_REFERENCE_PORT reference $reference
	start_datasource $DATA_PROTEINS_PORT proteins $proteins
	start_datasource $DATA_SEMEVAL_PORT semeval $semeval
	start_api
	#start_pubannotation
	#start_paconvert
	#start_udpipe
	start $pubannotation pubannotation $PUBANNOTATION_PORT
	start $udpipe udpipe $UDPIPE_PORT
	start $paconvert paconvert $PACONVERT_PORT
	start $stanford stanford $STANFORD_PORT
	
	#start_cdc 8086 vaers
	#start_cdc 8087 ctakes
	#start_cdc 8088 xcas
	start_cdc $CTAKES_CLINICAL_PORT ctakes-clinical
	start_cdc $CTAKES_TEMPORAL_PORT ctakes-temporal
	start_cdc $ETHERNLP_PORT ethernlp
	start_cdc $NCBO_PORT ncbo
	start_cdc $UIMA2LIF_PORT uima2lif
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
				start_datasource $DATA_COREF_PORT coref $coref
				;;
			reference)
				start_datasource $DATA_REFERENCE_PORT reference $reference
				;;
			proteins)
				start_datasource $DATA_PROTEINS_PORT proteins $proteins
				;;
			semeval)
				start_datasource $DATA_SEMEVAL_PORT semeval $semeval
				;;
			api)
				start_api
				;;
			pubannotation)
				#start_pubannotation
				start $pubannotation pubannotation $PUBANNOTATION_PORT
				;;
			paconvert)
				#start_paconvert
				start $paconver paconvert $PACONVERT_PORT
				;;
	        clinical) 
		        start_cdc $CTAKES_CLINICAL_PORT ctakes-clinical
				;;
	        temporal)
	            start_cdc $CTAKES_TEMPORAL_PORT ctakes-temporal
				;;
			ncbo)
				start_cdc $NCBO_PORT ncbo
				;;
			ethernlp)
				start_cdc $ETHERNLP_PORT ethernlp
				;;
			ethernlp-service)
				start_cdc $ENTERNLP_SERVICE_PORT ethernlp-service
				;;
			uima2lif)
				start_cdc $UIMA2LIF_PORT uima2lif
				;;
			udpipe)
				#start_udpipe
				start $udpipe udpipe $UDPIPE_PORT
				;;
			stanford)
				start $stanford stanford $STANFORD_PORT
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
			coref|reference|proteins|semeval|api|pubannotation|ncbo|ethernlp|ethernlp-service|uima2lif|paconvert|udpipe|stanford)
				stop $2
				;;
			clinical|temporal)
				stop ctakes-$2
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
				docker pull $paconvert
				docker pull $vaers
				docker pull $uima2lif
				docker pull $udpipe
				docker pull $stanford
				start_all
				;;	
			coref)
				stop $2
				docker pull $image
				start $DATA_COREF_PORT coref $coref
				;;
			reference)
				stop $2
				docker pull $image
				start $DATA_REFERENCE_PORT reference $reference
				;;
			proteins)
				stop $2
				docker pull $image
				start $DATA_PROTEINS_PORT proteins $proteins
				;;
			semeval)
				stop $2
				docker pull $image
				start $DATA_SEMEVAL_PORT semeval $semeval
				;;
			api)
				stop $2
				docker pull $api
				start_api
				;;
			pubannotation)
				stop $2
				docker pull $pubannotation
				start $pubannotation pubannotation $PUBANNOTATION_PORT
				;;
			paconvert)
				stop $2
				docker pull $paconvert
				start $paconvert paconvert $PACONVERT_PORT
				;;
		    clinical)
		        stop ctakes-$2
				docker pull docker.lappsgrid.org/cdc/ctakes-$2
				start_cdc $CTAKES_CLINICAL_PORT ctakes-$2	
				;;
		    temporal)
		        stop ctakes-$2
				docker pull docker.lappsgrid.org/cdc/ctakes-$2
				start_cdc $CTAKES_TEMPORAL_PORT ctakes-$2	
				;;
			ncbo)
				stop ncbo
				docker pull docker.lappsgrid.org/cdc/ncbo
				start_cdc $NCBO_PORT ncbo
				;;
			ethernlp)
				stop ethernlp
				docker pull docker.lappsgrid.org/cdc/ethernlp
				start_cdc $ETHERNLP_PORT ethernlp
				;;
			ethernlp-service)
				stop ethernlp-service
				docker pull docker.lappsgrid.org/cdc/ethernlp-service
				start_cdc $ETHERNLP_SERVICE_PORT ethernlp-service
				;;
		    uima2lif)
		        stop $2
				docker pull $uima2lif
				start_cdc $UIMA2LIF_PORT uima2lif
				;;
			udpipe)
				stop $2
				docker pull $udpipe
				start $udpipe udpipe $UDPIPE_PORT
				;;
			stanford)
				stop $2
				docker pull $stanford
				start $stanford stanford $STANFORD_PORT
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
