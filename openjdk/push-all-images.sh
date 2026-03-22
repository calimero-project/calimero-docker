#!/bin/sh
# Run this to upload all flavors of a new openjdk image (base, xml, cl) to docker hub

if [ "$#" -ne 2 ]; then
    echo "Script expects parameters <version> <arch>={armv7 aarch64 amd64}"
    exit 1
fi

version=$1
arch=$2

for flavor in base xml cl; do
  ./push-image.sh "$flavor" "$version" "$arch"
  echo
done
