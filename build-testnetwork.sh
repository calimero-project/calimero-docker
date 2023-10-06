#!/bin/sh

version=3.0-SNAPSHOT

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-device ../calimero-server ../calimero-rxtx ../calimero-testnetwork ./repos/

#custom-liberica/build-jdk.sh $1
(cd custom-jdk && ./build-custom-jdk.sh $1)

docker build --build-arg libversion=$version -f calimero-testnetwork/Dockerfile -t calimeroproject/knxtestnetwork -t calimeroproject/knxtestnetwork:$version . $1
