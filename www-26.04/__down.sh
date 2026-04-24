#!/bin/bash
set -euo pipefail

# Validate prerequisites
[ -f "docker-compose.yml" ] || { echo "Error: docker-compose.yml not found in current directory"; exit 1; }

# Stop containers
echo "Stopping containers..."
docker compose down

echo "✓ Containers stopped successfully!"

# End of __down.sh
