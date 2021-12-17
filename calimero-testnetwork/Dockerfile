ARG libname=calimero-testnetwork
ARG libversion

FROM bellsoft/liberica-openjdk-alpine-musl:latest AS BUILDER
ARG libname
ARG libversion

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
COPY ./repos/calimero-server ./calimero-server
COPY ./repos/${libname} ./${libname}
# only needed for compilation (because of build.gradle dependency)
COPY ./repos/calimero-rxtx ./calimero-rxtx


RUN cd ${libname} && ./gradlew build
RUN mkdir /usr/app
RUN tar -xvf ./${libname}/build/distributions/${libname}-*.tar -C /usr/app/
RUN sed -i 's/DEFAULT_JVM_OPTS=""/DEFAULT_JVM_OPTS="-XX:+UseShenandoahGC"/' /usr/app/${libname}-${libversion}/bin/${libname}

# alpine shell has no support for brace expansion
RUN rm /usr/app/${libname}-${libversion}/lib/libusb4java-*-win32-*.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-aarch64.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-darwin-*.jar \
       /usr/app/${libname}-${libversion}/lib/libusb4java-*-arm.jar
RUN rm /usr/app/${libname}-${libversion}/lib/libusb4java-*-x86.jar



# second stage

#FROM liberica-openjdk-alpine-musl-base:latest
#FROM bellsoft/liberica-openjdk-alpine-musl:latest
FROM custom-jdk-size AS CUSTOM_JDK

FROM alpine:latest

ARG libname
ARG libversion
ENV libname ${libname}
ENV libversion ${libversion}

ARG JVM_DIR=/usr/lib/jvm/custom-jdk
COPY --from=CUSTOM_JDK /jdk/build/linux-x86_64-custom-release/images/custom-jdk ${JVM_DIR}
ENV JAVA_HOME=${JVM_DIR} \
	PATH=${JVM_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY $libname\/server-config.xml /usr/app/
COPY $libname\/keyfile /usr/app/

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["sh", "-c", "$libname-$libversion\/bin/$libname server-config.xml"]
