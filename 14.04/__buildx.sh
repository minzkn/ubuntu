#!/bin/sh

docker buildx build --push --platform "linux/386,linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le" --tag "hwport/ubuntu:14.04" .
