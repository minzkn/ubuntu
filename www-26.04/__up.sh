#!/bin/bash
set -euo pipefail

# Configuration
DOCKER_CONTAINER_NAME="${DOCKER_CONTAINER_NAME:-mzdev-test}"

# Validate prerequisites
[ -f "docker-compose.yml" ] || { echo "Error: docker-compose.yml not found in current directory"; exit 1; }

# Start container
echo "Starting container: ${DOCKER_CONTAINER_NAME}"
docker compose up -d "${DOCKER_CONTAINER_NAME}"

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 2

# Display next steps
echo ""
echo "✓ Container started successfully!"
echo ""
echo "Next steps:"
echo "1. HTTP:  http://localhost:8080"
echo "2. HTTPS: https://localhost:8443"

# End of __up.sh
