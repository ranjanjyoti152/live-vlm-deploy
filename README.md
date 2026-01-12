# Live VLM WebUI - Docker Compose Setup

This directory contains a Docker Compose setup for running the NVIDIA Live VLM WebUI with flexible Ollama deployment options.

## 🎯 Two Deployment Modes

Choose the mode that best fits your needs:

### 🔵 Mode 1: External Ollama (Default)
Use your existing Ollama installation on the host machine.
- ✅ Share Ollama across multiple applications
- ✅ Lower memory footprint (one container)
- ✅ Direct control over Ollama

### 🟢 Mode 2: Ollama in Docker (Recommended for Beginners)
Run Ollama as a Docker container alongside the WebUI.
- ✅ No Ollama installation needed
- ✅ Fully containerized and isolated
- ✅ Easier cleanup and management
- ✅ Perfect for testing and development

---

## 🚀 Quick Start

### Option A: With Ollama in Docker (Easiest) ⭐

**No Ollama installation needed! Everything runs in Docker.**

```bash
# 1. Start both Ollama and WebUI containers
docker compose --profile ollama up -d

# 2. Pull a vision model
docker exec ollama ollama pull llama3.2-vision:11b

# 3. Check status
docker compose ps

# 4. View logs
docker compose logs -f
```

**That's it!** Access the WebUI at `https://localhost:8090`

---

### Option B: With External Ollama

**Use your existing Ollama installation.**

#### Prerequisites:

1. **Install Ollama** (if not already installed)
   ```bash
   curl -fsSL https://ollama.ai/install.sh | sh
   ```

2. **Start Ollama service**
   ```bash
   ollama serve
   ```

3. **Pull a vision model**
   ```bash
   ollama pull llama3.2-vision:11b
   ```

#### Start the WebUI:

```bash
# Start only the WebUI container
docker compose up -d

# Check logs
docker compose logs -f
```

**Access the WebUI** at `https://localhost:8090`

---

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

**Project Documentation:**
- [Deployment Modes Guide](./DEPLOYMENT_MODES.md) - Detailed comparison and switching guide
- [Quick Reference](./QUICKSTART.md) - Common commands and tips
- [Environment Configuration](./.env.example) - Configuration options

**External Links:**
- [Live VLM WebUI GitHub](https://github.com/NVIDIA-AI-IOT/live-vlm-webui)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Available Vision Models](https://ollama.com/search?c=vision)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

---

**Questions or issues?** Check the [troubleshooting guide](https://github.com/NVIDIA-AI-IOT/live-vlm-webui/blob/main/docs/troubleshooting.md) or open an issue on GitHub.
