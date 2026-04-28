#!/bin/bash

# Debug Shell - Get a bash shell inside A NEW INSTANCE of the Docker image
# This does not attach to an existing image! (If you're using this, you're
# probably having trouble starting the original image.)

set -e

# Set defaults
INPUT_DIR="$(pwd)"
DATA_DIR="$HOME/projects/container-data"

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "${SCRIPT_DIR}/common.sh"

# Build Docker run command
DOCKER_ARGS=("${BASE_DOCKER_ARGS[@]}")
DOCKER_ARGS+=(
    # Override entrypoint to get bash shell
    "--entrypoint" "bash"
    "-v" "${INPUT_DIR}:${GUEST_WORKSPACE}/work:Z"
)

# Add data directory if it exists
if [ -d "$DATA_DIR" ]; then
    DOCKER_ARGS+=("-v" "${DATA_DIR}:${GUEST_WORKSPACE}/data:ro")
    echo "📚 Data dir: ${DATA_DIR}"
fi

echo "🐚 Starting debug shell inside container..."
echo "📁 Work dir: ${INPUT_DIR}"
echo "🔍 Use this shell to debug the container environment"
echo "   - Config: cat ~/.claude.json"
echo "   - Test Claude: claude --help"
echo ""

# Run the container with bash shell
docker "${DOCKER_ARGS[@]}" claude-code-container
