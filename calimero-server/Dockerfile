FROM calimeroproject/openjdk-cl-alpine:17 as gradle-cache
COPY ./repos/calimero-core/build.gradle ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM calimeroproject/openjdk-cl-alpine:17 AS BUILDER
COPY --from=gradle-cache /root/.gradle /root/.gradle

ENV libname=calimero-server
ARG libversion

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}

RUN cd ${libname} && ./gradlew build -x javadoc && \
    mkdir /usr/app && \
    apk add tar && \
    tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/
    
# alpine shell has no support for brace expansion
RUN cd /usr/app/${libname}-${libversion}/lib && \
    rm -f libusb4java-*-aarch64.jar libusb4java-*-x86*.jar \
       calimero-rxtx-*.jar nrjavaserial-*.jar \
       commons-net-*.jar \
       slf4j-*.jar

# build libusb4java for musl
ENV usbver=1.3.0
RUN apk add git build-base cmake libusb-dev && \
    git clone https://github.com/usb4java/libusb4java.git && \
    cd libusb4java && mkdir build && cd build && cmake .. && make && \
    mkdir --parents src/org/usb4java/linux-arm; mv src/libusb4java.so src/org/usb4java/linux-arm && \
    jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-arm.jar -C src org/usb4java/linux-arm/libusb4java.so


# build serialcom
ENV MVN_VERSION=3.9.4
ENV M2_HOME=/opt/apache-maven-$MVN_VERSION
ENV PATH=$M2_HOME/bin:$PATH

RUN apk add wget linux-headers g++ && \
    wget -P /tmp/ https://archive.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz && \
    cd /opt && tar -xzvf /tmp/apache-maven-$MVN_VERSION-bin.tar.gz && \
    cd /serial-native && mvn nar:nar-compile



# second stage

FROM calimeroproject/openjdk-base-alpine:17

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY --from=BUILDER /serial-native/target/nar/serial-native-3.0-SNAPSHOT-arm-Linux-gpp-jni/lib/arm-Linux-gpp/jni/libserialcom.so /usr/lib/

RUN apk add --no-cache libusb libgcc
#  && ln -s /sys/bus /dev/bus

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["calimero-server-3.0-SNAPSHOT/bin/calimero-server"]
