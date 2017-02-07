# This file should be sourced by other install scripts that need to determine
# the flavor of Linux they are running on.

if [[ `cat /etc/*-release | grep -i ubuntu` ]] ; then 
    OS="ubuntu"
elif [[ `cat /etc/*-release | grep -i "red hat"` ]] ; then 
    OS="redhat"
elif [[ `cat /etc/*-release | grep -i "centos"` ]] ; then 
    OS="redhat"
fi

export OS

