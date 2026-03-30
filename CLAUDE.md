# AI Integraterz — Claude Code Configuration

## What This Repo Is

The AI Integraterz core system. Takes a business extraction call and builds:
- Custom AI training for every role in the business
- Owner/founder personal AI game plan
- Company adoption document and toolkit
- Role-specific Claude Code configs and workflows
- VA training guide
- Self-install delivery package

Optionally pulls in:
- `expert-series-v3` — Titans Council + Content Multiplier
- `gtm-company` — Full autonomous GTM deployment

## Session Start

Run `/project-main` at the start of every session for a repo health brief.

## NEVER

- Auto-send emails or messages — always draft first
- Modify client deliverables after confirmation without asking
- Skip the extraction phase — it powers everything downstream
- Delete state files — they contain session history
- Hardcode client data — use templates + config injection

## ALWAYS

- Read `config/project.json` before any agent run
- Write agent output to `outputs/<agent>/<client-id>/`
- Log every run to `state/<agent>/last-run.json`
- Use `lib/run-agent.sh <agent-name>` to trigger any agent
- Check `.env` for API keys before running — fail loudly if missing

## MUST

- One client = one config file in `config/clients/<client-id>.json`
- Every deliverable gets a corresponding entry in `state/training-builder/pipeline.json`
- All templates in `templates/` are the source of truth — never edit outputs directly

## Workflow

1. Run extraction agent → populates `config/clients/<id>.json`
2. Run training-builder agent → generates all deliverables from client config
3. Run coaching-setup agent → sets up $300/mo seat tracking and schedules
4. Optional: run expert-series agent or gtm-deploy agent for upsells
5. Package deliverables → `lib/package-delivery.sh <client-id>`

## Tool Permissions

- Read/Write/Edit: all directories
- Bash: lib/ scripts only — do not run arbitrary shell commands
- MCP: Gmail (draft only), Slack (send allowed), ClickUp, Calendar, Notion

## Key Files

- `config/project.json` — global project config
- `config/clients/` — one JSON per client
- `agents/` — agent playbooks (markdown)
- `lib/run-agent.sh` — agent runner
- `templates/` — all output templates
- `state/` — per-agent run state
- `outputs/` — all client deliverables
- `.env.example` — required environment variables
