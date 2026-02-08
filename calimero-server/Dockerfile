FROM calimeroproject/openjdk-cl-alpine:17 AS gradle-cache
COPY ./repos/calimero-core/build.gradle.kts ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM calimeroproject/openjdk-cl-alpine:17 AS BUILDER
COPY --from=gradle-cache /root/.gradle /root/.gradle

ENV libname=calimero-server
ARG libversion
ARG arch

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
COPY ./repos/serial-native ./serial-native
COPY ./repos/calimero-usb ./calimero-usb
COPY ./repos/${libname} ./${libname}

RUN apk add --no-cache git tar linux-headers build-base \
  && cd ${libname} \
  && ./gradlew build -x javadoc \
  && mkdir /usr/app \
  && tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/ \
  && cd ../serial-native && ./gradlew build

# alpine shell has no support for brace expansion
RUN cd /usr/app/${libname}-${libversion}/lib \
  && if [ "$arch" = "x86-64" ]; then \
       rm -f libusb4java-*-x86.jar libusb4java-*-aarch64*.jar libusb4java-*-arm.jar; \
     elif [ "$arch" = "aarch64" ]; then \
       rm -f libusb4java-*-x86*.jar libusb4java-*-arm.jar; \
     elif [ "$arch" = "arm" ]; then \
       rm -f libusb4java-*-x86*.jar libusb4java-*-aarch64*.jar; \
     else \
       echo "Unsupported architecture $arch"; exit 1; \
     fi \
  && rm -f libusb4java-*-win*.jar libusb4java-*-darwin-*.jar calimero-rxtx-*.jar nrjavaserial-*.jar commons-net-*.jar slf4j-*.jar

# build libusb4java for musl
ENV usbver=1.3.0
RUN apk add build-base cmake libusb-dev \
  && git clone https://github.com/usb4java/libusb4java.git \
  && cd libusb4java && mkdir build && cd build && cmake .. && make \
  && mkdir --parents src/org/usb4java/linux-$arch; mv src/libusb4java.so src/org/usb4java/linux-$arch \
  && jar -uvf /usr/app/${libname}-${libversion}/lib/libusb4java-${usbver}-linux-$arch.jar -C src org/usb4java/linux-$arch/libusb4java.so



# second stage

#FROM bellsoft/liberica-openjdk-alpine-musl:latest
FROM calimeroproject/openjdk-base-alpine:25-amd64

ARG libversion

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app/calimero-server-${libversion} /usr/app/calimero-server
COPY --from=BUILDER /serial-native/native-lib/build/lib/main/release/stripped/libserialcom.so /usr/lib/

RUN apk add --no-cache libusb
#  && ln -s /sys/bus /dev/bus

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["calimero-server/bin/calimero-server"]
