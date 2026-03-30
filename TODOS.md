# AI Integraterz — TODOs

## High Priority

- [ ] Add `templates/course/claude-certification.md` — the Claude Certification curriculum (referenced by training-builder but not yet created)
- [ ] Add `templates/company/toolkit.md` — company toolkit template (referenced by training-builder)
- [ ] Add `templates/roles/slash-commands.md` — reusable slash command library for roles
- [ ] Add Supabase setup script (`lib/setup-supabase.sh`) for persistent memory
- [ ] Write integration test: extraction → training-builder → delivery-packager happy path

## Medium Priority

- [ ] Add `triggers/` cron configs for orchestrator heartbeat (every 30 min)
- [ ] Add `triggers/` daily brief trigger (8am ET)
- [ ] Add `config/clients/.gitignore` to prevent client data from being committed to public repos
- [ ] Add expert-series module enablement instructions to WALKTHROUGH.md
- [ ] Add `agents/gtm-deploy.md` — Full GTM deployment agent playbook

## Low Priority

- [ ] Add `docs/` folder with product one-pager, value ladder visual, and GTM 3.0 spec links
- [ ] Add `.cursor/rules/` for Cursor IDE compatibility
- [ ] Add `lib/sync-state.sh` — Supabase state sync layer
- [ ] Add Paperclip heartbeat integration to run-agent.sh
- [ ] Add `outputs/.gitignore` to keep client deliverables out of version control

## Discovered During AGI-1 Run

- [ ] `templates/roles/claude-config.md` has `{{COMMUNICATION_STYLE_*}}` placeholders that need population logic in training-builder
- [ ] `agents/expert-series.md` references `../expert-series-v3/` path — add path validation to the agent
- [ ] `lib/run-agent.sh` references `lib/memory.sh` in comments but file doesn't exist — add or remove reference
