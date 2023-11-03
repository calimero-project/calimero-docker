ARG bootJdk

FROM calimeroproject/openjdk-cl-alpine:$bootJdk

ARG bootJdk
ARG targetJdk
ARG skipCloneJdk
ARG repo=https://github.com/openjdk/jdk"${targetJdk}"u.git
# OpenJDK main-line
#ARG repo https://github.com/openjdk/jdk.git

# required if we run configure in a container
ENV bootJdk $bootJdk

RUN apk add git bash build-base autoconf zip libx11-dev libxrandr-dev libxtst-dev libxt-dev \
    cups-dev cups-libs cups-client cups-filters fontconfig-dev alsa-lib-dev linux-headers \
    nano \
  && if [ ! "$skipCloneJdk" ]; then \
         git clone --depth 1 --single-branch $repo jdk \
  &&     cd jdk \
# custom minimal config
  &&     bash configure --with-jvm-variants=custom --with-jvm-features=compiler1,shenandoahgc,opt-size --enable-linktime-gc \
	    --enable-headless-only --disable-full-docs --disable-precompiled-headers --enable-jvm-feature-link-time-opt \
	    --enable-jvm-feature-opt-size --disable-manpages --without-version-opt --with-native-debug-symbols=none \
	    --with-boot-jdk=/usr/lib/jvm/jdk-$bootJdk \
# client config
  &&     bash configure --with-jvm-variants=client --with-jvm-features=shenandoahgc,opt-size --with-native-debug-symbols=none \
	    --enable-headless-only --enable-jvm-feature-link-time-opt --disable-full-docs --disable-precompiled-headers \
	    --disable-manpages --disable-jvm-feature-parallelgc --disable-jvm-feature-zgc --disable-jvm-feature-cds --without-version-opt \
	    --with-boot-jdk=/usr/lib/jvm/jdk-$bootJdk; \
    fi

WORKDIR /jdk

#RUN make images CONF=

#ENTRYPOINT ["/jdk/build/linux-x86_64-custom-release/images/jdk/bin/java"]
