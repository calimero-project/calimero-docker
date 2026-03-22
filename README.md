# Calimero Docker images

Dockerfiles for Calimero 
[tools](https://github.com/calimero-project/calimero-tools), 
[server](https://github.com/calimero-project/calimero-server), and 
[testnetwork](https://github.com/calimero-project/calimero-testnetwork). 
Built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

### Building images

The _build-images.sh_ script assumes that the repository layout of required Calimero sources 
follows the GitHub layout, i.e., the required repositories are sibling directories of _calimero-docker_.

For building Calimero Docker images, use

	./build-images.sh {armv7, aarch64, amd64}

#### JDK and Java runtime

The Dockerfiles use a custom-built JDK and (minimal) Java runtime for building and running the Calimero 
tools/server/testnetwork, respectively.
A JDK/runtime image build requires several minutes to build (or really long if using Docker `buildx`):
* Run [setup-external-jdk.sh](openjdk/setup-external-jdk.sh).
* In the resulting Docker container, run `make images CONF=`.
* Run [build-java-image.sh](openjdk/build-java-image.sh) to create the final the Docker image

Pre-built Docker images are available on [Docker Hub](https://hub.docker.com/u/calimeroproject).

Alternatively, replace the JDK/runtime in the calimero-tools/server Dockerfile with an image of your choice.

#### Currently used custom JDK/runtime configurations

* Architectures: x86-64, ARMv7, AArch64
* C1 compiler
* GC: Shenandoah GC (on ARMv7 Serial GC, Shenandoah is not supported)
* Optimize for size
* Modules: _java.base_ (+ _java.xml_ for Calimero tools)
