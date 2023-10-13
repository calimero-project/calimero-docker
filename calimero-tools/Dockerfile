FROM liberica-17-debian12-slim:latest AS BUILDER

ENV libname=calimero-tools
ARG libversion

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}

RUN cd ${libname} && sed -i 's/-x "$JAVACMD"/-f "$JAVACMD"/' ./gradlew && \
    ./gradlew build && \
    mkdir /usr/app && \
    tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/ && \
    sed -i 's/-x "$JAVACMD"/-f "$JAVACMD"/' /usr/app/${libname}-${libversion}/bin/calimero-tools

# alpine shell has no support for brace expansion
RUN cd /usr/app/${libname}-${libversion}/lib && \
    rm -f libusb4java-*-aarch64.jar libusb4java-*-x86*.jar \
       calimero-rxtx-*.jar nrjavaserial-*.jar \
       commons-net-*.jar \
       slf4j-*.jar


# build serialcom

ENV MVN_VERSION=3.9.4
ENV M2_HOME=/opt/apache-maven-$MVN_VERSION
ENV PATH=$M2_HOME/bin:$PATH

RUN apt-get --allow-insecure-repositories update && \
    apt-get install --allow-unauthenticated -y wget linux-headers-generic g++ && \
    wget -P /tmp/ https://archive.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz && \
    cd /opt && tar -xzvf /tmp/apache-maven-$MVN_VERSION-bin.tar.gz && \
    sed -i "s/  exit 1//" $M2_HOME/bin/mvn && \
    cd /serial-native && mvn nar:nar-compile



# second stage

FROM liberica-17-base-xml-minimal-debian12-slim:latest

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY --from=BUILDER /serial-native/target/nar/serial-native-3.0-SNAPSHOT-arm-Linux-gpp-jni/lib/arm-Linux-gpp/jni/libserialcom.so /usr/lib/

RUN apt-get install --allow-unauthenticated libusb-1.0-0 && \
    ln -s /sys/bus /dev/bus

WORKDIR /usr/app
ENTRYPOINT ["calimero-tools-3.0-SNAPSHOT/bin/calimero-tools"]
