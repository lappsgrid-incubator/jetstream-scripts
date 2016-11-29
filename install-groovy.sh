#!/bin/bash

echo "Installing Groovy."
wget https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.7.zip
unzip apache-groovy-binary-2.4.7.zip
mkdir -p /usr/lib/groovy
mv groovy-2.4.7 /usr/lib/groovy
ln -s /usr/lib/groovy/groovy-2.4.7 /usr/lib/groovy/current
# Add Groovy to the default $PATH of all users
echo 'export GROOVY_HOME=/usr/lib/groovy/current' > /etc/profile.d/groovy.sh
echo 'export PATH=$GROOVY_HOME/bin:$PATH' >> /etc/profile.d/groovy.sh
chmod +x /etc/profile.d/groovy.sh
rm apache-groovy-binary-2.4.7.zip

# Allow Groovy scripts to be run as sudo
echo 'Defaults	secure_path="/usr/lib/groovy/current/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' > /etc/sudoers.d/groovy
