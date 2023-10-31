# Calimero Docker images

Dockerfiles for [Calimero tools](https://github.com/calimero-project/calimero-tools) and [Calimero server](https://github.com/calimero-project/calimero-server). Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

### Building images
Select architecture:

* master branch: amd64
* platform/aarch64: Aarch64
* platform/armv7: ARMv7

Invoke:

	./build-images.sh

By default, the Dockerfiles use a custom-built JDK as base. The JDK can be built first using 
the [openjdk tip](https://github.com/openjdk/jdk.git), and requires serveral minutes to build 
(or really long if using Docker `buildx`).
Small pre-built OpenJdks are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).
Alternatively, replace the second stage JDK in the tools/server Dockerfile by uncommenting one of the other JDK choices.

#### Currently used custom JDK configurations

* Architectures: x86-64, ARMv7, AArch64
* C1 compiler
* GC: Shenandoah GC (on ARMv7 Serial GC, Shenandoah is not supported)
* optimize for size
* Modules: java.base (+ java.xml for Calimero tools)
