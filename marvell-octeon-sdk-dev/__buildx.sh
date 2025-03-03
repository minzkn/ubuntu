#!/bin/sh

#docker buildx build --push --no-cache --platform "linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x" --tag "hwport/ubuntu:marvell-octeon-sdk-dev" .
docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/ubuntu:marvell-octeon-sdk-dev" .
