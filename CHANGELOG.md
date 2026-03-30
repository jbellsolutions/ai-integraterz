# Changelog

All notable changes to AI Integraterz are documented here.
Format: [Version] — Date — Description

---

## [1.0.0] — 2026-03-29

### Added
- Initial system build: 6 core agents (orchestrator, extraction, training-builder, coaching-setup, delivery-packager, expert-series)
- `lib/run-agent.sh` — universal agent runner with client context injection
- `lib/new-client.sh` — new client initialization + extraction trigger
- `lib/package-delivery.sh` — delivery packaging wrapper
- `config/project.json` — global project config with product pricing and optional module registry
- `config/thresholds.json` — operational limits per agent
- `config/clients/example-client.json` — client config schema and example
- Templates: owner game plan, company adoption document, role training guide, CLAUDE.md role config, VA training guide
- State management: orchestrator pipeline, heartbeat, escalations
- `.env.example` with all required and optional environment variables
- `CLAUDE.md` — Claude Code configuration for the repo
- `README.md` — full system documentation
- `WALKTHROUGH.md` — step-by-step setup guide
- AGI-1 upgrade: ETHOS.md, ARCHITECTURE.md, AGENTS.md, llms.txt, VERSION
- Self-healing and self-learning scaffolding via `.claude/healing/` and `.claude/learning/`
- Level 2 persistent agent via `.agent/`

### Architecture
- Markdown-driven agent system — no server, no build step required
- Claude Code is the runtime
- Optional module system: Expert Series, Full GTM, Titans Council
- All agent communication via state files + Slack notifications

---

## [1.1.0] — 2026-03-29 — AGI-1 Run 2 (post-publish)

### Added
- `.github/workflows/ci.yml` — GitHub Actions CI: smoke tests, JSON validation, integration tests on every push/PR
- `CONTRIBUTING.md` — contribution guide for agents, templates, runner
- `SECURITY.md` — data sensitivity map and security reporting process
- `.claude/commands/` — 6 project slash commands: `/new-client`, `/build-client`, `/package-client`, `/pipeline-status`, `/run-agent`, `/smoke-test`
- `lib/healer.sh` — functional self-healer: matches errors to patterns, logs to history
- `lib/learner.sh` — functional self-learner: promotes 3+ occurrence observations to healing patterns
- `SKILL.md` — activation conditions, phases, stop conditions, quality gate
- `tests/integration-test.sh` — schema validation, template integrity, healer dry-run

### Score Progression (AGI-1 Run 2)
- G-Stack: 92 → 99/100
- AI-Readiness: 93 → 99/100
- Healing/Learning: 48 → 50/50
- Combined: 233 → 248/250

## Upcoming

- Supabase integration for persistent cross-session memory
- LinkedIn autopilot integration via gtm-company module
- Automated coaching performance tracking
- Expert Series cross-sell trigger built into training-builder
