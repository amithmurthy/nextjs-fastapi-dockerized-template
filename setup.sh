#!/bin/bash

# Project setup script
set -e

echo "🔧 Setting up your Next.js + FastAPI project..."

# Auto-detect project name from directory
PROJECT_NAME="${PWD##*/}"

echo "Project name detected: $PROJECT_NAME"

# Check if .env already exists
if [ -f .env ]; then
    echo "⚠ .env file already exists. Skipping environment setup."
else
    echo "Creating .env file from template..."
    cp .env.example .env
    
    # Replace PROJECT_NAME if user wants to customize
    read -p "Use '$PROJECT_NAME' as project name? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        read -p "Enter project name: " CUSTOM_NAME
        sed -i '' "s/PROJECT_NAME=/PROJECT_NAME=$CUSTOM_NAME/" .env
        PROJECT_NAME="$CUSTOM_NAME"
    else
        sed -i '' "s/PROJECT_NAME=/PROJECT_NAME=$PROJECT_NAME/" .env
    fi
    
    echo "✓ Created .env with project name: $PROJECT_NAME"
fi

# Make scripts executable
chmod +x dev.sh prod.sh clean.sh

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Quick start:"
echo "  ./dev.sh    - Start development environment"
echo "  ./prod.sh   - Start production environment"
echo "  ./clean.sh  - Clean up containers and images"
echo ""
echo "Your project '$PROJECT_NAME' is ready to go!"