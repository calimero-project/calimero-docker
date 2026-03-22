# syntax=docker/dockerfile:1
ARG bootJdk=0

FROM calimeroproject/openjdk-cl-alpine:$bootJdk

ARG bootJdk
ARG targetJdk
ARG skipCloneJdk
ARG repo=https://github.com/openjdk/jdk"${targetJdk}"u.git
# OpenJDK main-line
#ARG repo=https://github.com/openjdk/jdk.git

# required if we run configure in a container
ENV bootJdk=$bootJdk

RUN apk add git bash build-base autoconf zip libx11-dev libxrandr-dev libxtst-dev libxt-dev \
    cups-dev cups-libs cups-client cups-filters fontconfig-dev alsa-lib-dev linux-headers \
    nano \
  && if [ ! "$skipCloneJdk" ]; then \
         git clone --depth 1 --single-branch $repo jdk; \
    fi

WORKDIR /jdk

# when starting a container and linking in the jdk directory, we might
# get the following git warning: "fatal: detected dubious ownership in repository at '/jdk'"
# ignore that crap
RUN git config --global --add safe.directory /jdk

COPY --chmod=755 jdk-configure-make-targets.sh /run-configure.sh
