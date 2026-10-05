#!/usr/bin/env bash
# Weekly maintenance (template): lint the knowledge base and draft promotion candidates.
set -euo pipefail
WIKI="${WIKI_DIR:-$HOME/brain/wiki}"
REPORT="$WIKI/_consolidation/$(date -u +%F)-weekly.md"

{
  echo "# Weekly brain report $(date -u +%F)"
  echo "## Stale (not touched in 90d)"; find "$WIKI" -name '*.md' -mtime +90 -print
  echo "## Possible duplicates (same H1)"; grep -rh '^# ' "$WIKI" --include='*.md' | sort | uniq -d
  echo "## Orphans (no inbound [[links]])"; echo "  (run your link-graph check here)"
} > "$REPORT"

# Draft promotion candidates into inbox/ as status: draft (one file per candidate).
# Have your assistant read $REPORT and propose notes; a human promotes them later.
echo "wrote $REPORT"
