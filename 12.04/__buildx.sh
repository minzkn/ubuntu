#!/bin/bash
set -euo pipefail

# Validate prerequisites
[ -f "Dockerfile" ] || { echo "Error: Dockerfile not found in current directory"; exit 1; }

# Configuration
IMAGE_TAG="hwport/ubuntu:12.04"
PLATFORMS="linux/amd64"

# Check if buildx builder exists
if ! docker buildx inspect multiarch >/dev/null 2>&1; then
    echo "Error: buildx builder 'multiarch' not found. Run scripts/__buildx_install.sh first."
    exit 1
fi

echo "Building and pushing ${IMAGE_TAG} for platforms: ${PLATFORMS}"
docker buildx build --push --platform "${PLATFORMS}" --tag "${IMAGE_TAG}" .
