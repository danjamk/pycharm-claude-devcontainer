#!/bin/bash
# .devcontainer/start.sh - Smart post-start script
# This runs every time the container starts

set -e

echo "🌟 Starting PyCharm + Claude Code development environment..."
echo "📅 Container started at: $(date)"
echo ""

# Ensure we're in the workspace
cd /workspace

# Configure Claude Code - simplified approach
echo "🤖 Claude Code is available - run 'claude' to start"
echo "   Choose 'Use Subscription' for simplest setup"
echo "   Or use API key if preferred"

# Ensure Claude config directory exists
mkdir -p /home/developer/.claude

# Basic Claude configuration (user will choose auth method)
if [ ! -f "/home/developer/.claude/claude.json" ]; then
    cat > /home/developer/.claude/claude.json << 'EOF'
{
  "shiftEnterKeyBindingInstalled": true,
  "theme": "dark",
  "hasCompletedOnboarding": false,
  "autoEdit": false,
  "diff": "auto"
}
EOF
    echo "✅ Claude Code basic configuration created"
fi

# Configure Claude Code for safe container operation
echo "🛡️  Configuring Claude Code security settings..."
claude config set --global autoEdit false 2>/dev/null || true
claude config set --global diff auto 2>/dev/null || true

# Set up the project for Claude Code if CLAUDE.md exists
if [ -f "CLAUDE.md" ]; then
    echo "📋 Project context (CLAUDE.md) available for Claude Code"
else
    echo "⚠️  CLAUDE.md not found - consider creating project context"
fi

# Check if requirements.txt needs updating
if [ -f "requirements.txt" ]; then
    echo "📦 Checking Python dependencies..."
    # Only install if requirements.txt is newer than last install
    if [ ! -f "/home/developer/.last_requirements_install" ] || \
       [ "requirements.txt" -nt "/home/developer/.last_requirements_install" ]; then
        echo "📦 Installing/updating Python dependencies..."
        pip install -r requirements.txt --quiet
        touch /home/developer/.last_requirements_install
        echo "✅ Dependencies updated"
    else
        echo "ℹ️  Dependencies are up to date"
    fi
fi

# Verify the development environment
echo "🔍 Environment verification:"
echo "  🐍 Python: $(python --version)"
echo "  📦 Pip: $(pip --version | cut -d' ' -f1-2)"
echo "  🤖 Claude Code: $(claude --version 2>/dev/null || echo 'Available (run claude to start)')"
echo "  📁 Working directory: $(pwd)"
echo "  👤 User: $(whoami)"
echo ""

# Show quick status
if [ -f "src/main.py" ]; then
    echo "✅ Project structure looks good"
else
    echo "ℹ️  Project structure will be created by setup.sh"
fi

if [ -f "tests/test_main.py" ]; then
    echo "✅ Test suite available"
fi

if [ -f ".git/config" ]; then
    echo "✅ Git repository initialized"
fi

echo ""
echo "🎯 Ready for development! Next steps:"
echo "  1. PyCharm should be connected to this container"
echo "  2. Open PyCharm's integrated terminal"
echo "  3. Run 'claude' to start Claude Code with AI assistance"
echo ""
echo "💻 Quick commands:"
echo "  claude                     # Start Claude Code"
echo "  python src/main.py         # Run main application"
echo "  python -m pytest tests/   # Run test suite"
echo "  ./scripts/dev-commands.sh check  # Full code quality check"
echo ""

# Create a status file for monitoring
cat > /home/developer/.container_status << EOF
{
  "started_at": "$(date -Iseconds)",
  "python_version": "$(python --version)",
  "claude_configured": $([ -f "/home/developer/.claude/api_configured" ] && echo "true" || echo "false"),
  "project_structure": $([ -f "src/main.py" ] && echo "true" || echo "false"),
  "git_initialized": $([ -f ".git/config" ] && echo "true" || echo "false")
}
EOF

echo "✨ Environment startup complete!"