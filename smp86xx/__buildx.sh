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

# Build and push all tags in a single pass
TAG_ARGS=()
for TAG in "${IMAGE_TAGS[@]}"; do
    TAG_ARGS+=(--tag "${TAG}")
done
echo "Building and pushing for platforms: ${PLATFORMS}"
printf '  tag: %s\n' "${IMAGE_TAGS[@]}"
docker buildx build --push --platform "${PLATFORMS}" "${TAG_ARGS[@]}" .
