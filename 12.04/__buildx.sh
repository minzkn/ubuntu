#!/bin/sh

docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/ubuntu:12.04" .
