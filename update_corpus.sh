#!/usr/bin/env bash
set -euo pipefail

tree-sitter test -u -p .
echo "Corpus updated. Run 'tree-sitter test -p .' to verify."
