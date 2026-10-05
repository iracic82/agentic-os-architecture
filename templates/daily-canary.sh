#!/usr/bin/env bash
# Daily recall canary (template). Proves the memory still answers a known question.
# Replace the query/expected with your own; wire the MCP/HTTP call to your memory service.
set -euo pipefail
QUERY="${1:-what is our convention for X}"
EXPECT="${2:-the-known-answer-substring}"
LOG="${BRAIN_LOG:-$HOME/brain/.logs/daily-canary.log}"; mkdir -p "$(dirname "$LOG")"

answer="$(your_memory_search_cli "$QUERY")"     # <- replace with your search_memory call
if printf '%s' "$answer" | grep -qi "$EXPECT"; then
  echo "$(date -u +%FT%TZ) PASS canary" >> "$LOG"
else
  echo "$(date -u +%FT%TZ) FAIL canary: expected '$EXPECT', got: ${answer:0:200}" >> "$LOG"
  # notify yourself here (the store may be broken or drifted)
fi
