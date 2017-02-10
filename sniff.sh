# This file should be sourced by other install scripts that need to determine
# the flavor of Linux they are running on.

if [[ `cat /etc/*-release | grep -i ubuntu` ]] ; then 
    OS="ubuntu"
elif [[ -e /etc/centos-release ]] ; then 
    OS="centos"
elif [[ -e /etc/redhat-release ]] ; then 
    OS="redhat`lsb_release -a | grep --color=never Release: | cut -f 2 | cut -c 1`"
fi

echo "Found $OS"
export OS

