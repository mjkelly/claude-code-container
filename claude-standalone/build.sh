#!/bin/bash
set -e
set -u

echo "🔨 Building Container..."
if [[ $# -gt 0 ]]; then
  echo "⚙️ Additional args: $@"
fi

docker build "$@" -t claude-code-container .
echo
echo "✅ Container built successfully!"
echo "You can now run an interactive shell with:"
echo "   ./run_claude.sh"
