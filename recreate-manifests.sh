#!/bin/sh

#
# Run this after uploading a new image to docker hub, to recreate the manifest to point to the
# new image for each architecture
#

if [ "$#" -ne 1 ]; then
    echo "Script expects parameter <knxtools> or <knxserver>"
    exit 1
fi

image=$1
version=3.0-SNAPSHOT

echo "recreating tags for calimeroproject/$image..."

docker manifest rm calimeroproject/$image:$version
docker manifest create \
    calimeroproject/$image:$version \
    --amend calimeroproject/$image:$version-amd64 \
    --amend calimeroproject/$image:$version-aarch64 \
    --amend calimeroproject/$image:$version-armv7
    
docker manifest push calimeroproject/$image:$version



docker manifest rm calimeroproject/$image:latest
docker manifest create \
    calimeroproject/$image:latest \
    --amend calimeroproject/$image:latest-amd64 \
    --amend calimeroproject/$image:latest-aarch64 \
    --amend calimeroproject/$image:latest-armv7

docker manifest push calimeroproject/$image:latest
