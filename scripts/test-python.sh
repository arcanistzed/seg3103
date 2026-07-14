#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR/python-backend"

if python -m venv .venv &> /dev/null; then
    . .venv/bin/activate
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
else
    python -m pip install --user -r requirements.txt --break-system-packages 2>/dev/null || \
    PIP_REQUIRE_VIRTUALENV=false python -m pip install --user -r requirements.txt
fi

python -m pytest