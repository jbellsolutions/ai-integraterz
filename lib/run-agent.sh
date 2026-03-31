#!/usr/bin/env bash
# run-agent.sh — AI Integraterz Agent Runner
# Usage: ./lib/run-agent.sh <agent-name> [--client <client-id>] [--auto] [--transcript <file>]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ─── Colors ────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'; BOLD='\033[1m'
info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}  [OK]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERR]${NC}   $*" >&2; }

# ─── Parse arguments ───────────────────────────────────────────────────────
AGENT_NAME="${1:?Usage: run-agent.sh <agent-name> [--client <id>] [--auto] [--transcript <file>] [--update <event>] [--response] [--pre-call]}"
CLIENT_ID=""
AUTO_FLAG=""
TRANSCRIPT_FILE=""
UPDATE_EVENT=""
RESPONSE_FLAG=""
PRE_CALL_FLAG=""

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --client)     CLIENT_ID="$2"; shift 2 ;;
    --auto)       AUTO_FLAG="--allowedTools '*'"; shift ;;
    --transcript) TRANSCRIPT_FILE="$2"; shift 2 ;;
    --update)     UPDATE_EVENT="$2"; shift 2 ;;
    --response)   RESPONSE_FLAG="true"; shift ;;
    --pre-call)   PRE_CALL_FLAG="true"; shift ;;
    *) warn "Unknown argument: $1"; shift ;;
  esac
done

echo "========================================"
echo " AI Integraterz Agent: ${AGENT_NAME}"
echo " $(date)"
[[ -n "$CLIENT_ID" ]]    && echo " Client: ${CLIENT_ID}"
[[ -n "$UPDATE_EVENT" ]] && echo " Update event: ${UPDATE_EVENT}"
[[ -n "$RESPONSE_FLAG" ]] && echo " Mode: response processing"
[[ -n "$PRE_CALL_FLAG" ]] && echo " Mode: pre-call"
echo "========================================"

# ─── Load env ──────────────────────────────────────────────────────────────
if [[ -f "$PROJECT_ROOT/.env" ]]; then
  set -a; source "$PROJECT_ROOT/.env"; set +a
  info "Environment loaded."
else
  warn ".env not found — running without environment variables."
fi

# ─── Verify playbook exists ────────────────────────────────────────────────
PLAYBOOK="$PROJECT_ROOT/agents/${AGENT_NAME}.md"
if [[ ! -f "$PLAYBOOK" ]]; then
  err "Playbook not found: ${PLAYBOOK}"
  err "Available agents: $(ls "$PROJECT_ROOT/agents/" | sed 's/.md//' | tr '\n' ', ')"
  exit 1
fi
info "Playbook: ${PLAYBOOK}"

# ─── Load project config ───────────────────────────────────────────────────
PROJECT_CONFIG=$(cat "$PROJECT_ROOT/config/project.json" 2>/dev/null || echo '{}')
THRESHOLDS=$(cat "$PROJECT_ROOT/config/thresholds.json" 2>/dev/null || echo '{}')

# ─── Load client config (if provided) ─────────────────────────────────────
CLIENT_CONFIG=""
if [[ -n "$CLIENT_ID" ]]; then
  CLIENT_FILE="$PROJECT_ROOT/config/clients/${CLIENT_ID}.json"
  if [[ -f "$CLIENT_FILE" ]]; then
    CLIENT_CONFIG=$(cat "$CLIENT_FILE")
    info "Client config loaded: ${CLIENT_FILE}"
  else
    err "Client config not found: ${CLIENT_FILE}"
    exit 1
  fi
fi

# ─── Load agent state ──────────────────────────────────────────────────────
STATE_DIR="$PROJECT_ROOT/state/${AGENT_NAME}"
mkdir -p "$STATE_DIR"

LAST_RUN_FILE="$STATE_DIR/last-run.json"
LAST_RUN='{"status":"never_run","run_count":0,"last_run_at":null}'
[[ -f "$LAST_RUN_FILE" ]] && LAST_RUN=$(cat "$LAST_RUN_FILE")

# ─── Load transcript (if provided) ────────────────────────────────────────
TRANSCRIPT_CONTENT=""
if [[ -n "$TRANSCRIPT_FILE" ]]; then
  if [[ -f "$TRANSCRIPT_FILE" ]]; then
    TRANSCRIPT_CONTENT=$(cat "$TRANSCRIPT_FILE")
    info "Transcript loaded: ${TRANSCRIPT_FILE}"
  else
    err "Transcript file not found: ${TRANSCRIPT_FILE}"
    exit 1
  fi
fi

# ─── Build prompt ──────────────────────────────────────────────────────────
PLAYBOOK_CONTENT=$(cat "$PLAYBOOK")

PROMPT=$(cat <<PROMPTEOF
# Agent Run: ${AGENT_NAME}
**Timestamp:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Project Root:** ${PROJECT_ROOT}
${CLIENT_ID:+**Client ID:** ${CLIENT_ID}}
${UPDATE_EVENT:+**Update Event:** ${UPDATE_EVENT}}
${RESPONSE_FLAG:+**Mode:** response (process owner's check-in response)}
${PRE_CALL_FLAG:+**Mode:** pre-call (generate call script before the discovery call)}

## Your Playbook
${PLAYBOOK_CONTENT}

## Project Configuration
\`\`\`json
${PROJECT_CONFIG}
\`\`\`

## Thresholds
\`\`\`json
${THRESHOLDS}
\`\`\`

## Your Last Run State
\`\`\`json
${LAST_RUN}
\`\`\`

$(if [[ -n "$CLIENT_CONFIG" ]]; then
echo "## Client Config
\`\`\`json
${CLIENT_CONFIG}
\`\`\`"
fi)

$(if [[ -n "$TRANSCRIPT_CONTENT" ]]; then
echo "## Call Transcript / Notes
\`\`\`
${TRANSCRIPT_CONTENT}
\`\`\`"
fi)

## Instructions
1. Follow your playbook above exactly
2. Use the client config and extraction data as your source of truth
3. Write all outputs to the correct paths under \`outputs/${CLIENT_ID:-<client-id>}/\`
4. Update your state file when done: \`state/${AGENT_NAME}/last-run.json\`
5. Set status to "completed", increment run_count, set last_run_at to now
PROMPTEOF
)

info "Prompt built ($(echo "$PROMPT" | wc -c | tr -d ' ') chars)."

# ─── Run Claude ────────────────────────────────────────────────────────────
info "Starting Claude for ${AGENT_NAME}..."
echo "────────────────────────────────────────"

eval "echo \"\$PROMPT\" | claude ${AUTO_FLAG} --print -p -"
CLAUDE_EXIT=$?

echo "────────────────────────────────────────"
if [[ $CLAUDE_EXIT -ne 0 ]]; then
  warn "Claude exited with code ${CLAUDE_EXIT}"
else
  ok "Agent run complete."
fi

echo ""
echo "========================================"
echo " ${AGENT_NAME} finished — $(date)"
echo "========================================"
