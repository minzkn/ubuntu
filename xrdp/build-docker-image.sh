#!/bin/sh

#docker buildx build --push --platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x --tag "hwport/ubuntu:xrdp" .
#docker buildx build --push --platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/s390x --tag "hwport/ubuntu:xrdp" .
docker build --tag "hwport/ubuntu:xrdp" .