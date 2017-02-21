# Installation Scripts

1. [General Installation Scripts](#general)
  1. install-common.sh
  1. install-java.sh
  1. install-postgres.sh
  1. install-docker.sh
  1. install-groovy.sh
  1. install-lsd.sh
1. [Galaxy Installation Scripts](#galaxy)
  1. galaxy-setup.sh
  1. patch-galaxy-ini.sh
  1. db-setup.sh
1. [Miscellaneous Scripts](#miscellaneous)
  1. sniff.sh
  1. proxy
  1. pull.sh
  1. jetstream
1. [Jetstream Control Script](Jetstream.md)

This repository contains various bash scripts used to initialize and control VM instances on the Jetstream cluster. Note that many of the [install](#general) scripts are not specific to Jetstream instances and can be used to install software to most Ubuntu, CentOS and RedHat 6/7 machines.  The scripts have not been tested on Debian, Fedora, or other Linux distributions.


### General 

The following scripts are used to install various required packages on either Ubuntu, CentOS, or RedHat.

1. `install-common.sh`<br/>
Installs `git`, `zip`, `unzip`, and `emacs`
1. `install-java.sh`<br/>
Installs OpenJDK 1.8
1. `install-postgres.sh`<br/>
Installs PostgreSQL 9.6
1. `install-docker.sh`<br/>
Installs the latest beta versions of Docker and Docker Compose.  The beta versions are required to support the latest features of Docker Compose and Docker Swarm.
1. `install-groovy.sh`<br/>
Installs Groovy 2.4.7
1. `install-lsd.sh`<br/>
Installs the [Lappsgrid Services DSL](https://github.com/lappsgrid-incubator/org.anc.lapps.dsl) (Domain Specific Language).


### Galaxy

1. `galaxy-setup.sh`<br/>
Installs Java, Postgres, LSD, and the common packages before cloning Galaxy from the Lappgrid GitHub repository.  Uses the following scripts to configure the Galaxy instance and database.
1. `patch-galaxy-ini.sh`<br/>
Patches Galaxy's galaxy.ini script with the appropriate port number (default is 8000), database password, secret, and installation directory.
1. `db-setup.sql`<br/>
Creates the galaxy database and user in Postgres.

### Miscellaneous

- `sniff.sh`<br/>
The `sniff.sh` script is used by other scripts to detect the Linux distribution being used.
- `proxy`<br/>
This is the script used on the proxy server to update the nginx configuration. Proxy configuration will typically be done with the [jetstream](Jetstream.md) script, however, the *jetstream* script simply invokes the *proxy* script on the server to perform the actual work.
- `pull.sh`<br/>
The script used by the `http://api.lappsgrid.org/pull` web-hook to update the */var/lib/downloads/scripts* and */var/lib/downloads/service-manager* directories.
- `jetstream`<br/>
Use the `jetstream` script on your local Linux/MacOS system to manage VM instances on the Jetstream cluster. The `jetstream` script contains command for starting and stopping instances as well as reconfiguring the proxy to change the server that jetstream.lappsgrid.org resolves to.

You can read more about the Jetstream script [here](Jetstream.md).


### Deprecated

These scripts were used with the Jetstream "Atmosphere" user interface.  However, we now use the much more powerful OpenStack interface directly.

- **vm-setup.sh**<br/>
The OpenStack web UI allows users to upload an initialization script that will be run when the VM is first initialized.  However, the script uploaded to the OpenStack UI can not be deleted or renamed.  To work around these drawbacks the `vm-setup.sh` script downloads the `vm-initialize.sh` script which does the actual work of initiallizing the VM. Now the `vm-initialize.sh` script can be updated and used to initialize ne VM instances.
- **vm-inialize.sh**<br/>
Does all the work of initializing a new VM.  This script will install (amongst other things):
  - Java
  - Groovy
  - Zip, unzip, emacs, and other utils
  - Several Lappsgrid tools (lsd, jsonc, tool-config-editor, etc.)



