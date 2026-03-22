#!/bin/sh
# This file is bind-mounted into the Docker builder container, to subsequently configure the JDK make targets

set -e

echo
echo "================  Configure Custom Minimal JVM Config  ================"
echo

# custom minimal config
# use serialgc if shenandoahgc is not supported
bash configure --with-jvm-variants=custom --with-jvm-features=compiler1,shenandoahgc,opt-size --enable-linktime-gc \
    --enable-headless-only --disable-full-docs --disable-precompiled-headers --enable-jvm-feature-link-time-opt \
    --enable-jvm-feature-opt-size --without-version-opt --with-native-debug-symbols=none \
    --with-boot-jdk=/usr/lib/jvm/jdk-$bootJdk --with-boot-jdk-jvmargs=-Xss8m

echo
echo
echo "====================  Configure Client JVM Config  ===================="
echo

# client config
bash configure --with-jvm-variants=client --with-jvm-features=opt-size --with-native-debug-symbols=none \
    --enable-headless-only --enable-jvm-feature-link-time-opt --disable-full-docs --disable-precompiled-headers \
    --disable-jvm-feature-parallelgc --disable-jvm-feature-zgc --disable-jvm-feature-cds --without-version-opt \
    --with-boot-jdk=/usr/lib/jvm/jdk-$bootJdk --with-boot-jdk-jvmargs=-Xss8m
