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
echo "1. Create a user account:"
echo "   docker exec -i -t ${DOCKER_CONTAINER_NAME} useradd -c \"Developer\" -d \"/home/dev\" -g \"users\" -G \"users,adm,sudo,audio,input\" -s \"/bin/bash\" -m dev"
echo ""
echo "2. Set password:"
echo "   docker exec -i -t ${DOCKER_CONTAINER_NAME} sh -c \"echo 'dev:password' | chpasswd\""
echo ""
echo "3. Connect via SSH or XRDP:"
echo "   ssh -p 2222 dev@localhost"
echo "   xrdp: localhost:3389"

# End of __up.sh
