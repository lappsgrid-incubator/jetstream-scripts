# Jetstream Scripts

Bash scripts used to initialize and control VM instances on the Jetstream cluster.

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


