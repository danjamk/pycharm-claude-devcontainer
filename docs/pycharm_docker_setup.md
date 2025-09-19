# PyCharm Docker Sandbox Setup - Python Hello World

## Choose Your Workflow

### Workflow A: IDE-First (Recommended for beginners)
1. Open PyCharm first
2. Create files through the IDE
3. Configure Docker interpreter
4. Develop normally

### Workflow B: Docker-First (From original guide)
1. Create all Docker files first
2. Test Docker setup
3. Open PyCharm
4. Configure interpreter

### Workflow C: PyCharm Template (Advanced)
1. Use PyCharm's built-in Docker project templates
2. Customize as needed

---

## Workflow A: IDE-First Approach (Start Here!)

### Step 1: Open PyCharm and Create Project
1. **Open PyCharm**
2. **File** → **New Project**
3. **Location**: Navigate to your cloned `pycharm-docker-sandbox` directory
4. **Python Interpreter**: Choose any local interpreter for now (we'll change this later)
5. **Create**

### Step 2: Create Basic Python Files Through PyCharm
1. **Right-click project root** → **New** → **Directory** → Name: `src`
2. **Right-click project root** → **New** → **Directory** → Name: `tests`
3. **Right-click src** → **New** → **Python File** → Name: `main`
4. **Right-click tests** → **New** → **Python File** → Name: `test_main`

**Add content to `src/main.py` through PyCharm:**
```python
def greet(name="World"):
    return f"Hello, {name}!"

def main():
    print(greet())
    print("Python Docker sandbox is working!")

if __name__ == "__main__":
    main()
```

**Add content to `tests/test_main.py`:**
```python
import unittest
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from main import greet

class TestMain(unittest.TestCase):
    def test_greet_default(self):
        result = greet()
        self.assertEqual(result, "Hello, World!")

if __name__ == "__main__":
    unittest.main()
```

### Step 3: Test Your Code Works Locally First
1. **Right-click** `src/main.py` → **Run 'main'**
2. Verify it works with your local Python
3. **Right-click** `tests/test_main.py` → **Run 'Unittests in test_main.py'**

### Step 4: Create Docker Files Through PyCharm
1. **Right-click project root** → **New** → **File** → Name: `requirements.txt`
2. **Add this content to requirements.txt:**
```txt
# Development dependencies
pytest>=7.0.0
black>=22.0.0
flake8>=4.0.0
```

3. **Right-click project root** → **New** → **File** → Name: `Dockerfile`
4. **Add this content to Dockerfile:**
```dockerfile
# Use official Python runtime as base image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set work directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
        nano \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create non-root user for development
RUN useradd -m -s /bin/bash developer && \
    chown -R developer:developer /workspace
USER developer

# Default command (overridden by docker-compose for development)
CMD ["python", "src/main.py"]
```

5. **Right-click project root** → **New** → **File** → Name: `docker-compose.yml`
6. **Add this content to docker-compose.yml:**
```yaml
services:
  python-dev:
    build: .
    container_name: pycharm-python-sandbox
    volumes:
      # Mount source code for live editing
      - .:/workspace
      # Preserve pip cache
      - pip-cache:/home/developer/.cache/pip
    working_dir: /workspace
    # Keep container running for development
    tty: true
    stdin_open: true
    command: sleep infinity  # Override CMD to keep container alive
    # Optional: expose ports if you'll run web services later
    # Comment out if you get port conflicts
    # ports:
    #   - "8001:8000"
    #   - "5001:5000"
    environment:
      - PYTHONPATH=/workspace/src

volumes:
  pip-cache:
```

**Note about ports:** The ports section is commented out to avoid conflicts with macOS system services (like AirPlay on port 5000). You can uncomment and modify these later if you need to run web servers.

7. **Save all files** (Cmd+S on each file)

### Step 5: Configure Docker Interpreter in PyCharm
**Important:** Configure the interpreter first - PyCharm will build the Docker image automatically when needed.

1. **PyCharm** → **Preferences** → **Project** → **Python Interpreter**
2. **Add Interpreter** → **Docker Compose**
3. **Server**: Should auto-detect Docker
4. **Configuration files**: Select your `docker-compose.yml` (should auto-populate)
5. **Service**: Select `python-dev` (should now appear in dropdown)
6. **Step 2/3**: The "Create and configure new target" field will be read-only and auto-populated - this is normal
7. **Step 3/3**: Leave Python interpreter path as `/usr/local/bin/python3`
8. **Create** → **OK**

**PyCharm will now build the Docker image automatically** and set up the interpreter.

## Troubleshooting Port Conflicts

If you get an error like "ports are not available" or "port already in use":

### Check what's using the port:
```bash
# Check port 5000
lsof -i :5000

# Check port 8000  
lsof -i :8000
```

### Fix port conflicts:
1. **Edit docker-compose.yml** and change the ports:
```yaml
ports:
  - "8001:8000"  # Changed from 8000:8000
  - "5001:5000"  # Changed from 5000:5000
```

2. **Or comment out ports entirely** (recommended for basic development):
```yaml
# ports:
#   - "8000:8000" 
#   - "5000:5000"
```

3. **Save the file**
4. **Cancel and restart** the PyCharm interpreter setup (no rebuild needed)

**Important:** After making changes to docker-compose.yml or Dockerfile, you need to rebuild:
```bash
docker compose down
docker compose up -d python-dev
```

### Step 6: Wait for PyCharm to Complete Setup
**Wait for PyCharm to build and index** (this may take a few minutes the first time)

### Step 7: Test Your Docker Development Environment
Now when you run your code, it runs in Docker automatically!

1. **Right-click** `src/main.py` → **Run 'main'**
2. Verify output shows it's running in Docker
3. **Right-click** `tests/test_main.py` → **Run tests**

## Manual Docker Testing (Optional)

If you want to test Docker commands manually:

### Build and Run Manually
```bash
# Build the Docker image (if PyCharm hasn't already)
docker compose build

# Run the application manually
docker compose run --rm python-dev python src/main.py

# Run tests manually
docker compose run --rm python-dev python -m pytest tests/ -v
```

### Interactive Development Session
```bash
# Start an interactive bash session in the container
docker compose run --rm python-dev bash

# Inside the container, you can:
python src/main.py
python -m pytest tests/
python -c "import sys; print(sys.version)"
```

---

## Workflow C: PyCharm's Built-in Docker Support

### Option 1: New Project with Docker
1. **PyCharm** → **New Project**
2. **More Settings** → **Project type**: Python
3. **New environment using**: Docker
4. **Image name**: `python:3.11`
5. PyCharm creates basic Docker setup automatically!

### Option 2: Add Docker to Existing Project
1. **Open your existing project**
2. **Tools** → **Docker** → **Create Dockerfile**
3. PyCharm generates a basic Dockerfile
4. **Add interpreter** → **Docker** → **Dockerfile**

---

## Project Structure Overview
After completion, your `pycharm-docker-sandbox` repo will look like this:
```
pycharm-docker-sandbox/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── src/
│   └── main.py
├── tests/
│   └── test_main.py
└── README.md
```

## Complete File Contents (For Any Workflow)

When you create these files (either through terminal or PyCharm), here's what goes in each:

### `requirements.txt`
```txt
# Development dependencies
pytest>=7.0.0
black>=22.0.0
flake8>=4.0.0

# Add your project dependencies here
# requests>=2.28.0
# numpy>=1.21.0
```

## Step 2: Create Docker Configuration
### `Dockerfile`
```dockerfile
# Use official Python runtime as base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set work directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create non-root user for development
RUN useradd -m -s /bin/bash developer && \
    chown -R developer:developer /workspace
USER developer

# Default command
CMD ["python", "src/main.py"]
```

### `docker-compose.yml`
```yaml
version: '3.8'

services:
  python-dev:
    build: .
    container_name: pycharm-python-sandbox
    volumes:
      # Mount source code for live editing
      - .:/workspace
      # Preserve pip cache
      - pip-cache:/home/developer/.cache/pip
    working_dir: /workspace
    # Keep container running for development
    tty: true
    stdin_open: true
    # Optional: expose ports if you'll run web services
    ports:
      - "8000:8000"
      - "5000:5000"
    environment:
      - PYTHONPATH=/workspace/src

volumes:
  pip-cache:
```

### `.dockerignore`
```
**/__pycache__
**/*.pyc
**/*.pyo
**/*.pyd
**/.git
**/.gitignore
**/README.md
**/Dockerfile
**/docker-compose.yml
**/.dockerignore
**/venv
**/.venv
.pytest_cache
.coverage
*.egg-info
```

## Step 3: Test Docker Setup

### 3.1 Build and Run the Container
```bash
# Build the Docker image
docker compose build

# Run the application
docker compose run --rm python-dev python src/main.py

# Run tests
docker compose run --rm python-dev python -m pytest tests/ -v
```

**Expected output for main.py:**
```
Hello, World!
Python Docker sandbox is working!
Python version: 3.11.x (...)
Running in container: True
```

### 3.2 Interactive Development Session
```bash
# Start an interactive bash session in the container
docker compose run --rm python-dev bash

# Inside the container, you can:
python src/main.py
python -m pytest tests/
python -c "import sys; print(sys.version)"
```

## Step 4: Configure PyCharm

### 4.1 Open Project in PyCharm
1. **Open PyCharm**
2. **File** → **Open** → Navigate to your `pycharm-docker-sandbox` directory
3. **Open** the project

### 4.2 Configure Docker Interpreter
1. **PyCharm** → **Preferences** (or **File** → **Settings** on Windows/Linux)
2. **Project: pycharm-docker-sandbox** → **Python Interpreter**
3. **Add Interpreter** (gear icon) → **Docker Compose**

**Docker Compose Configuration:**
- **Configuration files**: `./docker-compose.yml`
- **Service**: `python-dev`
- **Environment variables**: `PYTHONPATH=/workspace/src`
- **Python interpreter path**: `/usr/local/bin/python`

4. **OK** → **OK**

### 4.3 Wait for Indexing
PyCharm will:
- Build the Docker image if needed
- Index the Python environment
- Set up code completion and debugging

## Step 5: Test PyCharm Integration

### 5.1 Run Configuration
1. **Right-click** on `src/main.py`
2. **Run 'main'**
3. Verify it runs in the Docker container (check output for "Running in container: True")

### 5.2 Test Configuration
1. **Right-click** on `tests/` directory
2. **Run 'pytest in tests'**
3. Verify tests pass in the Docker environment

### 5.3 Debug Configuration
1. **Set a breakpoint** in `src/main.py` (click left margin on line with `print(greet())`)
2. **Right-click** on `src/main.py`
3. **Debug 'main'**
4. Verify debugger stops at breakpoint and you can inspect variables

## Step 6: Verify Complete Setup

### 6.1 Test Development Workflow
1. **Edit `src/main.py`** - change the greeting message
2. **Run the application** - should see your changes
3. **Edit `tests/test_main.py`** - add a new test
4. **Run tests** - should include your new test

### 6.2 Test Docker Isolation
```bash
# In terminal, verify container is isolated
docker compose run --rm python-dev python -c "
import os
print('Container ID:', os.environ.get('HOSTNAME'))
print('User:', os.environ.get('USER'))
print('Working directory:', os.getcwd())
"
```

## Step 7: Development Best Practices

### 7.1 Container Management
```bash
# Start development container in background (keeps running)
docker compose up -d python-dev

# Connect to running container (multiple terminals possible)
docker compose exec python-dev bash

# Check container status
docker compose ps

# View logs
docker compose logs python-dev

# Stop container
docker compose down

# Restart container (if you changed docker-compose.yml)
docker compose down
docker compose up -d python-dev

# Clean restart with rebuild (if you changed Dockerfile/requirements)
docker compose down
docker compose build --no-cache
docker compose up -d python-dev
```

### 7.2 Package Management
```bash
# Add new package to requirements.txt, then:
docker compose build

# Or install temporarily for testing:
docker compose run --rm python-dev pip install package-name
```

### 7.3 Multiple Python Versions
To test different Python versions, create additional services in `docker-compose.yml`:
```yaml
services:
  python-dev:
    # ... existing config
    
  python39-dev:
    build: 
      context: .
      dockerfile: Dockerfile
      args:
        PYTHON_VERSION: 3.9
    container_name: pycharm-python39-sandbox
    # ... same configuration as python-dev
```

## Troubleshooting

### Common Issues and Solutions

**PyCharm can't connect to Docker:**
- Ensure Docker Desktop is running
- Check Docker Compose file syntax
- Try rebuilding: `docker compose build --no-cache`

**Import errors in PyCharm:**
- Verify PYTHONPATH environment variable in Docker configuration
- Check that `src/` is marked as Sources Root in PyCharm
- Ensure interpreter is properly configured

**File permission issues:**
- The Dockerfile creates a non-root user to avoid permission problems
- If issues persist, check volume mount permissions

**Container builds but PyCharm shows errors:**
- Wait for PyCharm to finish indexing (progress bar at bottom)
- Try invalidating caches: **File** → **Invalidate Caches and Restart**

## Next Steps

Once this basic setup is working:
1. **Add more complex dependencies** (web frameworks, databases)
2. **Create multiple containers** for different services
3. **Add debugging configurations** for different scenarios
4. **Integrate with version control** workflows
5. **Add CI/CD pipeline** using the same Docker setup

This setup gives you a completely isolated Python development environment that's reproducible across different machines and team members!