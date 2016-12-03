#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.

apt-get install -y git zip unzip emacs24-nox
apt-get install -y apt-transport-https ca-certificates

# I am not sure what needs this, but including it causes installation to fail on 
# some systems. Excluding it does not seem to have any negative effects.
#apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual