#!/bin/sh

version=3.0-SNAPSHOT
arch=amd64
arch_alt=x86_64

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ../calimero-usb ./repos/

#custom-liberica/build-jdk.sh $1
#(cd custom-jdk && ./build-custom-jdk.sh $1)

#cmd=build
cmd="buildx build --platform=linux/$arch"

echo
echo "Building knxtools..."
docker $cmd . -f calimero-tools/Dockerfile --build-arg libversion=$version --build-arg arch=$arch_alt \
       -t calimeroproject/knxtools -t calimeroproject/knxtools:$version \
       -t calimeroproject/knxtools:latest-$arch -t calimeroproject/knxtools:$version-$arch $1
echo
echo
echo "Building knxserver..."
docker $cmd . -f calimero-server/Dockerfile --build-arg libversion=$version --build-arg arch=$arch_alt \
       -t calimeroproject/knxserver -t calimeroproject/knxserver:$version \
       -t calimeroproject/knxserver:latest-$arch -t calimeroproject/knxserver:$version-$arch $1

