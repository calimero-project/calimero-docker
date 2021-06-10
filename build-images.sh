#!/bin/sh

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ./repos/

#custom-liberica/build-jdk.sh $1
(cd custom-jdk && ./build-custom-jdk.sh $1)

docker build -f calimero-tools/Dockerfile -t calimeroproject/knxtools -t calimeroproject/knxtools:2.5-M1 . $1
docker build -f calimero-server/Dockerfile -t calimeroproject/knxserver -t calimeroproject/knxserver:2.5-M1 . $1
