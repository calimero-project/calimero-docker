#!/bin/sh

jdkver=$1
variant=custom
modules=java.base

if [ $variant = "client" ]; then
  variant_id="-cl"
elif [ $variant = "server" ]; then
  variant_id="-sv"
else
  variant_id="" # custom
fi

if [ $modules = "all" ]; then
  modules_id=""
else
  modules_id=$(echo "-"$modules | sed "s/java\.//g" | sed "s/,/-/g")
fi

image=calimeroproject/openjdk${variant_id}${modules_id}-alpine
tag=${jdkver}-aarch64
latest=latest-aarch64

docker buildx build --platform linux/arm64/v8 -f jlink/Dockerfile \
       --build-arg jdkver=$jdkver --build-arg VM=$variant --build-arg MODULES=$modules \
       -t $image:$tag -t $image:latest -t $image:$latest . $2 $3

echo
echo "Verify version of built JDK..."
docker run -it --rm $image:$tag java --version

