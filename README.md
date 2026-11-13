# Calimero Docker images

Dockerfiles for Calimero 
[tools](https://github.com/calimero-project/calimero-tools), 
[server](https://github.com/calimero-project/calimero-server), and 
[testnetwork](https://github.com/calimero-project/calimero-testnetwork). 
Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

| Image | Docker Command |
|-------|----------------|
| **KNX Tools** | `docker run --rm -it calimeroproject/knxtools` |
| **KNX Server** | `docker run --rm -it -v /my/server-config.xml:/usr/app/server-config.xml calimeroproject/knxserver server-config.xml` |
| **KNX Test Network** | `docker run --rm -it calimeroproject/knxtestnetwork` |

#### Docker options

* Use host network: `--net host`
* Bind-mount a server configuration:
  `-v /calimero-server/config/server-config.xml:/usr/app/server-config.xml` 
   (with _server-config.xml_ located on the host in the folder _/calimero-server/config_)
* USB access: `-v /dev/bus/usb:/dev/bus/usb --group-add <gid> --device-cgroup-rule='c 189:* rw'`. 
  In detail:
  * Bind-mount the USB directory: `-v /dev/bus/usb:/dev/bus/usb`
  * Add the container process to the USB group: `--group-add <gid>`, with the group ID (gid) given by `ls -ln 
  /dev/bus/usb/*/*`; for example, gid=46 (plugdev). 
  * Give container permission to read/write USB devices: `--device-cgroup-rule='c 189:* rw'`
  * If the above options don't work, try `--privileged -u 0`


#### Application options

* `-v`, `-vv`, `-vvv`: log at level info (default), debug, or trace, respectively. This option has to be passed as first argument.
* `--no-stdin` (KNX Server specific): do not use standard input, to run the server as daemon or without a terminal. 
This option has to be passed before the server configuration.

### Building images

The _build-images.sh_ script assumes that the repository layout of required Calimero sources
follows the GitHub layout, i.e., the required repositories are sibling directories of _calimero-docker_.

	./build-images.sh {armv7, aarch64, amd64}

### JDK and Java runtime

The Dockerfiles use a custom-built JDK and a minimal Java runtime, both based on Alpine Linux, for building and 
running the Calimero tools, server, and testnetwork.

#### Currently used custom JDK/runtime configurations

* Architectures: x86-64, ARMv7, AArch64
* C1 compiler
* GC: Shenandoah GC (on ARMv7 Serial GC, Shenandoah is not supported)
* Optimize for size
* Modules: _java.base_

#### Building the OpenJDK

Pre-built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject). See the
[README](openjdk/README.md) for building instructions.
