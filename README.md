# Secure AI Python Development with PyCharm DevContainer Template

AI-assisted coding with tools like Claude Code can be enormously powerful - but with that power comes risks.
AI development tools don't always follow instructions exactly, sometimes due to poorly thought-out prompts, user error,
or even AI bugs and implementation issues.

The best practice for secure AI development is to run AI coding assistants like Claude Code in a containerized development environment.
This provides elevated isolation from your host system, ensuring that any mistakes or unexpected behavior during AI-assisted coding
has less of a chance to impact your local files or development environments. Along with other protections, you can feel more comfortable leveraging this power.

This **PyCharm DevContainer template** is specifically designed for secure Python development with JetBrains PyCharm Professional,
Docker dev containers, and Claude Code as your AI coding assistant. This approach can be adapted to other IDEs
(VS Code pioneered dev containers and has excellent support), other AI assistants, and alternative container solutions
(Podman, Colima, Orbstack, etc.), as well as other programming languages.

This project has a companion blog article you can find here: **[Containerized Development: My Security Layer for AI Coding Tools](https://medium.com/@dan.jam.kuhn/containerized-development-my-security-layer-for-ai-coding-tools-df48ac4af3e4)**


**Important**: Containerizing your Python development environment protects your host system, but doesn't protect your code,
data, or remote systems. This template implements additional security best practices:

- **✅ Read-only SSH keys for git repositories** - Project-specific deploy keys prevent accidental force pushes
  - See [.devcontainer/docs/GITHUB_SETUP.md](.devcontainer/docs/GITHUB_SETUP.md) for setup
- **✅ Project-specific AWS credentials** - Isolated IAM users with minimal permissions prevent production access
  - See [.devcontainer/docs/AWS_SETUP.md](.devcontainer/docs/AWS_SETUP.md) for setup
  - Automated setup script: `./scripts/setup-aws-iam-user.sh`
- **✅ No host credential mounts** - Your personal ~/.aws and ~/.ssh are never exposed to the container
  - See [.devcontainer/docs/MACOS_SECURITY.md](.devcontainer/docs/MACOS_SECURITY.md) for Docker file sharing

**All security features are optional** - the template works perfectly for vanilla Python development without AWS or GitHub SSH.
Each feature gracefully degrades when not configured, with helpful status messages and setup guides.

## 🎯 Secured Python AI Development Template

This secure development environment template combines PyCharm Professional with DevContainers and integrated Claude Code
for safe, reproducible AI-assisted Python development that works identically across all team members' machines.

## 🚀 What This Secure AI Development Environment Provides

- **🐍 Python 3.12** containerized development environment with complete dependency isolation
- **🧠 Claude Code AI assistant** integrated and ready for secure AI-assisted coding
- **🛡️ Complete host system protection** - no local Python/dependencies conflicts
- **🔄 Reproducible team development** - identical environment across all machines
- **📦 Persistent development storage** - configuration and cache preserved between sessions
- **⚡ Dual IDE support** - PyCharm Professional or VS Code (your choice!)
- **🔒 Secure AI coding practices** - isolated environment for safe AI development
- **🐚 Zsh with Oh My Zsh** - syntax highlighting, autosuggestions, and git-aware prompt
- **☁️ Optional AWS integration** - project-specific IAM users with automated setup
- **🔑 Optional GitHub SSH** - read-only deploy keys for secure git operations
- **📚 Comprehensive documentation** - detailed guides for all features and setup

## 📋 Prerequisites

### Required Software for AI Development Setup

**Choose Your IDE** (you only need one):
- **PyCharm Professional** (Community Edition lacks DevContainer support)
  - Paid (free for students/open source projects)
  - Best for Python specialists
- **Visual Studio Code** (free)
  - Free and open source
  - Best for polyglot developers
  - Requires "Dev Containers" extension

**Required for Both:**
- **Docker Desktop** (running and allocated 8GB+ RAM for containerized development)
- **Anthropic Account** (for Claude Code AI assistant - free tier available)

### System Requirements
- **macOS/Windows/Linux** with Docker support
- **8GB+ RAM** for Docker allocation
- **10GB+ free disk space** for container images

## 📦 Using This Template for Your Project

If you want to create a **new independent project** from this template (not contribute to the template itself), choose one of these options:

### Option 1: Clone and Re-initialize (Recommended)

This creates a completely independent project with no connection to the original template:

```bash
# 1. Clone the template to your new project name
git clone https://github.com/danjamk/pycharm-claude-devcontainer.git your-project-name
cd your-project-name

# 2. Remove the connection to the original repository
rm -rf .git

# 3. Initialize a fresh git repository
git init
git add .
git commit -m "Initial commit: Created from pycharm-claude-devcontainer template"

# 4. Create a new repository on GitHub (via web interface)
# Go to https://github.com/new and create your repository
# IMPORTANT: Do NOT initialize with README, .gitignore, or license (you already have these)

# 5. Connect to your new GitHub repository (replace YOUR-USERNAME and YOUR-REPO-NAME)
git remote add origin git@github.com:YOUR-USERNAME/YOUR-REPO-NAME.git
git branch -M main
git push -u origin main
```

### Option 2: GitHub "Use This Template" Button

If the repository has enabled the template feature:

1. Visit https://github.com/danjamk/pycharm-claude-devcontainer
2. Click the green **"Use this template"** button (top right)
3. Choose **"Create a new repository"**
4. Name it (e.g., `your-project-name`)
5. Clone your new repo: `git clone git@github.com:YOUR-USERNAME/your-project-name.git`

This creates a brand new repository with no git history and no connection to the original.

### Option 3: Download as ZIP

Simplest manual approach:

1. Visit https://github.com/danjamk/pycharm-claude-devcontainer
2. Click **Code → Download ZIP**
3. Extract to a folder with your project name
4. Initialize git:
   ```bash
   cd your-project-name
   git init
   git add .
   git commit -m "Initial commit: Created from pycharm-claude-devcontainer template"
   ```
5. Create repo on GitHub and connect as shown in Option 1, step 4-5

### After Creating Your New Project

Update these files with your project-specific information:

- **README.md** - Replace with your project description
- **CLAUDE.md** - Update with your project context for AI assistance
- **.env.example** - Add any project-specific environment variables
- **requirements.txt** - Update with your project dependencies

Now proceed with the Quick Start guide below to set up your development environment.

---

## 🤝 DevContainer is Optional for Contributors

**Important**: When you use this template for your project, contributors can choose whether to use the DevContainer or develop locally. The DevContainer provides consistency and convenience, but is **not required**.

### For Project Maintainers

When contributors join your project, they have two options:

#### Option A: Use the DevContainer (Recommended for Consistency)
- ✅ Automatic environment setup with all dependencies
- ✅ Guaranteed identical environment across all team members
- ✅ No "works on my machine" issues
- ✅ Requires Docker + PyCharm Professional or VS Code

#### Option B: Local Development (Standard Python)
Contributors can work normally without Docker:

```bash
# 1. Clone your repository
git clone git@github.com:your-username/your-project.git
cd your-project

# 2. Create a Python virtual environment
python3 -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows

# 3. Install dependencies from requirements.txt
pip install -r requirements.txt

# 4. Set PYTHONPATH for clean imports (optional but recommended)
export PYTHONPATH="${PYTHONPATH}:$(pwd)/src"  # Add to .bashrc/.zshrc

# 5. Develop normally
python src/main.py
python -m pytest tests/
```

### What Contributors Need Without DevContainer
- **Python 3.12+** (or compatible version specified in your project)
- **pip** for package management
- **Dependencies** from `requirements.txt`
- **Environment variables** from `.env.example` (if applicable)
- Their own preferred IDE/editor

### Recommended: Update Your Project README

When you customize this template for your project, add a section like this to your README:

```markdown
## Development Setup

### Option A: DevContainer (Recommended)
Provides automatic setup with all dependencies and tools configured.

**Requirements**: Docker Desktop + PyCharm Professional (or VS Code)

1. Open project in PyCharm
2. Click "Reopen in Container" when prompted
3. Wait for container to build (first time only)
4. Start developing!

### Option B: Local Development
Standard Python development without Docker.

**Requirements**: Python 3.12+

1. Clone the repository
2. Create virtual environment: `python3 -m venv venv`
3. Activate: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Set PYTHONPATH: `export PYTHONPATH="${PYTHONPATH}:$(pwd)/src"`
6. Run tests to verify: `python -m pytest tests/`

Both approaches work perfectly - choose what fits your workflow!
```

### The Bottom Line

The DevContainer is a **convenience tool** that ensures consistency, not a requirement. Your project's Python code works with or without it - contributors choose what works best for them.

---

## 🏃‍♂️ Quick Start Guide for Secure AI Development

**Choose your IDE:** This template works with both PyCharm Professional and VS Code. Follow the guide for your preferred IDE.

### Quick Start with PyCharm Professional

#### 1. Open Your Project in PyCharm
```bash
# If you just created the project, you're already in the directory
# Otherwise, navigate to it:
cd your-project-name
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

#### 6. Start Secure AI-Assisted Development!
- **Run Python code:** Right-click → Run
- **AI coding assistance:** Type `claude` in terminal for intelligent code suggestions
- **Automated testing:** `python -m pytest tests/`
- **Code formatting:** `black src/ tests/`

---

### Quick Start with Visual Studio Code

#### 1. Install Dev Containers Extension
1. Open VS Code
2. Click Extensions icon (sidebar) or press `Cmd+Shift+X` (macOS) / `Ctrl+Shift+X` (Windows/Linux)
3. Search for "Dev Containers" by Microsoft
4. Click **Install**

Or install from command line:
```bash
code --install-extension ms-vscode-remote.remote-containers
```

#### 2. Open Project in Container
```bash
# Navigate to your project
cd your-project-name

# Open in VS Code
code .
```

When VS Code opens:
1. A notification appears: "Folder contains a Dev Container configuration file"
2. Click **Reopen in Container**

Or use Command Palette: `Cmd+Shift+P` / `Ctrl+Shift+P` → **Dev Containers: Reopen in Container**

#### 3. First Build (5-10 minutes)
- VS Code builds the container automatically
- Progress shown in bottom-right corner
- Click "show log" to see detailed build progress
- Python extensions are automatically installed

#### 4. Configure Claude Code AI Assistant
Once the container is ready:
1. Open integrated terminal: Press `` Ctrl+` `` (backtick)
2. Terminal is automatically connected to container with Zsh
3. Run: `claude`
4. Choose **"Use Subscription"** (recommended)
5. Authenticate via browser with your Anthropic account

#### 5. Verify Python Setup
The Python interpreter is automatically configured:
- Check bottom-right status bar: should show `Python 3.12.x`
- If needed, click and select `/usr/local/bin/python3`

#### 6. Start Secure AI-Assisted Development!
- **Run Python:** Right-click file → Run Python → Run Python File in Terminal
- **Run tests:** Click testing flask icon (sidebar) or run `python -m pytest tests/`
- **Debug:** Set breakpoints and press `F5`
- **Claude Code:** Type `claude` in terminal for AI assistance
- **Format:** Right-click → Format Document (uses Black automatically)

**For detailed VS Code setup, see [.devcontainer/docs/VSCODE_SETUP.md](.devcontainer/docs/VSCODE_SETUP.md)**

---

## 🏗️ Project Structure

```
├── .devcontainer/              # DevContainer configuration
│   ├── devcontainer.json      # Container settings (PyCharm + VS Code)
│   ├── Dockerfile             # Python 3.12 + Zsh + AWS CLI
│   ├── setup.sh              # Post-creation setup
│   ├── start.sh              # Smart AWS/GitHub detection
│   ├── docs/                 # Comprehensive setup guides
│   │   ├── AWS_SETUP.md      # AWS credential management
│   │   ├── GITHUB_SETUP.md   # GitHub SSH configuration
│   │   ├── MACOS_SECURITY.md # Docker file sharing security
│   │   ├── PYCHARM_TERMINAL.md # Zsh terminal setup
│   │   └── VSCODE_SETUP.md   # VS Code complete setup guide
│   └── ssh/                  # Project-specific SSH keys (optional)
│       └── README.md         # SSH key instructions
├── scripts/                   # Utility scripts
│   ├── setup-aws-iam-user.sh # Automated AWS IAM user creation
│   ├── cleanup-aws-iam-user.sh # AWS IAM user cleanup
│   ├── aws-permissions-config.example.sh # Policy template
│   └── README.md             # Scripts documentation
├── src/                       # Python source code
│   ├── __init__.py
│   └── main.py               # Sample application
├── tests/                     # Test files
│   ├── __init__.py
│   └── test_main.py          # Sample tests
├── .env.example              # Environment variables template
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

### Common Commands (in container terminal with Zsh)
```bash
# Application
python src/main.py                    # Run main application

# Testing
python -m pytest tests/              # Run all tests
python -m pytest tests/ -v          # Verbose output
python-test                          # Alias for pytest (with zsh)

# Code Quality
black src/ tests/                    # Format code
flake8 src/ tests/                   # Lint code
mypy src/                           # Type checking
python-format                        # Alias for black (with zsh)
python-lint                          # Alias for flake8 (with zsh)

# AWS (if configured)
aws-whoami                          # Show AWS identity
aws-account                         # Show AWS account ID

# Claude Code
claude                              # Start AI assistant
claude --help                      # Get help

# Shell Features (Zsh + Oh My Zsh)
# - Syntax highlighting (commands turn green/red as you type)
# - Auto-suggestions (gray text from history - press → to accept)
# - Git-aware prompt (shows branch and status)
```

### Container Management
- **Rebuild:** Services → Docker → Container → Rebuild
- **Restart:** Services → Docker → Container → Restart
- **Logs:** Services → Docker → Container → View Logs

## 🔧 Configuration

### Persistent Storage
The container preserves between restarts:
- **Claude Code configuration** (`/home/developer/.claude`)
- **Zsh command history** (`/commandhistory/.zsh_history`)
- **Python package cache** (`/home/developer/.cache/pip`)

### Optional Features
Configure these features based on your project needs:
- **AWS Integration** - See [.devcontainer/docs/AWS_SETUP.md](.devcontainer/docs/AWS_SETUP.md)
  - Automated setup: `./scripts/setup-aws-iam-user.sh`
- **GitHub SSH Keys** - See [.devcontainer/docs/GITHUB_SETUP.md](.devcontainer/docs/GITHUB_SETUP.md)
- **PyCharm Terminal (Zsh)** - See [.devcontainer/docs/PYCHARM_TERMINAL.md](.devcontainer/docs/PYCHARM_TERMINAL.md)
- **VS Code Setup** - See [.devcontainer/docs/VSCODE_SETUP.md](.devcontainer/docs/VSCODE_SETUP.md)

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

## 🔐 Security Features

This template implements multiple layers of security for safe AI-assisted development:

### Container Isolation
- **No host system access** - AI assistant can't accidentally modify your local files
- **Separate user context** - Runs as non-root `developer` user
- **Volume isolation** - Only project directory is mounted

### Optional Credential Management
All credential features are optional and gracefully degrade when not configured:

#### AWS Credentials (Optional)
- **Project-specific IAM users** with minimal permissions
- **Automated setup** via `./scripts/setup-aws-iam-user.sh`
- **No host ~/.aws mount** - credentials generated from .env file
- **Policy templates** for common project types (data pipelines, web apps, ML)
- See [.devcontainer/docs/AWS_SETUP.md](.devcontainer/docs/AWS_SETUP.md)

#### GitHub SSH Keys (Optional)
- **Read-only deploy keys** prevent accidental force pushes
- **Project-specific keys** in .devcontainer/ssh/
- **No host ~/.ssh mount** - personal SSH keys remain isolated
- See [.devcontainer/docs/GITHUB_SETUP.md](.devcontainer/docs/GITHUB_SETUP.md)

#### Docker File Sharing
- **Restricted access** - only project directory shared
- **No ~/.aws or ~/.ssh exposure** to containers
- See [.devcontainer/docs/MACOS_SECURITY.md](.devcontainer/docs/MACOS_SECURITY.md)

### What's Protected
- ✅ Host system (container isolation)
- ✅ Personal AWS credentials (not mounted)
- ✅ Personal SSH keys (not mounted)
- ✅ Production environments (project-specific IAM users)
- ✅ Git history (read-only SSH keys)

## 📚 Additional Resources

### DevContainer & IDE Documentation
- **[DevContainers Specification](https://containers.dev/)** - Official DevContainer standard
- **[PyCharm DevContainer Guide](https://www.jetbrains.com/help/pycharm/connect-to-devcontainer.html)** - JetBrains official docs
- **[VS Code DevContainers](https://code.visualstudio.com/docs/devcontainers/containers)** - Microsoft official docs
- **[VS Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial)** - Python in VS Code

### Tools & Best Practices
- **[Claude Code Documentation](https://docs.anthropic.com/claude/docs)** - AI assistant docs
- **[Docker Best Practices](https://docs.docker.com/develop/best-practices/)** - Container optimization

## 📄 License

MIT License - feel free to use this template for any project.

**Happy coding with AI assistance! 🤖**