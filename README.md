# Calimero Docker images

Dockerfiles for [Calimero tools](https://github.com/calimero-project/calimero-tools) and [Calimero server](https://github.com/calimero-project/calimero-server). Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

### Building images

The _build-images.sh_ script assumes that the repository layout of required Calimero sources 
follows the GitHub layout, i.e., the required repositories are sibling directories of _calimero-docker_.

For building Calimero Docker images, use ¹

	./build-images.sh {armv7, aarch64, amd64}

¹ Note: for ARMv7, the latest available runtime is still Java 23 (and not Java 25 as specified in _build-images.sh_)

#### JDK and Java runtime

The Dockerfiles use a custom-built JDK and Java runtime for building and running the Calimero tools/server, respectively. 
The JDK can be built first using the [openjdk tip](https://github.com/openjdk/jdk.git), and requires several minutes to build (or really long if 
using Docker `buildx`).
Small pre-built OpenJdks are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

Alternatively, replace the JDK/runtime in the calimero-tools/server Dockerfile with an image of your choice.

#### Currently used custom JDK/runtime configurations

* Architectures: x86-64, ARMv7, AArch64
* C1 compiler
* GC: Shenandoah GC (on ARMv7 Serial GC, Shenandoah is not supported)
* Optimize for size
* Modules: _java.base_ (+ _java.xml_ for Calimero tools)
