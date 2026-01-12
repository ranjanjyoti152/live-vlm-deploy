# Live VLM WebUI - Deployment Modes

This Docker Compose setup supports **two deployment modes** for Ollama:

## 🔵 Mode 1: External Ollama (Default)

Use your existing Ollama installation running on the host machine.

### When to use:
- ✅ You already have Ollama installed
- ✅ You want to share Ollama across multiple applications
- ✅ You prefer managing Ollama directly on your system
- ✅ Lower memory footprint (one less container)

### Prerequisites:
```bash
# Install Ollama (if not already installed)
curl -fsSL https://ollama.ai/install.sh | sh

# Start Ollama service
ollama serve

# Pull a vision model
ollama pull llama3.2-vision:11b
```

### Start the WebUI:
```bash
docker compose up -d
```

### Architecture:
```
Host Machine
├── Ollama (localhost:11434) ← Running directly on host
└── Docker Container
    └── Live VLM WebUI (port 8090) → Connects to host Ollama
```

---

## 🟢 Mode 2: Ollama in Docker (Recommended for Simplicity)

Run Ollama as a Docker container alongside the WebUI.

### When to use:
- ✅ You don't have Ollama installed
- ✅ You want everything containerized and isolated
- ✅ Easier cleanup and management
- ✅ Consistent environment across systems
- ✅ No system-wide installation required

### Start Everything:
```bash
# Start both Ollama and WebUI containers
docker compose --profile ollama up -d

# Pull a vision model
docker exec ollama ollama pull llama3.2-vision:11b

# Or pull multiple models
docker exec ollama ollama pull llava:13b
docker exec ollama ollama pull bakllava:7b
```

### Architecture:
```
Host Machine
└── Docker Network
    ├── Ollama Container (port 11434)
    └── Live VLM WebUI Container (port 8090)
         └── Connects to Ollama container
```

### Model Storage:
Models are stored in a Docker volume `ollama-data` which persists even when containers are stopped.

```bash
# View model storage
docker volume inspect ollama-data

# List downloaded models
docker exec ollama ollama list
```

---

## 📊 Comparison

| Feature | External Ollama | Ollama in Docker |
|---------|----------------|------------------|
| **Setup Complexity** | Medium (install Ollama) | Easy (just Docker) |
| **Resource Usage** | Lower (1 container) | Higher (2 containers) |
| **Isolation** | No | Yes |
| **Model Sharing** | Yes (with other apps) | No (container only) |
| **Cleanup** | Manual | Easy (`docker compose down -v`) |
| **Portability** | No | Yes (same config everywhere) |
| **Start Command** | `docker compose up` | `docker compose --profile ollama up` |

---

## 🔄 Switching Between Modes

### From External to Docker:
```bash
# Stop current setup
docker compose down

# Start with Ollama in Docker
docker compose --profile ollama up -d

# Pull models (if not already in volume)
docker exec ollama ollama pull llama3.2-vision:11b
```

### From Docker to External:
```bash
# Stop everything
docker compose down

# Make sure Ollama is running on host
ollama serve

# Start only WebUI
docker compose up -d
```

---

## 🛠️ Common Commands

### Mode 1 (External Ollama):
```bash
# Start
docker compose up -d

# View logs
docker compose logs -f live-vlm-webui

# Stop
docker compose down

# Manage Ollama
ollama list
ollama pull <model-name>
ollama rm <model-name>
```

### Mode 2 (Ollama in Docker):
```bash
# Start everything
docker compose --profile ollama up -d

# View logs (both services)
docker compose logs -f

# View Ollama logs only
docker compose logs -f ollama

# Manage models
docker exec ollama ollama list
docker exec ollama ollama pull llama3.2-vision:11b
docker exec ollama ollama rm <model-name>

# Stop everything
docker compose down

# Stop and remove model data
docker compose down -v
```

---

## ✅ Verification

### Check if Ollama is accessible:
```bash
# Test Ollama API
curl http://localhost:11434/v1/models

# List models
curl http://localhost:11434/api/tags

# For Docker mode, you can also exec into the container
docker exec ollama ollama list
```

### Check container status:
```bash
# Default mode (1 container)
docker compose ps

# Docker mode (2 containers)
docker compose --profile ollama ps
```

---

## 🎯 Recommended Setup

### For Development/Testing:
➡️ **Mode 2 (Docker)** - Everything isolated and easy to clean up

### For Production:
➡️ **Mode 1 (External)** - Better performance, shared resources

### For Beginners:
➡️ **Mode 2 (Docker)** - Easier to set up, no system installation needed

---

## 📚 Additional Resources

- **Main README:** [README.md](./README.md)
- **Quick Reference:** [QUICKSTART.md](./QUICKSTART.md)
- **Ollama Documentation:** https://github.com/ollama/ollama
- **Available Vision Models:** https://ollama.com/search?c=vision
