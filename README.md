# Ollama CLI

Run large language models locally with [Ollama](https://ollama.com).

---

## Start / Stop the Service

```bash
# Start and enable on boot
sudo systemctl enable --now ollama

# Check status
systemctl status ollama

# Stop
sudo systemctl stop ollama
```

---

## Basic Usage

```bash
# Pull a model
ollama pull llama3.2

# Chat interactively
ollama run llama3.2

# One-shot prompt
ollama run llama3.2 "Explain containers in one paragraph"

# List downloaded models
ollama list

# Remove a model
ollama rm llama3.2
```

## Formats:

> GUF (GPT-Generated Unified Format) is a file format designed for fast loading and running of large language models (LLMs) on consumer hardware, particularly via llama.cpp.

---

## REST API

Ollama exposes a local API on `http://localhost:11434`.

```bash
# Generate
curl http://localhost:11434/api/generate \
  -d '{"model":"llama3.2","prompt":"Hello!","stream":false}'

# Chat
curl http://localhost:11434/api/chat \
  -d '{
    "model": "llama3.2",
    "messages": [{"role":"user","content":"Hello!"}],
    "stream": false
  }'

# List models
curl http://localhost:11434/api/tags
```

---

## Configuration

| File | Purpose |
|------|---------|
| `config/ollama.env` | Service environment variables |
| `config/Modelfile.example` | Custom model definition |
| `scripts/setup.sh` | First-time setup helper |
| `scripts/list-models.sh` | Show all available models |

### Apply the env config

```bash
sudo cp config/ollama.env /etc/ollama/ollama.env
sudo systemctl restart ollama
```

---

## Firewall (optional — expose to LAN)

```bash
sudo firewall-cmd --permanent --add-port=11434/tcp
sudo firewall-cmd --reload
```

> **Warning:** Only do this on a trusted network. Ollama has no authentication by default.

---

## GPU Acceleration

Ollama auto-detects NVIDIA and AMD GPUs.

```bash
# Check if GPU is being used
ollama run llama3.2 "hi"
# Look for "using GPU" in: journalctl -u ollama -f

# NVIDIA — install drivers + CUDA
sudo dnf install akmod-nvidia
```

---

## Troubleshooting

```bash
# View live logs
journalctl -u ollama -f

# Reset a stuck model
ollama stop llama3.2

# Check available disk space (models can be large)
df -h ~/.ollama
```
