# PyCharm + Claude Code DevContainer Template
Vibe coding with tools like Claude Code can be enormously powerful - but with that power comes risks.
AI tools do not always follow instructions exactly.  Sometimes due to poorly thought out prompts or user error.  But it 
can also be due to AI bugs or poor implementation considerations. 

A good practice to balance the power with safety is to run AI tools like Claude Code in a containerized environment.  
This provides isolation from your host system, ensuring that any mistakes or unexpected behavior do not impact your local files or environment.
Along with other protections, you can feel more conformable leveraging this power.

This project is based specifically on the use if Jetbrains Pycharm (so focused on Python example) with Docker for dev containers and Claude Code 
as the vibe coding AI assistant.  This approach can be adapted to other IDEs (VS Code pioneered dev containers and has great support for this).
Other AI assistance can be used with other container solutions (Podman, Colima, Orbstack, etc.) as well.  And of course
other programming languages can be used.

Containerizing your development environment is not enough thought.  This can help protect your host system, but it does not protect your code, data or remote systems.
You should still follow best practices for security, including:
- Setup read-only ssh keys for your git repositories and ensure you control commits outside the container
- For cloud infrastructure, only allow access to development accounts where total destruction is acceptable.
this applies to data and other services too.  Only allow write permissions tio assets that can be destroyed and recreated easily.

With these basic guardrails in place, you can leverage the power of AI tools like Claude Code with much more confidence.

This project is a production-ready template for Python development using PyCharm Professional with DevContainers and integrated Claude Code AI assistance.

## 🚀 What This Provides

- **🐍 Python 3.12** containerized development environment
- **🧠 Claude Code AI** assistant integrated and ready to use
- **🛡️ Complete isolation** - no local Python/dependencies conflicts
- **🔄 Reproducible setup** - works identically across all machines
- **📦 Persistent storage** - configuration and cache preserved between sessions
- **⚡ PyCharm Professional** full IDE integration with container backend

## 📋 Prerequisites

### Required Software
- **PyCharm Professional** (Community Edition lacks DevContainer support)
- **Docker Desktop** (running and allocated 8GB+ RAM)
- **Anthropic Account** (for Claude Code - free tier available)

### System Requirements
- **macOS/Windows/Linux** with Docker support
- **8GB+ RAM** for Docker allocation
- **10GB+ free disk space** for container images

## 🏃‍♂️ Quick Start

### 1. Clone and Open
```bash
git clone https://github.com/your-username/pycharm-claude-devcontainer.git
cd pycharm-claude-devcontainer
```

### 2. Open in PyCharm
1. **Launch PyCharm Professional**
2. **File → Open** → Select the project directory
3. **PyCharm will detect** `.devcontainer/devcontainer.json`
4. **Click "Reopen in Container"** when prompted

### 3. First Build (5-10 minutes)
- PyCharm builds the container automatically
- Monitor progress in **Services** tool window
- Container downloads Python 3.12, installs tools, and configures environment

### 4. Setup Claude Code
1. **Open terminal** in PyCharm (connected to container)
2. **Run:** `claude`
3. **Choose "Use Subscription"** (recommended)
4. **Authenticate** via browser with your Anthropic account

### 5. Configure Python Interpreter
1. **Right-click** `src/main.py` → **Run**
2. **Configure interpreter** when prompted:
   - **Add Interpreter → System Interpreter**
   - **Path:** `/usr/local/bin/python3`
   - **Click OK**

### 6. Start Developing!
- **Run code:** Right-click → Run
- **AI assistance:** Type `claude` in terminal
- **Testing:** `python -m pytest tests/`
- **Formatting:** `black src/ tests/`

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