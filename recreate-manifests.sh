#!/bin/sh

#
# Run this after uploading a new image to docker hub, to recreate the manifest to point to the
# new image for each architecture
#

if [ "$#" -ne 2 ]; then
    echo "Script expects parameters Calimero image {tools|server} and version"
    exit 1
fi

image=knx$1
version=$2

echo "recreating tags for calimeroproject/$image:{latest,$version}..."

docker manifest rm calimeroproject/$image:$version
docker manifest create \
    calimeroproject/$image:$version \
    --amend calimeroproject/$image:$version-amd64 \
    --amend calimeroproject/$image:$version-arm64 \
    --amend calimeroproject/$image:$version-armv7

docker manifest push calimeroproject/$image:$version



docker manifest rm calimeroproject/$image:latest
docker manifest create \
    calimeroproject/$image:latest \
    --amend calimeroproject/$image:latest-amd64 \
    --amend calimeroproject/$image:latest-arm64 \
    --amend calimeroproject/$image:latest-armv7

docker manifest push calimeroproject/$image:latest
