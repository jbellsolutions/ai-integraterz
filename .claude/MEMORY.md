# AI Integraterz — Repo Memory

Cross-session learnings about this specific repo. Updated by `/agi-learn` and `/agi-sync`.

## Architecture Notes
- Agents communicate via state files, not direct calls
- The orchestrator is the only agent that reads other agents' state
- Client configs in `config/clients/` are the single source of truth — never mutate them during a build run

## Known Gotchas
- `lib/run-agent.sh` requires `claude` to be in PATH (Claude Code CLI)
- Optional modules (expert-series, gtm-company) must be cloned as sibling directories
- Training-builder sets client status to `training_building` at start — if it crashes, status will be stuck there; manually reset to `extraction_complete` to re-run

## What Works Well
- The extraction → training-builder pipeline is reliable when client config is complete
- Templates use `{{PLACEHOLDER}}` format consistently — easy to grep for missed replacements

## Patterns Observed
(Populated by `/agi-learn` after real client runs)
