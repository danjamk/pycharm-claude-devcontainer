# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a PyCharm Docker sandbox project designed for containerized Python development. The setup provides an isolated Python 3.12 development environment with PyCharm IDE integration.

## Architecture

**Container Setup:**
- **Service**: `python-dev` - main development container
- **Base Image**: python:3.12-slim
- **Working Directory**: `/workspace` (maps to project root)
- **User**: `developer` (non-root for security)
- **Environment**: `PYTHONPATH=/workspace/src`

**Project Structure:**
- `src/` - Application source code
- `tests/` - Test files using unittest framework
- `requirements.txt` - Python dependencies (pytest, black, flake8)
- `Dockerfile` - Container configuration
- `docker-compose.yml` - Service orchestration

## Development Commands

### Container Management
```bash
# Start development environment
docker compose up -d python-dev

# Access container shell (can run multiple times for multiple sessions)
docker compose exec python-dev bash

# Stop environment
docker compose down

# Rebuild after Dockerfile/requirements changes
docker compose build --no-cache
docker compose up -d python-dev
```

### Code Execution (Inside Container)
```bash
# Run main application
python src/main.py

# Run tests
python -m pytest tests/ -v
python -m pytest tests/test_main.py  # specific test file

# Code formatting and linting
black src/ tests/
flake8 src/ tests/
```

### Package Management
```bash
# Temporary install (lost on container restart)
pip install package-name

# Permanent install:
# 1. Add to requirements.txt
# 2. Rebuild container: docker compose build
```

## Development Workflow

1. **Container-First Development**: Code changes sync automatically between host and container via volume mounts
2. **PyCharm Integration**: IDE configured with Docker Compose interpreter pointing to `python-dev` service
3. **Git Operations**: Always performed on host machine, not inside container
4. **Port Management**: Ports 5000 and 8000 exposed (may need adjustment for macOS conflicts)

## Testing

- **Framework**: Python unittest (built-in)
- **Test Discovery**: Tests located in `tests/` directory
- **Path Setup**: Tests manually configure sys.path to import from `src/`
- **Execution**: Run via pytest for better output formatting

## Important Notes

- Container runs with `sleep infinity` command to stay alive for development
- Volume mounts preserve pip cache and enable live code editing
- PyCharm interpreter should be configured as Docker Compose type
- All git operations should be performed on host, not in container
- PYTHONPATH is pre-configured to include src/ directory