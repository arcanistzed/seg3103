#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR/python-backend"

PYTHON_BIN="${PYTHON_BIN:-python3}"

rm -rf .venv
"$PYTHON_BIN" -m venv .venv
. .venv/bin/activate

python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m pytest