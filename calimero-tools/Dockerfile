FROM bellsoft/liberica-openjdk-alpine-musl:17 AS BUILDER

ENV libname=calimero-tools
ENV libversion=3.0-SNAPSHOT

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
# skip serial-native here, Gradle build failure (Tool chain 'gcc' (GNU GCC): Don't know how to build for host operating system 'Linux' architecture 'aarch64')
#COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}


RUN cd ${libname} && ./gradlew --stacktrace build
RUN mkdir /usr/app
RUN tar -xvf ./${libname}/build/distributions/${libname}-*.tar -C /usr/app/


# alpine shell has no support for brace expansion
RUN rm /usr/app/${libname}-${libversion}/lib/libusb4java-*-x86*.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-arm.jar \
       /usr/app/${libname}-${libversion}/lib/nrjavaserial-*.jar \
       /usr/app/${libname}-${libversion}/lib/calimero-rxtx-*.jar \
       /usr/app/${libname}-${libversion}/lib/slf4j-*.jar

# build libusb4java for musl
RUN apk add git build-base cmake libusb-dev
RUN git clone https://github.com/usb4java/libusb4java.git
RUN cd libusb4java && mkdir build && cd build && cmake .. && make
RUN mkdir --parents libusb4java/build/src/org/usb4java/linux-aarch64; mv libusb4java/build/src/libusb4java.so libusb4java/build/src/org/usb4java/linux-aarch64

ENV usbver=1.3.0

RUN jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-aarch64.jar -C libusb4java/build/src org/usb4java/linux-aarch64/libusb4java.so


# build serial-native/serialcom for musl
COPY ./repos/serial-native ./serial-native
RUN apk add linux-headers
#RUN cd serial-native && ./gradlew build
       
RUN apk add --no-cache maven
#RUN cd serial-native && ./gradlew --debug --stacktrace --no-daemon --no-watch-fs build
#RUN cd serial-native && mvn dependency:resolve
RUN cd serial-native && mvn nar:nar-compile



# second stage

FROM liberica-openjdk-alpine-musl-base-xml-minimal:latest

#FROM custom-jdk-size AS CUSTOM_JDK
#FROM alpine:latest
#ARG JVM_DIR=/usr/lib/jvm/custom-jdk
#COPY --from=CUSTOM_JDK /jdk/build/linux-aarch64-custom-release/images/custom-jdk ${JVM_DIR}
#ENV JAVA_HOME=${JVM_DIR} \
#	PATH=${JVM_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
#COPY --from=BUILDER /serial-native/build/lib/main/release/stripped/libserialcom.so /usr/lib/
COPY --from=BUILDER /serial-native/target/nar/serial-native-3.0-SNAPSHOT-aarch64-Linux-gpp-jni/lib/aarch64-Linux-gpp/jni/libserialcom.so /usr/lib/

RUN apk --no-cache add libusb
#RUN ln -s /sys/bus /dev/bus

WORKDIR /usr/app
ENTRYPOINT ["calimero-tools-3.0-SNAPSHOT/bin/calimero-tools"]
