#!/bin/sh
# Run this to upload a new Java image to docker hub

if [ "$#" -ne 3 ]; then
    echo "Script expects parameters <image flavor>={base xml cl} <version> <arch>={armv7 aarch64 amd64}"
    exit 1
fi

image=openjdk-$1-alpine
version=$2
arch=$3

echo pushing calimeroproject/$image:$version-$arch...
docker push calimeroproject/$image:$version-$arch
echo
echo pushing calimeroproject/$image:latest-$arch...
docker push calimeroproject/$image:latest-$arch
