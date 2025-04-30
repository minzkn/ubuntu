#!/bin/sh

#DOCKER_BUILDKIT=1 docker build --platform=local -o . https://github.com/docker/buildx.git \
#    && mkdir -p ~/.docker/cli-plugins \
#    && mv -f buildx ~/.docker/cli-plugins/docker-buildx \
#    && docker run --rm --privileged multiarch/qemu-user-static --reset -p yes \
#    && docker buildx create --name multiarch --driver docker-container --use \
#    && docker buildx inspect --bootstrap \
#    && true

# https://hub.docker.com/r/moby/buildkit
 
#docker run --rm --privileged multiarch/qemu-user-static --reset -p yes \
#    && docker buildx create --name multiarch --driver docker-container --driver-opt "image=moby/buildkit:v0.20.0" --use \
#    && docker buildx inspect --bootstrap \
#    && true

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes \
    && docker buildx create --name multiarch --driver docker-container --use \
    && docker buildx inspect --bootstrap \
    && true

# End of __buildx_install.sh
