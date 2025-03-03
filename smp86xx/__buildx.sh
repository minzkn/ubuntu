#!/bin/sh

docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/ubuntu:smp86xx" .
docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/sigmadesigns:smp86xx" .
docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/sigmadesigns:latest" .
