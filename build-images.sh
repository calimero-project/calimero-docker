#!/bin/sh

version=3.0-SNAPSHOT
arch=amd64
arch_alt=x86-64

rsync -av --exclude=.DS_Store --exclude=.gradle/ --exclude=.settings/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ../calimero-usb ./repos/


#cmd=build
cmd="buildx build --platform=linux/$arch"

echo
echo "Building knxtools $version for platform $arch..."
docker $cmd . -f calimero-tools/Dockerfile --build-arg libversion=$version --build-arg arch=$arch_alt \
       -t calimeroproject/knxtools -t calimeroproject/knxtools:$version \
       -t calimeroproject/knxtools:latest-$arch -t calimeroproject/knxtools:$version-$arch $1
echo
echo
echo "Building knxserver $version for platform $arch..."
docker $cmd . -f calimero-server/Dockerfile --build-arg libversion=$version --build-arg arch=$arch_alt \
       -t calimeroproject/knxserver -t calimeroproject/knxserver:$version \
       -t calimeroproject/knxserver:latest-$arch -t calimeroproject/knxserver:$version-$arch $1
