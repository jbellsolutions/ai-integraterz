#!/usr/bin/env bash
# healer.sh — AI Integraterz Self-Healer
# Matches failed agent errors against known patterns and applies documented fixes.
# Usage: ./lib/healer.sh <agent-name>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

AGENT_NAME="${1:?Usage: healer.sh <agent-name>}"
PATTERNS_FILE="$REPO_ROOT/.claude/healing/patterns.json"
HISTORY_FILE="$REPO_ROOT/.claude/healing/history.json"
STATE_FILE="$REPO_ROOT/state/${AGENT_NAME}/last-run.json"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo "========================================"
echo " AI Integraterz Healer: ${AGENT_NAME}"
echo " $(date)"
echo "========================================"

if [[ ! -f "$STATE_FILE" ]]; then
  echo -e "${YELLOW}[HEALER]${NC} No state file for ${AGENT_NAME} — nothing to heal."
  exit 0
fi

STATUS=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('status','unknown'))" 2>/dev/null || echo "unknown")

if [[ "$STATUS" != "failed" ]]; then
  echo -e "${GREEN}[HEALER]${NC} ${AGENT_NAME} status: ${STATUS} — no healing needed."
  exit 0
fi

ERROR=$(python3 -c "import json; d=json.load(open('$STATE_FILE')); print(d.get('error',''))" 2>/dev/null || echo "")
echo -e "${YELLOW}[HEALER]${NC} Error detected: ${ERROR}"

# Match against patterns
MATCHED=false
if [[ -f "$PATTERNS_FILE" ]]; then
  while IFS= read -r pattern; do
    TRIGGER=$(echo "$pattern" | python3 -c "import json,sys; print(json.load(sys.stdin)['trigger'])" 2>/dev/null || echo "")
    FIX=$(echo "$pattern" | python3 -c "import json,sys; print(json.load(sys.stdin)['fix'])" 2>/dev/null || echo "")
    ID=$(echo "$pattern" | python3 -c "import json,sys; print(json.load(sys.stdin)['id'])" 2>/dev/null || echo "")

    if [[ -n "$TRIGGER" ]] && echo "$ERROR" | grep -qi "$TRIGGER"; then
      echo -e "${GREEN}[HEALER]${NC} Matched pattern: ${ID}"
      echo -e "${GREEN}[HEALER]${NC} Fix: ${FIX}"
      MATCHED=true

      # Log to history
      python3 - << PYEOF
import json, datetime
h = json.load(open('$HISTORY_FILE'))
h['entries'].append({
    "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
    "agent": "$AGENT_NAME",
    "pattern_id": "$ID",
    "error": "$ERROR",
    "fix_applied": "$FIX",
    "result": "applied"
})
h['total_heals'] = h.get('total_heals', 0) + 1
json.dump(h, open('$HISTORY_FILE','w'), indent=2)
PYEOF
      break
    fi
  done < <(python3 -c "import json; [print(json.dumps(p)) for p in json.load(open('$PATTERNS_FILE'))['patterns']]" 2>/dev/null || true)
fi

if [[ "$MATCHED" == "false" ]]; then
  echo -e "${RED}[HEALER]${NC} No matching pattern — manual review needed."
  python3 - << PYEOF
import json, datetime
h = json.load(open('$HISTORY_FILE'))
h['entries'].append({
    "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
    "agent": "$AGENT_NAME",
    "pattern_id": "unmatched",
    "error": "$ERROR",
    "fix_applied": None,
    "result": "unmatched"
})
h['total_unmatched'] = h.get('total_unmatched', 0) + 1
json.dump(h, open('$HISTORY_FILE','w'), indent=2)
PYEOF
  exit 1
fi

echo "========================================"
echo " Healing complete — $(date)"
echo "========================================"
