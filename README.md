# Ollama CLI

Run large language models locally with [Ollama](https://ollama.com).

---

## Start / Stop the Service

```bash
# Start and enable on boot
sudo systemctl enable --now ollama

# Or use on demand
ollama serve

# Check status
systemctl status ollama

# Stop
sudo systemctl stop ollama
```

---

## Basic Usage

```bash
# Pull a model
ollama pull qwen3.5:9b-q4_K_M

# Chat interactively
ollama run qwen3.5:9b-q4_K_M

# One-shot prompt
ollama run qwen3.5:9b-q4_K_M "Explain containers in one paragraph"

# List downloaded models
ollama list

# Remove a model
ollama rm qwen3.5:9b-q4_K_M
```

## Formats:

> GUF (GPT-Generated Unified Format) is a file format designed for fast loading and running of large language models (LLMs) on consumer hardware, particularly via llama.cpp.

---

## REST API

Ollama exposes a local API on `http://localhost:11434`.

```bash
# Generate
curl http://localhost:11434/api/generate \
  -d '{"model":"qwen3.5:9b-q4_K_M","prompt":"Hello!","stream":false}'

# Chat
curl http://localhost:11434/api/chat \
  -d '{
    "model": "qwen3.5:9b-q4_K_M",
    "messages": [{"role":"user","content":"Hello!"}],
    "stream": false
  }'

# List models
curl http://localhost:11434/api/tags
```

---

## Claude Code

Open models can be used with Claude Code (Anthropic's agentic coding tool) through Ollama’s Anthropic-compatible API, enabling you to use models such as qwen3.5, glm-5:cloud, kimi-k2.5:cloud.

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Start Claude Code with  a model:

```bash
ollama serve
ollama launch claude --model qwen3.5:9b-q4_K_M
```

### Manual setup

```bash
ANTHROPIC_AUTH_TOKEN=ollama ANTHROPIC_BASE_URL=http://localhost:11434 ANTHROPIC_API_KEY="" claude --model qwen3.5:9b-q4_K_M
```

### Tooling

Uv is an extremely fast Python package and project manager written in Rust.
It can be used to install the `claude-monitor` tool, which provides a real-time dashboard for monitoring model performance and resource usage.

```bash
sudo dnf install uv
uv tool install claude-monitor
ccmonitor --view realtime
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
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.2.0/24" port protocol="tcp" port="11434" accept'
sudo firewall-cmd --reload
```

> **Warning:** Only do this on a trusted network. Ollama has no authentication by default.

---

## GPU Acceleration

Ollama auto-detects NVIDIA and AMD GPUs.

```bash
# Check if GPU is being used
ollama run qwen3.5:9b-q4_K_M "hi"
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
ollama stop qwen3.5:9b-q4_K_M

# Check available disk space (models can be large)
df -h ~/.ollama
```
