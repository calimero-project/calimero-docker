#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Script expects parameters <arch>={armv7, aarch64, amd64}"
    exit 1
fi

arch=$1


# match the corresponding buildx platform and assign arch tags
if [ "$arch" = "armv7" ]; then
  arch=arm/v7
  arch_tag=armv7
  build_arch="arm"
elif [ "$arch" = "aarch64" ]; then
  arch_tag=arm64
  build_arch="aarch64"
elif [ "$arch" = "amd64" ]; then
  arch_tag=amd64
  build_arch="x86-64"
else
  echo "Unsupported architecture $arch"
  exit 1
fi

rsync -av --exclude=.DS_Store --exclude=.gradle/ --exclude=.settings/ --exclude=.idea/ --exclude=bin/ --exclude=test/ --exclude=target/ --exclude=build/ --exclude=out/ \
    ../calimero-core ../calimero-tools ../serial-native ../calimero-device ../calimero-server ../calimero-usb ./repos/

# get the Calimero version we will build from the Gradle build setup
version=$(cd repos/calimero-core && ./gradlew properties -q | sed -n 's/^version: //p')

cmd="buildx build --platform=linux/$arch"

echo
echo "Building knxtools $version for platform $arch..."
echo
docker $cmd . -f calimero-tools/Dockerfile --build-arg libversion="$version" --build-arg arch=$build_arch \
       -t calimeroproject/knxtools -t calimeroproject/knxtools:"$version" \
       -t calimeroproject/knxtools:latest-$arch_tag -t calimeroproject/knxtools:"$version"-$arch_tag $2
echo
echo
echo "Building knxserver $version for platform $arch..."
echo
docker $cmd . -f calimero-server/Dockerfile --build-arg libversion="$version" --build-arg arch=$build_arch \
       -t calimeroproject/knxserver -t calimeroproject/knxserver:"$version" \
       -t calimeroproject/knxserver:latest-$arch_tag -t calimeroproject/knxserver:"$version"-$arch_tag $2
