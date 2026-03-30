# AI Integraterz — Agents

## System Overview

AI Integraterz runs on 6 agents. Each is a Claude Code playbook in `agents/`. All run through `lib/run-agent.sh`. Agents do not call each other directly — they communicate via state files and the orchestrator.

---

## Agent Roster

### orchestrator
**File:** `agents/orchestrator.md`
**Schedule:** Every 30 min (8am-9pm ET) + daily briefs (8am, 8pm)
**Trigger:** `./lib/run-agent.sh orchestrator`
**Role:** CEO of the system. Monitors all clients and agent health. Routes tasks. Sends Justin daily briefings via Slack.
**Reads:** `state/orchestrator/client-pipeline.json`, all agent `last-run.json` files
**Writes:** `state/orchestrator/last-heartbeat.json`, `state/orchestrator/escalations.json`
**Hands off to:** Any agent, via Slack notification or state file update

---

### extraction
**File:** `agents/extraction.md`
**Schedule:** On demand (after each discovery call)
**Trigger:** `./lib/run-agent.sh extraction --client <id> [--transcript <file>]`
**Role:** Turns call notes / transcripts into structured client config JSON. The first agent in every client's journey.
**Reads:** Call transcript or notes (injected via prompt), `config/clients/example-client.json`
**Writes:** `config/clients/<id>.json`, `state/extraction/last-run.json`
**Hands off to:** `training-builder` (after Justin reviews the config)

---

### training-builder
**File:** `agents/training-builder.md`
**Schedule:** On demand (after extraction review)
**Trigger:** `./lib/run-agent.sh training-builder --client <id>`
**Role:** Core production agent. Reads client config and builds every deliverable in the $997 training package.
**Reads:** `config/clients/<id>.json`, all files in `templates/`
**Writes:** `outputs/<id>/owner/`, `outputs/<id>/company/`, `outputs/<id>/roles/`, `outputs/<id>/va/`, `outputs/<id>/certification/`, `outputs/<id>/self-install/`, `state/training-builder/pipeline.json`
**Hands off to:** `delivery-packager`

---

### delivery-packager
**File:** `agents/delivery-packager.md`
**Schedule:** On demand (after training-builder completes)
**Trigger:** `./lib/run-agent.sh delivery-packager --client <id>` or `./lib/package-delivery.sh <id>`
**Role:** Quality-checks all outputs, organizes them into a numbered delivery repo structure, writes the client-facing README and SETUP.md.
**Reads:** `outputs/<id>/` (all training-builder outputs), `state/training-builder/pipeline.json`
**Writes:** `outputs/<id>/delivery-repo/` (the final client package)
**Hands off to:** Justin (manual review + delivery)

---

### coaching-setup
**File:** `agents/coaching-setup.md`
**Schedule:** On demand (after delivery is sent)
**Trigger:** `./lib/run-agent.sh coaching-setup --client <id>`
**Role:** Sets up the $300/mo/seat coaching program. Creates calendar invites, ClickUp tasks, and coaching welcome package.
**Reads:** `config/clients/<id>.json`
**Writes:** `outputs/<id>/coaching/`, `state/coaching-setup/active-clients.json`
**External:** Google Calendar (create recurring events), ClickUp (create tasks)
**Hands off to:** orchestrator (moves client to `active` status)

---

### expert-series
**File:** `agents/expert-series.md`
**Schedule:** On demand (cross-sell trigger)
**Trigger:** `./lib/run-agent.sh expert-series --client <id>`
**Role:** Cross-sell agent. Uses extraction data to run the Titans Council positioning process and generate the Content Multiplier output (32+ pieces).
**Reads:** `config/clients/<id>.json`, `../expert-series-v3/` (sibling repo, optional)
**Writes:** `outputs/<id>/expert-series/`
**Requires:** `config/project.json → optional_modules.expert_series.enabled: true`
**Hands off to:** Justin (manual review + delivery)

---

## Handoff Protocol

```
Justin's call
    └──► extraction (manual trigger by Justin)
              └──► [Justin reviews config]
                        └──► training-builder (manual trigger)
                                  └──► delivery-packager (auto or manual)
                                            └──► [Justin sends to client]
                                                      └──► coaching-setup (manual trigger)
                                                                └──► orchestrator (monitors ongoing)
```

Optional cross-sell at any point after extraction:
```
extraction ──► expert-series ──► [Justin reviews + delivers]
```

---

## Adding a New Agent

1. Create `agents/<name>.md` following the playbook format (Mission, Schedule, Prerequisites, Run Checklist, State File Format, Safety Rails)
2. Add to `config/project.json → agents[]`
3. Add to this file under Agent Roster
4. Add state directory: `mkdir -p state/<name>`
5. Test: `./lib/run-agent.sh <name> --client example-client`
