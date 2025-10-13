#!/bin/bash
# .devcontainer/start.sh - Smart post-start script
# This runs every time the container starts
# Detects and configures optional features (AWS, GitHub SSH)

set -e

# Track what's configured for welcome banner
AWS_CONFIGURED=false
AWS_STATUS_MSG=""
GITHUB_SSH_CONFIGURED=false
GITHUB_SSH_STATUS_MSG=""

echo ""
echo "🔄 Container started at $(date)"
echo ""

# Ensure we're in the workspace
cd /workspace

# ============================================================================
# AWS Credentials Configuration (OPTIONAL)
# ============================================================================
echo "🔐 Checking for AWS credentials..."

if [ -f "/workspace/.env" ]; then
    # Source .env to get variables
    set -a
    source /workspace/.env 2>/dev/null || true
    set +a

    # Check if AWS credentials are present
    if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "   ✅ AWS credentials found in .env"

        # Create ~/.aws directory
        mkdir -p "$HOME/.aws"
        chmod 700 "$HOME/.aws"

        # Create credentials file
        cat > "$HOME/.aws/credentials" << EOF
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF
        chmod 600 "$HOME/.aws/credentials"

        # Create config file
        cat > "$HOME/.aws/config" << EOF
[default]
region = ${AWS_REGION:-us-east-1}
output = json
EOF
        chmod 600 "$HOME/.aws/config"

        # Verify AWS authentication
        if aws sts get-caller-identity > /dev/null 2>&1; then
            AWS_CONFIGURED=true

            # Get AWS identity details
            AWS_IDENTITY=$(aws sts get-caller-identity 2>/dev/null)
            AWS_ACCOUNT=$(echo "$AWS_IDENTITY" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
            AWS_ARN=$(echo "$AWS_IDENTITY" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)
            AWS_REGION=$(aws configure get region 2>/dev/null || echo "${AWS_REGION:-us-east-1}")

            # Extract username from ARN
            if [[ $AWS_ARN == *":user/"* ]]; then
                AWS_USER=$(echo "$AWS_ARN" | cut -d'/' -f2)
            elif [[ $AWS_ARN == *":assumed-role/"* ]]; then
                AWS_USER=$(echo "$AWS_ARN" | cut -d'/' -f2)
            elif [[ $AWS_ARN == *":role/"* ]]; then
                AWS_USER=$(echo "$AWS_ARN" | cut -d'/' -f2)
            else
                AWS_USER="Unknown"
            fi

            AWS_STATUS_MSG="✅ Configured (Account: $AWS_ACCOUNT | Region: $AWS_REGION | User: $AWS_USER)"
            echo "   ✅ AWS authentication successful"
        else
            AWS_STATUS_MSG="⚠️  Credentials in .env but authentication failed"
            echo "   ⚠️  AWS credentials found but authentication failed"
        fi
    else
        AWS_STATUS_MSG="⚠️  Not configured (add AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to .env)"
        echo "   ℹ️  No AWS credentials in .env (optional)"
    fi
else
    AWS_STATUS_MSG="⚠️  Not configured (create .env file - see .devcontainer/docs/AWS_SETUP.md)"
    echo "   ℹ️  No .env file found (optional)"
fi

echo ""

# ============================================================================
# GitHub SSH Configuration (OPTIONAL)
# ============================================================================
echo "🔑 Checking for GitHub SSH key..."

if [ -f "/workspace/.devcontainer/ssh/id_ed25519_github_readonly" ]; then
    echo "   ✅ GitHub SSH key found"

    # Create ~/.ssh directory
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    # Copy project SSH key to ~/.ssh
    cp /workspace/.devcontainer/ssh/id_ed25519_github_readonly "$HOME/.ssh/"
    cp /workspace/.devcontainer/ssh/id_ed25519_github_readonly.pub "$HOME/.ssh/" 2>/dev/null || true
    chmod 600 "$HOME/.ssh/id_ed25519_github_readonly"
    chmod 644 "$HOME/.ssh/id_ed25519_github_readonly.pub" 2>/dev/null || true

    # Create SSH config to use this key for GitHub
    cat > "$HOME/.ssh/config" << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github_readonly
    IdentitiesOnly yes
    StrictHostKeyChecking accept-new
EOF
    chmod 600 "$HOME/.ssh/config"

    GITHUB_SSH_CONFIGURED=true
    GITHUB_SSH_STATUS_MSG="✅ Configured (read-only access)"
    echo "   ✅ GitHub SSH configured for read-only access"
else
    GITHUB_SSH_STATUS_MSG="⚠️  Not configured (see .devcontainer/docs/GITHUB_SETUP.md for setup)"
    echo "   ℹ️  No GitHub SSH key found (optional - can use HTTPS)"
fi

echo ""

# ============================================================================
# Sync Python Dependencies (if requirements.txt changed)
# ============================================================================
if [ -f "requirements.txt" ]; then
    echo "📦 Checking Python dependencies..."

    # Only install if requirements.txt is newer than last install
    if [ ! -f "/home/developer/.last_requirements_install" ] || \
       [ "requirements.txt" -nt "/home/developer/.last_requirements_install" ]; then
        echo "   📦 Installing/updating Python dependencies..."
        pip install -r requirements.txt --quiet
        touch /home/developer/.last_requirements_install
        echo "   ✅ Dependencies updated"
    else
        echo "   ℹ️  Dependencies are up to date"
    fi
    echo ""
fi

# ============================================================================
# Display Welcome Banner
# ============================================================================
cat << 'BANNER'
╔════════════════════════════════════════════════════════╗
║  PyCharm + Claude Code Development Container          ║
╚════════════════════════════════════════════════════════╝
BANNER

echo ""
echo "🐍 Python:      $(python --version 2>&1)"
echo "🤖 Claude Code: $(claude --version 2>/dev/null || echo 'not configured yet')"
echo "📁 Workspace:   /workspace"
echo ""

# Show optional features status
echo "Optional Features:"
echo "  AWS:         $AWS_STATUS_MSG"
echo "  GitHub SSH:  $GITHUB_SSH_STATUS_MSG"
echo ""

# Context-aware quick start based on what's configured
echo "📚 Quick Start:"
echo "   • python src/main.py    - Run application"
echo "   • pytest tests/         - Run tests"
echo "   • claude                - Start Claude Code"

if [ "$AWS_CONFIGURED" = true ]; then
    echo "   • aws-whoami           - Check AWS identity"
fi

if [ "$GITHUB_SSH_CONFIGURED" = true ]; then
    echo "   • git pull             - Pull latest changes (SSH)"
fi

echo ""

# Show links to setup guides if features not configured
if [ "$AWS_CONFIGURED" = false ] || [ "$GITHUB_SSH_CONFIGURED" = false ]; then
    echo "📖 Setup Guides (optional features):"
    if [ "$AWS_CONFIGURED" = false ]; then
        echo "   • AWS: .devcontainer/docs/AWS_SETUP.md"
    fi
    if [ "$GITHUB_SSH_CONFIGURED" = false ]; then
        echo "   • GitHub: .devcontainer/docs/GITHUB_SETUP.md"
    fi
    echo ""
fi

echo "✨ Ready to code!"
echo ""