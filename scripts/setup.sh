#!/usr/bin/env bash
# install/update ollama 
set -euo pipefail

echo "==> Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

echo "==> Enabling and starting ollama service..."
sudo systemctl enable --now ollama

echo "==> Applying environment config..."
sudo mkdir -p /etc/ollama
sudo cp "$(dirname "$0")/../config/ollama.env" /etc/ollama/ollama.env
sudo systemctl restart ollama

echo "==> Waiting for Ollama to be ready..."
until curl -sf http://localhost:11434 > /dev/null 2>&1; do
  sleep 1
done

echo ""
echo "Done! Run: ollama run llama3.2"
