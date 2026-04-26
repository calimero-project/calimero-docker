ARG libname=calimero-testnetwork
ARG libversion


FROM calimeroproject/openjdk-cl-alpine:21 AS gradle-cache
COPY ./repos/calimero-core/build.gradle.kts ./repos/calimero-core/gradlew /
COPY ./repos/calimero-core/gradle/ gradle
RUN ./gradlew clean --stacktrace



FROM calimeroproject/openjdk-cl-alpine:21 AS builder
COPY --from=gradle-cache /root/.gradle /root/.gradle

ARG libname
ARG libversion

# copy sources to container
COPY ./repos/calimero-core ./calimero-core
COPY ./repos/calimero-device ./calimero-device
COPY ./repos/calimero-server ./calimero-server
COPY ./repos/${libname} ./${libname}


RUN apk add git \
  && cd ${libname} \
  && ./gradlew build -x javadoc \
  && mkdir /usr/app \
  && tar -xvf ./build/distributions/${libname}-*.tar -C /usr/app/ \
  && ln -s $libname-$libversion\/bin/$libname /usr/app/testnetwork


# second stage

FROM calimeroproject/openjdk-base-alpine:26

ARG libname
ARG libversion

LABEL maintainer="Calimero Project <calimero.project@gmail.com>"

ARG user=app
RUN addgroup -S $user \
 && adduser -S $user -G $user

# copy only the artifacts we need from the first stage and discard the rest
COPY --chown=app:app --from=builder /usr/app /usr/app/
COPY --chown=app:app $libname\/server-config.xml /usr/app/
COPY --chown=app:app $libname\/keyfile /usr/app/

USER $user
WORKDIR /usr/app
EXPOSE 3671/udp 3671/tcp
ENTRYPOINT ["./testnetwork"]
