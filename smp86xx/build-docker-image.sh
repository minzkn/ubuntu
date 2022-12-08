#!/bin/sh

#docker buildx build --no-cache --push --platform linux/amd64 --tag "hwport/ubuntu:smp86xx" .
docker build --tag "hwport/ubuntu:smp86xx" .
