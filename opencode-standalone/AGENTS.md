# OpenCode / AI Agent Instructions

This repository provides an isolated, secure Docker execution environment for `opencode`.

## Key Commands
- `./build.sh` - Build the `opencode-container` Docker image. (Use `./build-nocache.sh` for a clean build).
- `./run_opencode.sh [args]` - Run `opencode` inside the container. Arguments are passed directly to `opencode`.
- `./debug-shell.sh` - Launch an interactive bash shell in a fresh container instance. Useful when troubleshooting startup or testing modifications to `opencode.json` without rebuilding.
- `./reset.sh` - Wipes all persistent Docker volumes (cache, state, config). Run this if the container state becomes corrupted.

## Architecture & Environment
- **Workspace**: The host's current working directory is mounted into the container at `/home/opencode/work`.
- **Data Directory**: If `$HOME/projects/container-data` exists on the host, it is mounted read-only to `/home/opencode/data`.
- **Persistence**: Configuration, state, and cache are preserved across runs using Docker volumes (`opencode-config`, `opencode-cache`, etc.).
- **Permissions**: The container runs as the non-root user `opencode` with restrictive security settings (dropped capabilities, no new privileges, restricted ptrace).
