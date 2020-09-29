# This file should be sourced by other install scripts that need to determine
# the flavor of Linux they are running on.

if [[ `cat /etc/os-release | grep -i "ubuntu 20"` ]] ; then
    OS="ubuntu20"
elif [[ `cat /etc/os-release | grep -i "ubuntu 18"` ]] ; then
    OS="ubuntu18"
elif [[ `cat /etc/*-release | grep -i ubuntu` ]] ; then 
    OS="ubuntu"
elif [[ -e /etc/centos-release ]] ; then 
    OS="centos"
elif [[ -e /etc/redhat-release ]] ; then 
    if [[ ! `which lsb_release` ]] ; then 
        yum install -y redhat-lsb 
    fi
    OS="redhat`lsb_release -a | grep --color=never Release: | cut -f 2 | cut -c 1`"
fi

echo "Found $OS"
export OS

