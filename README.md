# Secure AI Python Development with PyCharm DevContainer Template

AI-assisted coding with tools like Claude Code can be enormously powerful - but with that power comes risks.
AI development tools don't always follow instructions exactly, sometimes due to poorly thought out prompts, user error,
or even AI bugs and implementation issues.

A best practice for secure AI development is to run AI coding assistants like Claude Code in a containerized development environment.
This provides complete isolation from your host system, ensuring that any mistakes or unexpected behavior during AI-assisted coding
do not impact your local files or environment. Along with other protections, you can feel more comfortable leveraging this power.

This **production-ready PyCharm DevContainer template** is specifically designed for secure Python development with JetBrains PyCharm Professional,
Docker dev containers, and Claude Code as your AI coding assistant. This approach can be adapted to other IDEs
(VS Code pioneered dev containers and has excellent support), other AI assistants, and alternative container solutions
(Podman, Colima, Orbstack, etc.), as well as other programming languages.

**Important**: Containerizing your Python development environment protects your host system, but doesn't protect your code,
data, or remote systems. Follow these additional security best practices:
- Setup read-only SSH keys for git repositories and control commits outside the container
- For cloud infrastructure, only allow access to development accounts where total destruction is acceptable
- Only grant write permissions to assets that can be destroyed and recreated easily

With these guardrails in place, you can leverage AI-assisted Python development with much more confidence.

## 🎯 Production-Ready Python AI Development Template

This secure development environment template combines PyCharm Professional with DevContainers and integrated Claude Code
for safe, reproducible AI-assisted Python development that works identically across all team members' machines.

## 🚀 What This Secure AI Development Environment Provides

- **🐍 Python 3.12** containerized development environment with complete dependency isolation
- **🧠 Claude Code AI assistant** integrated and ready for secure AI-assisted coding
- **🛡️ Complete host system protection** - no local Python/dependencies conflicts
- **🔄 Reproducible team development** - identical environment across all machines
- **📦 Persistent development storage** - configuration and cache preserved between sessions
- **⚡ JetBrains PyCharm Professional** full IDE integration with secure container backend
- **🔒 Secure AI coding practices** - isolated environment for safe AI development

## 📋 Prerequisites

### Required Software for AI Development Setup
- **PyCharm Professional** (Community Edition lacks DevContainer support for this template)
- **Docker Desktop** (running and allocated 8GB+ RAM for containerized development)
- **Anthropic Account** (for Claude Code AI assistant - free tier available)

### System Requirements
- **macOS/Windows/Linux** with Docker support
- **8GB+ RAM** for Docker allocation
- **10GB+ free disk space** for container images

## 🏃‍♂️ Quick Start Guide for Secure AI Development

### 1. Clone This Python DevContainer Template
```bash
git clone https://github.com/your-username/pycharm-claude-devcontainer.git
cd pycharm-claude-devcontainer
```

### 2. Launch PyCharm Professional with DevContainer Support
1. **Launch PyCharm Professional**
2. **File → Open** → Select the project directory
3. **PyCharm will automatically detect** the `.devcontainer/devcontainer.json` configuration
4. **Click "Reopen in Container"** when prompted for secure containerized development

### 3. First Build (5-10 minutes)
- PyCharm builds the container automatically
- Monitor progress in **Services** tool window
- Container downloads Python 3.12, installs tools, and configures environment

### 4. Configure Claude Code AI Assistant
1. **Open PyCharm terminal** (automatically connected to secure container)
2. **Run:** `claude`
3. **Choose "Use Subscription"** (recommended for team development)
4. **Authenticate** via browser with your Anthropic account for AI-assisted coding

### 5. Configure Python Development Environment
1. **Right-click** `src/main.py` → **Run**
2. **Configure Python interpreter** when prompted:
   - **Add Interpreter → System Interpreter**
   - **Path:** `/usr/local/bin/python3`
   - **Click OK**

### 6. Start Secure AI-Assisted Development!
- **Run Python code:** Right-click → Run
- **AI coding assistance:** Type `claude` in terminal for intelligent code suggestions
- **Automated testing:** `python -m pytest tests/`
- **Code formatting:** `black src/ tests/`

## 🏗️ Project Structure

```
├── .devcontainer/              # DevContainer configuration
│   ├── devcontainer.json      # Container settings
│   ├── Dockerfile             # Python 3.12 + tools image
│   ├── setup.sh              # Post-creation setup
│   └── start.sh              # Container startup script
├── src/                       # Python source code
│   ├── __init__.py
│   └── main.py               # Sample application
├── tests/                     # Test files
│   ├── __init__.py
│   └── test_main.py          # Sample tests
├── requirements.txt           # Python dependencies
├── CLAUDE.md                 # AI assistant context
└── README.md                 # This file
```

## 🛠️ Development Workflow

### Daily Usage
1. **Open PyCharm** → Project auto-connects to container
2. **Develop normally** with full PyCharm features
3. **Use Claude Code** for AI assistance: `claude`
4. **Run/debug/test** as usual - all happens in container

### Common Commands (in container terminal)
```bash
# Application
python src/main.py                    # Run main application

# Testing
python -m pytest tests/              # Run all tests
python -m pytest tests/ -v          # Verbose output

# Code Quality
black src/ tests/                    # Format code
flake8 src/ tests/                   # Lint code
mypy src/                           # Type checking

# Claude Code
claude                              # Start AI assistant
claude --help                      # Get help
```

### Container Management
- **Rebuild:** Services → Docker → Container → Rebuild
- **Restart:** Services → Docker → Container → Restart
- **Logs:** Services → Docker → Container → View Logs

## 🔧 Configuration

### Persistent Storage
The container preserves between restarts:
- **Claude Code configuration** (`/home/developer/.claude`)
- **Bash command history** (`/commandhistory/.bash_history`)
- **Python package cache** (`/home/developer/.cache/pip`)

### Port Forwarding
- **8000:** Development server
- **5000:** Flask/API server
- **3000:** Frontend server
- **8080:** Alternative web server

### Environment Variables
- `PYTHONPATH=/workspace/src` - Clean imports from src/
- `DEVCONTAINER=true` - Container environment indicator

## 🚀 Advanced Usage

### Installing Additional Python Packages
```bash
# Temporary (lost on rebuild)
pip install package-name

# Permanent (add to requirements.txt)
echo "package-name>=1.0.0" >> requirements.txt
# Then rebuild container
```

### Adding Development Tools
Edit `.devcontainer/Dockerfile` to add tools:
```dockerfile
RUN apt-get update && apt-get install -y \
    your-new-tool \
    && rm -rf /var/lib/apt/lists/*
```

### Custom Setup Scripts
- **setup.sh:** Runs once when container is first created
- **start.sh:** Runs every time container starts
- Customize these for project-specific setup

## 🐛 Troubleshooting

### Container Won't Build
- **Check Docker:** Ensure Docker Desktop is running
- **Memory:** Increase Docker memory to 8GB+
- **Clean build:** Services → Container → Rebuild with --no-cache

### PyCharm Won't Connect
- **Restart PyCharm** completely
- **Check Services panel:** View → Tool Windows → Services
- **Recreate container:** Remove and rebuild

### Claude Code Issues
- **Reset config:** `rm -rf /home/developer/.claude/*`
- **Restart Claude:** Run `claude` and reconfigure
- **Check authentication:** Ensure Anthropic account is valid

### Python Interpreter Not Found
- **Path:** Use `/usr/local/bin/python3`
- **Recreate:** Add Interpreter → System Interpreter
- **Verify:** Run `which python3` in container terminal

## 📚 Additional Resources

- **[DevContainers Documentation](https://containers.dev/)**
- **[PyCharm DevContainer Guide](https://www.jetbrains.com/help/pycharm/connect-to-devcontainer.html)**
- **[Claude Code Documentation](https://docs.anthropic.com/claude/docs)**
- **[Docker Best Practices](https://docs.docker.com/develop/best-practices/)**

## 📄 License

MIT License - feel free to use this template for any project.

**Happy coding with AI assistance! 🤖**