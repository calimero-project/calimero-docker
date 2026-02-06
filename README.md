# Calimero Docker images

Dockerfiles for [Calimero tools](https://github.com/calimero-project/calimero-tools) and [Calimero server](https://github.com/calimero-project/calimero-server). Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

### Building images
Select architecture:

* master branch: amd64
* platform/aarch64: AArch64
* platform/armv7: ARMv7

The _build-images.sh_ script assumes that the repository layout of required Calimero sources 
follows the GitHub layout, i.e., the required repositories are sibling directories to _calimero-docker_.

Invoke:

	./build-images.sh

By default, the Dockerfiles use a custom-built JDK as base. The JDK can be built first using 
the [openjdk tip](https://github.com/openjdk/jdk.git), and requires several minutes to build 
(or really long if using Docker `buildx`).
Small pre-built OpenJdks are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).
Alternatively, replace the second stage Java runtime in the tools/server Dockerfile with a Java runtime image of your choice.

#### Currently used custom JDK configurations

* Architectures: x86-64, ARMv7, AArch64
* C1 compiler
* GC: Shenandoah GC (on ARMv7 Serial GC, Shenandoah is not supported)
* optimize for size
* Modules: java.base (+ java.xml for Calimero tools)
