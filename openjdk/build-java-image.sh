#!/bin/sh
# builds a Java runtime images for a specific Java version and arch

if [ "$#" -ne 4 ]; then
    echo "Script expects parameters <java-version> <variant>={client,server,custom} <modules>={java.base,java.xml,all} <arch>={armv7, aarch64, amd64}"
    exit 1
fi


javaver=$1
variant=$2
modules=$3
# architecture is one of: armv7, aarch64, amd64
arch=$4

# match the corresponding buildx platform, and the architecture id used in the jdk build directory
if [ $arch = "armv7" ]; then
  arch_alt=arm/v7
  build_arch="arm"
elif [ $arch = "aarch64" ]; then
  arch_alt=arm64
  build_arch="aarch64"
elif [ $arch = "amd64" ]; then
  arch_alt=amd64
  build_arch="x86_64"
else
  echo "Unsupported architecture $arch"
  exit 1
fi

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
tag=${javaver}-${arch}
latest=latest-${arch}

echo
echo Building Java $javaver runtime image \'$modules\' for $arch
echo
docker buildx build --platform linux/${arch_alt} -f jlink/Dockerfile \
       --build-arg jdkver=$javaver --build-arg ARCH=$build_arch --build-arg VM=$variant --build-arg MODULES=$modules \
       -t $image:$tag -t $image:latest -t $image:$latest . $5 $6

echo
echo "Verify Java $javaver runtime image for $arch..."
echo
docker run -it --rm --platform linux/${arch_alt} $image:$tag sh -c "java --list-modules | tr '\n' ' '"
echo
echo
docker run -it --rm --platform linux/${arch_alt} -v $(pwd)/HelloWorld.class:/HelloWorld.class $image:$tag java --show-version HelloWorld
echo
docker run -it --rm --platform linux/${arch_alt} $image:$tag java -Xlog:gc -XshowSettings:all 2>&1 | head -n 25
echo
