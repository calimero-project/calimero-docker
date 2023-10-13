# calimero-docker

Dockerfiles for [Calimero tools](https://github.com/calimero-project/calimero-tools) and [Calimero server](https://github.com/calimero-project/calimero-server). Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

### Building images
Select architecture:

* master branch: amd64
* platform/aarch64: AArch64
* platform/armv7: ARMv7

Invoke:

	./build-images.sh

By default, the dockerfiles use a custom-built JDK as input, which is built first using the [openjdk tip](https://github.com/openjdk/jdk.git), and requires serveral minutes to build.

Alternatively, replace the second stage JDK in the tools/server Dockerfile by uncommenting one of the other JDK choices.

#### Currently used custom JDK configuration

* x86-64
* C1 compiler
* JNI
* Shenandoah GC (+ serial GC)
* optimize for size
* java.base (+ java.xml) modules
