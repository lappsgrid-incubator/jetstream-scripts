#!/usr/bin/env bash
set -u

scripts=http://downloads.lappsgrid.org/keith

function usage()
{
	echo
	echo "USAGE"
	echo "   sudo ./one-step-install.sh"
	echo
	echo
}

function log {
	echo $1 | tee /var/log/one-step-install.log >&2
}

source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)

if [[ -z $OS ]] ; then
	log "The variable OS has not been set!"
	exit 1
fi

if [[ $OS = ubuntu ]] ; then
	log "Updating apt-get indices."
	apt-get update
else
	yum makecache fast
fi

set +u
if [[ -z "$EDITOR" ]] ; then
	EDITOR=emacs
fi
set -u

# Installs the packages required to install and run the Service Grid.
set -e
log "Installing common packages"
curl -sSL $scripts/install-common.sh | bash
log "Installing Java"
curl -sSL $scripts/install-java.sh | bash
log "Installing PostgreSQL"
curl -sSL $scripts/install-postgres.sh | bash

# Edit the Service Manager config file. The config file is used
# to generate then Tomcat config files.
log "Configuring the Service Manager"
wget $scripts/ServiceManager.config
wget http://downloads.lappsgrid.org/smg-1.0.0.tgz
tar xzf smg-1.0.0.tgz
chmod +x smg-1.0.0/smg
$EDITOR ServiceManager.config
smg-1.0.0/smg ServiceManager.config

# Now install Tomcat and create the PostgreSQL database.
log "Starting Tomcat installation."
MANAGER=/usr/share/tomcat/service-manager
BPEL=/usr/share/tomcat/active-bpel
curl -sSL $scripts/install-tomcat.sh | bash

cp tomcat-users.xml $MANAGER/conf
cp service_manager.xml $MANAGER/conf/Catalina/localhost

cp tomcat-users-bpel.xml $BPEL/conf/tomcat-users.xml
cp active-bpel.xml $BPEL/conf/Catalina/localhost
cp langrid.ae.properties $BPEL/bpr

source ./db.config

log "Creating role, database and stored procedure."
createuser -S -D -R -P $ROLENAME
createdb $DATABASE -O $ROLENAME -E 'UTF8'
createlang plpgsql $DATABASE
psql $DATABASE < create_storedproc.sql
psql $DATABASE -c "ALTER FUNCTION \"AccessStat.increment\"(character varying, character varying, character varying, character varying, character varying, timestamp without time zone, timestamp without time zone, integer, timestamp without time zone, integer, timestamp without time zone, integer, integer, integer, integer) OWNER TO $ROLENAME"

log "Securing the Tomcat installations"
for dir in $MANAGER $BPEL ; do
	pushd $dir > /dev/null
	# Make the tomcat user the owner of everything.
	chown -R $TOMCAT_USER:$TOMCAT_USER .

	# Tighten permissions on subdirectories.
	chmod -R 0700 bin
	chmod -R 0700 conf
	chmod -R 0750 logs
	chmod -R 0700 temp
	chmod -R 0700 work
	chmod -R 0770 webapps
	popd > /dev/null
done

log "Downloading the latest service manager war file."
wget https://github.com/openlangrid/langrid/releases/download/servicegrid-core-20161206/jp.go.nict.langrid.webapps.servicegrid-core.jxta-p2p.nict-nlp-20161206.war
mv jp.go.nict.langrid.webapps.servicegrid-core.jxta-p2p.nict-nlp-20161206.war $MANAGER/webapps/service_manager.war

log "Removing default webapps."
for dir in $MANAGER/webapps $BPEL/webapps ; do
	pushd $dir > /dev/null
	rm -rf docs examples manager host-manager
	popd > /dev/null
done

fi
if [[ $OS = RedHat ]] ; then
	systemctl start tomcat
else
	service tomcat start
fi

log "The Service Grid is now running."
echo
