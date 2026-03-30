#!/usr/bin/env bash
# new-client.sh — Initialize a new client from a discovery call
# Usage: ./lib/new-client.sh <client-id> [--transcript <file>]
#
# Creates the client config stub and runs extraction.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CLIENT_ID="${1:?Usage: new-client.sh <client-id> [--transcript <file>]}"
TRANSCRIPT_FILE=""
shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --transcript) TRANSCRIPT_FILE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

CLIENT_FILE="$PROJECT_ROOT/config/clients/${CLIENT_ID}.json"

if [[ -f "$CLIENT_FILE" ]]; then
  echo "[WARN] Client config already exists: ${CLIENT_FILE}"
  echo "       Delete it first or use a different client-id."
  exit 1
fi

echo "========================================"
echo " New Client: ${CLIENT_ID}"
echo " $(date)"
echo "========================================"

# Copy example template as stub
cp "$PROJECT_ROOT/config/clients/example-client.json" "$CLIENT_FILE"
# Set the client_id in the stub
if command -v jq &>/dev/null; then
  tmp=$(mktemp)
  jq --arg id "$CLIENT_ID" '.client_id = $id | .status = "pending"' "$CLIENT_FILE" > "$tmp"
  mv "$tmp" "$CLIENT_FILE"
fi

echo "[OK] Client stub created: ${CLIENT_FILE}"
echo ""
echo "Running extraction agent..."

TRANSCRIPT_ARG=""
[[ -n "$TRANSCRIPT_FILE" ]] && TRANSCRIPT_ARG="--transcript ${TRANSCRIPT_FILE}"

"$SCRIPT_DIR/run-agent.sh" extraction --client "$CLIENT_ID" $TRANSCRIPT_ARG

echo ""
echo "Extraction complete. Review ${CLIENT_FILE} then run:"
echo "  ./lib/run-agent.sh training-builder --client ${CLIENT_ID}"
