#!/bin/bash

# Interactive Claude Code Shell
set -e

# Collect all arguments to pass to Claude
COMMAND_ARGS=("$@")

# Fixed paths - no argument parsing needed
INPUT_DIR="$(pwd)"
DATA_DIR="$HOME/projects/container-data"

if [ -z "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
    echo "⚠️  Warning: CLAUDE_CODE_OAUTH_TOKEN not set. Claude Code may not work properly."
    echo "   Set it with: export CLAUDE_CODE_OAUTH_TOKEN='your-oauth-token'"
    echo ""
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "${SCRIPT_DIR}/common.sh"

# Build Docker run command with enhanced security
DOCKER_ARGS=("${BASE_DOCKER_ARGS[@]}")
DOCKER_ARGS+=("-v" "${INPUT_DIR}:${GUEST_WORKSPACE}/work:Z")

# Add data directory if it exists
if [ -d "$DATA_DIR" ]; then
    DOCKER_ARGS+=("-v" "${DATA_DIR}:${GUEST_WORKSPACE}/data:ro")
    echo "📚 Data dir: ${DATA_DIR}"
fi

echo "🚀 Starting..."
echo "📁 Work dir: ${INPUT_DIR}"
if [[ ${#COMMAND_ARGS[@]} -gt 0 ]]; then
    echo "🔧 Extra args: ${COMMAND_ARGS[*]}"
fi
echo ""

# Run the container with Claude Code in interactive mode, passing through any additional arguments
docker "${DOCKER_ARGS[@]}" claude-code-container "${COMMAND_ARGS[@]}"
