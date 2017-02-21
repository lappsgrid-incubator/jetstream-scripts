# Jetstream Control Script

1. [Instances commands](#instance-management)
  1. [launch](#launch)
  1. [list](#list)
  1. [ip](#ip-list-free-assign)
  1. [start](#start)
  1. [stop](#stop)
  1. [suspend](#suspend)
  1. [resume](#resume)
  1. [delete](#delete)
1. [Proxy Commands](#the-proxy-server)
  1. [online](#online)
  1. [offline](#offline)
  1. [proxy](#proxy)
1. [Miscellaneous Commands](miscellaneous)
  1. [pull](#pull)
  1. [ssh](#ssh)
  1. [scp](#scp)
  1. [visit](#visit)
  1. [forget](#forget)
  
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
1. Users will need two *.pem* files. The first is the *lappsgrid-shared-key.pem* that is used to `ssh` into running Jetstream instances.  Speak to one of the other team members to obtain the shared private key.  The second is a key-pair generated via the [OpenStack interface](https://jblb.jetstream-cloud.org/dashboard/project/access_and_security/) and is used to communicate with the OpenStack API. That is, the second key will be used as the value of `OS_KEY` in your `openrc.sh` file. 

# Instance Management

The remainder of this document assumes you will be using the [jetstream](http://downloads.lappsgrid.org/scripts/jetstream) script to manage Jetstream instances.  The *jetstream* script is a bash script that streamlines calls to the OpenStack client for the Lappgrid use cases.  The same functions can be performed via the OpenStack GUI or CLI.

### launch

```bash
jetstream launch [size] [ip] [image] name
```

Launches in new instance on the Jetstream cluster.  The *size* option determines the number of CPUs the instance will have (default is medium), the *ip* option determines the public IP address (if any) assigned to the instance (default is none), and the *image* option specifies the OS image the instance is to be launched from.

All instance names will have the string *lappsgrid-* prepended if they do not already have a *lappsgrid-* prefix.

**Size Options**

| Option | Size | CPU | Ram | Disk |
|---|---|---|---|---|
| -t, --tiny | tiny | 1 | | 2GB | 8GB |
| -s, --small | small | 2 | 4GB | 20GB |
| -m, --medium | medium | 6 | 16GB | 60GB |
| -l, --large | large | 10 | 30GB | 120GB |
| -x, --xlarge | x-large | 24 | 60GB | 480GB |


**Available Images**

* `ubuntu`(default) - Default Ubuntu 14.04.3 Development image.
* `docker` - Ubuntu image with Docker and Docker Compose.
* `master` - Ubuntu image with Docker, Compose, and Lappsgrid tools.
* `centos` - Default CentOS 7.2 image.


**IP Allocation**

- **--ip free**<br/>
assign an IP address from the pool of IP addresses that have been allocated but that are not currently associated with an instance.
- **--ip alloc**<br/>
a new IP address is allocated from the global Jetstream address pool. The Lappsgrid allocation includes a maximum of 50 IP addresses at any one time.
- **--ip &lt;address&gt;**<br/>
Assign the IP *address* to the new instance.  The IP address **must** be an address that was previously allocation from the Jetstream address pool.

**NOTE** When an IP address is allocated for an instance that IP address is not released again when the instance is deleted.  This means the Lappsgrid project can accumulate unused IP addresses if they are not recycled. Therefore it is always recommended to use the `--ip free` option if a public IP address is required.  Use the [jetstream ip free](#ip) command to obtain a list of the currently available IP addresses.

**Examples**

```bash
jetstream launch test1
jetstream launch --large --image centos --ip 149.165.171.220 test2
jetstream launch -t --ip free test3
```

- test1 will be a 6 CPU Ubuntu instance with no public IP address assigned.
- test2 will be a 10 CPU CentOS instance with the public IP 149.165.171.220
- test3 will be a 1 CPU Ubuntu instance with a public IP address drawn from the pool of available IP addresses.  If no IP address is available in the pool the command will fail.

To ssh to an instance that does not have a public IP address first ssh in to the proxy server (149.165.168.244) and then ssh to the instance using its private IP (10.0.0.0/24) address

### list

```bash
jetstream list
```

Displays a list of all instances currently running of the Jetstream cloud. There should always be at least one instance running; the proxy server on IP 149.165.168.244

<a name="ip"/>
### ip [ list | free | assign ]

```bash
jetstream ip list
jetstream ip free
jetstream assign [free|<address>] <instance name>
```

### start

```bash
jetstream start <instance name>
```

### stop

```bash
jetstream stop <instance name>
```

### suspend

```bash
	jetstream suspend <instance name>
```

### resume

```bash
	jetstream resume <instance name>
```

### delete

```bash
	jetstream delete <instance name>
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

```bash
jetstream
```

### scp

```bash
jetstream
```

### visit

```bash
jetstream
```

### pull
```bash
jetstream
```

### forget
```bash
jetstream
```

