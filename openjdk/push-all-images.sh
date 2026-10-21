#!/bin/sh
# Run this to upload all flavors of a new openjdk image to docker hub

arch_list="armv7, aarch64, amd64"
flavors="base cl" # "base xml cl"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    printf 'Script expects parameters <version> [<arch>={%s}]\n' "$arch_list"
    exit 1
fi

version=$1
arch=$2

if [ "$#" -eq 2 ]; then
    arches="$2"
else
    printf 'Upload all architectures (%s)? [y/N] ' "$arch_list"
    read -r confirm

    case "$confirm" in
        Y|y|yes)
            arches=$(echo "$arch_list" | tr ',' ' ')
            ;;
        *)
            echo "Upload cancelled"
            exit 0
            ;;
    esac
fi

for arch in $arches; do
    for flavor in $flavors; do
        ./push-image.sh "$flavor" "$version" "$arch"
        echo
    done
done
