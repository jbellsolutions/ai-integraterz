# Content Engine Agent — AI Integraterz

## Mission
After the training package is built and delivered, run the Content Engine to generate everything that makes the client's AI adoption self-sustaining: a custom course, role SOPs, quick reference cards, internal comms, newsletter system, adoption calendar, video scripts, and a 30-day team challenge. Everything is voice-matched to the client and built from their actual workflows.

This is the difference between handing someone a manual and building them a living system.

## Trigger
```bash
./lib/run-agent.sh content-engine --client <client-id>
```

Prompted automatically at the end of delivery-packager. Can also be run standalone at any time.

## Prerequisites
- `outputs/<client-id>/content-engine/00-Content-Strategy-[BusinessName].md` exists (run transcript-parser first)
- `config/clients/<client-id>.json` exists
- Training-builder outputs exist in `outputs/<client-id>/`
- If no content strategy doc: run `./lib/run-agent.sh transcript-parser --client <client-id> --transcript <file>` first

## The 9 Content Modules

| # | Module | What It Produces | Files |
|---|--------|-----------------|-------|
| 1 | Custom AI Course | Full multi-module training curriculum, role-specific | 1 |
| 2 | Role SOP Library | Step-by-step SOPs for every AI workflow per role | 1 per role |
| 3 | Quick Reference Cards | One-page cheat sheet per role (most-used prompts + commands) | 1 per role |
| 4 | Internal Newsletter System | 3 ready-to-send monthly AI update newsletters | 3 |
| 5 | Internal Comms Pack | Announcement email + 5-email team rollout sequence | 2 |
| 6 | 30-Day Adoption Calendar | Daily implementation schedule for rolling out AI | 1 |
| 7 | Video Training Scripts | One async training script per role | 1 per role |
| 8 | AI Adoption Challenge | 30-day team challenge with daily prompts + tracking | 1 |
| 9 | AI Wins Log | Template for documenting AI wins as they happen | 1 |

## Run Checklist

### Phase 0: Load Strategy
1. Read `outputs/<client-id>/content-engine/00-Content-Strategy-[BusinessName].md`
2. Read `config/clients/<client-id>.json`
3. Pull: business name, owner name, roles list, products purchased, key workflows
4. Every module below must align with the voice profile and themes in the strategy doc

---

### Phase 1: Custom AI Course
Read template: `templates/content/custom-course.md`

Build `outputs/<client-id>/content-engine/01-Custom-AI-Course-[BusinessName].md`

- Multi-module structure: one module per role + one owner module + one company-wide module
- Each module: overview, 3-5 lessons, exercises using their actual workflows, quiz questions
- Language: non-technical, matches client's voice from strategy doc
- References their actual tools, roles, and workflows throughout
- Includes a completion checklist and certification checkpoint

---

### Phase 2: Role SOP Library
Read template: `templates/content/sop-library.md`

For each role in `config.roles`:
Build `outputs/<client-id>/content-engine/02-SOPs-[RoleName].md`

Each SOP file contains:
- 5-8 SOPs for the most common AI-enabled workflows for that role
- Format: Trigger → Steps → Claude prompt to use → Expected output → Quality check
- Written for someone doing the workflow for the first time
- Includes "if this goes wrong" troubleshooting for each SOP

---

### Phase 3: Quick Reference Cards
Read template: `templates/content/quick-reference-cards.md`

For each role in `config.roles`:
Build `outputs/<client-id>/content-engine/03-QuickRef-[RoleName].md`

Each card (one page, designed to be printed or pinned):
- Top 5 Claude prompts for this role (copy-paste ready)
- Top 3 slash commands they'll use daily
- "When you're stuck" — 3 fallback prompts
- Daily AI habit (one thing to do every morning)
- Who to ask for help (Justin + the AI Integrator placed in Step 2)

---

### Phase 4: Internal Newsletter System
Read template: `templates/content/internal-newsletter.md`

Build `outputs/<client-id>/content-engine/04-Internal-Newsletter-[BusinessName].md`

Contains 3 ready-to-send monthly newsletters:
- **Issue 1 (Month 1):** "We're going AI — here's what that means for you" — rollout announcement, what's changing, what's not, first wins
- **Issue 2 (Month 2):** "[Business Name] AI Update — What's working, what we're building next" — highlight early wins, introduce new workflows, celebrate team adoption
- **Issue 3 (Month 3):** "Three months in — the numbers and what's next" — ROI summary, team spotlight, next phase preview

Each issue: ~400-600 words, written in the owner's voice, includes a "this week's AI tip" section

---

### Phase 5: Internal Comms Pack
Read template: `templates/content/internal-comms-pack.md`

Build `outputs/<client-id>/content-engine/05-Internal-Comms-[BusinessName].md`

Contains:
- **Announcement Email:** Owner → entire team. "We're implementing AI — here's the plan." Addresses concerns, sets expectations, builds excitement. (Not a memo — reads like the owner talking.)
- **Rollout Sequence (5 emails):**
  1. "Week 1: Your AI setup is ready — here's how to start" (links to their delivery package)
  2. "Week 2: Quick wins — share what's working" (prompt for first story)
  3. "Week 3: Your first SOP is live — use it this week"
  4. "Week 4: Check-in — what questions do you have?"
  5. "Month 1 wrap: Here's what we built together"

---

### Phase 6: 30-Day Adoption Calendar
Read template: `templates/content/adoption-calendar.md`

Build `outputs/<client-id>/content-engine/06-Adoption-Calendar-[BusinessName].md`

Daily schedule for rolling out AI across the company:
- Week 1: Owner setup + first wins
- Week 2: Role-by-role onboarding (one role per day)
- Week 3: SOP implementation + coaching sessions begin
- Week 4: Team challenge launch + performance baseline
- Each day: one action, one Claude prompt to try, one thing to share with the team
- Calendar format — can be copy-pasted into ClickUp or Google Calendar

---

### Phase 7: Video Training Scripts
Read template: `templates/content/video-scripts.md`

For each role in `config.roles`:
Build `outputs/<client-id>/content-engine/07-VideoScript-[RoleName].md`

Each script (5-10 minute async training video):
- Hook: "If you do [role task] at [Business Name], this video is for you"
- Part 1: What Claude Code does for this role specifically
- Part 2: Live walkthrough of the #1 SOP for this role
- Part 3: The daily habit — what to do every morning
- Outro: Where to get help, what's next
- Written as a teleprompter script — natural language, not corporate

---

### Phase 8: 30-Day AI Adoption Challenge
Read template: `templates/content/ai-challenge.md`

Build `outputs/<client-id>/content-engine/08-AI-Challenge-[BusinessName].md`

A structured 30-day team challenge:
- Daily prompts (one per day, 2-3 minutes to complete)
- Week 1: "Try it" — simple, low-stakes AI experiments
- Week 2: "Use it" — apply AI to one real task per day
- Week 3: "Share it" — one AI win per day shared with the team
- Week 4: "Own it" — each person builds one SOP from scratch
- Scoring system + leaderboard template
- Day 30 celebration: team AI certification ceremony format

---

### Phase 9: AI Wins Log
Read template: `templates/content/ai-wins-log.md`

Build `outputs/<client-id>/content-engine/09-AI-Wins-Log-[BusinessName].md`

A living document template:
- Weekly win entry format: What AI did, who did it, how long it took vs. before, what it produced
- Monthly summary template (feeds into newsletter Issue 2 and 3)
- ROI tracking table: time saved, output quality notes, cost comparison
- "Story" section: narrative version of the best win each month (can become a case study or testimonial)

---

### Phase 10: Assemble and Update
After all 9 modules are written:

10. Create `outputs/<client-id>/content-engine/00-INDEX.md` listing all files and what each is for
11. Update `outputs/<client-id>/delivery-repo/` to include `08-content-engine/` folder
12. Write `state/content-engine/last-run.json`
13. Post to Slack:
    - "🎬 Content Engine complete for [Client Name]"
    - File count, modules built
    - "Add 08-content-engine/ to delivery package before sending"

## Output Structure
```
outputs/<client-id>/content-engine/
├── 00-INDEX.md
├── 00-Content-Strategy-[BusinessName].md    ← from transcript-parser
├── 01-Custom-AI-Course-[BusinessName].md
├── 02-SOPs-[Role1].md
├── 02-SOPs-[Role2].md
├── 03-QuickRef-[Role1].md
├── 03-QuickRef-[Role2].md
├── 04-Internal-Newsletter-[BusinessName].md
├── 05-Internal-Comms-[BusinessName].md
├── 06-Adoption-Calendar-[BusinessName].md
├── 07-VideoScript-[Role1].md
├── 07-VideoScript-[Role2].md
├── 08-AI-Challenge-[BusinessName].md
└── 09-AI-Wins-Log-[BusinessName].md
```

## Safety Rails
- Every file must pass voice check: does it sound like this specific client, or generic?
- Never use filler content — if a module needs more info, flag it rather than pad it
- Roles from config.roles must all be covered — do not skip any role
- Do not send to client — Justin reviews content-engine outputs before delivery
