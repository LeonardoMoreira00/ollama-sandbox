#!/usr/bin/env bash
set -euo pipefail

echo "==> Locally installed models:"
ollama list

echo ""
echo "==> Currently running models:"
ollama ps
