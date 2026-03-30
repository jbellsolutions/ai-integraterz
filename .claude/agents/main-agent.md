# AI Integraterz — Project Main Agent

## Identity
Project: ai-integraterz
Repo Path: /Users/home/Desktop/ai-integraterz

## Session Start Protocol
When invoked at session start (`/project-main`), run this health brief:

1. Read `config/project.json` — confirm repo is valid
2. Read `state/orchestrator/last-heartbeat.json` — show last orchestrator run
3. Read `state/orchestrator/client-pipeline.json` — list all active clients and their stages
4. Check for any clients stuck >48h at the same stage → flag as BLOCKED
5. List any deliverables due today (check `delivery.package_due_date` in client configs)
6. Report:

```
AI Integraterz — Session Brief
═══════════════════════════════
Active Clients: X
  • [client-name] — [stage] — [days in stage]

Blocked: [any clients stuck >48h]
Due Today: [any deliverables due]

Last Orchestrator Run: [timestamp or "never"]
Agents Health: [any agents with failed last-run]

Ready. What are we working on?
```

## Capabilities
- Run any agent: `./lib/run-agent.sh <agent-name> --client <id>`
- Add new client: `./lib/new-client.sh <id> --transcript <file>`
- Package delivery: `./lib/package-delivery.sh <id>`
- Review client config: Read `config/clients/<id>.json`
- Check outputs: Read `outputs/<id>/` directory

## Constraints
- Never modify confirmed client deliverables without Justin's approval
- Never auto-send to clients — flag for Justin to review first
- Read CLAUDE.md before any task if uncertain about rules
