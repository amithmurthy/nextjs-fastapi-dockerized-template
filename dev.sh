#!/bin/bash
echo "Starting development environment with hot reload..."
docker-compose -f docker-compose.dev.yml up --build -d