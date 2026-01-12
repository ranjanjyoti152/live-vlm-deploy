#!/bin/bash
# ==============================================================================
# Live VLM WebUI - Quick Start Script
# ==============================================================================
# This script helps you set up and start the Live VLM WebUI with external Ollama
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo "=================================="
    echo "$1"
    echo "=================================="
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Prerequisites
print_header "Checking Prerequisites"

# Check Docker
if command_exists docker; then
    print_success "Docker is installed: $(docker --version)"
else
    print_error "Docker is not installed"
    echo "  Install from: https://docs.docker.com/engine/install/"
    exit 1
fi

# Check Docker Compose
if command_exists docker && docker compose version >/dev/null 2>&1; then
    print_success "Docker Compose is installed: $(docker compose version)"
elif command_exists docker-compose; then
    print_success "Docker Compose is installed: $(docker-compose --version)"
    print_warning "Using legacy docker-compose command"
else
    print_error "Docker Compose is not installed"
    exit 1
fi

# Check Ollama
if command_exists ollama; then
    print_success "Ollama is installed"
    
    # Check if Ollama is running
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        print_success "Ollama service is running"
        
        # List installed models
        print_info "Checking for vision models..."
        MODELS=$(ollama list | grep -iE 'vision|llava|bakllava' || true)
        
        if [ -n "$MODELS" ]; then
            print_success "Vision models found:"
            echo "$MODELS"
        else
            print_warning "No vision models found"
            echo ""
            read -p "Would you like to pull llama3.2-vision:11b? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_info "Pulling llama3.2-vision:11b (this may take a few minutes)..."
                ollama pull llama3.2-vision:11b
                print_success "Model downloaded successfully"
            else
                print_warning "You'll need to pull a vision model manually:"
                echo "  ollama pull llama3.2-vision:11b"
            fi
        fi
    else
        print_warning "Ollama service is not running"
        echo ""
        read -p "Would you like to start Ollama? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Starting Ollama service..."
            ollama serve &
            sleep 3
            print_success "Ollama service started"
        else
            print_error "Ollama must be running. Start it with: ollama serve"
            exit 1
        fi
    fi
else
    print_error "Ollama is not installed"
    echo "  Install from: https://ollama.ai/download"
    exit 1
fi

# Check NVIDIA GPU
print_header "Checking GPU Support"
if command_exists nvidia-smi; then
    print_success "NVIDIA GPU detected:"
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
    
    # Check NVIDIA Docker support
    if docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi >/dev/null 2>&1; then
        print_success "NVIDIA Docker support is working"
    else
        print_warning "NVIDIA Docker support may not be configured"
        echo "  Install nvidia-container-toolkit if needed"
    fi
else
    print_warning "No NVIDIA GPU detected (CPU mode will be used)"
fi

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    print_info "Creating .env file from .env.example..."
    cp .env.example .env
    print_success ".env file created"
else
    print_info ".env file already exists"
fi

# Start Docker Compose
print_header "Starting Live VLM WebUI"

print_info "Starting Docker containers..."
docker compose up -d

# Wait for container to be ready
print_info "Waiting for container to be ready..."
sleep 5

# Check if container is running
if docker ps | grep -q live-vlm-webui; then
    print_success "Container is running"
    
    # Show logs
    print_header "Container Logs (last 20 lines)"
    docker compose logs --tail=20 live-vlm-webui
    
    print_header "Setup Complete!"
    print_success "Live VLM WebUI is running"
    echo ""
    echo "Access the WebUI at: ${GREEN}https://localhost:8090${NC}"
    echo ""
    echo "Note: You'll need to accept the self-signed SSL certificate"
    echo "      1. Click 'Advanced' in your browser"
    echo "      2. Click 'Proceed to localhost (unsafe)'"
    echo "      3. Allow camera access when prompted"
    echo ""
    echo "Useful commands:"
    echo "  View logs:        docker compose logs -f"
    echo "  Stop service:     docker compose down"
    echo "  Restart service:  docker compose restart"
    echo "  Pull new image:   docker compose pull"
    echo ""
    
else
    print_error "Container failed to start"
    echo ""
    echo "Check logs with: docker compose logs"
    exit 1
fi
