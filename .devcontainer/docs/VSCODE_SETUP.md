# VS Code DevContainer Setup Guide

This guide explains how to use this Python development template with Visual Studio Code instead of PyCharm Professional. VS Code pioneered the DevContainer specification and has excellent support for containerized development.

## Overview

While this template is optimized for PyCharm Professional, it works perfectly with VS Code. The same container, tools, and Claude Code integration work identically - only the IDE frontend changes.

## Prerequisites

### Required Software
- **Visual Studio Code** (free, available at https://code.visualstudio.com/)
- **Docker Desktop** (running and allocated 8GB+ RAM)
- **Dev Containers Extension** for VS Code
- **Anthropic Account** for Claude Code (free tier available)

### Installing the Dev Containers Extension

1. Open VS Code
2. Click Extensions icon (sidebar) or press `Cmd+Shift+X` (macOS) / `Ctrl+Shift+X` (Windows/Linux)
3. Search for "Dev Containers" by Microsoft
4. Click **Install**

Alternatively, install from the command line:
```bash
code --install-extension ms-vscode-remote.remote-containers
```

## Quick Start

### 1. Open Project in VS Code

```bash
# Navigate to your project directory
cd your-project-name

# Open in VS Code
code .
```

### 2. Reopen in Container

VS Code will detect the `.devcontainer/devcontainer.json` configuration:

1. A notification appears: "Folder contains a Dev Container configuration file"
2. Click **Reopen in Container**

Alternatively, use the command palette:
- Press `Cmd+Shift+P` (macOS) / `Ctrl+Shift+P` (Windows/Linux)
- Type and select: **Dev Containers: Reopen in Container**

### 3. First Build (5-10 minutes)

VS Code builds the container automatically:
- Progress shown in the bottom-right corner
- Container downloads Python 3.12, installs tools, and configures environment
- You can click "show log" to see detailed build progress

### 4. Configure Claude Code

Once the container is ready:

1. Open the integrated terminal: `Ctrl+` ` (backtick) or **Terminal → New Terminal**
2. The terminal is automatically connected to the container with Zsh
3. Run: `claude`
4. Choose **"Use Subscription"** (recommended for team development)
5. Authenticate via browser with your Anthropic account

### 5. Verify Python Setup

The Python interpreter is automatically configured via `devcontainer.json`:

1. Open `src/main.py`
2. Check bottom-right status bar - should show: `Python 3.12.x ('/usr/local/bin/python3')`
3. If not, click on it and select `/usr/local/bin/python3`

### 6. Start Developing!

Everything works normally:
- **Run Python files**: Right-click → Run Python → Run Python File in Terminal
- **Run tests**: Click the testing flask icon (sidebar), or run `python -m pytest tests/`
- **Debug**: Set breakpoints and press `F5`
- **Claude Code**: Type `claude` in terminal for AI assistance
- **Format code**: Right-click → Format Document (uses Black automatically)

## Pre-Installed Extensions

The DevContainer automatically installs these VS Code extensions:

### Python Development
- **Python** (`ms-python.python`) - Core Python support
- **Pylance** (`ms-python.vscode-pylance`) - Fast language server
- **Black Formatter** (`ms-python.black-formatter`) - Code formatting
- **Flake8** (`ms-python.flake8`) - Linting
- **Mypy Type Checker** (`ms-python.mypy-type-checker`) - Type checking
- **Ruff** (`charliermarsh.ruff`) - Fast Python linter (alternative)

### Development Tools
- **Even Better TOML** (`tamasfe.even-better-toml`) - TOML file support
- **YAML** (`redhat.vscode-yaml`) - YAML file support
- **GitLens** (`eamodio.gitlens`) - Enhanced git integration

### AI Assistance
- **GitHub Copilot Chat** (`github.copilot-chat`) - Optional AI pair programmer
  - Note: Requires separate GitHub Copilot subscription
  - Can be removed from `devcontainer.json` if not using

## Pre-Configured Settings

The DevContainer configures these VS Code settings automatically:

### Python Configuration
- **Python Interpreter**: `/usr/local/bin/python3` (Python 3.12)
- **Testing Framework**: pytest enabled
- **Linting**: Flake8 enabled
- **Formatting**: Black (runs on save)
- **Import Organization**: Automatic on save

### Editor Configuration
- **Format on Save**: Enabled for Python files
- **Default Formatter**: Black
- **Hidden Files**: `__pycache__`, `*.pyc`, `.pytest_cache`

### Terminal Configuration
- **Default Shell**: Zsh with Oh My Zsh
- **Features**: Syntax highlighting, auto-suggestions, git-aware prompt

## Common VS Code Tasks

### Running Python Files

**Method 1: Run Button**
- Open a Python file
- Click the ▶️ play button (top-right)

**Method 2: Right-click Menu**
- Right-click in the editor
- Select **Run Python → Run Python File in Terminal**

**Method 3: Keyboard Shortcut**
- Press `Ctrl+Alt+N` (if Code Runner extension is installed)

### Running Tests

**Method 1: Testing Sidebar**
1. Click the testing flask icon (sidebar)
2. Click **Configure Python Tests**
3. Select **pytest**
4. Select **tests** as the directory
5. Tests appear in the sidebar - click to run individual tests or test files

**Method 2: Terminal**
```bash
python -m pytest tests/              # Run all tests
python -m pytest tests/ -v          # Verbose output
python -m pytest tests/test_main.py # Run specific file
```

### Debugging

1. Set breakpoints by clicking left of line numbers
2. Press `F5` or **Run → Start Debugging**
3. Select **Python File** as the debug configuration
4. Use debug controls to step through code

### Formatting and Linting

**Automatic (on save)**
- Format and organize imports automatically when you save Python files

**Manual**
- **Format Document**: `Shift+Alt+F` (Windows/Linux) / `Shift+Option+F` (macOS)
- **Organize Imports**: `Shift+Alt+O` (Windows/Linux) / `Shift+Option+O` (macOS)
- **Run Linter**: Problems panel shows linting issues automatically

### Git Integration

VS Code has excellent built-in git support:
- **Source Control Sidebar**: Click the branch icon (sidebar)
- **Stage Changes**: Click `+` next to files
- **Commit**: Enter message and click ✓ checkmark
- **Push/Pull**: Click `...` → Push/Pull
- **GitLens**: Enhanced features like blame annotations, commit history

## Using Claude Code in VS Code

Claude Code runs in the integrated terminal:

### Starting Claude Code
```bash
# In the VS Code terminal
claude
```

### Claude Code Workflow
1. Type or paste your coding request
2. Claude analyzes your codebase
3. Claude proposes changes
4. Review changes in VS Code's diff viewer
5. Accept or reject changes

### Tips for Claude Code in VS Code
- **Split Terminal**: Drag terminal to side for side-by-side view with editor
- **Multiple Terminals**: Create separate terminals for Claude and manual commands
- **Terminal History**: Use arrow keys to recall previous Claude prompts
- **Zsh Features**: Auto-complete and syntax highlighting work with Claude commands

## Container Management

### Rebuild Container
When you modify `.devcontainer/` files:
1. `Cmd+Shift+P` / `Ctrl+Shift+P`
2. **Dev Containers: Rebuild Container**
3. Choose **Rebuild** (keeps volumes) or **Rebuild Without Cache** (clean build)

### Reopen Locally
To work outside the container:
1. `Cmd+Shift+P` / `Ctrl+Shift+P`
2. **Dev Containers: Reopen Folder Locally**

### View Container Logs
1. `Cmd+Shift+P` / `Ctrl+Shift+P`
2. **Dev Containers: Show Container Log**

### Attach to Running Container
To open a second VS Code window connected to the same container:
1. `Cmd+Shift+P` / `Ctrl+Shift+P`
2. **Dev Containers: Attach to Running Container**
3. Select your container from the list

## Customizing for Your Project

### Adding VS Code Extensions

Edit `.devcontainer/devcontainer.json`:
```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "your-publisher.your-extension"  // Add here
      ]
    }
  }
}
```

Then rebuild the container.

### Changing VS Code Settings

Edit `.devcontainer/devcontainer.json`:
```json
{
  "customizations": {
    "vscode": {
      "settings": {
        "python.defaultInterpreterPath": "/usr/local/bin/python3",
        "your.custom.setting": "value"  // Add here
      }
    }
  }
}
```

### Creating Launch Configurations

Create `.vscode/launch.json` in your project (this file is gitignored by default):
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal"
    },
    {
      "name": "Python: Main Module",
      "type": "python",
      "request": "launch",
      "module": "src.main",
      "console": "integratedTerminal"
    }
  ]
}
```

## Troubleshooting

### "Failed to connect" Error
- **Cause**: Docker not running or insufficient resources
- **Solution**:
  - Ensure Docker Desktop is running
  - Increase Docker memory to 8GB+ (Docker Desktop → Settings → Resources)
  - Restart Docker Desktop

### Python Interpreter Not Found
- **Cause**: VS Code didn't detect the Python interpreter
- **Solution**:
  1. Click on Python version in bottom-right status bar
  2. Select **Enter interpreter path**
  3. Enter: `/usr/local/bin/python3`
  4. Press Enter

### Extensions Not Installing
- **Cause**: Container was built but extensions failed to install
- **Solution**:
  1. `Cmd+Shift+P` / `Ctrl+Shift+P`
  2. **Dev Containers: Rebuild Container Without Cache**
  3. Wait for full rebuild

### Tests Not Discovered
- **Cause**: pytest configuration not detected
- **Solution**:
  1. Delete `.vscode/settings.json` if it exists in your project
  2. `Cmd+Shift+P` / `Ctrl+Shift+P`
  3. **Python: Configure Tests**
  4. Select **pytest**
  5. Select **tests** directory

### Terminal Shows Bash Instead of Zsh
- **Cause**: Terminal profile not set correctly
- **Solution**:
  1. Click the dropdown arrow next to `+` in terminal panel
  2. Select **zsh** from the list
  3. Or: `Cmd+Shift+P` / `Ctrl+Shift+P` → **Terminal: Select Default Profile** → **zsh**

### Claude Code Not Found
- **Cause**: Container build didn't install Claude Code
- **Solution**:
  1. Rebuild container: **Dev Containers: Rebuild Container**
  2. If still failing, check setup script: `cat .devcontainer/setup.sh`
  3. Manually install: run setup script in terminal: `bash .devcontainer/setup.sh`

### Slow Performance
- **Cause**: Insufficient Docker resources
- **Solution**:
  - Docker Desktop → Settings → Resources
  - Increase CPUs to 4+
  - Increase Memory to 8GB+
  - Increase Swap to 2GB+
  - Click **Apply & Restart**

## VS Code vs PyCharm

Both IDEs work great with this template. Here's a comparison:

| Feature | VS Code | PyCharm Professional |
|---------|---------|---------------------|
| **Cost** | Free | Paid (free for students/open source) |
| **DevContainer Support** | Pioneered standard | Full support since 2021 |
| **Python Debugging** | Excellent | Excellent |
| **AI Integration** | Claude Code + Copilot | Claude Code + AI Assistant |
| **Performance** | Lightweight | More resource-intensive |
| **Extensions** | Massive marketplace | JetBrains plugin ecosystem |
| **Learning Curve** | Gentle | Steeper |
| **Best For** | Polyglot developers | Python specialists |

**Both work perfectly with this template** - choose based on your preference and budget!

## Additional Resources

- **[VS Code DevContainers Docs](https://code.visualstudio.com/docs/devcontainers/containers)**
- **[VS Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial)**
- **[DevContainers Specification](https://containers.dev/)**
- **[Claude Code Documentation](https://docs.anthropic.com/claude/docs)**

## Getting Help

If you encounter issues:

1. **Check this guide** for troubleshooting steps
2. **View container logs**: `Cmd+Shift+P` → **Dev Containers: Show Container Log**
3. **Rebuild container**: `Cmd+Shift+P` → **Dev Containers: Rebuild Container**
4. **Check Docker**: Ensure Docker Desktop is running with adequate resources
5. **Report issues**: https://github.com/danjamk/pycharm-claude-devcontainer/issues

**Happy coding with VS Code! 🚀**