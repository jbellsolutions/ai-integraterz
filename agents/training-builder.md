# Training Builder Agent — AI Integraterz

## Mission
Take a completed client config and build every deliverable in the AI Integraterz Training Package. This is the core production agent — it turns the extraction into the full $997 delivery.

## Trigger
```bash
./lib/run-agent.sh training-builder --client <client-id>
```

## Prerequisites
- `config/clients/<client-id>.json` exists with status `extraction_complete`
- Templates in `templates/` are present
- Output directory `outputs/<client-id>/` will be created

## Run Checklist

### Phase 0: Setup
1. Read `config/clients/<client-id>.json` — load all client data
2. Read `config/project.json` for global settings
3. Read `config/thresholds.json` for limits
4. Create output directory: `outputs/<client-id>/`
5. Create subdirs: `owner/`, `company/`, `roles/`, `va/`, `toolkit/`, `self-install/`
6. Update client pipeline status to `training_building`

### Phase 1: Owner Track
7. Read `templates/owner/game-plan.md`
8. Populate with client owner data:
   - Personalized opening using owner name and business name
   - Their specific role (CEO / Founder / etc.)
   - Their stated main problem → AI solution mapped to it
   - Top 5 AI uses built specifically for their daily tasks (from extraction)
   - Claude Code setup guide for their role
   - CLAUDE.md config written for their specific responsibilities
   - Executive AI dashboard template
9. Write to `outputs/<client-id>/owner/AI-Game-Plan-[OwnerName].md`

### Phase 2: Company Track
10. Read `templates/company/adoption-document.md`
11. Populate with company data:
    - Company name throughout
    - Current tools → AI-augmented version of each
    - Team rollout sequence (phase 1: owner, phase 2: managers, phase 3: whole team)
    - AI governance policy (how decisions get made, what requires human approval)
    - Company-wide toolkit recommendations for their industry
12. Write to `outputs/<client-id>/company/Company-AI-Adoption-[BusinessName].md`

13. Read `templates/company/toolkit.md`
14. Populate with industry-specific tools and Claude Code setups
15. Write to `outputs/<client-id>/toolkit/Company-AI-Toolkit-[BusinessName].md`

### Phase 3: Role-Specific Tracks
16. For EACH role in `client.roles`:
    a. Read `templates/roles/role-training.md`
    b. Populate with this specific role's data:
       - Role title and person's name
       - Their daily tasks → AI-augmented versions
       - Their pain points → AI solutions for each
       - Custom CLAUDE.md config for their responsibilities
       - 5 most valuable slash commands for their role (written out)
       - 3 automated workflows using their actual tools
       - Practice exercises using language from their industry
       - Performance benchmarks (before/after expectations)
    c. Write to `outputs/<client-id>/roles/Training-[RoleTitle].md`
    d. Write CLAUDE.md config to `outputs/<client-id>/roles/CLAUDE-[RoleTitle].md`

### Phase 4: VA Training Guide
17. Read `templates/va/va-guide.md`
18. Populate with client context:
    - Company name, industry, key contacts
    - How the company operates
    - Tasks the VA should own
    - Escalation paths
    - Tools they'll use
    - Communication standards
19. Write to `outputs/<client-id>/va/VA-Training-Guide-[BusinessName].md`

### Phase 5: Claude Certification Bundle
20. Copy `templates/course/claude-certification.md` to `outputs/<client-id>/certification/`
21. Update with client-specific examples drawn from their industry and roles

### Phase 6: Self-Install Repo
22. Create `outputs/<client-id>/self-install/README.md` — the walkthrough guide
23. Write step-by-step install instructions using THEIR specific setup
24. Copy all CLAUDE.md configs into `outputs/<client-id>/self-install/configs/`
25. Write `outputs/<client-id>/self-install/SETUP.md` — one command to rule them all:
    ```
    Tell Claude Code: "Read SETUP.md and set everything up for me"
    ```

### Phase 7: Delivery Summary
26. Write `outputs/<client-id>/DELIVERY-SUMMARY.md`:
    - What's in each folder
    - How to use each piece
    - Recommended order to go through everything
    - Next steps (coaching onboarding)
    - Justin's contact info

### Phase 8: Update State
27. Update `state/training-builder/pipeline.json` with this client and all deliverables generated
28. Update `state/orchestrator/client-pipeline.json` → status `training_complete`
29. Write `state/training-builder/last-run.json`

### Phase 9: Notify
30. Post to Slack #ai-integraterz-ops:
    - Client name and deliverables count
    - What was built (role tracks, pages generated)
    - Ready for packaging: `./lib/package-delivery.sh <client-id>`
    - Any gaps flagged during build

## Output Structure
```
outputs/<client-id>/
├── DELIVERY-SUMMARY.md
├── owner/
│   └── AI-Game-Plan-[Name].md
├── company/
│   └── Company-AI-Adoption-[Business].md
├── toolkit/
│   └── Company-AI-Toolkit-[Business].md
├── roles/
│   ├── Training-CEO.md
│   ├── CLAUDE-CEO.md
│   ├── Training-SalesManager.md
│   └── CLAUDE-SalesManager.md (etc.)
├── va/
│   └── VA-Training-Guide-[Business].md
├── certification/
│   └── Claude-Certification.md
└── self-install/
    ├── README.md
    ├── SETUP.md
    └── configs/
        └── (all CLAUDE.md files)
```

## Safety Rails
- Never fabricate client data — use only what's in the config
- If a required template is missing, log the error and skip that section
- Flag any role with fewer than 2 daily tasks — needs more extraction
- Mark status `training_building` while running — prevents duplicate runs
