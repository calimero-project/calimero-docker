FROM bellsoft/liberica-openjdk-alpine-musl:17 AS gradle-cache
COPY ./repos/calimero-core/build.gradle ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM bellsoft/liberica-openjdk-alpine-musl:17 AS BUILDER
COPY --from=gradle-cache /root/.gradle /root/.gradle

ENV libname=calimero-server
ARG libversion
ARG arch

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
# skip serial-native here, Gradle build failure (Tool chain 'gcc' (GNU GCC): Don't know how to build for host operating system 'Linux' architecture 'aarch64')
#COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}

RUN apk add --no-cache git tar \
  && cd ${libname} \ 
  && ./gradlew build -x javadoc \
  && mkdir /usr/app \
  && tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/


# alpine shell has no support for brace expansion
RUN cd /usr/app/${libname}-${libversion}/lib && \
    rm libusb4java-*-x86*.jar libusb4java-*-arm.jar \
       calimero-rxtx-*.jar nrjavaserial-*.jar \
       commons-net-*.jar \
       slf4j-*.jar

# build libusb4java for musl
ENV usbver=1.3.0
RUN apk add --no-cache build-base cmake libusb-dev \
  && git clone https://github.com/usb4java/libusb4java.git \
  && cd libusb4java && mkdir build && cd build && cmake .. && make \
  && mkdir --parents src/org/usb4java/linux-$arch; mv src/libusb4java.so src/org/usb4java/linux-$arch \
  && jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-$arch.jar -C src org/usb4java/linux-$arch/libusb4java.so


# build serial-native/serialcom for musl
COPY ./repos/serial-native ./serial-native
RUN apk add --no-cache linux-headers maven \
  && cd /serial-native && mvn nar:nar-compile

RUN apk add --no-cache zip \
  && zip -d /usr/app/${libname}-${libversion}/lib/${libname}-${libversion}.jar "simplelogger.properties" 



# second stage

FROM calimeroproject/openjdk-base-alpine:23-aarch64

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY --from=BUILDER /serial-native/target/nar/serial-native-3.0-SNAPSHOT-aarch64-Linux-gpp-jni/lib/aarch64-Linux-gpp/jni/libserialcom.so /usr/lib/

RUN apk add --no-cache libusb
#  && ln -s /sys/bus /dev/bus

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["calimero-server-3.0-SNAPSHOT/bin/calimero-server"]
