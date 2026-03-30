#!/usr/bin/env bash
# package-delivery.sh — Package client outputs into delivery repo
# Usage: ./lib/package-delivery.sh <client-id>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CLIENT_ID="${1:?Usage: package-delivery.sh <client-id>}"
OUTPUTS_DIR="$PROJECT_ROOT/outputs/${CLIENT_ID}"
DELIVERY_DIR="$OUTPUTS_DIR/delivery-repo"

echo "========================================"
echo " Packaging delivery for: ${CLIENT_ID}"
echo " $(date)"
echo "========================================"

if [[ ! -d "$OUTPUTS_DIR" ]]; then
  echo "[ERROR] Output directory not found: ${OUTPUTS_DIR}" >&2
  exit 1
fi

# Run delivery packager agent
"$SCRIPT_DIR/run-agent.sh" delivery-packager --client "$CLIENT_ID"

echo ""
echo "Delivery package ready at:"
echo "  ${DELIVERY_DIR}"
echo ""
echo "Next steps:"
echo "  1. Review DELIVERY-SUMMARY.md"
echo "  2. Zip the delivery-repo folder"
echo "  3. Send to client with welcome email"
