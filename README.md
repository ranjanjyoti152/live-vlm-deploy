# Live VLM WebUI - Docker Setup with External Ollama

This directory contains a Docker Compose setup for running the NVIDIA Live VLM WebUI with an external Ollama instance.

## 🚀 Quick Start

### Prerequisites

1. **Ollama** must be installed and running on your host machine
   ```bash
   # Install Ollama (if not already installed)
   curl -fsSL https://ollama.ai/install.sh | sh
   
   # Start Ollama service
   ollama serve
   ```

2. **Pull a vision model** in Ollama
   ```bash
   # Recommended models
   ollama pull llama3.2-vision:11b
   # OR
   ollama pull llava:13b
   # OR
   ollama pull bakllava:7b
   ```

3. **Docker and Docker Compose** must be installed
   ```bash
   # Check if Docker is installed
   docker --version
   docker compose version
   ```

4. **NVIDIA GPU** with Docker GPU support (optional but recommended)
   ```bash
   # Install NVIDIA Container Toolkit if not already installed
   # See: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
   ```

### Start the WebUI

```bash
# Navigate to this directory
cd /home/proxpc/live-vlm

# Start the Live VLM WebUI
docker compose up -d

# Check logs
docker compose logs -f live-vlm-webui
```

### Access the WebUI

Open your browser and navigate to:
```
https://localhost:8090
```

**Note:** You'll need to accept the self-signed SSL certificate:
1. Click "Advanced" in your browser
2. Click "Proceed to localhost (unsafe)"
3. Allow camera access when prompted

## 🎥 Using the WebUI

1. **Configure VLM API:**
   - API Base URL: `http://localhost:11434/v1`
   - Model: Select your installed model (e.g., `llama3.2-vision:11b`)

2. **Camera Control:**
   - Select your camera from the dropdown
   - Click "START" to begin analysis
   - Adjust Frame Interval for processing frequency

3. **Prompts:**
   - Choose from preset prompts or write custom ones
   - Adjust Max Tokens for response length

## 🛠️ Configuration

### Environment Variables

Create a `.env` file from the example:
```bash
cp .env.example .env
```

Edit `.env` to customize settings:
```bash
# Example .env
API_BASE=http://localhost:11434/v1
DEFAULT_MODEL=llama3.2-vision:11b
WEBUI_PORT=8090
```

### Available Models

Check available models in Ollama:
```bash
ollama list
```

Pull additional vision models:
```bash
# Llama 3.2 Vision (11B parameters)
ollama pull llama3.2-vision:11b

# LLaVA (13B parameters)
ollama pull llava:13b

# BakLLaVA (7B parameters - faster, smaller)
ollama pull bakllava:7b

# Gemma 3 with vision (4B parameters - very fast)
ollama pull gemma3:4b
```

## 📊 System Monitoring

The WebUI includes real-time system monitoring:
- GPU utilization and VRAM usage
- CPU and RAM statistics
- Inference latency metrics
- Live sparkline graphs

## 🔧 Troubleshooting

### Ollama not accessible

1. Verify Ollama is running:
   ```bash
   curl http://localhost:11434/v1/models
   ```

2. Check Ollama logs:
   ```bash
   # If running as service
   sudo journalctl -u ollama -f
   ```

### GPU not available in container

1. Install NVIDIA Container Toolkit:
   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
     sudo tee /etc/os-release.d/nvidia-docker.list
   sudo apt-get update
   sudo apt-get install -y nvidia-container-toolkit
   sudo systemctl restart docker
   ```

2. Verify GPU access:
   ```bash
   docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
   ```

### WebUI not starting

1. Check container logs:
   ```bash
   docker compose logs -f
   ```

2. Verify port 8090 is not in use:
   ```bash
   sudo lsof -i :8090
   ```

### Camera not accessible

1. Use HTTPS (required for WebRTC)
2. Accept the self-signed certificate
3. Grant camera permissions in your browser

## 🛑 Stop the Services

```bash
# Stop the container
docker compose down

# Stop and remove volumes (if needed)
docker compose down -v
```

## 📚 Additional Resources

- [Live VLM WebUI GitHub](https://github.com/NVIDIA-AI-IOT/live-vlm-webui)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Available Vision Models](https://ollama.com/search?c=vision)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📝 Architecture

```
┌─────────────────────────────────────────────────┐
│                   Host Machine                  │
│                                                 │
│  ┌─────────────────┐      ┌─────────────────┐  │
│  │ Ollama Service  │      │  Docker         │  │
│  │ (localhost:     │◄─────┤  Container:     │  │
│  │  11434)         │      │  Live VLM WebUI │  │
│  └─────────────────┘      │  (port 8090)    │  │
│                           └─────────────────┘  │
│                                  ▲              │
└──────────────────────────────────┼──────────────┘
                                   │
                            Browser (HTTPS)
                         https://localhost:8090
```

## 🎯 Use Cases

- 🔒 **Security:** Real-time monitoring and alert generation
- 🤖 **Robotics:** Visual feedback for robot control
- 🏭 **Industrial:** Quality control, safety monitoring
- 🏥 **Healthcare:** Activity monitoring, fall detection
- ♿ **Accessibility:** Visual assistance for visually impaired
- 📚 **Education:** Interactive learning experiences

---

**Questions or issues?** Check the [troubleshooting guide](https://github.com/NVIDIA-AI-IOT/live-vlm-webui/blob/main/docs/troubleshooting.md) or open an issue on GitHub.
