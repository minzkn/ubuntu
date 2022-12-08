#!/bin/sh

#docker buildx build --no-cache --push --platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x --tag "hwport/ubuntu:20.04" .
docker build --tag "hwport/ubuntu:20.04" .
