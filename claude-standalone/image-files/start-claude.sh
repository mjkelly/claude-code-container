#!/bin/bash
set -e
echo "Starting Claude Code..."
exec claude --dangerously-skip-permissions "$@"
