#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

exec bash scripts/smoke_parse.sh \
  ../blockhash-oracle \
  ../LZV2Vyper \
  ../twocrypto-ng \
  ../curve-std \
  ../yb-core \
  ../fee-splitter \
  ../yearn-vaults-v3/contracts
