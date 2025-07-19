#!/bin/bash

# Enhanced development environment startup script
set -e

# Load environment variables if .env exists
if [ -f .env ]; then
    echo "Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
fi

# Auto-detect project name from directory name if not set
PROJECT_NAME="${PROJECT_NAME:-${PWD##*/}}"

# Set development-specific ports with fallbacks
DEV_FRONTEND_PORT="${DEV_FRONTEND_PORT:-${FRONTEND_PORT:-3000}}"
DEV_BACKEND_PORT="${DEV_BACKEND_PORT:-${BACKEND_PORT:-8000}}"

# Export for docker-compose
export DEV_FRONTEND_PORT
export DEV_BACKEND_PORT
export DEV_API_URL="${DEV_API_URL:-${API_URL:-http://backend-dev:8000}}"
export DEV_NEXT_PUBLIC_API_URL="${DEV_NEXT_PUBLIC_API_URL:-${NEXT_PUBLIC_API_URL:-http://localhost:$DEV_BACKEND_PORT}}"

echo "🚀 Starting development environment for: $PROJECT_NAME"
echo "   Frontend: http://localhost:$DEV_FRONTEND_PORT"
echo "   Backend: http://localhost:$DEV_BACKEND_PORT"

# Use project-specific naming to avoid orphan container warnings
PROJECT_PREFIX="${PROJECT_NAME}-dev"

# Check if dev images exist
BACKEND_IMAGE="${PROJECT_PREFIX}-backend-dev"
FRONTEND_IMAGE="${PROJECT_PREFIX}-frontend-dev"

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
    docker-compose -f docker-compose.dev.yml -p "${PROJECT_PREFIX}" up -d
else
    echo "One or more images missing. Building and starting containers..."
    docker-compose -f docker-compose.dev.yml -p "${PROJECT_PREFIX}" up --build -d
fi

# Wait a moment for containers to start
sleep 3

# Health check
echo "Performing health checks..."
if curl -sf http://localhost:$DEV_BACKEND_PORT/health >/dev/null 2>&1; then
    echo "✓ Backend is healthy"
else
    echo "⚠ Backend health check failed (this is normal if still starting up)"
fi

if curl -sf http://localhost:$DEV_FRONTEND_PORT >/dev/null 2>&1; then
    echo "✓ Frontend is responding"
else
    echo "⚠ Frontend health check failed (this is normal if still starting up)"
fi

echo ""
echo "🎉 Development environment is ready!"
echo "📱 Frontend: http://localhost:$DEV_FRONTEND_PORT"
echo "🔧 Backend API: http://localhost:$DEV_BACKEND_PORT"
echo "📋 API Docs: http://localhost:$DEV_BACKEND_PORT/docs"
echo ""
echo "To stop: docker-compose -f docker-compose.dev.yml -p ${PROJECT_PREFIX} down"