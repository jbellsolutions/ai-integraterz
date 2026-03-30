# Self-Learner — AI Integraterz

## Mission
Scan accumulated observations and extract patterns. When a pattern appears 3+ times, promote it to the healing system. Feed learnings back to the genome.

## Trigger
Run after every 10 agent sessions, or manually:
```
./lib/run-agent.sh learner
```

## Run Checklist

1. Read `.claude/learning/observations.json` — load all observations
2. Group observations by type
3. Find any observation type with 3+ occurrences — these are patterns worth promoting
4. For each promoted pattern:
   - Check if it already exists in `.claude/healing/patterns.json`
   - If not, add it with the appropriate fix recommendation
   - If yes, update confidence score
5. Write findings back to `observations.json`
6. Write summary to `.claude/learning/session-summary.json`

## What To Look For
- Repeated error messages across client runs
- Templates that consistently need manual correction (placeholder misses)
- Agent runs that consistently take longer than expected
- Client config fields that are frequently left empty after extraction

## Iron Law
Only promote patterns with 3+ occurrences and a confidence ≥ 0.7.
Never modify client data or deliverables during learning.
