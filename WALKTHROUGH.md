# AI Integraterz — Setup Walkthrough

> **To install:** Open Claude Code in this folder and type `set this up for me` or `/walkthrough`

---

## What You're Setting Up

This repo is the AI Integraterz production system. It takes a discovery call with a business owner and builds their complete AI training infrastructure automatically.

---

## Prerequisites

Before you begin:

- [ ] **Claude Code** installed — [claude.ai/code](https://claude.ai/code)
- [ ] **Node.js** v18+ — `node --version`
- [ ] **Anthropic API key** — [console.anthropic.com](https://console.anthropic.com)
- [ ] **Slack Bot Token** (for agent notifications) — optional but recommended
- [ ] **jq** installed for JSON processing — `brew install jq`

---

## Step 1: Clone the Repo

```bash
cd ~/Desktop
git clone https://github.com/jbellsolutions/ai-integraterz
cd ai-integraterz
```

---

## Step 2: Set Up Environment

```bash
cp .env.example .env
```

Open `.env` and fill in:

```bash
ANTHROPIC_API_KEY=sk-ant-your-key-here
SLACK_BOT_TOKEN=xoxb-your-token          # optional
SLACK_USER_JUSTIN=U01D077J78S            # optional
```

Everything else in `.env` is optional for the core system to run.

---

## Step 3: Make Scripts Executable

```bash
chmod +x lib/*.sh
```

---

## Step 4: Verify Setup

```bash
# Check Claude Code is installed
claude --version

# Check jq is available
jq --version

# Check the config is valid
cat config/project.json | jq '.'
```

---

## Step 5: Run Your First Client

### Option A: From a Call Transcript

After Justin's discovery call, drop the transcript or notes into the project:

```bash
# Initialize new client + run extraction
./lib/new-client.sh acme-consulting --transcript ~/Desktop/acme-call-notes.txt
```

### Option B: Fill In Config Manually

```bash
# Copy the example config
cp config/clients/example-client.json config/clients/acme-consulting.json

# Edit with the client's details
# Then run extraction to validate and complete it
./lib/run-agent.sh extraction --client acme-consulting
```

---

## Step 6: Build All Deliverables

```bash
./lib/run-agent.sh training-builder --client acme-consulting
```

This generates everything in `outputs/acme-consulting/`:
- Owner game plan
- Company adoption document
- Role-specific training tracks
- CLAUDE.md configs per role
- VA training guide
- Self-install package

---

## Step 7: Package for Delivery

```bash
./lib/package-delivery.sh acme-consulting
```

The delivery repo lands at:
```
outputs/acme-consulting/delivery-repo/
```

ZIP it and send to the client. The client opens it, tells Claude Code "set this up for me", and Claude Code installs everything.

---

## Step 8: Set Up Coaching

After delivery is sent:

```bash
./lib/run-agent.sh coaching-setup --client acme-consulting
```

This creates calendar invites for coaching sessions and ClickUp tasks for the 30-day bootcamp.

---

## Daily Operations

### Monitor All Clients
```bash
./lib/run-agent.sh orchestrator
```

### Add Expert Series (cross-sell)
First, clone the Expert Series repo as a sibling:
```bash
cd ~/Desktop
git clone https://github.com/jbellsolutions/expert-series-v3
```

Then enable it in `config/project.json` and run:
```bash
./lib/run-agent.sh expert-series --client acme-consulting
```

### Add Full GTM Deployment (upsell)
```bash
cd ~/Desktop
git clone https://github.com/jbellsolutions/gtm-company
```

Enable in `config/project.json` and configure per the gtm-company README.

---

## Troubleshooting

**Agent fails immediately:** Check `.env` has `ANTHROPIC_API_KEY` set.

**"Playbook not found":** Agent name typo. Run `ls agents/` to see all agents.

**"Client config not found":** Run extraction first, or check `config/clients/<id>.json` exists.

**Claude Code not found:** Install from [claude.ai/code](https://claude.ai/code).

---

## File Reference

| File | What to edit |
|------|-------------|
| `.env` | API keys and tokens |
| `config/project.json` | Enable optional modules, update pricing |
| `config/thresholds.json` | Adjust operational limits |
| `config/clients/<id>.json` | Per-client configuration |
| `agents/<name>.md` | Change what an agent does |
| `templates/**/*.md` | Change the output format/content |
