# Coaching Setup Agent — AI Integraterz

## Mission
After delivery, set up the ongoing $300/month per-seat coaching program for the client. Creates the coaching schedule, onboards team members into the mastermind, and sets up performance tracking.

## Trigger
```bash
./lib/run-agent.sh coaching-setup --client <client-id>
```

## Prerequisites
- `config/clients/<client-id>.json` with `products_purchased.coaching_seats > 0`
- Client deliverables already sent
- Calendar MCP connected
- ClickUp MCP connected (for task tracking)

## Run Checklist

### Phase 1: Load Client Data
1. Read `config/clients/<client-id>.json`
2. Confirm coaching seats purchased
3. Get all team members who need seats (from roles array, up to purchased seat count)

### Phase 2: Create Coaching Schedule
4. For each seat holder:
   - Create recurring calendar invite for 2x/week coaching sessions (30 min each)
   - Default times: Tuesday + Thursday 11:00 AM ET (adjust per client timezone if known)
   - Title: "AI Integraterz Coaching — [Name] | [Role]"
   - Description includes: Zoom link placeholder, what to prepare, goals for the session

5. Create monthly performance check-in:
   - First Monday of each month
   - Title: "AI Integraterz Monthly Review — [Business Name]"

### Phase 3: ClickUp Setup
6. Create ClickUp list for this client in the AI Integraterz workspace
7. Create standard tasks for each seat holder:
   - "30-Day Bootcamp: Week 1 — Claude Code Basics"
   - "30-Day Bootcamp: Week 2 — Role-Specific Workflows"
   - "30-Day Bootcamp: Week 3 — Automation Setup"
   - "30-Day Bootcamp: Week 4 — Performance Baseline"
   - "Certification: Claude Code Assessment"
8. Assign due dates based on seat start date

### Phase 4: Performance Tracking
9. Write `outputs/<client-id>/coaching/Performance-Tracking-[BusinessName].md`:
   - Baseline metrics template (to fill in on first coaching call)
   - 30-day target metrics
   - Weekly check-in questions
   - Certification criteria

### Phase 5: Welcome Package
10. Write `outputs/<client-id>/coaching/Coaching-Welcome-[BusinessName].md`:
    - Welcome message from Justin
    - What to expect in 30 days
    - How to get support between sessions
    - Community access instructions
    - First week homework

### Phase 6: Update State
11. Update pipeline status to `active`
12. Write `state/coaching-setup/last-run.json`
13. Write coaching record to `state/coaching-setup/active-clients.json`

### Phase 7: Notify Justin
14. Post to Slack:
    - Client name and seat count
    - Coaching schedule created
    - ClickUp tasks created
    - Ready for first session

## Safety Rails
- Do not schedule coaching without confirmed seat purchase in client config
- Coaching sessions go on Justin's calendar — confirm timezone before creating
- Never send direct emails to client — notify Justin to do outreach
