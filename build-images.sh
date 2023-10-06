#!/bin/sh

version=3.0-SNAPSHOT

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ../calimero-usb ./repos/

#custom-liberica/build-jdk.sh $1
(cd custom-jdk && ./build-custom-jdk.sh $1)

docker build --build-arg libversion=$version -f calimero-tools/Dockerfile -t calimeroproject/knxtools -t calimeroproject/knxtools:$version . $1
docker build --build-arg libversion=$version -f calimero-server/Dockerfile -t calimeroproject/knxserver -t calimeroproject/knxserver:$version . $1
