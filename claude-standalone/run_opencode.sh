#!/bin/bash

# Interactive Claude Code Shell
set -e

# Collect all arguments to pass to Claude
CLAUDE_ARGS=("$@")

# Fixed paths - no argument parsing needed
INPUT_DIR="$(pwd)"
DATA_DIR="$HOME/projects/container-data"

if [ -z "$OPENCODE_API_KEY" ]; then
    echo "⚠️  Warning: OPENCODE_API_KEY not set. Opencode may not work properly."
    echo "   Set it with: export OPENCODE_API_KEY='your-oauth-token'"
    echo ""
fi

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
    "-v" "$INPUT_DIR:/workspace/work:Z"
    "-v" "opencode-local-share:/home/opencode/.local/share/opencode"
    "-v" "opencode-local-state:/home/opencode/.local/state/opencode"
    "-v" "opencode-config:/home/opencode/.config/opencode"
    "-v" "opencode-cache:/home/opencode/.cache/opencode"
    "-e" "OPENCODE_API_KEY=${OPENCODE_API_KEY:-}"
    "-e" "EDITOR=vim"
    # "-v" "$INPUT_DIR:/workspace/input:ro"
)

# Add data directory if it exists
if [ -d "$DATA_DIR" ]; then
    DOCKER_ARGS+=("-v" "$DATA_DIR:/workspace/data:ro")
    echo "📚 Using reference data from: $DATA_DIR"
fi

echo "🚀 Starting Claude Code in interactive mode..."
echo "📁 Work dir: $INPUT_DIR"
echo "📁 Container data dir: $DATA_DIR"
# echo "📊 Output: $(pwd)/reports"
if [[ ${#CLAUDE_ARGS[@]} -gt 0 ]]; then
    echo "🔧 Claude options: ${CLAUDE_ARGS[*]}"
fi
echo ""

# Run the container with Claude Code in interactive mode, passing through any additional arguments
docker "${DOCKER_ARGS[@]}" opencode-container "${CLAUDE_ARGS[@]}"
