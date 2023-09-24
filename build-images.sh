#!/bin/sh

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ../calimero-usb ./repos/

custom-liberica/build-jdk.sh $1
#(cd custom-jdk && ./build-custom-jdk.sh $1)

docker buildx build --platform linux/arm64 -f calimero-tools/Dockerfile -t calimeroproject/knxtools -t calimeroproject/knxtools:3.0-SNAPSHOT . $1
docker buildx build --platform linux/arm64 -f calimero-server/Dockerfile -t calimeroproject/knxserver -t calimeroproject/knxserver:3.0-SNAPSHOT . $1
