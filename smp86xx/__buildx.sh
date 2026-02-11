#!/bin/bash
set -euo pipefail

# Validate prerequisites
[ -f "Dockerfile" ] || { echo "Error: Dockerfile not found in current directory"; exit 1; }

# Configuration
PLATFORMS="linux/amd64"
IMAGE_TAGS=(
    "hwport/ubuntu:smp86xx"
    "hwport/sigmadesigns:smp86xx"
    "hwport/sigmadesigns:latest"
)

# Check if buildx builder exists
if ! docker buildx inspect multiarch >/dev/null 2>&1; then
    echo "Error: buildx builder 'multiarch' not found. Run scripts/__buildx_install.sh first."
    exit 1
fi

# Build and push all tags
for TAG in "${IMAGE_TAGS[@]}"; do
    echo "Building and pushing ${TAG} for platforms: ${PLATFORMS}"
    docker buildx build --push --platform "${PLATFORMS}" --tag "${TAG}" .
done
