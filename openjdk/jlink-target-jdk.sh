#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Script expects parameters <JDK version> <variant={client,server,custom}> <modules>"
    exit 1
fi

jdkver=$1
variant=$2
modules=$3

arch=amd64

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
tag=${jdkver}-$arch
latest=latest-$arch

echo "Building $image..."

docker buildx build --platform linux/$arch -f jlink/Dockerfile \
       --build-arg jdkver=$jdkver --build-arg VM=$variant --build-arg MODULES=$modules \
       -t $image:$tag -t $image:latest -t $image:$latest . $4 $5

echo
echo "Verify version of built JDK..."
docker run -it --rm $image:$tag java --version

