#!/bin/bash
# ==============================================================================
# View Live VLM WebUI Logs
# ==============================================================================

if [ "$1" == "-f" ]; then
    echo "Following logs (Ctrl+C to exit)..."
    docker compose logs -f live-vlm-webui
else
    docker compose logs --tail=50 live-vlm-webui
fi
