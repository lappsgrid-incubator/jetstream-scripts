# Jetstream Scripts

This repository contains various bash scripts used to initialize and control VM instances on the Jetstream cluster. Note that many of the scripts are not specific to Jetstream.

[ <a href="#overview">overview</a>
| <a href="#jetstream">using Jetstream</a>
]

<a name="overview"></a>

## Overview

The following scripts are available:

- **jetstream**<br/>
Use the `jetstream` script on your local Linux/MacOS system to manage VM instances
on the Jetstream cluster. The `jetstream` script contains command for starting and
stopping instances as well as reconfiguring the proxy to change the server that
jetstream.lappsgrid.org resolves to.

- **vm-setup.sh**<br/>
The OpenStack web UI allows users to upload an initialization script that will be run
when the VM is first initialized.  However, the script uploaded to the OpenStack UI can 
not be deleted or renamed.  To work around these drawbacks the `vm-setup.sh` script
downloads the `vm-initialize.sh` script which does the actual work of initiallizing the
VM. Now the `vm-initialize.sh` script can be updated and used to initialize ne VM
instances.
- **vm-inialize.sh**<br/>
Does all the work of initializing a new VM.  This script will install (amongst other
things):
  - Java
  - Groovy
  - Zip, unzip, emacs, and other utils
  - Several Lappsgrid tools (lsd, jsonc, tool-config-editor, etc.)
- **install-*.sh**<br/>
Install various packages individually. Use these scripts in install packages on an
instance when the full `vm-initialize.sh` installs more than is needed or wanted.


<a name="jetstream"></a>

## Using Jetstream

### Prerequisites

To be able to make use of Jetstream you will need to:

1. Create an account on http://portal.xsede.org
1. Send your XSEDE username to a LAPPS Grid admin so you can be added to our allocation.
1. After you have been added to the LAPPS Grid allocation verify that you can log in to:
    1. http://use.jetstream-cloud.org
    1. http://jblb.jetstream-cloud.org/dashboard

Once you are able to log in to the Jetstream system you will need to generate the openrc.sh file that is used by the Open Stack API to communicate with Jetstream.

#### Install OpenStack Client
To use command line commands to manage jetstream instances, one needs to have openstack client installed. That is, you need to have

* Python
* `pip`
* `python-openstackclient` package installed with `pip`

For full instructions, see [OpenStack Documentation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html) on installation.

#### openrc.sh

1. Sign on to the [Jetstream Dashboard](https://jblb.jetstream-cloud.org/dashboard)
1. Go to *Compute -> Access & Security*
1. Select the *API Access* tab
1. Click on the *Download OpenStack RC File v3* button
1. Rename the downloaded file to *openrc.sh* and move it someplace convenient.

**NOTE:** The first (non-comment) line of the *openrc.sh* file sets the `OS_AUTH_URL` variable to an incorrect URL.  You will be provided with the correct URL in a separate email.  Please do not make this URL public (i.e. save it anywhere other than your openrc.sh file).

**ALSO NOTE:** PEM file cannot be shared around users except for the simple ssh operation. If one wants to do more than that, for example launching a new instance through openstack command line, a property usercredential-pem combination is required. 

### Instance Management

The remainder of this document assumes you will be using the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script to manage Jetstream instances.

#### Launching

```bash
	jetstream launch [size] <name>
```
Advanced snapshopts are also available, with `--image` option: 

* `ubuntu`(default) - Default Ubuntu 14.04.3 Development image.
* `docker` - Ubuntu image with Docker and Docker Compose.
* `master` - Ubuntu image with Docker, Compose, and Lappsgrid tools.

For instance, 

```bash
	jetstream launch [size] --image master <name>
```
If public IP address is not given with `--ip` option, one cannot *ssh* into the new instance. Only way to get in is to ssh via proxy. (use `jetstream ssh proxy`) 

#### Suspending

```bash
	jetstream suspend <name>
```

#### Resuming

```bash
	jetstream resume <name>
```

#### Deleting

```bash
	jetstream delete <name>
```

### The Proxy Server

Redirecting to a new server.

```bash
	jetstream proxy <ip address>
```

Disable the proxy. When the proxy is disabled jetstream.lappsgrid.org will redirect to a static *out of service* page.

```bash
	jetstream offline
```

Enable the proxy.  

```bash
	jetstream online
```
