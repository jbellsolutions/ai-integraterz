# AI Integraterz — Agents

## System Overview

AI Integraterz runs on 14 agents. Each is a Claude Code playbook in `agents/`. All run through `lib/run-agent.sh`. Agents do not call each other directly — they communicate via state files and the orchestrator.

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

### automation-mapper *(P1 Gap #1)*
**File:** `agents/automation-mapper.md`
**Schedule:** Pre-call (run before or during the One-Hour Game Plan call)
**Trigger:** `./lib/run-agent.sh automation-mapper --client <id> [--pre-call]`
**Role:** Runs the Automation Priority Matrix LIVE on the call. Scores workflow candidates, identifies top 3 automations, captures owner quotes for voice-matching, feeds ranked list into extraction config.
**Reads:** `config/clients/<id>.json` (pre-call info)
**Writes:** `outputs/<id>/call-prep/Automation-Priority-Matrix-[name].md`, appends `automation_priorities[]` to client config
**Hands off to:** `extraction` (feeds ranked automations into the build)

---

### contract-generator *(P1 Gap #2)*
**File:** `agents/contract-generator.md`
**Schedule:** Auto-triggered after `extraction_complete`
**Trigger:** `./lib/run-agent.sh contract-generator --client <id>`
**Role:** Generates complete SOW + Mutual NDA from client config. Zero manual editing required. Outputs ready-to-send Markdown.
**Reads:** `config/clients/<id>.json` (tier, pricing, owner info, team size)
**Writes:** `outputs/<id>/contracts/SOW-NDA-[name]-[date].md`
**Hands off to:** Justin (reviews + sends for signature)

---

### integrator-onboarding *(P1 Gap #3)*
**File:** `agents/integrator-onboarding.md`
**Schedule:** Auto-triggered after `training_complete`
**Trigger:** `./lib/run-agent.sh integrator-onboarding --client <id>`
**Role:** Trains and certifies the AI Integrator (internal champion or placed by Justin's team). Produces Profile Sheet, Certification Track, and Weekly Reporting Template.
**Reads:** `config/clients/<id>.json`, `outputs/<id>/` (all built deliverables)
**Writes:** `outputs/<id>/integrator/` (3 files)
**Hands off to:** Integrator (self-directed 30-day track), Justin (if placed integrator needed)

---

### 30-day-checkpoint *(P2 Gap #5)*
**File:** `agents/30-day-checkpoint.md`
**Schedule:** Auto-triggered at Day 30 post-delivery
**Trigger:** `./lib/run-agent.sh 30-day-checkpoint --client <id>` or `--response` flag for processing replies
**Role:** Sends check-in email to owner at Day 30. Collects wins data. Generates internal summary with upsell signals and pre-populated ROI data for the 90-day report.
**Reads:** `config/clients/<id>.json`, `state/orchestrator/client-pipeline.json`
**Writes:** `outputs/<id>/checkpoints/` (email + summary), updates client config + pipeline state
**Hands off to:** `roi-report` (feeds data at Day 90)

---

### roi-report *(P2 Gap #6)*
**File:** `agents/roi-report.md`
**Schedule:** Auto-triggered at Day 90 post-delivery
**Trigger:** `./lib/run-agent.sh roi-report --client <id>`
**Role:** Generates client-facing 90-Day ROI Card + internal version. Calculates hours saved, annual value, ROI multiplier. Drives case study candidates and expansion pitches.
**Reads:** `config/clients/<id>.json`, wins log, 30-day summary, pipeline state
**Writes:** `outputs/<id>/reports/` (client + internal versions), `state/case-studies/candidates.json`
**Hands off to:** Justin (reviews + sends to client, pitches expansion)

---

### client-slack-setup *(P2 Gap #7)*
**File:** `agents/client-slack-setup.md`
**Schedule:** Auto-triggered immediately after `extraction_complete`
**Trigger:** `./lib/run-agent.sh client-slack-setup --client <id> [--update <event>]`
**Role:** Creates private Slack channel per client. Posts onboarding summary. Posts milestone updates throughout the engagement lifecycle.
**Reads:** `config/clients/<id>.json`, pipeline state
**Writes:** Slack channel (via API), stores channel ID in client config + pipeline state
**External:** Slack API (SLACK_BOT_TOKEN required)
**Hands off to:** All agents (milestone updates post here automatically)

---

## Handoff Protocol

```
Pre-call research
    └──► automation-mapper (Justin triggers before/during call)
              └──► Justin's One-Hour Game Plan call
                        └──► extraction (manual trigger by Justin)
                                  └──► contract-generator (auto)
                                  └──► client-slack-setup (auto)
                                  └──► [Justin reviews config]
                                            └──► training-builder (manual trigger)
                                                      └──► integrator-onboarding (auto)
                                                      └──► delivery-packager (auto or manual)
                                                                └──► [Justin sends to client]
                                                                          └──► coaching-setup (manual trigger)
                                                                                    └──► orchestrator (monitors ongoing)
                                                                                              └──► 30-day-checkpoint (auto, Day 30)
                                                                                                        └──► roi-report (auto, Day 90)
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
