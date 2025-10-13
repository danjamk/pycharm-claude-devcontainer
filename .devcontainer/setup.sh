#!/bin/bash
# .devcontainer/setup.sh - Comprehensive post-create setup script
# This runs once when the devcontainer is first created

set -e

echo "🚀 Setting up PyCharm + Claude Code development environment..."
echo "📍 Current directory: $(pwd)"
echo "👤 Current user: $(whoami)"
echo "🐍 Python version: $(python --version)"
echo ""

# Ensure we're in the workspace directory
cd /workspace

# Create project structure if it doesn't exist
echo "📁 Creating project structure..."
mkdir -p src tests docs .devcontainer scripts

# Initialize git if not already a git repository
if [ ! -d ".git" ]; then
    echo "🎯 Initializing git repository..."
    git init
    git config --global init.defaultBranch main

    # Set up git user if not already configured
    if [ -z "$(git config --global user.name)" ]; then
        git config --global user.name "Developer"
        git config --global user.email "developer@example.com"
        echo "⚠️  Note: Update git config with your actual name and email"
    fi
fi

# Create or update requirements.txt
echo "📦 Setting up requirements.txt..."
if [ ! -f "requirements.txt" ]; then
    cat > requirements.txt << 'EOF'
# Core development dependencies
pytest>=7.0.0
pytest-cov>=4.0.0
black>=22.0.0
flake8>=4.0.0
mypy>=1.0.0

# Development tools
ipython>=8.0.0
ipdb>=0.13.0
python-dotenv>=1.0.0

# Common useful libraries
requests>=2.28.0
# numpy>=1.21.0
# pandas>=1.5.0
# fastapi>=0.100.0

# Add your specific project dependencies below
EOF
    echo "✅ Created requirements.txt"
else
    echo "ℹ️  requirements.txt already exists"
fi

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install --no-cache-dir -r requirements.txt

# Create .env.example if it doesn't exist
echo "🔐 Setting up .env.example..."
if [ ! -f ".env.example" ]; then
    cat > .env.example << 'EOF'
# .env.example - Environment Variables Template
# Copy this file to .env and fill in your values
# IMPORTANT: Never commit .env to git (it contains secrets)

# ============================================================================
# AWS Credentials (OPTIONAL)
# ============================================================================
# Only needed if your project uses AWS services
# See .devcontainer/docs/AWS_SETUP.md for setup instructions
#
# AWS_ACCESS_KEY_ID=your-access-key-id-here
# AWS_SECRET_ACCESS_KEY=your-secret-access-key-here
# AWS_ACCOUNT_ID=123456789012
# AWS_REGION=us-east-1

# ============================================================================
# Application-Specific Environment Variables
# ============================================================================
# Add your project's environment variables below
EOF
    echo "✅ Created .env.example"
else
    echo "ℹ️  .env.example already exists"
fi

# Create comprehensive .gitignore
echo "🙈 Setting up .gitignore..."
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
pip-wheel-metadata/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# PyCharm
.idea/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
.python-version

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Claude Code (don't commit Claude config)
.claude/

# Local development
*.log
.env.local
.env.development.local
.env.test.local
.env.production.local

# Docker
.dockerignore

# Temporary files
*.tmp
*.temp
EOF
    echo "✅ Created .gitignore"
else
    echo "ℹ️  .gitignore already exists"
fi

# Create sample Python files if they don't exist
if [ ! -f "src/main.py" ]; then
    echo "🐍 Creating sample Python application..."
    cat > src/main.py << 'EOF'
"""
Main application module for the PyCharm + Claude Code project.
"""
import os
import sys
from pathlib import Path


def greet(name: str = "World") -> str:
    """
    Generate a greeting message.

    Args:
        name: The name to greet (default: "World")

    Returns:
        A greeting string
    """
    return f"Hello, {name}!"


def get_environment_info() -> dict:
    """
    Get information about the current environment.

    Returns:
        Dictionary with environment information
    """
    return {
        "python_version": sys.version,
        "working_directory": str(Path.cwd()),
        "in_container": os.path.exists("/.dockerenv"),
        "devcontainer": os.getenv("DEVCONTAINER", "false") == "true",
        "user": os.getenv("USER", "unknown"),
        "home": os.getenv("HOME", "unknown")
    }


def main() -> None:
    """Main function demonstrating the application."""
    print("🎉 " + greet("PyCharm + Claude Code"))
    print("=" * 50)

    env_info = get_environment_info()

    print("📊 Environment Information:")
    for key, value in env_info.items():
        print(f"  {key}: {value}")

    print("\n🚀 Development environment is ready!")
    print("💡 Try running: python -m pytest tests/")


if __name__ == "__main__":
    main()
EOF
    echo "✅ Created src/main.py"
fi

# Create comprehensive test file
if [ ! -f "tests/test_main.py" ]; then
    echo "🧪 Creating test suite..."
    cat > tests/test_main.py << 'EOF'
"""
Test suite for the main application module.
"""
import sys
import os
import unittest
from pathlib import Path

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

try:
    from main import greet, get_environment_info
except ImportError as e:
    print(f"Import error: {e}")
    print("Make sure src/main.py exists and is properly formatted")
    sys.exit(1)


class TestGreeting(unittest.TestCase):
    """Test cases for the greeting functionality."""

    def test_greet_default(self):
        """Test greeting with default parameter."""
        result = greet()
        self.assertEqual(result, "Hello, World!")

    def test_greet_custom_name(self):
        """Test greeting with custom name."""
        result = greet("Claude")
        self.assertEqual(result, "Hello, Claude!")

    def test_greet_empty_string(self):
        """Test greeting with empty string."""
        result = greet("")
        self.assertEqual(result, "Hello, !")


class TestEnvironmentInfo(unittest.TestCase):
    """Test cases for environment information."""

    def test_get_environment_info_returns_dict(self):
        """Test that environment info returns a dictionary."""
        result = get_environment_info()
        self.assertIsInstance(result, dict)

    def test_environment_info_has_required_keys(self):
        """Test that environment info contains required keys."""
        result = get_environment_info()
        required_keys = [
            "python_version",
            "working_directory",
            "in_container",
            "devcontainer",
            "user",
            "home"
        ]
        for key in required_keys:
            self.assertIn(key, result)

    def test_devcontainer_flag(self):
        """Test that devcontainer flag is detected correctly."""
        result = get_environment_info()
        # In our devcontainer, this should be True
        self.assertTrue(result["devcontainer"])


if __name__ == "__main__":
    unittest.main(verbosity=2)
EOF
    echo "✅ Created tests/test_main.py"
fi

# Create an empty __init__.py to make tests a package
touch tests/__init__.py
touch src/__init__.py

# Create CLAUDE.md for project context
echo "📋 Creating CLAUDE.md for project context..."
cat > CLAUDE.md << 'EOF'
# PyCharm + Claude Code Development Environment

## Project Overview
This is a Python development project running in a PyCharm DevContainer with Claude Code integration. The environment provides complete isolation, reproducibility, and AI-powered development assistance.

## Development Environment Details

### Container Configuration
- **Base Image**: Python 3.12-slim
- **Container User**: developer (non-root for security)
- **IDE Backend**: PyCharm (running in container)
- **AI Assistant**: Claude Code (running in container)
- **Package Management**: pip with requirements.txt

### Directory Structure
```
/workspace/                 # Main project directory (mounted from host)
├── .devcontainer/         # DevContainer configuration files
│   ├── devcontainer.json  # Container settings
│   ├── Dockerfile         # Container image definition
│   ├── setup.sh          # Post-create setup script
│   └── start.sh          # Post-start script
├── src/                   # Python source code
│   ├── __init__.py
│   └── main.py           # Main application
├── tests/                 # Test files
│   ├── __init__.py
│   └── test_main.py      # Test suite
├── docs/                  # Documentation
├── requirements.txt       # Python dependencies
├── CLAUDE.md             # This file (AI context)
└── README.md             # Project documentation
```

### Persistent Storage
- **Claude Config**: `/home/developer/.claude` (persisted via Docker volume)
- **Bash History**: `/commandhistory/.bash_history` (persisted via Docker volume)
- **Pip Cache**: `/home/developer/.cache/pip` (persisted via Docker volume)

## Development Workflow

### Daily Startup
1. Open PyCharm
2. Open project (PyCharm detects devcontainer.json)
3. Choose "Reopen in Container" when prompted
4. Wait for container to build/start (first time takes longer)
5. PyCharm connects to container backend automatically

### Claude Code Usage
1. Open PyCharm's integrated terminal (connected to container)
2. Run `claude` to start Claude Code
3. Claude Code has full context of container environment
4. Use natural language to request code changes, debugging, etc.

### Common Commands (in container terminal)
```bash
# Application
python src/main.py              # Run main application
python -c "from src.main import greet; print(greet('Claude'))"

# Testing
python -m pytest tests/         # Run all tests
python -m pytest tests/ -v     # Run tests with verbose output
python -m pytest tests/test_main.py::TestGreeting  # Run specific test class

# Code Quality
black src/ tests/               # Format code
flake8 src/ tests/              # Check code style
mypy src/                       # Type checking

# Development
pip install package-name        # Install temporary package
pip install -r requirements.txt # Install all dependencies
pip freeze > requirements.txt   # Update requirements (be careful!)

# Claude Code
claude                          # Start Claude Code
claude --help                   # See Claude Code options
```

## Environment Variables
- `PYTHONPATH=/workspace/src` - Python module search path
- `CLAUDE_CONFIG_DIR=/home/developer/.claude` - Claude configuration
- `DEVCONTAINER=true` - Indicates we're in a development container
- `ANTHROPIC_API_KEY` - Your Claude API key (set on host, passed to container)

## Security Features
- **Container Isolation**: Claude Code cannot access host filesystem outside project
- **Non-root User**: All operations run as 'developer' user for security
- **API Key Isolation**: API keys are managed separately from project code
- **Network Isolation**: Container has limited network access

## PyCharm Integration
- **Backend in Container**: PyCharm server runs inside container for full context
- **Frontend on Host**: PyCharm UI runs on host, connects to container backend
- **Seamless Experience**: Debugging, running, testing all work normally
- **Plugin Support**: PyCharm plugins can be installed in container environment

## Notes for Claude Code

### When Working with This Project:
- **File Paths**: Use paths relative to `/workspace` (e.g., `src/main.py`, not `./src/main.py`)
- **Python Imports**: The `src/` directory is in PYTHONPATH for clean imports
- **Testing**: Always run tests after making changes: `python -m pytest tests/`
- **Code Style**: Format code with `black` and check with `flake8`
- **Git Operations**: Git is available and configured in the container

### Best Practices:
- **Make small, testable changes** - each change should have corresponding tests
- **Follow Python conventions** - use type hints, docstrings, and proper naming
- **Test-driven development** - write tests for new functionality
- **Security awareness** - remember we're in a containerized environment

### Available Tools:
- **Python 3.12** with full standard library
- **pytest** for testing
- **black** for code formatting
- **flake8** for linting
- **mypy** for type checking
- **ipython** for interactive development
- **git** for version control
- **All standard Unix tools** (grep, find, etc.)

## Troubleshooting

### Container Issues
- **Container won't start**: Check Docker is running, rebuild with PyCharm
- **Permission errors**: Ensure files are owned by developer user
- **Claude Code not found**: Run setup script or restart container

### PyCharm Issues
- **Can't connect**: Restart PyCharm and try reconnecting to container
- **Slow performance**: Increase Docker memory allocation
- **Missing features**: Check that all required plugins are installed

### Claude Code Issues
- **API errors**: Check ANTHROPIC_API_KEY environment variable
- **Context issues**: Ensure you're running Claude from `/workspace` directory
- **Permission errors**: Claude Code runs as 'developer' user (non-root)

## Getting Help
- **Claude Code Help**: Run `claude --help` in container terminal
- **PyCharm Help**: Use PyCharm's built-in help system
- **Container Logs**: Check PyCharm's Services panel for container logs
- **Health Check**: Run `/home/developer/health-check.sh` in container
EOF

echo "✅ Created CLAUDE.md"

# Create README.md if it doesn't exist
if [ ! -f "README.md" ]; then
    echo "📖 Creating README.md..."
    cat > README.md << 'EOF'
# PyCharm + Claude Code Development Environment

A modern Python development setup using PyCharm DevContainers with integrated Claude Code AI assistance.

## Quick Start

1. **Prerequisites**
   - PyCharm Professional (with DevContainer support)
   - Docker Desktop
   - ANTHROPIC_API_KEY environment variable set on host

2. **Setup**
   ```bash
   git clone <your-repo>
   cd <your-project>
   # Open in PyCharm, choose "Reopen in Container" when prompted
   ```

3. **Start Developing**
   - PyCharm connects to container automatically
   - Open terminal in PyCharm and run `claude` to start AI assistance
   - Code with full Python toolchain and AI support

## Features

- 🐍 Python 3.12 with modern development tools
- 🤖 Claude Code AI assistant running in container
- 🛡️ Complete environment isolation and security
- 🔄 Consistent development environment across team
- 📦 Persistent configuration and package cache
- 🧪 Pre-configured testing with pytest
- 🎨 Code formatting with black and linting with flake8

## Project Structure

```
├── .devcontainer/     # Container configuration
├── src/              # Python source code
├── tests/            # Test files
├── requirements.txt  # Dependencies
└── CLAUDE.md        # AI assistant context
```

## Development Commands

```bash
# Run application
python src/main.py

# Run tests
python -m pytest tests/

# Format and lint
black src/ tests/
flake8 src/ tests/

# Start Claude Code
claude
```

## Documentation

See [CLAUDE.md](CLAUDE.md) for detailed environment information and usage instructions.
EOF
    echo "✅ Created README.md"
fi

# Run tests to make sure everything works
echo "🧪 Running initial tests..."
if python -m pytest tests/ -v; then
    echo "✅ All tests passed!"
else
    echo "⚠️  Some tests failed - check the code"
fi

# Create a simple script for common tasks
echo "🛠️  Creating utility scripts..."
mkdir -p scripts

cat > scripts/dev-commands.sh << 'EOF'
#!/bin/bash
# Common development commands

case "$1" in
    "test")
        echo "🧪 Running tests..."
        python -m pytest tests/ -v
        ;;
    "format")
        echo "🎨 Formatting code..."
        black src/ tests/
        ;;
    "lint")
        echo "🔍 Linting code..."
        flake8 src/ tests/
        ;;
    "check")
        echo "✅ Running full code check..."
        black src/ tests/
        flake8 src/ tests/
        python -m pytest tests/ -v
        ;;
    "requirements")
        echo "📦 Installing requirements..."
        pip install -r requirements.txt
        ;;
    *)
        echo "Usage: $0 {test|format|lint|check|requirements}"
        echo ""
        echo "Available commands:"
        echo "  test         - Run test suite"
        echo "  format       - Format code with black"
        echo "  lint         - Check code style with flake8"
        echo "  check        - Run format, lint, and tests"
        echo "  requirements - Install Python dependencies"
        ;;
esac
EOF

chmod +x scripts/dev-commands.sh

echo ""
echo "🎉 Setup complete! Your PyCharm + Claude Code environment is ready."
echo ""
echo "📋 Summary of what was created:"
echo "  ✅ Project structure (src/, tests/, docs/)"
echo "  ✅ Python dependencies (requirements.txt)"
echo "  ✅ Git configuration"
echo "  ✅ Sample application (src/main.py)"
echo "  ✅ Test suite (tests/test_main.py)"
echo "  ✅ Code quality tools configuration"
echo "  ✅ Documentation (README.md, CLAUDE.md)"
echo "  ✅ Development utilities (scripts/dev-commands.sh)"
echo ""
echo "🚀 Next steps:"
echo "  1. PyCharm should connect to this container automatically"
echo "  2. Open PyCharm's integrated terminal (with zsh)"
echo "  3. Run 'claude' to start Claude Code"
echo "  4. Start developing with AI assistance!"
echo ""
echo "💡 Useful commands:"
echo "  - claude                    # Start Claude Code"
echo "  - python src/main.py        # Run the application"
echo "  - python -m pytest tests/  # Run tests"
echo "  - ./scripts/dev-commands.sh check  # Run full code check"
echo ""
echo "📖 Optional Features (see .devcontainer/docs/):"
echo "  - AWS Integration: See docs/AWS_SETUP.md"
echo "  - GitHub SSH: See docs/GITHUB_SETUP.md"
echo "  - PyCharm Terminal: See docs/PYCHARM_TERMINAL.md (for zsh config)"
echo "  - macOS Security: See docs/MACOS_SECURITY.md"