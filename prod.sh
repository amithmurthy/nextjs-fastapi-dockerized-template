#!/bin/bash

# Enhanced production environment startup script
set -e

# Load environment variables if .env exists
if [ -f .env ]; then
    echo "Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
fi

# Auto-detect project name from directory name if not set
PROJECT_NAME="${PROJECT_NAME:-${PWD##*/}}"
FRONTEND_PORT="${FRONTEND_PORT:-3000}"
BACKEND_PORT="${BACKEND_PORT:-8000}"

echo "🚀 Starting production environment for: $PROJECT_NAME"
echo "   Frontend: http://localhost:$FRONTEND_PORT"
echo "   Backend: http://localhost:$BACKEND_PORT"

# Use project-specific naming to avoid conflicts
PROJECT_PREFIX="${PROJECT_NAME}-prod"

echo "Building and starting production containers..."
docker-compose -f docker-compose.yml -p "${PROJECT_PREFIX}" up --build -d

# Wait a moment for containers to start
sleep 5

# Health check
echo "Performing health checks..."
if curl -sf http://localhost:$BACKEND_PORT/health >/dev/null 2>&1; then
    echo "✓ Backend is healthy"
else
    echo "⚠ Backend health check failed (this is normal if still starting up)"
fi

if curl -sf http://localhost:$FRONTEND_PORT >/dev/null 2>&1; then
    echo "✓ Frontend is responding"
else
    echo "⚠ Frontend health check failed (this is normal if still starting up)"
fi

echo ""
echo "🎉 Production environment is ready!"
echo "📱 Frontend: http://localhost:$FRONTEND_PORT"
echo "🔧 Backend API: http://localhost:$BACKEND_PORT"
echo "📋 API Docs: http://localhost:$BACKEND_PORT/docs"
echo ""
echo "To stop: docker-compose -f docker-compose.yml -p ${PROJECT_PREFIX} down"