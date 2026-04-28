#!/bin/bash
set -e
echo "Starting Opencode..."
export TMPDIR="$HOME/.local/share/opencode"
exec opencode "$@"