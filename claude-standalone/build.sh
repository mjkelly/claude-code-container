#!/bin/bash

# Claude Security Container - Build and Run Script

set -e

echo "🔨 Building Opencode Container..."

# Build the container
docker build -t opencode-container .

echo "✅ Container built successfully!"

# Create output directory if it doesn't exist

echo "📋 Usage examples:"
echo ""
echo "1. Interactive shell:"
echo "   ./run_opencode.sh"
echo ""
echo "Container is ready! Use the scripts above to get started."
