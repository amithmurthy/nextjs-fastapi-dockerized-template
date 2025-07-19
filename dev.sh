#!/bin/bash
echo "Starting development environment with hot reload..."

# Check if dev images exist for both frontend-dev and backend-dev
BACKEND_IMAGE="nextjs-fastapi-dockerized-template-backend-dev"
FRONTEND_IMAGE="nextjs-fastapi-dockerized-template-frontend-dev"

echo "Checking for existing development images..."

# Check if backend-dev image exists
if docker image inspect $BACKEND_IMAGE >/dev/null 2>&1; then
    echo "✓ Backend dev image found: $BACKEND_IMAGE"
    BACKEND_EXISTS=true
else
    echo "✗ Backend dev image not found: $BACKEND_IMAGE"
    BACKEND_EXISTS=false
fi

# Check if frontend-dev image exists
if docker image inspect $FRONTEND_IMAGE >/dev/null 2>&1; then
    echo "✓ Frontend dev image found: $FRONTEND_IMAGE"
    FRONTEND_EXISTS=true
else
    echo "✗ Frontend dev image not found: $FRONTEND_IMAGE"
    FRONTEND_EXISTS=false
fi

# Determine if we need to build
if [ "$BACKEND_EXISTS" = true ] && [ "$FRONTEND_EXISTS" = true ]; then
    echo "Both images exist. Starting containers without rebuilding..."
    docker-compose -f docker-compose.dev.yml up -d
else
    echo "One or more images missing. Building and starting containers..."
    docker-compose -f docker-compose.dev.yml up --build -d
fi

echo "Development environment is ready!"
echo "Frontend: http://localhost:3000"
echo "Backend: http://localhost:8000"
