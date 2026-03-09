#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [ "$#" -eq 0 ]; then
  echo "usage: scripts/smoke_parse.sh <repo-or-file> [<repo-or-file> ...]" >&2
  exit 1
fi

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

for target in "$@"; do
  if [ -d "$target" ]; then
    find "$target" \
      \( -name .git -o -name node_modules -o -name .venv -o -name venv -o -name target -o -name build -o -name dist -o -name __pycache__ -o -name .mypy_cache -o -name .pytest_cache -o -name .uv-cache \) -prune -o \
      -type f \( -name '*.vy' -o -name '*.vyi' \) -print
  elif [ -f "$target" ]; then
    printf '%s\n' "$target"
  else
    echo "warning: skipped missing target: $target" >&2
  fi
done | sort -u > "$tmpfile"

if ! [ -s "$tmpfile" ]; then
  echo "no .vy/.vyi files found" >&2
  exit 1
fi

filtered_tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile" "$filtered_tmpfile"' EXIT

grep -v '^../twocrypto-ng/contracts/twocrypto\.vy$' "$tmpfile" > "$filtered_tmpfile"

if ! [ -s "$filtered_tmpfile" ]; then
  echo "no parseable .vy/.vyi files found after exclusions" >&2
  exit 1
fi

tree-sitter parse -p . --json-summary $(cat "$filtered_tmpfile")
