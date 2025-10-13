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
    zip \
    jq \
    less \
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
    # Zsh shell
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2 (optional to use, but available if needed)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    else \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/

# Install Node.js 20 (required for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Create developer user with zsh as default shell
RUN useradd -m -s /bin/zsh developer && \
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
RUN mkdir -p /workspace /home/developer/.claude /commandhistory /home/developer/.aws \
    && chown -R developer:developer /workspace /home/developer/.claude /commandhistory /home/developer/.aws

# Configure SSH for PyCharm remote development (if needed)
RUN mkdir -p /home/developer/.ssh && \
    chown -R developer:developer /home/developer/.ssh && \
    chmod 700 /home/developer/.ssh

# Switch to developer user to install Oh My Zsh
USER developer

# Install Oh My Zsh and plugins for developer user
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Create .zshenv (loaded for ALL shell types, including IDE non-interactive terminals)
RUN cat > /home/developer/.zshenv << 'ZSHENV_EOF'
# .zshenv - Loaded for ALL zsh shells (login, non-login, interactive, non-interactive)
# This ensures IDE terminals get the right environment

# Path configuration
export PATH="/usr/local/bin:$PATH"
export PYTHONPATH="/workspace/src"

# Claude Code configuration
export CLAUDE_CONFIG_DIR="/home/developer/.claude"

# AWS configuration (use .env-generated files in ~/.aws/ - optional)
export AWS_CONFIG_FILE="$HOME/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"

# Zsh history configuration
export HISTFILE=/commandhistory/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# PyCharm and other IDEs may start non-interactive shells
# Force load .zshrc ONLY if we're NOT interactive (interactive shells load it automatically)
if [[ ! -o interactive ]] && [[ -t 0 ]]; then
    if [ -f ~/.zshrc ]; then
        source ~/.zshrc
    fi
fi
ZSHENV_EOF

# Create .zprofile (loaded for login shells like PyCharm terminals)
RUN cat > /home/developer/.zprofile << 'ZPROFILE_EOF'
# .zprofile - Loaded for login shells (like PyCharm terminals)
# This file sources .zshrc to ensure interactive features are loaded

# Source .zshrc if it exists (to get Oh My Zsh, plugins, aliases, welcome message)
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi
ZPROFILE_EOF

# Update Oh My Zsh plugins in .zshrc
RUN sed -i 's/^plugins=(git)$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions)/' /home/developer/.zshrc

# Configure zsh for developer user
RUN echo '' >> /home/developer/.zshrc && \
    echo '# Path configuration' >> /home/developer/.zshrc && \
    echo 'export PATH="/usr/local/bin:$PATH"' >> /home/developer/.zshrc && \
    echo 'export PYTHONPATH="/workspace/src"' >> /home/developer/.zshrc && \
    echo '' >> /home/developer/.zshrc && \
    echo '# Claude Code configuration' >> /home/developer/.zshrc && \
    echo 'export CLAUDE_CONFIG_DIR="/home/developer/.claude"' >> /home/developer/.zshrc && \
    echo '' >> /home/developer/.zshrc && \
    echo '# Zsh history configuration' >> /home/developer/.zshrc && \
    echo 'export HISTFILE=/commandhistory/.zsh_history' >> /home/developer/.zshrc && \
    echo 'export HISTSIZE=10000' >> /home/developer/.zshrc && \
    echo 'export SAVEHIST=10000' >> /home/developer/.zshrc && \
    echo 'setopt SHARE_HISTORY' >> /home/developer/.zshrc && \
    echo 'setopt HIST_IGNORE_DUPS' >> /home/developer/.zshrc && \
    echo 'setopt HIST_IGNORE_ALL_DUPS' >> /home/developer/.zshrc && \
    echo 'setopt HIST_FIND_NO_DUPS' >> /home/developer/.zshrc && \
    echo '' >> /home/developer/.zshrc && \
    echo '# Useful aliases' >> /home/developer/.zshrc && \
    echo 'alias ll="ls -la"' >> /home/developer/.zshrc && \
    echo 'alias la="ls -la"' >> /home/developer/.zshrc && \
    echo 'alias ..="cd .."' >> /home/developer/.zshrc && \
    echo 'alias ...="cd ../.."' >> /home/developer/.zshrc && \
    echo 'alias grep="grep --color=auto"' >> /home/developer/.zshrc && \
    echo 'alias python-test="python -m pytest tests/ -v"' >> /home/developer/.zshrc && \
    echo 'alias python-format="black src/ tests/"' >> /home/developer/.zshrc && \
    echo 'alias python-lint="flake8 src/ tests/"' >> /home/developer/.zshrc && \
    echo 'alias claude-start="claude"' >> /home/developer/.zshrc && \
    echo '' >> /home/developer/.zshrc && \
    echo '# Disable AWS CLI pager (optional - no more pressing q to exit)' >> /home/developer/.zshrc && \
    echo 'export AWS_PAGER=""' >> /home/developer/.zshrc && \
    echo '' >> /home/developer/.zshrc && \
    echo '# AWS aliases (work with or without AWS configured)' >> /home/developer/.zshrc && \
    echo 'alias aws-whoami="if command -v aws &> /dev/null && aws sts get-caller-identity &> /dev/null 2>&1; then aws sts get-caller-identity; else echo \"⚠️  AWS not configured. See .devcontainer/docs/AWS_SETUP.md\"; fi"' >> /home/developer/.zshrc && \
    echo 'alias aws-account="if command -v aws &> /dev/null && aws sts get-caller-identity &> /dev/null 2>&1; then aws sts get-caller-identity --query Account --output text; else echo \"⚠️  AWS not configured\"; fi"' >> /home/developer/.zshrc

# Add welcome banner function to .zshrc
RUN cat >> /home/developer/.zshrc << 'WELCOME_EOF'

# ============================================================================
# Welcome Banner (shown on terminal open)
# ============================================================================
# Only show for interactive shells
if [[ $- == *i* ]]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║  PyCharm + Claude Code Development Container          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo "🐍 Python:      $(python --version 2>&1)"
    echo "🤖 Claude Code: $(claude --version 2>/dev/null || echo 'not configured yet')"
    echo "📁 Workspace:   /workspace"
    echo ""

    # Check AWS configuration
    echo "Optional Features:"
    if [ -f "/workspace/.env" ] && grep -q "AWS_ACCESS_KEY_ID" /workspace/.env 2>/dev/null; then
        if aws sts get-caller-identity &> /dev/null; then
            AWS_IDENTITY=$(aws sts get-caller-identity 2>/dev/null)
            AWS_ACCOUNT=$(echo "$AWS_IDENTITY" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
            AWS_USER=$(echo "$AWS_IDENTITY" | grep -o '"Arn": "[^"]*"' | awk -F'/' '{print $NF}' | tr -d '"')
            echo "  AWS:         ✅ Configured (Account: $AWS_ACCOUNT, User: $AWS_USER)"
        else
            echo "  AWS:         ⚠️  Credentials in .env but auth failed"
        fi
    else
        echo "  AWS:         ⚠️  Not configured (see .devcontainer/docs/AWS_SETUP.md)"
    fi

    # Check GitHub SSH configuration
    if [ -f "/home/developer/.ssh/id_ed25519_github_readonly" ]; then
        echo "  GitHub SSH:  ✅ Configured (read-only access)"
    else
        echo "  GitHub SSH:  ⚠️  Not configured (see .devcontainer/docs/GITHUB_SETUP.md)"
    fi

    echo ""
    echo "📚 Quick Start:"
    echo "   • python src/main.py    - Run application"
    echo "   • pytest tests/         - Run tests"
    echo "   • claude                - Start Claude Code"
    if aws sts get-caller-identity &> /dev/null 2>&1; then
        echo "   • aws-whoami           - Check AWS identity"
    fi
    echo ""
fi
WELCOME_EOF

# Set working directory
WORKDIR /workspace

# Create health check script
RUN cat > /home/developer/health-check.sh << 'HEALTHCHECK_EOF'
#!/bin/zsh
echo "=== System Health Check ==="
echo "Python: $(python --version)"
echo "AWS CLI: $(aws --version 2>&1 | head -n1)"
echo "Claude Code: $(claude --version 2>/dev/null || echo 'NOT CONFIGURED')"
echo "Node.js: $(node --version)"
echo "Shell: $SHELL"
HEALTHCHECK_EOF

RUN chmod +x /home/developer/health-check.sh

# Default command - keep container running for development
CMD ["sleep", "infinity"]