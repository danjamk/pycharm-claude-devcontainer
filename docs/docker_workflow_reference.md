# Docker Development Workflow - Quick Reference

## Daily Workflow

### 🌅 Morning Startup
```bash
# Navigate to project
cd ~/yukon/pycharm-docker-sandbox

# Start long-running container
docker compose up -d python-dev
```

### 💻 Development Sessions
```bash
# Open new terminal in container (run multiple times for multiple terminals)
docker compose exec python-dev bash

# Inside container - you're now at /workspace
python src/main.py              # Run your code
python -m pytest tests/ -v     # Run tests
pip install package-name       # Install packages temporarily
pip list                       # See installed packages
python --version               # Check Python version
whoami                         # Verify you're 'developer' user
```

### 📝 Git Operations (Host Terminal)
```bash
# Always run git commands on host (Mac), not in container
git status
git add .
git commit -m "Your commit message"
git push origin main
git pull origin main
```

### 🌙 End of Day
```bash
# Stop and remove container
docker compose down
```

---

## Quick Commands

### Container Management
```bash
# Check container status
docker compose ps

# View container logs
docker compose logs python-dev

# Restart container
docker compose restart python-dev

# Stop container
docker compose stop python-dev

# Start stopped container
docker compose start python-dev
```

### Package Management
```bash
# Temporary install (lost when container restarts)
docker compose exec python-dev pip install package-name

# Permanent install:
# 1. Add to requirements.txt
echo "requests>=2.28.0" >> requirements.txt

# 2. Rebuild container
docker compose down
docker compose up -d python-dev
```

### Development Commands (Inside Container)
```bash
# Run your application
python src/main.py

# Run tests
python -m pytest tests/
python -m pytest tests/ -v          # Verbose output
python -m pytest tests/test_main.py # Run specific test file

# Check code style
black src/ tests/                   # Format code
flake8 src/ tests/                  # Check style issues

# Interactive Python
python                              # Start Python REPL
python -c "import sys; print(sys.version)"  # Quick Python commands
```

### File Operations
```bash
# Inside container at /workspace
ls -la                             # List files
cat src/main.py                    # View file contents  
touch newfile.py                   # Create new file
mkdir new_directory               # Create directory

# Remember: All changes sync to host automatically!
```

---

## Troubleshooting

### Container Won't Start
```bash
# Check for port conflicts
lsof -i :5000
lsof -i :8000

# Check container logs for errors
docker compose logs python-dev

# Remove any conflicting containers
docker compose down --remove-orphans
docker system prune

# Rebuild from scratch
docker compose build --no-cache
docker compose up -d python-dev
```

### Container Starts Then Exits
```bash
# Check container status (look for "Exited")
docker compose ps -a

# View container logs to see what happened
docker compose logs python-dev

# Make sure docker-compose.yml has "command: sleep infinity"
# Then restart:
docker compose down
docker compose up -d python-dev
```

### PyCharm Can't Connect
```bash
# Ensure container is running
docker compose ps

# Restart PyCharm interpreter setup
# Preferences → Project → Python Interpreter → Reconfigure
```

### Package Installation Issues
```bash
# Update pip in container
docker compose exec python-dev pip install --upgrade pip

# Clear pip cache
docker compose exec python-dev pip cache purge

# Rebuild container with clean cache
docker compose build --no-cache
```

### File Permission Issues
```bash
# Check file ownership (should be your user on host)
ls -la

# If needed, fix permissions on host
sudo chown -R $(whoami):$(id -gn) .
```

---

## Project Structure
```
pycharm-docker-sandbox/
├── Dockerfile                 # Container configuration
├── docker-compose.yml        # Service configuration  
├── requirements.txt          # Python dependencies
├── src/
│   └── main.py              # Your application code
├── tests/
│   └── test_main.py         # Your test code
└── WORKFLOW.md              # This file!
```

---

## Environment Info

### Inside Container
- **User:** developer (non-root)
- **Python:** 3.12.x
- **Working Directory:** /workspace
- **Package Manager:** pip
- **Editor Available:** nano

### Host Machine
- **Git Operations:** Use host terminal
- **File Editing:** PyCharm IDE
- **Container Management:** docker compose commands

---

## Pro Tips

**Multiple Terminals:**
- Each `docker compose exec python-dev bash` creates a new terminal session
- All sessions share the same container and filesystem
- Use different terminals for different tasks (dev, testing, monitoring)

**Fast Container Access:**
```bash
# Create an alias for quick access
echo 'alias dockersh="docker compose exec python-dev bash"' >> ~/.zshrc
source ~/.zshrc

# Now just run:
dockersh
```

**Check Container Health:**
```bash
# See running processes in container
docker compose exec python-dev ps aux

# Check container resource usage
docker stats pycharm-python-sandbox
```

**Development Best Practices:**
- Keep containers running during active development
- Use `docker compose down` only when switching projects or end of day
- Always test code in container before committing
- Add permanent dependencies to requirements.txt
- Use host terminal for all git operations

---

## Emergency Commands

**Nuclear Option (Reset Everything):**
```bash
# Stop all containers and remove everything
docker compose down --volumes --remove-orphans

# Remove all unused Docker resources
docker system prune -a

# Rebuild from scratch
docker compose build --no-cache
docker compose up -d python-dev
```

**Quick Restart:**
```bash
# Fast container restart
docker compose restart python-dev
```

**Check What's Running:**
```bash
# All Docker containers
docker ps -a

# Just this project
docker compose ps
```