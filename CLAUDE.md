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
