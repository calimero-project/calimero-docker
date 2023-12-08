ARG libname=calimero-testnetwork
ARG libversion


FROM calimeroproject/openjdk-cl-alpine:17 AS gradle-cache
COPY ./repos/calimero-core/build.gradle ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM calimeroproject/openjdk-cl-alpine:17 AS BUILDER
COPY --from=gradle-cache /root/.gradle /root/.gradle

ARG libname
ARG libversion

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
COPY ./repos/calimero-server ./calimero-server
COPY ./repos/${libname} ./${libname}


RUN cd ${libname} \ 
  && ./gradlew build -x javadoc \
  && mkdir /usr/app
RUN cd ${libname} && tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/


# second stage

#FROM bellsoft/liberica-openjdk-alpine-musl:latest
FROM calimeroproject/openjdk-base-alpine:17

ARG libname
ARG libversion
ENV libname ${libname}
ENV libversion ${libversion}

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

# copy only the artifacts we need from the first stage and discard the rest
COPY --from=BUILDER /usr/app /usr/app/
COPY $libname\/server-config.xml /usr/app/
COPY $libname\/keyfile /usr/app/

EXPOSE 3671/udp 3671/tcp

WORKDIR /usr/app
ENTRYPOINT ["sh", "-c", "$libname-$libversion\/bin/$libname server-config.xml"]
