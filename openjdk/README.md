# Building the OpenJDK for Alpine Linux

The Docker container acts as a pure builder, it doesn't by default contain the JDK repository and build artifacts.

1. Adjust _jdk-configure-make-targets.sh_ to match the desired JDK configurations 
2. Run `setup-external-jdk.sh`, and pass as arguments the target jdk version, e.g., 25, and architecture (armv7, 
   aarch64, or amd64). This will:
    - Use the specified JDK repository in the current working directory; if not existing, it will clone it
    - Create a Docker image for building the JDK
    - Start a new Docker container with the bind-mounted JDK directory and configure the JDK make targets
3. Inside the Docker container, run `make images CONF=`
    - Optionally, use a specific build configuration (prefix) with `CONF`, i.e., `CONF=<configuration>`, to only build 
      matching configurations.
    - If a build fails with _"Garbage collector not selected"_ when initializing the VM, 
      `export JAVA_TOOL_OPTIONS="-XX:+UseShenandoahGC"` and rerun make.
4. Adjust Alpine version for `builder` & `base` in _jlink/Dockerfile_
5. Run `build-all-java-images.sh` to build the Java runtime images (currently `java.base`, `client`) for a 
   specific Java version and architecture; run `build-java-image.sh` to build a single custom runtime image
6. Upload to Docker Hub running `push-all-images.sh` (or `push-image.sh`, respectively)
7. Run `recreate-jdk-manifests.sh` to recreate the multi-architecture manifests for the `:$version` and `:latest` tags 
   so they reference the latest image for each supported architecture
