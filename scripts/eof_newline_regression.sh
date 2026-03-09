#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

tmpfile="$(mktemp -t vyper-eof-regression).vy"
trap 'rm -f "$tmpfile"' EXIT

printf 'def __default__():\n    pass' > "$tmpfile"

tree-sitter parse -p . "$tmpfile" >/dev/null
