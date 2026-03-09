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

total=0
successful=0

while IFS= read -r file; do
  total=$((total + 1))
  if output="$(tree-sitter parse -p . "$file" 2>&1)"; then
    rc=0
  else
    rc=$?
  fi

  if [ "$rc" -ne 0 ]; then
    printf '%s\n' "$output"
  else
    successful=$((successful + 1))
  fi
done < "$filtered_tmpfile"

printf '\nSuccessful parses: %d/%d\n' "$successful" "$total"

if [ "$successful" -ne "$total" ]; then
  exit 1
fi
