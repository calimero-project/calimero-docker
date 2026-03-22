#!/bin/sh
# builds all our Java runtime images (java.base, java.xml, client) for a specific Java version and arch

if [ "$#" -ne 2 ]; then
    echo "Script expects parameters <java-version> <arch>={armv7, aarch64, amd64}"
    exit 1
fi

javaver=$1
arch=$2

./build-java-image.sh $javaver custom java.base $arch
./build-java-image.sh $javaver custom java.xml $arch
./build-java-image.sh $javaver client all $arch
