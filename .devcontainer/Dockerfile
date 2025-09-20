# Use official Python 3.12 as base - matches your current setup
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV DEVCONTAINER=true
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic development tools
    git \
    curl \
    wget \
    nano \
    vim \
    htop \
    tree \
    unzip \
    # Build tools for Python packages
    build-essential \
    pkg-config \
    # Network and security tools
    openssh-client \
    ca-certificates \
    gnupg \
    # Search and file tools (useful for Claude Code)
    ripgrep \
    fd-find \
    fzf \
    # Docker CLI (for docker-in-docker if needed)
    docker.io \
    # SSH server for PyCharm remote development
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (required for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Create developer user (matches your security preferences)
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    usermod -aG docker developer 2>/dev/null || true

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Install common Python development tools
RUN pip install --no-cache-dir \
    # Testing
    pytest>=7.0.0 \
    pytest-cov \
    # Code formatting and linting
    black>=22.0.0 \
    flake8>=4.0.0 \
    mypy>=1.0.0 \
    # Development tools
    ipython \
    ipdb \
    # Useful libraries
    requests \
    python-dotenv

# Create necessary directories
RUN mkdir -p /workspace /home/developer/.claude /commandhistory \
    && chown -R developer:developer /workspace /home/developer/.claude /commandhistory

# Set up bash history and aliases for developer user
RUN echo 'export HISTFILE=/commandhistory/.bash_history' >> /home/developer/.bashrc && \
    echo 'export HISTSIZE=10000' >> /home/developer/.bashrc && \
    echo 'export HISTFILESIZE=10000' >> /home/developer/.bashrc && \
    echo 'export PROMPT_COMMAND="history -a; history -c; history -r"' >> /home/developer/.bashrc && \
    echo 'shopt -s histappend' >> /home/developer/.bashrc && \
    echo '' >> /home/developer/.bashrc && \
    echo '# Useful aliases' >> /home/developer/.bashrc && \
    echo 'alias ll="ls -la"' >> /home/developer/.bashrc && \
    echo 'alias la="ls -la"' >> /home/developer/.bashrc && \
    echo 'alias ..="cd .."' >> /home/developer/.bashrc && \
    echo 'alias ...="cd ../.."' >> /home/developer/.bashrc && \
    echo 'alias grep="grep --color=auto"' >> /home/developer/.bashrc && \
    echo 'alias python-test="python -m pytest tests/ -v"' >> /home/developer/.bashrc && \
    echo 'alias python-format="black src/ tests/"' >> /home/developer/.bashrc && \
    echo 'alias python-lint="flake8 src/ tests/"' >> /home/developer/.bashrc && \
    echo 'alias claude-start="claude"' >> /home/developer/.bashrc && \
    echo '' >> /home/developer/.bashrc && \
    echo '# Welcome message' >> /home/developer/.bashrc && \
    echo 'echo "🐍 Python $(python --version | cut -d" " -f2) DevContainer with Claude Code"' >> /home/developer/.bashrc && \
    echo 'echo "📁 Workspace: /workspace"' >> /home/developer/.bashrc && \
    echo 'echo "🤖 Start Claude Code: claude"' >> /home/developer/.bashrc && \
    echo 'echo ""' >> /home/developer/.bashrc

# Configure SSH for PyCharm remote development (if needed)
RUN mkdir -p /home/developer/.ssh && \
    chown -R developer:developer /home/developer/.ssh && \
    chmod 700 /home/developer/.ssh

# Switch to developer user
USER developer

# Set working directory
WORKDIR /workspace

# Create a simple health check script
RUN echo '#!/bin/bash\npython --version && claude --version 2>/dev/null || echo "Claude Code not configured yet"' > /home/developer/health-check.sh && \
    chmod +x /home/developer/health-check.sh

# Default command - keep container running for development
CMD ["sleep", "infinity"]