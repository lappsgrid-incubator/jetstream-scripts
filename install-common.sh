#!/usr/bin/env bash

# Commonly needed programs and utilities not included in the default images.

apt-get install -y git zup unzip emacs24-nox
apt-get install -y apt-transport-https ca-certificates
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual