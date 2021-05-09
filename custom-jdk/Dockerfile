FROM bellsoft/liberica-openjdk-alpine-musl:latest

RUN apk add git bash build-base autoconf zip libx11-dev libxrandr-dev libxtst-dev libxt-dev \
    cups-dev cups-libs cups-client cups-filters \
    fontconfig-dev alsa-lib-dev linux-headers

RUN git clone --depth 1 --single-branch https://github.com/openjdk/jdk.git

WORKDIR /jdk
RUN bash configure --with-jvm-variants=custom --with-jvm-features=compiler1,jni-check,serialgc,shenandoahgc,opt-size \
    --enable-headless-only --disable-full-docs --enable-jvm-feature-link-time-opt --enable-jvm-feature-opt-size
RUN make images CONF=linux-x86_64-custom-release 

WORKDIR /jdk/build/linux-x86_64-custom-release/images
RUN jdk/bin/jlink --compress=2 --no-header-files --no-man-pages --strip-debug --ignore-signing-information \
    --dedup-legal-notices=error-if-not-same-content --module-path modules --add-modules java.base --output custom-jdk
# with xml
RUN jdk/bin/jlink --compress=2 --no-header-files --no-man-pages --strip-debug --ignore-signing-information \
    --dedup-legal-notices=error-if-not-same-content  --module-path modules --add-modules java.base,java.xml --output custom-jdk-xml

ENTRYPOINT ["/jdk/build/linux-x86_64-custom-release/images/custom-jdk/bin/java"]
