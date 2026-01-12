# Live VLM WebUI - Quick Reference

## 🚀 Quick Commands

### Start Everything (Automated)
```bash
./start.sh
```
This script will:
- ✓ Check all prerequisites (Docker, Ollama, GPU)
- ✓ Start Ollama if not running
- ✓ Pull vision models if needed
- ✓ Start the Live VLM WebUI container
- ✓ Show you the logs

### Manual Commands

```bash
# Start the WebUI
docker compose up -d

# View logs (last 50 lines)
./logs.sh

# Follow logs in real-time
./logs.sh -f

# Stop the WebUI
./stop.sh

# Restart the WebUI
docker compose restart

# Update to latest image
docker compose pull
docker compose up -d
```

## 📋 Setup Checklist

- [ ] Ollama installed: `curl -fsSL https://ollama.ai/install.sh | sh`
- [ ] Ollama running: `ollama serve`
- [ ] Vision model installed: `ollama pull llama3.2-vision:11b`
- [ ] Docker installed: `docker --version`
- [ ] NVIDIA GPU drivers (optional): `nvidia-smi`
- [ ] Start WebUI: `./start.sh`
- [ ] Access WebUI: `https://localhost:8090`

## 🎯 Recommended Vision Models

| Model | Size | Speed | Quality | Command |
|-------|------|-------|---------|---------|
| **llama3.2-vision:11b** | 11B | Medium | High | `ollama pull llama3.2-vision:11b` |
| **llava:13b** | 13B | Slow | Very High | `ollama pull llava:13b` |
| **bakllava:7b** | 7B | Fast | Good | `ollama pull bakllava:7b` |
| **gemma3:4b** | 4B | Very Fast | Good | `ollama pull gemma3:4b` |

## 🌐 Access URLs

- **WebUI:** https://localhost:8090
- **Ollama API:** http://localhost:11434/v1

## 🔧 Configuration

The WebUI will automatically connect to Ollama at `http://localhost:11434/v1`

To customize, edit `.env`:
```bash
cp .env.example .env
# Edit .env with your preferred settings
```

## 📊 System Requirements

### Minimum
- CPU: Any modern CPU
- RAM: 8GB
- Storage: 10GB free space
- OS: Linux (Ubuntu 20.04+)

### Recommended
- NVIDIA GPU (4GB+ VRAM)
- RAM: 16GB+
- Storage: 50GB+ SSD

## 🐛 Troubleshooting

### Ollama not running
```bash
ollama serve
```

### Check Ollama status
```bash
curl http://localhost:11434/api/tags
```

### View WebUI logs
```bash
./logs.sh -f
```

### Reset everything
```bash
docker compose down
./start.sh
```

### GPU not working
```bash
# Install NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

# Test GPU access
docker run --rm --gpus all nvidia/cuda:11.8.0-base-ubuntu22.04 nvidia-smi
```

## 📁 File Structure

```
/home/proxpc/live-vlm/
├── docker-compose.yml    # Docker Compose configuration
├── .env.example          # Environment variables template
├── README.md             # Detailed documentation
├── QUICKSTART.md         # This file
├── start.sh              # Automated startup script
├── stop.sh               # Stop script
├── logs.sh               # Logs viewer
└── live-vlm-webui/       # Cloned repository (reference)
```

## 💡 Tips

1. **First time setup:** Run `./start.sh` - it handles everything
2. **Check logs:** Use `./logs.sh -f` to see real-time activity
3. **Model selection:** Larger models = better quality but slower
4. **Frame interval:** Adjust in WebUI for processing frequency
5. **Custom prompts:** Write your own or use presets in the WebUI

## 🔗 Useful Links

- [GitHub Repository](https://github.com/NVIDIA-AI-IOT/live-vlm-webui)
- [Ollama Models](https://ollama.com/search?c=vision)
- [Full Documentation](./README.md)

---

**Need help?** Check the [full README](./README.md) or visit the [GitHub issues page](https://github.com/NVIDIA-AI-IOT/live-vlm-webui/issues).
