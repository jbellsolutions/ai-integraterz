# AI Integraterz — Cursor Rules

## What This Repo Is
Agent-based business AI training system. Agents are markdown playbooks in `agents/`. Templates in `templates/`. Per-client config in `config/clients/`.

## Never Edit
- `config/clients/*.json` directly during a build — use extraction agent
- `outputs/` directory directly — always regenerate via training-builder
- `.env` — contains secrets

## Always
- Check `config/clients/example-client.json` as the schema before editing any client config
- Run `tests/smoke-test.sh` after any structural changes
- Update CHANGELOG.md when adding new agents or templates

## Patterns
- Placeholders in templates use `{{UPPER_SNAKE_CASE}}` format
- Agent playbooks follow: Mission → Schedule → Prerequisites → Run Checklist → State File Format → Safety Rails
- All agent output paths: `outputs/<client-id>/<category>/`
