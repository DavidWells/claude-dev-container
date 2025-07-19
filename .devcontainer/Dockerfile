FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Set shell with pipefail for better error handling
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install essential tools and Playwright dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  git \
  curl \
  wget \
  python3 \
  make \
  g++ \
  sudo \
  unzip \
  fzf \
  vim \
  # PAM authentication dependencies
  libpam0g-dev \
  libpam-modules \
  # X11 and display dependencies for headful browser testing
  xvfb \
  x11-utils \
  # Playwright dependencies
  libnss3 \
  libnspr4 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libdbus-1-3 \
  libxkbcommon0 \
  libatspi2.0-0 \
  libx11-6 \
  libxcomposite1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libxcb1 \
  libxss1 \
  libgtk-3-0 \
  libpango-1.0-0 \
  libcairo2 \
  libasound2 \
  # Clean up
  && rm -rf /var/lib/apt/lists/* \
  # Create fzf configuration files if they don't exist
  && mkdir -p /usr/share/doc/fzf/examples \
  && echo "# fzf key bindings" > /usr/share/doc/fzf/examples/key-bindings.zsh \
  && echo "# fzf completion" > /usr/share/doc/fzf/examples/completion.zsh

# Install Deno (required for claude-flow)
# Using a more robust installation method with proper error handling
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && export DENO_INSTALL="/usr/local" \
  && curl -fsSL https://deno.land/install.sh | sh -s v1.46.3 \
  || (echo "Deno installation failed, trying alternative method..." \
    && wget -qO- https://github.com/denoland/deno/releases/latest/download/deno-x86_64-unknown-linux-gnu.zip -O /tmp/deno.zip \
    && unzip -q /tmp/deno.zip -d /usr/local/bin/ \
    && rm /tmp/deno.zip) \
  && chmod +x /usr/local/bin/deno

# Install Node.js v24
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

# Install Bun.js (latest version)
RUN curl -fsSL https://bun.sh/install | bash \
  && mv ~/.bun/bin/bun /usr/local/bin/bun \
  && chmod +x /usr/local/bin/bun

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get update && apt-get install -y --no-install-recommends gh \
  && rm -rf /var/lib/apt/lists/*

# Create node user and configure for development
# Check if group/user already exist and handle accordingly
RUN (getent group node || groupadd node) \
  && (id -u node &>/dev/null || useradd -g node -s /bin/bash -m node) \
  && echo 'node:nodepassword' | chpasswd \
  && echo node ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/node \
  && chmod 0440 /etc/sudoers.d/node

ARG USERNAME=node

# Persist shell history for zsh
RUN mkdir -p /commandhistory \
  && touch /commandhistory/.zsh_history \
  && chown -R $USERNAME:$USERNAME /commandhistory \
  && chmod 755 /commandhistory \
  && chmod 644 /commandhistory/.zsh_history

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Install global npm packages
RUN npm install -g pnpm @anthropic-ai/claude-code@latest @google/gemini-cli vibetunnel@1.0.0-beta.13
# VScode in web browser
# RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy git-profile script and make it executable
COPY scripts/git-profile /usr/local/bin/git-profile
RUN chmod +x /usr/local/bin/git-profile

# Create directories for Playwright
RUN mkdir -p /home/node/.cache/ms-playwright \
  && chown -R node:node /home/node/.cache

# Switch to node user
USER node

# Set npm cache directory
ENV NPM_CONFIG_CACHE=/home/node/.npm

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Default robbyrussell theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
  -t robbyrussell \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export HISTFILE=/commandhistory/.zsh_history" \
  -a "export HISTSIZE=10000" \
  -a "export SAVEHIST=10000" \
  -a "setopt SHARE_HISTORY" \
  -a "setopt APPEND_HISTORY" \
  -a "alias yolo='claude --dangerously-skip-permissions'" \
  -a "alias gyolo='gemini --yolo'" \
  -a "alias tailscale='docker exec devcontainer-tailscale tailscale'" \
  -x

ENV GITHUB_OWNER=bailejl
ENV GITHUB_REPO=Product-Outcomes

# # Set up aliases and environment info in profile
# RUN alias swarm-status="/github status" \
#   && alias swarm-tasks="/github tasks" \
#   && alias swarm-claim="/github claim" \
#   && alias swarm-update="/github update" \
#   && echo "echo GITHUB_OWNER: \$(echo \$GITHUB_OWNER)" >> ~/.profile \
#   && echo "echo GITHUB_REPO: \$(echo \$GITHUB_REPO)" >> ~/.profile \
#   && echo "echo CLAUDE_SWARM_ID: \$(echo \$CLAUDE_SWARM_ID)" >> ~/.profile

# Pre-install Playwright browsers as the node user
# RUN npx playwright install chromium firefox webkit
RUN npx playwright install chromium

# Create Chrome symlink for MCP server compatibility (needed for ARM64)
# Switch back to root to create system directories
USER root
RUN mkdir -p /opt/google/chrome
USER node
RUN sudo ln -sf /home/node/.cache/ms-playwright/chromium-*/chrome-linux/chrome /opt/google/chrome/chrome

# Set working directory
WORKDIR /workspace