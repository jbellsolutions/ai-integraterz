# AI Integraterz — Level 2 Persistent Agent

## What This Is
The `.agent/` directory contains the Level 2 persistent agent for AI Integraterz. Unlike Level 1 (Claude Code sessions), the Level 2 agent maintains state across sessions and can run autonomously.

## Files
- `identity.json` — Project identity, key components, entry points, fragile areas
- `state.json` — Cross-session state: sessions count, clients processed, observations, patterns
- `agent.py` — Persistent Python agent (requires `pip install anthropic`)
- `README.md` — This file

## To Start the Level 2 Agent
```bash
cd /Users/home/Desktop/ai-integraterz/.agent
pip install anthropic
python agent.py
```

## What the Level 2 Agent Does
- Monitors client pipeline every 30 minutes
- Sends Justin a daily brief via Slack
- Detects blocked clients and escalates
- Learns patterns from successful runs
- Maintains cross-session context

## Level 1 (Claude Code) vs Level 2 (Persistent)
| | Level 1 | Level 2 |
|---|---|---|
| Trigger | Manual (you run it) | Autonomous (cron) |
| State | Per-session | Cross-session |
| Requires | Claude Code open | Python running in background |
| Use for | Building deliverables | Monitoring + orchestration |
