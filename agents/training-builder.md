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

### Phase 3: Role-Specific Tracks — The 10X Package Per Role
16. For EACH role in `client.roles`, produce THREE deliverables (the full 10X VA package):

   **Deliverable A: Custom AI Course** (per role)
    a. Read `templates/content/custom-course.md` (or `templates/roles/role-training.md` for the core training track)
    b. Build a multi-module training curriculum for this specific role:
       - Module 0: Company-wide foundation (shared across all roles)
       - Module for this role: uses their actual workflows, their actual tools, their actual language from the call
       - Each lesson: real task, real Claude prompt, real exercise with their data
       - Completion = Claude Code Certification for this role
    c. Write to `outputs/<client-id>/roles/Course-[RoleTitle].md`

   **Deliverable B: Custom Toolkit** (per role)
    a. Every AI tool this role will use, configured and ready
    b. Not a generic tool list — specific to what came up on the call for this role
    c. Pre-written prompts for their top 5 tasks
    d. MCP connections relevant to their tools (ClickUp, Gmail, Calendar as applicable)
    e. Custom CLAUDE.md config written for their specific responsibilities and workflow conventions
    f. 5 most valuable slash commands for their role (written out, copy-paste ready)
    g. Write CLAUDE.md to `outputs/<client-id>/roles/CLAUDE-[RoleTitle].md`
    h. Write toolkit to `outputs/<client-id>/roles/Toolkit-[RoleTitle].md`

   **Deliverable C: Custom Operating Manual** (per role)
    a. SOPs for every AI-enabled workflow this role runs (5-8 SOPs minimum)
    b. Each SOP: trigger → steps → Claude prompt → expected output → quality check → troubleshooting
    c. Daily habits: what to do every morning (1 specific habit, 1 prompt)
    d. Quick reference card: top 5 prompts + top 3 slash commands + "when stuck" fallbacks (print-ready)
    e. Performance benchmarks: before/after expectations for each major workflow
    f. Escalation path: who to ask when stuck (AI Integrator name + Justin contact)
    g. Write to `outputs/<client-id>/roles/OperatingManual-[RoleTitle].md`

   **Quality check per role:**
    - Course, Toolkit, and Operating Manual all produced (3 files per role minimum)
    - No `{{` placeholder tokens remain in any file
    - Role person's name appears correctly
    - Claude prompts are specific (reference their actual tasks, not generic examples)
    - Tools match what was mentioned in the call for this role

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
├── call-prep/
│   └── Call-Script-[BusinessName].md       ← Justin's pre-call reference (never sent to client)
├── owner/
│   └── AI-Game-Plan-[Name].md
├── company/
│   └── Company-AI-Adoption-[Business].md
├── toolkit/
│   └── Company-AI-Toolkit-[Business].md
├── roles/
│   ├── Course-[RoleTitle].md               ← Custom AI Course (10X Package A)
│   ├── Toolkit-[RoleTitle].md              ← Custom Toolkit (10X Package B)
│   ├── CLAUDE-[RoleTitle].md               ← CLAUDE.md config for this role
│   ├── OperatingManual-[RoleTitle].md      ← Custom Operating Manual (10X Package C)
│   └── (above 4 files repeated for each role)
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

**The 10X Package per role = Course + Toolkit + Operating Manual.** Three files per role, built from what the client said on the call, voice-matched, specific to their actual tasks. This is the full AI Integraterz deliverable — not generic training.

## Safety Rails
- Never fabricate client data — use only what's in the config
- If a required template is missing, log the error and skip that section
- Flag any role with fewer than 2 daily tasks — needs more extraction
- Mark status `training_building` while running — prevents duplicate runs
