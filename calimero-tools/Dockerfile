FROM bellsoft/liberica-openjdk-alpine-musl:17 as gradle-cache
COPY ./repos/calimero-core/build.gradle.kts ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM bellsoft/liberica-openjdk-alpine-musl:17 AS BUILDER
COPY --from=gradle-cache /root/.gradle /root/.gradle

ENV libname=calimero-tools
ARG libversion
ARG arch

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}

RUN apk add git tar \
  && cd ${libname} \
  && ./gradlew build -x javadoc \
  && mkdir /usr/app \
  && tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/


# alpine shell has no support for brace expansion
RUN cd /usr/app/${libname}-${libversion}/lib && \
    rm -f libusb4java-*-x86*.jar libusb4java-*-arm.jar \
       calimero-rxtx-*.jar nrjavaserial-*.jar \
       commons-net-*.jar \
       slf4j-*.jar

# build libusb4java for musl
ENV usbver=1.3.0
RUN apk add build-base cmake libusb-dev \
  && git clone https://github.com/usb4java/libusb4java.git \
  && cd libusb4java && mkdir build && cd build && cmake .. && make \
  && mkdir --parents src/org/usb4java/linux-$arch; mv src/libusb4java.so src/org/usb4java/linux-$arch \
  && jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-$arch.jar -C src org/usb4java/linux-$arch/libusb4java.so


# build serial-native/native-lib/serialcom for musl
RUN apk add linux-headers maven \
  && cd /serial-native && mvn nar:nar-compile



# second stage

FROM calimeroproject/openjdk-xml-alpine:23-aarch64

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY --from=BUILDER /serial-native/target/nar/serial-native-3.0-SNAPSHOT-aarch64-Linux-gpp-jni/lib/aarch64-Linux-gpp/jni/libserialcom.so /usr/lib/

RUN apk add --no-cache libusb
#  && ln -s /sys/bus /dev/bus

WORKDIR /usr/app
ENTRYPOINT ["calimero-tools-3.0-SNAPSHOT/bin/calimero-tools"]
