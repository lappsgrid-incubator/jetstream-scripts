#! /usr/bin/env bash

REPO=http://downloads.lappsgrid.org

function install_tool() {
	CMD=$1
	TGZ=$2
	if [ ! `which $CMD` ] ; then
		echo "Installing $CMD"
		wget $REPO/$TGZ
		tar xzf $TGZ
		mv $CMD *.jar /usr/local/bin
		chmod a+x /usr/local/bin/$CMD
		rm $TGZ
	else
		echo "$CMD is already installed."
	fi
}

# Install Docker
if [ ! `which docker` ] ; then
	echo "Installing Docker."
	#apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	#echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
	#apt-get update
	#apt-get install -y docker-engine
	curl -sSL https://experimental.docker.com/ | sh
else
	echo "Docker already installed."
fi

# General setup
if [ ! `which unzip` ] ; then
	echo "Installing unzip."
	apt-get install -y zip unzip apt-transport-https ca-certificates
	apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
else
	echo "Unzip already installed."
fi

if [ ! `which emacs` ] ; then
	echo "Installing emacs"
	apt-get install -y emacs24-nox
else
	echo "Emacs is already installed."
fi
# Install Java 8 on Ubuntu
if [ ! `which java` ] ; then
	# Install Oracle Java 8
	sudo aptitude install -y python-software-properties
	echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/webupd8team-java.list
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
	sudo aptitude update
	# Enable silent install
	echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
	sudo aptitude -y install oracle-java8-installer
	sudo update-java-alternatives -s java-8-oracle
	sudo apt-get install -y oracle-java8-set-default
else
	echo "Java already installed."
fi

# Install Groovy
if [ ! `which groovy` ] ; then
	echo "Installing Groovy."
	wget https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.7.zip
	unzip apache-groovy-binary-2.4.7.zip
	mkdir -p /usr/lib/groovy
	mv groovy-2.4.7 /usr/lib/groovy
	ln -s /usr/lib/groovy/groovy-2.4.7 /usr/lib/groovy/current
	#echo << EOF > /etc/profile.d/groovy.sh
	echo 'export GROOVY_HOME=/usr/lib/groovy/current' > /etc/profile.d/groovy.sh
	echo 'export PATH=$GROOVY_HOME/bin:$PATH' >> /etc/profile.d/groovy.sh
	chmod +x /etc/profile.d/groovy.sh
	rm apache-groovy-binary-2.4.7.zip
	echo 'Defaults	secure_path="/usr/lib/groovy/current/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' > /etc/sudoers.d/groovy
else
	echo "Groovy already installed."
fi

# Install Docker Compose
if [ ! `which docker-compose` ] ; then
	echo "Installing Docker Compose."
	curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
	chmod +x /usr/bin/docker-compose
else
	echo "Docker Compose already installed."
fi

# Install LSD, JSONC and TCE tools
install_tool 'lsd' 'lsd-latest.tgz'
install_tool 'tce' 'ToolConfEditor-latest.tgz'
install_tool 'jsonc' 'jsonc-latest.tgz'
exit 0

for user in suderman keighrim ; do
	if [ ! -d /home/$user ] ; do
		useradd -m -s /bin/bash $user
		mkdir /home/$user/.ssh
		wget $REPO/keys/$user.key
		cat $user.key >> /home/$user/.ssh/authorized_keys
		rm $user.key
		chmod -R 640 /home/$user/.ssh
		echo "$user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
	done
done
