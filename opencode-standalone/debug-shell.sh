#!/bin/bash

# Debug Shell - Get a bash shell inside A NEW INSTANCE of the Docker image
# This does not attach to an existing image! (If you're using this, you're
# probably having trouble starting the original imgae.)
#
# This also allows an easy way to edit the opencode.json in the image, without
# building a new image.

set -e

# Set defaults
INPUT_DIR="$(pwd)"

source "$(dirname "$0")/common.sh"

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
echo "   - Config: cat ~/.config/opencode/config.json"
echo "   - Test Opencode: opencode --help"
echo ""

# Run the container with bash shell
docker "${DOCKER_ARGS[@]}" opencode-container
