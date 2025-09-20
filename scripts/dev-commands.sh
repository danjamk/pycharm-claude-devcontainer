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
