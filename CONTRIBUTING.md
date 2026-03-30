# Contributing to AI Integraterz

## The One Rule

**Never commit client data.** `config/clients/*.json` (except `example-client.json`) and `outputs/` are gitignored for a reason. If you see client data in a PR, reject it.

## Adding a New Agent

1. Create `agents/<name>.md` following this structure:
   - **Mission** — one sentence, what this agent does
   - **Schedule** — when it runs and how to trigger it
   - **Prerequisites** — what must exist before it runs
   - **Run Checklist** — numbered phases, each phase numbered steps
   - **State File Format** — what it writes to `state/<name>/last-run.json`
   - **Safety Rails** — what it will NEVER do

2. Add to `config/project.json → agents[]`

3. Add to `AGENTS.md` under Agent Roster

4. Create `state/<name>/` directory

5. Add to `tests/smoke-test.sh` agent playbook check

6. Run `bash tests/smoke-test.sh` — all must pass

## Adding a New Template

1. Add to `templates/<category>/<name>.md`
2. Use `{{UPPER_SNAKE_CASE}}` for all placeholders
3. Add a corresponding build step in `agents/training-builder.md`
4. Add to `tests/smoke-test.sh` template check

## Editing the Runner (`lib/run-agent.sh`)

This affects every agent. Test with at least one agent before merging:
```bash
./lib/run-agent.sh orchestrator
```

## Commit Style

```
<type>: <short description>

Types: feat, fix, docs, test, refactor, chore
```

Examples:
- `feat: add linkedin-agent playbook`
- `fix: handle missing client config gracefully in extraction`
- `docs: update WALKTHROUGH with Supabase setup steps`

## Running Tests

```bash
bash tests/smoke-test.sh
```

All 43 checks must pass before any PR merges.
