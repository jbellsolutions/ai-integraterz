# AI Integraterz

> **One call. Custom AI training built for your business. Your team producing more in 30 days — guaranteed.**

Built by Justin Bell | [usingaitoscale.com](https://usingaitoscale.com)

---

## What This Repo Does

AI Integraterz takes a single discovery call with a business owner and automatically builds:

- **Owner AI Game Plan** — personalized AI playbook for the founder/CEO
- **Company AI Adoption Document** — official how-we-use-AI guide for the org
- **Role-Specific Training Tracks** — custom Claude Code training for every role
- **CLAUDE.md Configs** — per-role AI assistant configurations
- **VA Training Guide** — onboarding guide for AI-enabled virtual assistants
- **Company Toolkit** — curated, configured AI tools for the industry
- **Self-Install Delivery Repo** — everything packaged for one-command setup

All from one extraction call. Delivered in 48 hours to 7 days.

---

## Quick Start

### For a New Client

```bash
# 1. Drop the call transcript into the project root
# 2. Run the extraction agent
./lib/new-client.sh <client-id> --transcript path/to/call-notes.txt

# 3. Review the generated config
cat config/clients/<client-id>.json

# 4. Build all deliverables
./lib/run-agent.sh training-builder --client <client-id>

# 5. Package for delivery
./lib/package-delivery.sh <client-id>
```

### Run Any Agent

```bash
./lib/run-agent.sh <agent-name> --client <client-id>
```

Available agents:
- `extraction` — Parse call notes into structured client config
- `training-builder` — Build all deliverables from client config
- `coaching-setup` — Set up coaching schedule and ClickUp tasks
- `delivery-packager` — Package outputs into client delivery repo
- `expert-series` — Run Titans Council + Content Multiplier (cross-sell)
- `orchestrator` — Monitor all clients and agent health

---

## Repo Structure

```
ai-integraterz/
├── agents/              # Agent playbooks (what each agent does)
│   ├── orchestrator.md
│   ├── extraction.md
│   ├── training-builder.md
│   ├── coaching-setup.md
│   ├── delivery-packager.md
│   └── expert-series.md
├── config/
│   ├── project.json     # Global project settings
│   ├── thresholds.json  # Operational limits per agent
│   └── clients/         # One JSON per client (generated from extraction)
│       └── example-client.json
├── lib/
│   ├── run-agent.sh     # Main agent runner
│   ├── new-client.sh    # New client initialization
│   └── package-delivery.sh
├── templates/           # Output templates (source of truth)
│   ├── owner/
│   ├── company/
│   ├── roles/
│   └── va/
├── state/               # Per-agent run state (auto-updated)
│   ├── orchestrator/
│   ├── extraction/
│   ├── training-builder/
│   └── coaching-setup/
├── outputs/             # Generated client deliverables
│   └── <client-id>/     # Everything for one client
├── .env.example         # Required environment variables
├── CLAUDE.md            # Claude Code configuration for this repo
└── WALKTHROUGH.md       # Step-by-step setup guide
```

---

## Optional Modules

These repos extend AI Integraterz with additional capability. Clone as sibling directories and enable in `config/project.json`.

| Module | Repo | What It Adds |
|--------|------|-------------|
| Expert Series | `jbellsolutions/expert-series-v3` | Titans Council positioning + Content Multiplier |
| Full GTM | `jbellsolutions/gtm-company` | Autonomous email SDR + LinkedIn + content engine |
| Titans Council | `jbellsolutions/titans-of-direct-response-mastermind-council` | 18-agent copywriter positioning system |

---

## Value Ladder

| Step | Product | Price |
|------|---------|-------|
| Free | Discovery Call (extraction) | $0 |
| 1 | AI Integraterz Training Package | $997 |
| 2 | Ongoing Coaching + Certification | $300/mo/seat |
| 3 | AI Integrator VA Placement | Setup + retainer |
| 4 | AI Operations Hub | $2,000 setup |
| 5 | Full GTM Deployment | $5K-$10K + $2K-$3.5K/mo |

---

## Setup

```bash
# Clone the repo
git clone https://github.com/jbellsolutions/ai-integraterz
cd ai-integraterz

# Copy and fill in environment variables
cp .env.example .env
# Edit .env with your API keys

# Make lib scripts executable
chmod +x lib/*.sh
```

See `WALKTHROUGH.md` for full step-by-step setup.

---

## Contact

**Justin Bell** | justin@usingaitoscale.com | [usingaitoscale.com](https://usingaitoscale.com)
