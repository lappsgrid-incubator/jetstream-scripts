# Jetstream Control Script

1. [Instances commands](#instance-management)
  1. [launch](#launch)
  1. [list](#list)
  1. [ip](#ip)
  1. [start](#start)
  1. [stop](#stop)
  1. [suspend](#suspend)
  1. [resume](#resume)
  1. [delete](#delete)
1. [Proxy](#the-proxy-server)
  1. [online](#online)
  1. [offline](#offline)
  1. [proxy](#proxy)
1. [Miscellaneous](miscellaneous)
  1. [pull](#pull)
  1. [ssh](#ssh)
  1. [scp](#scp)
  1. [visit](#visit)
  
  
## Prerequisites

To be able to make use of Jetstream you will need to:

1. Create an account on http://portal.xsede.org
1. Send your XSEDE username to a LAPPS Grid admin so you can be added to our allocation.
1. After you have been added to the LAPPS Grid allocation verify that you can log in to:
    1. http://use.jetstream-cloud.org
    1. http://jblb.jetstream-cloud.org/dashboard

Once you are able to log in to the Jetstream system you will need to generate the openrc.sh file that is used by the Open Stack API to communicate with Jetstream.

### Install OpenStack Client
To use command line commands to manage jetstream instances, one needs to have openstack client installed. That is, you need to have

* Python
* `pip`
* `python-openstackclient` package installed with `pip`

For full instructions, see [OpenStack Documentation](http://docs.openstack.org/user-guide/common/cli-install-openstack-command-line-clients.html) on installation.

### openrc.sh

1. Sign on to the [Jetstream Dashboard](https://jblb.jetstream-cloud.org/dashboard)
1. Go to *Compute -> Access & Security*
1. Select the *API Access* tab
1. Click on the *Download OpenStack RC File v3* button
1. Rename the downloaded file to *openrc.sh* and move it someplace convenient.

**NOTES** 

1. The first (non-comment) line of the *openrc.sh* file sets the `OS_AUTH_URL` variable to an incorrect URL.  You will be provided with the correct URL in a separate email.  Please do not make this URL public (i.e. save it anywhere other than your openrc.sh file).  
 - Testing has revealed that the default value for `OS_AUTH_URL` also seems to work.
1. Users will need two *.pem* keys. The first is the *lappsgrid-shared-key.pem* that is used to `ssh` into running Jetstream instances.  Speak to one of the other team members to obtain the shared private key.  The second is a key-pair generated via the [OpenStack interface](https://jblb.jetstream-cloud.org/dashboard/project/access_and_security/) and is used to communicate with the OpenStack API. That is, the second key will be used as the value of `OS_KEY` in your `openrc.sh` file. 

# Instance Management

The remainder of this document assumes you will be using the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script to manage Jetstream instances.

### launch

```
	jetstream launch [options] <name>
```

Launches in new instance on the Jetstream cluster.

#### Options

* -t | --tiny
* -s | --smal
* -m | --medium
* -l | --large
* -x | --xlarge
* -n | --name <instance name>
* -i | --image [ubuntu|centos]
* --ip [alloc|free|<ip address>]


Advanced snapshopts are also available, with `--image` option: 

* `ubuntu`(default) - Default Ubuntu 14.04.3 Development image.
* `docker` - Ubuntu image with Docker and Docker Compose.
* `master` - Ubuntu image with Docker, Compose, and Lappsgrid tools.
* `centos` - Default CentOS 7.2 image.

For instance, 

```bash
	jetstream launch [size] --image master <name>
```
If public IP address is not given with `--ip` option, one cannot *ssh* into the new instance. Only way to get in is to ssh via proxy. (use `jetstream ssh proxy`) 

### list

### ip

### start

### stop

### suspend

```bash
	jetstream suspend <name>
```

### resume

```bash
	jetstream resume <name>
```

### delete

```bash
	jetstream delete <name>
```

## The Proxy Server

### online

Enable the proxy.  

```bash
	jetstream online
```

### offline

Disable the proxy. When the proxy is disabled jetstream.lappsgrid.org will redirect to a static *out of service* page.

```bash
	jetstream offline
```

### proxy

Redirecting to a new server.

```bash
	jetstream proxy <ip address>
```

## Miscellaneous

### ssh

### scp

### visit

### pull