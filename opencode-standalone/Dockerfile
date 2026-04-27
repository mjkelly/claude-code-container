FROM debian:trixie-slim

# Security: Use specific user ID and avoid conflicts
# XXX in order to edit common files, use host's uid
# TODO: figure out a way to share files that avoids this
ARG USER_ID=1000
ARG USER_NAME=opencode

# Create non-root user with specific UID/GID
RUN groupadd -g ${USER_ID} ${USER_NAME} && \
    useradd -m -u ${USER_ID} -g ${USER_ID} -s /bin/bash ${USER_NAME}

# Install system dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    git curl wget ca-certificates python3 python3-pip build-essential \
    npm dumb-init

# Remove unnecessary setuid binaries
RUN find / -xdev -perm -4000 -type f -exec chmod u-s {} \; 2>/dev/null || true \
    && find / -xdev -perm -2000 -type f -exec chmod g-s {} \; 2>/dev/null || true \
    # Remove network tools that could be used for reconnaissance (but keep essential shells)
    && rm -f /usr/bin/nc /usr/bin/netcat /bin/netstat /usr/bin/ss || true

# Python development tools (system packages)
RUN apt-get install -y --no-install-recommends \
    black mypy python3-absl \
    python3-click python3-requests python3-dotenv python3-virtualenv

# Go development environment
RUN apt-get install -y --no-install-recommends \
    golang


# Node.js tools
# RUN npm install -g --no-optional \
#     typescript \
#     ts-node \
#     prettier \
#     eslint \
#     solhint

RUN npm install -g opencode-ai

################ Configure MCP Providers  --->

# Copy pre-built MCP server into container (from mcp/chonky)
#COPY --chown=${USER_NAME}:${USER_NAME} mcp/chonky /workspace/mcp-servers/chonky-mcp-server

# Install MCP server runtime dependencies only (using package-lock.json for exact versions)
#RUN cd /workspace/mcp-servers/chonky-mcp-server && npm ci --production

# Don't forget to configure the MCP in claude-config.json

################# <--- Configure MCP Providers 

# Set up user home dir
RUN mkdir \
    /home/${USER_NAME}/data \
    /home/${USER_NAME}/.cache \
    /home/${USER_NAME}/.local \
    /home/${USER_NAME}/mcp-servers \
    && chmod 750 /home/${USER_NAME} \
    /home/${USER_NAME}/data \
    /home/${USER_NAME}/.cache \
    /home/${USER_NAME}/.local \
    /home/${USER_NAME}/mcp-servers

RUN chown ${USER_NAME}:${USER_NAME} \
    /home/${USER_NAME}/.cache \
    /home/${USER_NAME}/.local

# Copy opencode config -- this is when we set up extensions, etc.
COPY --chown=${USER_NAME}:${USER_NAME} opencode.json /home/${USER_NAME}/.config/opencode/opencode.json

# Second stage of installation (separate layer of more volatile stuff)
RUN apt-get install -y --no-install-recommends \
    vim jq less silversearcher-ag

# Cleanup from installation
RUN rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && rm -rf /var/cache/apt/*

# Switch to non-root user for security
USER ${USER_NAME}
# NOTE: This directory does not exist on the image! You must mount something
# here. (run_opencode.sh handles this.)
WORKDIR /home/${USER_NAME}/work

# Create simple startup script for runtime
RUN echo '#!/bin/bash\n\
set -e\n\
set -x\n\
echo "Starting Opencode..."\n\
export TMPDIR=~/.local/share/opencode\n\
# Use environment variable for API key\n\
exec opencode "$@"\n\
' > /home/${USER_NAME}/start-opencode.sh \
    && chmod +x /home/${USER_NAME}/start-opencode.sh

# Security: Set secure environment variables and limits
ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false \
    # Prevent core dumps
    RLIMIT_CORE=0 \
    # Limit file descriptors
    RLIMIT_NOFILE=1024 \
    # Prevent ptrace (debugging other processes)
    YAMA_PTRACE_SCOPE=1

# Security: Use dumb-init for proper signal handling and process reaping
ENTRYPOINT ["dumb-init", "--", "/home/opencode/start-opencode.sh"]
