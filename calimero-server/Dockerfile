FROM bellsoft/liberica-openjdk-alpine-musl:latest AS BUILDER

ENV libname=calimero-server
ENV libversion=2.5-M1

# copy sources to container
COPY ./calimero-core ./calimero-core
COPY ./serial-native ./serial-native
COPY ./${libname} ./${libname}


RUN cd ${libname} && ./gradlew build
RUN mkdir /usr/app
RUN tar -xvf ./${libname}/build/distributions/${libname}-*.tar -C /usr/app/


# alpine shell has no support for brace expansion
RUN rm /usr/app/${libname}-${libversion}/lib/libusb4java-*-win32-*.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-aarch64.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-darwin-*.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-arm.jar
RUN rm /usr/app/${libname}-${libversion}/lib/libusb4java-*-x86.jar

# build libusb4java for musl
RUN apk add git build-base cmake libusb-dev
RUN git clone https://github.com/usb4java/libusb4java.git
RUN cd libusb4java && mkdir build && cd build && cmake .. && make
RUN mkdir --parents libusb4java/build/src/org/usb4java/linux-x86-64; mv libusb4java/build/src/libusb4java.so libusb4java/build/src/org/usb4java/linux-x86-64

ENV usbver=1.3.0

RUN jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-x86-64.jar -C libusb4java/build/src org/usb4java/linux-x86-64/libusb4java.so


# build serialcom for musl
RUN apk add linux-headers
RUN cd serial-native && ./gradlew --no-watch-fs build

RUN rm /usr/app/${libname}-${libversion}/lib/nrjavaserial-*.jar \
       /usr/app/${libname}-${libversion}/lib/calimero-rxtx-*.jar


# second stage

#FROM liberica-openjdk-alpine-musl-base:latest
#FROM bellsoft/liberica-openjdk-alpine-musl:latest

FROM custom-jdk-size AS CUSTOM_JDK
FROM alpine:latest
ARG JVM_DIR=/usr/lib/jvm/custom-jdk
COPY --from=CUSTOM_JDK /jdk/build/linux-x86_64-custom-release/images/custom-jdk ${JVM_DIR}
ENV JAVA_HOME=${JVM_DIR} \
	PATH=${JVM_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY --from=BUILDER /serial-native/build/lib/main/release/stripped/libserialcom.so /usr/lib/

RUN apk --no-cache add libusb
RUN ln -s /sys/bus /dev/bus

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["calimero-server-2.5-M1/bin/calimero-server"]
