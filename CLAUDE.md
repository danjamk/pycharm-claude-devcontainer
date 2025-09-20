# PyCharm + Claude Code DevContainer Template

## Project Overview
This is a **reference template** for Python development using PyCharm Professional with DevContainers and Claude Code integration. This template provides a complete, reproducible development environment that can be shared across teams and used as a starting point for Python projects.

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
│   └── main.py           # Sample application (replace with your code)
├── tests/                 # Test files
│   ├── __init__.py
│   └── test_main.py      # Sample tests (expand for your project)
├── requirements.txt       # Python dependencies (customize for your project)
├── CLAUDE.md             # This file (AI context for your project)
└── README.md             # Project documentation (update for your use case)
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

## Template Usage

### Getting Started with This Template
1. **Fork or clone** this repository
2. **Customize** the sample application in `src/main.py`
3. **Update** `requirements.txt` with your project dependencies
4. **Modify** `tests/test_main.py` with your test cases
5. **Edit** this `CLAUDE.md` file with your project context

### Template Features
- **Sample Python Application**: Basic structure in `src/main.py`
- **Unit Tests**: Example test suite in `tests/`
- **Code Quality Tools**: Pre-configured black, flake8, mypy
- **Development Scripts**: Utility commands in `scripts/dev-commands.sh`

### Advanced Features (Coming Soon)
- **GitHub Integration**: Read-only repository access for cloning dependencies
- **AWS Credentials**: Secure development account access
- **Additional Tools**: Database connections, API integrations

## Notes for Claude Code

### When Working with This Template:
- **File Paths**: Use paths relative to `/workspace` (e.g., `src/main.py`, not `./src/main.py`)
- **Python Imports**: The `src/` directory is in PYTHONPATH for clean imports
- **Testing**: Always run tests after making changes: `python -m pytest tests/`
- **Code Style**: Format code with `black` and check with `flake8`
- **Git Operations**: Git is available and configured in the container

### Development Best Practices:
- **Replace sample code** with your actual application logic
- **Expand test coverage** beyond the basic examples
- **Update requirements.txt** as you add dependencies
- **Follow Python conventions** - use type hints, docstrings, and proper naming
- **Security awareness** - remember we're in a containerized environment

### Available Tools:
- **Python 3.12** with full standard library
- **pytest** for testing and coverage
- **black** for code formatting
- **flake8** for linting
- **mypy** for type checking
- **ipython** for interactive development
- **git** for version control
- **Standard Unix tools** (grep, find, curl, etc.)

### Project Customization:
- **Update** project name and description in README.md
- **Modify** CLAUDE.md to reflect your specific project context
- **Customize** DevContainer configuration for additional tools
- **Configure** CI/CD integration for your repository

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
