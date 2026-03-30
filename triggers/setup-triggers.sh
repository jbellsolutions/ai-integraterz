#!/usr/bin/env bash
# setup-triggers.sh — Install cron jobs for AI Integraterz autonomous agents
# Usage: ./triggers/setup-triggers.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="$REPO_ROOT/lib/run-agent.sh"
LOG_DIR="$REPO_ROOT/logs"
mkdir -p "$LOG_DIR"

echo "Setting up AI Integraterz cron triggers..."

# Build cron entries
CRON_ORCHESTRATOR="*/30 8-21 * * 1-5 $RUNNER orchestrator >> $LOG_DIR/orchestrator.log 2>&1"
CRON_MORNING="0 8 * * 1-5 $RUNNER orchestrator >> $LOG_DIR/morning-brief.log 2>&1"
CRON_EVENING="0 20 * * 1-5 $RUNNER orchestrator >> $LOG_DIR/evening-brief.log 2>&1"

# Add to crontab (preserving existing entries)
(crontab -l 2>/dev/null | grep -v "ai-integraterz"; echo "# AI Integraterz"; echo "$CRON_ORCHESTRATOR"; echo "$CRON_MORNING"; echo "$CRON_EVENING") | crontab -

echo "Cron triggers installed:"
echo "  Orchestrator heartbeat: every 30 min, 8am-9pm Mon-Fri"
echo "  Morning brief: 8am Mon-Fri"
echo "  Evening brief: 8pm Mon-Fri"
echo ""
echo "Logs will appear in: $LOG_DIR/"
echo ""
echo "To view current crontab: crontab -l"
echo "To remove triggers: crontab -e (then delete the AI Integraterz lines)"
