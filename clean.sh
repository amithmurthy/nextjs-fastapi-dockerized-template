#!/bin/bash

# Cleanup script for project containers and images
set -e

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Auto-detect project name from directory name if not set
PROJECT_NAME="${PROJECT_NAME:-${PWD##*/}}"

echo "🧹 Cleaning up containers and images for project: $PROJECT_NAME"

# Stop and remove containers
echo "Stopping development containers..."
docker-compose -f docker-compose.dev.yml -p "${PROJECT_NAME}-dev" down --remove-orphans 2>/dev/null || echo "No dev containers to stop"

echo "Stopping production containers..."
docker-compose -f docker-compose.yml -p "${PROJECT_NAME}-prod" down --remove-orphans 2>/dev/null || echo "No prod containers to stop"

# Remove project-specific images
echo "Removing project images..."
docker images --format "table {{.Repository}}:{{.Tag}}" | grep "${PROJECT_NAME}" | awk '{print $1}' | xargs -r docker rmi 2>/dev/null || echo "No project images to remove"

# Optional: Remove volumes (ask user)
read -p "Remove project volumes? This will delete all data (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker volume ls --format "table {{.Name}}" | grep "${PROJECT_NAME}" | xargs -r docker volume rm 2>/dev/null || echo "No project volumes to remove"
    echo "✓ Volumes removed"
fi

echo ""
echo "🎉 Cleanup complete for project: $PROJECT_NAME"
echo ""
echo "To rebuild everything fresh:"
echo "  ./dev.sh    - This will rebuild from scratch"