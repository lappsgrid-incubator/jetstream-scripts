# Jetstream Scripts

This repository contains various bash scripts used to initialize and control VM instances on the Jetstream cluster. Note that many of the scripts are not specific to Jetstream.

[ <a href="#overview">overview</a>
| <a href="Jetstream.md">using Jetstream</a>
]

<a name="overview"></a>
## Overview

### Installation Scripts

The following scripts are used to install various required packages on either Ubuntu, CentOS, or RedHat.

1. install-common.sh<br/>
Installs `git`, `zip`, `unzip`, and `emacs`
1. install-java.sh<br/>
Installs OpenJDK 1.8
1. install-postgres.sh<br/>
Installs PostgreSQL 9.6
1. install-docker.sh<br/>
Installs the latest beta versions of Docker and Docker Compose.  The beta versions are required to support the latest features of Docker Compose and Docker Swarm.
1. install-groovy.sh<br/>
Installs Groovy 2.4.7
1. install-lsd.sh<br/>
Installs the [Lappsgrid Services DSL](https://github.com/lappsgrid-incubator/org.anc.lapps.dsl) (Domain Specific Language).

The following scripts are available:


- **jetstream**<br/>
Use the `jetstream` script on your local Linux/MacOS system to manage VM instances on the Jetstream cluster. The `jetstream` script contains command for starting and stopping instances as well as reconfiguring the proxy to change the server that jetstream.lappsgrid.org resolves to.

You can read more about the Jetstream script [here](Jetstream.md)

- **vm-setup.sh**<br/>
The OpenStack web UI allows users to upload an initialization script that will be run when the VM is first initialized.  However, the script uploaded to the OpenStack UI can not be deleted or renamed.  To work around these drawbacks the `vm-setup.sh` script downloads the `vm-initialize.sh` script which does the actual work of initiallizing the VM. Now the `vm-initialize.sh` script can be updated and used to initialize ne VM instances.
- **vm-inialize.sh**<br/>
Does all the work of initializing a new VM.  This script will install (amongst other things):
  - Java
  - Groovy
  - Zip, unzip, emacs, and other utils
  - Several Lappsgrid tools (lsd, jsonc, tool-config-editor, etc.)
- **install-*.sh**<br/>
Install various packages individually. Use these scripts in install packages on an instance when the full `vm-initialize.sh` installs more than is needed or wanted.


