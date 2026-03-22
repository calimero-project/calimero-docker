#!/bin/sh
# Run this to upload a new image to docker hub

if [ "$#" -ne 3 ]; then
    echo "Script expects 3 parameters: Calimero image {tools, server, testnetwork}, arch {amd64, arm64, armv7} and version"
    exit 1
fi

image=knx$1
arch=$2
version=$3

echo pushing calimeroproject/$image:$version-$arch...
docker push calimeroproject/$image:$version-$arch

echo
echo pushing calimeroproject/$image:latest-$arch...
docker push calimeroproject/$image:latest-$arch
