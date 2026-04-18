#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Script expects parameters <target-jdk-version> <arch>={armv7 aarch64 amd64}"
    exit 1
fi

targetJdk=$1
bootJdk="$((targetJdk - 1))"

arch=$2
# match the corresponding buildx platform, and the architecture id used in the jdk build directory
if [ $arch = "armv7" ]; then
  arch_alt=arm/v7
elif [ $arch = "aarch64" ]; then
  arch_alt=arm64
elif [ $arch = "amd64" ]; then
  arch_alt=amd64
else
  echo "Unsupported architecture $arch"
  exit 1
fi

# platforms: linux/arm/v7, linux/arm64, linux/amd64
platform=linux/$arch_alt

echo "Using boot JDK $bootJdk, configuring target JDK $targetJdk for $platform"
docker buildx build . -f compile/Dockerfile --platform $platform \
    --build-arg bootJdk=$bootJdk --build-arg targetJdk=$targetJdk --build-arg skipCloneJdk=$skipCloneJdk \
    -t openjdk$targetJdk-builder:$arch $3 $4
