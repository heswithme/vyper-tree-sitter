#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

files=()
while IFS= read -r -d '' file; do
  files+=("$file")
done < <(find .. -mindepth 2 -maxdepth 3 -path '../*/contracts/*.vy' -print0 | sort -z)

if [ "${#files[@]}" -eq 0 ]; then
  echo "no sibling ../*/contracts/*.vy files found" >&2
  exit 1
fi

exec bash scripts/smoke_parse.sh "${files[@]}"
