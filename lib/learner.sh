#!/usr/bin/env bash
# learner.sh — AI Integraterz Self-Learner
# Scans observations, promotes patterns with 3+ occurrences to healing system.
# Usage: ./lib/learner.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

OBS_FILE="$REPO_ROOT/.claude/learning/observations.json"
PATTERNS_FILE="$REPO_ROOT/.claude/healing/patterns.json"
SUMMARY_FILE="$REPO_ROOT/.claude/learning/session-summary.json"

echo "========================================"
echo " AI Integraterz Learner"
echo " $(date)"
echo "========================================"

if [[ ! -f "$OBS_FILE" ]]; then
  echo "[LEARNER] No observations file — nothing to learn from yet."
  exit 0
fi

OBS_COUNT=$(python3 -c "import json; print(len(json.load(open('$OBS_FILE'))['observations']))" 2>/dev/null || echo "0")
echo "[LEARNER] Observations to scan: ${OBS_COUNT}"

python3 - << 'PYEOF'
import json, datetime
from pathlib import Path
from collections import Counter

REPO = Path(__file__).parent.parent if '__file__' in dir() else Path(".")
import os
REPO = Path(os.environ.get("REPO_ROOT", "."))

obs_file = REPO / ".claude/learning/observations.json"
patterns_file = REPO / ".claude/healing/patterns.json"
summary_file = REPO / ".claude/learning/session-summary.json"

obs_data = json.loads(obs_file.read_text())
observations = obs_data.get("observations", [])

# Group by type
type_counts = Counter(o["type"] for o in observations)
promoted = []

patterns_data = json.loads(patterns_file.read_text())
existing_ids = {p["id"] for p in patterns_data["patterns"]}

for obs_type, count in type_counts.items():
    if count >= 3 and obs_type not in existing_ids:
        # Gather all details for this type
        details = [o["detail"] for o in observations if o["type"] == obs_type]
        new_pattern = {
            "id": obs_type,
            "description": f"Auto-learned: {obs_type} (seen {count}x)",
            "trigger": obs_type,
            "fix": details[0] if details else "Review observations for details",
            "confidence": min(0.5 + count * 0.1, 0.95),
            "occurrences": count
        }
        patterns_data["patterns"].append(new_pattern)
        promoted.append(obs_type)
        print(f"[LEARNER] Promoted pattern: {obs_type} (confidence: {new_pattern['confidence']})")

patterns_file.write_text(json.dumps(patterns_data, indent=2))

summary = {
    "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
    "observations_scanned": len(observations),
    "patterns_promoted": promoted,
    "type_counts": dict(type_counts)
}
summary_file.write_text(json.dumps(summary, indent=2))
print(f"[LEARNER] Done. {len(promoted)} pattern(s) promoted.")
PYEOF

echo "========================================"
echo " Learning complete — $(date)"
echo "========================================"
