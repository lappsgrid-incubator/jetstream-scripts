#!/usr/env/bin bash

source <(curl -sSL http://downloads.lappsgrid.org/scripts/sniff.sh)

if [[ -z $JAVA_HOME ]] ; then
	echo "JAVA_HOME has not been set."
	exit 1
fi
export JCC_JDK=$JAVA_HOME

if [[ $OS = ubuntu ]] ; then
	apt-get install -y python-pip python-virtualenv python-dev git subversion emacs24-nox ant libblas-dev liblapack-dev libatlas-base-dev gfortran libxml2-dev libxslt1-dev zlib1g-dev
else
	echo "Unsupported OS: $OS"
	exit 1
fi

mkdir /home/bioasq
cd /home/bioasq
virtualenv venv

export ANT=`which ant`
export PYTHON=`which python`
export JCC="python -m jcc"
export NUM_FILES=8

wget http://www-us.apache.org/dist/lucene/pylucene/pylucene-6.5.0-src.tar.gz
tar xzf pylucene/pylucene-6.5.0-src.tar.gz
cd pylucene-6.5.0/jcc
#svn co http://svn.apache.org/repos/asf/lucene/pylucene/trunk/jcc
#cd jcc
python setup.py build
python setup.py install

cd ../
make
make install

cd ../

git clone https://github.com/AnthonyMRios/pymetamap.git
cd pymetamap
python setup.py install

#wget http://www.netlib.org/lapack/lapack-3.7.1.tgz
#tar xzf lapack-3.7.1.tgz
#cd lapack-3.7.1
#mv make.inc.example make.inc
#make

pip install pymedtermino nltk scipy numpy sklearn flask werkzeug jinja2 itsdangerous click cssselect lxml
git clone https://github.com/khyathiraghavi/BioAsqLG.git

