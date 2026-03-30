# AI Integraterz — SKILL.md

## What This Repo Does

Transforms a business discovery call into a complete AI training infrastructure. One 30-60 minute extraction call → owner game plan, company adoption doc, role-specific training tracks, CLAUDE.md configs, VA guide, company toolkit, and a self-installing delivery repo — all within 7 days.

## Iron Law

**Never deliver a client package with unreplaced placeholders.** The delivery-packager agent scans for `{{` in all outputs before packaging. If found, it halts and alerts Justin.

## Activation

This skill activates when:
- Someone says "new client" or provides a call transcript
- Someone asks to "build" or "package" a client
- Someone asks about the pipeline status
- Someone runs `/new-client`, `/build-client`, `/package-client`

## Phases

### Phase 1: Extraction
- Input: call notes or transcript
- Output: `config/clients/<id>.json`
- Command: `./lib/new-client.sh <id> --transcript <file>`

### Phase 2: Build
- Input: `config/clients/<id>.json`
- Output: `outputs/<id>/` (all deliverables)
- Command: `./lib/run-agent.sh training-builder --client <id>`

### Phase 3: Package
- Input: `outputs/<id>/`
- Output: `outputs/<id>/delivery-repo/` (self-install ZIP)
- Command: `./lib/package-delivery.sh <id>`

### Phase 4: Coaching
- Input: confirmed seat count in client config
- Output: calendar invites, ClickUp tasks, coaching welcome package
- Command: `./lib/run-agent.sh coaching-setup --client <id>`

## Stop Conditions

- Do not proceed past extraction if required fields are missing from client config
- Do not proceed past build if `{{` placeholders remain in outputs
- Do not send anything to clients — Justin reviews first

## Quality Gate

Before any delivery:
1. `bash tests/smoke-test.sh` — all 43 checks must pass
2. delivery-packager quality check — no `{{` in outputs
3. Justin reviews DELIVERY-SUMMARY.md

## Success Criteria

Client receives their package, opens Claude Code, and types "set this up for me." Claude Code installs everything. Client is live within one session.
