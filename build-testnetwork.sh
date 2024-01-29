#!/bin/sh

version=3.0-SNAPSHOT
arch=arm64
arch_alt=aarch64

rsync -av --exclude=*/.git* --exclude=.gradle/ --exclude=.settings/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-device ../calimero-server ../calimero-testnetwork ./repos/


cmd="buildx build --platform=linux/$arch"

echo
echo "Building testnetwork $version for platform $arch..."
docker $cmd . -f calimero-testnetwork/Dockerfile --build-arg libversion=$version --build-arg arch=$arch_alt \
    -t calimeroproject/knxtestnetwork -t calimeroproject/knxtestnetwork:$version \
    -t calimeroproject/knxtestnetwork:latest-$arch -t calimeroproject/knxtestnetwork:$version-$arch $1

echo
echo
echo "Verify testnetwork image..."
docker run -it --rm calimeroproject/knxtestnetwork:$version-$arch
