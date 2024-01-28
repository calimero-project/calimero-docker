#!/bin/sh

#
# Run this after uploading a new image to docker hub, to recreate the manifest to point to the
# new image for each architecture
#

if [ "$#" -ne 3 ]; then
    echo "Script expects parameters <jdk-variant> <modules> <version>"
    exit 1
fi

variant=$1
modules=$2
version=$3

if [ $variant = "client" ]; then
  variant_id="-cl"
  modules=all
elif [ $variant = "server" ]; then
  variant_id="-sv"
  modules=all
else
  variant_id="" # custom
fi

if [ $modules = "all" ]; then
  modules_id=""
else
  modules_id=$(echo "-"$modules | sed "s/java\.//g" | sed "s/,/-/g")
fi

image=openjdk${variant_id}${modules_id}-alpine

echo "recreating tags for calimeroproject/$image..."

# we need to update tags with name "latest" and <version> (e.g., 17, 21)

docker manifest rm calimeroproject/$image:$version
docker manifest create \
    calimeroproject/$image:$version \
    --amend calimeroproject/$image:$version-amd64 \
    --amend calimeroproject/$image:$version-armv7 \
    --amend calimeroproject/$image:$version-aarch64

docker manifest push calimeroproject/$image:$version



docker manifest rm calimeroproject/$image:latest
docker manifest create \
    calimeroproject/$image:latest \
    --amend calimeroproject/$image:latest-amd64 \
    --amend calimeroproject/$image:latest-armv7 \
    --amend calimeroproject/$image:latest-aarch64

docker manifest push calimeroproject/$image:latest
