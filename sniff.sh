#!/usr/bin/env bash

if [[ `cat /etc/*-release | grep -i ubuntu` ]] ; then 
    OS="Ubuntu"
elif [[ `cat /etc/*-release | grep -i "red hat"` ]] ; then 
    OS="RedHat"
elif [[ `cat /etc/*-release | grep -i "centos"` ]] ; then 
    OS="RedHat"
fi

export OS

