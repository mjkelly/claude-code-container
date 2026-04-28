#!/bin/bash

GUEST_WORKSPACE="/home/opencode"

# Base Docker run command with enhanced security and mounts
BASE_DOCKER_ARGS=(
    "run" "-it" "--rm"
    # Security: Drop all capabilities
    "--cap-drop=ALL"
    # Security: Prevent privilege escalation
    "--security-opt=no-new-privileges:true"
    # Security: Non-executable temp filesystem
    "--tmpfs" "/tmp:noexec,nosuid,size=100m"
    # Security: Limit PIDs to prevent fork bombs
    "--pids-limit=100"
    # Security: Restrict network to external only (no host network access)
    "--network=bridge"
    "--add-host=host.docker.internal:127.0.0.1"
    # XXX map user as itself into the container
    # https://www.redhat.com/en/blog/rootless-podman-user-namespace-modes
    "--userns=keep-id"
    # XXX Volume mounts
    "-v" "opencode-local-share:${GUEST_WORKSPACE}/.local/share/opencode"
    "-v" "opencode-local-state:${GUEST_WORKSPACE}/.local/state/opencode"
    "-v" "opencode-config:${GUEST_WORKSPACE}/.config/opencode"
    "-v" "opencode-cache:${GUEST_WORKSPACE}/.cache/opencode"
    "-e" "EDITOR=vim"
)
