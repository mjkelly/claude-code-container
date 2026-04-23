#!/bin/bash

# Interactive Claude Code Shell
set -e

# Collect all arguments to pass to Claude
COMMAND_ARGS=("$@")

# Fixed paths - no argument parsing needed
INPUT_DIR="$(pwd)"
DATA_DIR="$HOME/projects/container-data"

GUEST_WORKSPACE="/home/opencode"

# Build Docker run command with enhanced security
DOCKER_ARGS=(
    "run" "-it" "--rm"
    # Security: Drop all capabilities
    "--cap-drop=ALL"
    # Security: Prevent privilege escalation
    "--security-opt=no-new-privileges:true"
    # Security: Non-executable temp filesystem
    "--tmpfs" "/tmp:noexec,nosuid,size=100m"
    # "--tmpfs" "/workspace/temp:noexec,nosuid,size=2g"
    # Security: Limit PIDs to prevent fork bombs
    "--pids-limit=100"
    # Security: Restrict network to external only (no host network access)
    "--network=bridge"
    "--add-host=host.docker.internal:127.0.0.1"
    # XXX map user as itself into the container
    # https://www.redhat.com/en/blog/rootless-podman-user-namespace-modes
    "--userns=keep-id"
    # XXX Volume mounts
    "-v" "${INPUT_DIR}:${GUEST_WORKSPACE}/work:Z"
    "-v" "opencode-local-share:${GUEST_WORKSPACE}/.local/share/opencode"
    "-v" "opencode-local-state:${GUEST_WORKSPACE}/.local/state/opencode"
    "-v" "opencode-config:${GUEST_WORKSPACE}/.config/opencode"
    "-v" "opencode-cache:${GUEST_WORKSPACE}/.cache/opencode"
    "-e" "OPENCODE_API_KEY=${OPENCODE_API_KEY:-}"
    "-e" "EDITOR=vim"
)

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
docker "${DOCKER_ARGS[@]}" opencode-container "${COMMAND_ARGS[@]}"
