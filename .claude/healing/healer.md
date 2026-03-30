# Self-Healer — AI Integraterz

## Mission
When an error is detected in an agent run, match it against known patterns in `patterns.json` and apply the documented fix automatically.

## Trigger
Invoked by the orchestrator when an agent run shows `status: failed` in its `last-run.json`.

## Run Checklist

1. Read `state/<failed-agent>/last-run.json` — get the error message
2. Read `.claude/healing/patterns.json` — load all known patterns
3. Match the error message against each pattern's `trigger` field
4. If match found:
   - Apply the documented `fix`
   - Increment the pattern's `occurrences` counter
   - Log the healing action to `.claude/healing/history.json`
   - Notify Justin via Slack: "Auto-healed: [agent] — applied fix: [fix description]"
5. If no match found:
   - Log the unknown error to `.claude/healing/history.json` as `unmatched`
   - Notify Justin: "Unknown error in [agent] — needs manual review: [error]"

## State Files
- `.claude/healing/patterns.json` — known patterns (read + update occurrences)
- `.claude/healing/history.json` — audit log of all healing actions

## Iron Law
Never delete an agent's state file. Never overwrite a client config. Only apply documented fixes from patterns.json.
