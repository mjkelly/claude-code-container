# syntax=docker/dockerfile:1.4
FROM debian:trixie-slim

# ARG (not ENV): only needed during apt-get install, should not persist in the final image
ARG DEBIAN_FRONTEND=noninteractive

ARG USER_ID=1000
ARG USER_NAME=opencode

# Install system and development dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    dumb-init \
    git \
    golang \
    jq \
    less \
    npm \
    python3 \
    python3-absl \
    python3-click \
    python3-dotenv \
    python3-pip \
    python3-requests \
    python3-virtualenv \
    black \
    mypy \
    silversearcher-ag \
    vim \
    wget \
    && find / -xdev -perm -4000 -type f -exec chmod u-s {} \; 2>/dev/null || true \
    && find / -xdev -perm -2000 -type f -exec chmod g-s {} \; 2>/dev/null || true \
    && rm -f /usr/bin/nc /usr/bin/netcat /bin/netstat /usr/bin/ss || true

# Create non-root user and home directory structure
RUN groupadd -g ${USER_ID} ${USER_NAME} \
    && useradd -m -u ${USER_ID} -g ${USER_NAME} -s /bin/bash ${USER_NAME} \
    && mkdir -p \
        /home/${USER_NAME}/data \
        /home/${USER_NAME}/.cache \
        /home/${USER_NAME}/.local \
        /home/${USER_NAME}/mcp-servers \
    && chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME} \
    && chmod 750 /home/${USER_NAME} \
        /home/${USER_NAME}/data \
        /home/${USER_NAME}/.cache \
        /home/${USER_NAME}/.local \
        /home/${USER_NAME}/mcp-servers

# Install global npm packages (cached)
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
    npm install -g opencode-ai

# Copy startup script and configuration
COPY --chown=${USER_NAME}:${USER_NAME} image-files/start-opencode.sh /home/${USER_NAME}/start-opencode.sh
COPY --chown=${USER_NAME}:${USER_NAME} image-files/opencode.json /home/${USER_NAME}/.config/opencode/opencode.json
COPY --chown=${USER_NAME}:${USER_NAME} image-files/AGENTS.md /home/${USER_NAME}/.config/opencode/AGENTS.md

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/work

ENV NODE_ENV=production \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false

ENTRYPOINT ["dumb-init", "--", "/home/opencode/start-opencode.sh"]
