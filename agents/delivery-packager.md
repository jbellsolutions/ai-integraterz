# Delivery Packager Agent — AI Integraterz

## Mission
Take all generated outputs for a client and package them into a clean, professional delivery bundle — a GitHub repo the client can use directly with Claude Code.

## Trigger
```bash
./lib/run-agent.sh delivery-packager --client <client-id>
```
Or via script:
```bash
./lib/package-delivery.sh <client-id>
```

## Prerequisites
- `outputs/<client-id>/` exists with training-builder outputs
- `state/orchestrator/client-pipeline.json` shows status `training_complete`

## Run Checklist

### Phase 1: Validate Outputs
1. Read `state/training-builder/pipeline.json` for expected deliverables
2. Check all expected files exist in `outputs/<client-id>/`
3. Flag any missing files — do not proceed if critical files are missing

### Phase 2: Quality Check
4. Read each deliverable and verify:
   - No placeholder text left (no `{{`, `TBD`, `[INSERT`, `example.com` from template)
   - Client name appears correctly throughout
   - Role count matches client config
5. Log quality issues and flag for Justin review if found

### Phase 3: Build Delivery Repo Structure
6. Create `outputs/<client-id>/delivery-repo/`:
   ```
   delivery-repo/
   ├── README.md          (welcome + how to use this repo)
   ├── SETUP.md           (Claude Code install instructions)
   ├── DELIVERY-SUMMARY.md
   ├── 01-owner/
   ├── 02-company/
   ├── 03-roles/
   ├── 04-va/
   ├── 05-certification/
   ├── 06-coaching/
   ├── 07-self-install/
   │   └── configs/
   └── 08-content-engine/  (added if Content Engine was run)
       ├── 00-INDEX.md
       ├── 01-Custom-AI-Course/
       ├── 02-SOPs/
       ├── 03-QuickRef/
       ├── 04-Newsletter/
       ├── 05-Comms/
       ├── 06-Calendar/
       ├── 07-VideoScripts/
       ├── 08-Challenge/
       └── 09-WinsLog/
   ```

7. Copy all outputs into numbered folders (numbered = recommended reading order)

### Phase 4: Write Master README
8. Write `outputs/<client-id>/delivery-repo/README.md`:
   ```
   # [Business Name] — AI Integraterz Delivery Package

   Built by: Justin Bell | AI Integraterz
   Delivery Date: [date]

   ## How to Use This Package

   The fastest way: Open Claude Code in this folder and type:
   "Read SETUP.md and install everything for me"

   That's it. Claude Code will read your setup guide and configure everything.

   ## What's In Here
   [table of each folder and what's in it]

   ## Start Here
   1. Read 01-owner/ first — that's your personal game plan
   2. Share 03-roles/ with your team
   3. Run 07-self-install/ to configure Claude Code for everyone

   ## Support
   justin@usingaitoscale.com
   usingaitoscale.com
   ```

### Phase 5: Write SETUP.md
9. Write `outputs/<client-id>/delivery-repo/SETUP.md`:
   - Step-by-step Claude Code installation guide
   - "Copy this CLAUDE.md to your home folder"
   - "Add these slash commands to your .claude/commands/ folder"
   - Non-technical language — assumes no prior Claude Code experience
   - Screenshots described in text (where to click)

### Phase 6: Create ZIP + Push Instructions
10. Write `state/delivery-packager/last-run.json` with:
    - Delivery package path
    - File count
    - Quality check results
    - Suggested next steps for Justin

### Phase 7: Stamp Delivery Date + Notify
11. Write `delivery.delivered_at` (ISO timestamp) to `config/clients/<client-id>.json` — this is the timestamp the orchestrator uses for the 30-day checkpoint (Day 30) and 90-day ROI report (Day 90) countdown clocks. Without this, those agents cannot calculate timing.
12. Update `state/orchestrator/client-pipeline.json` for this client:
    - Set `stage: "delivered"`
    - Set `delivery_date: "<ISO timestamp>"`
    - Set `days_since_delivery: 0`
    - Set `content_engine_run: false` (unless Content Engine was just run)
13. Post to Slack #ai-integraterz-ops:
    - "✅ Delivery package ready for [Client Name]"
    - Path to delivery-repo folder
    - Quality check summary
    - Action needed: "Review and send to client"

### Phase 8: Content Engine Prompt
After packaging is complete and Slack notification is sent, ask Justin:

```
✅ Delivery package ready for [Client Name].

Would you like to run the Content Engine?

The Content Engine generates everything that makes AI adoption self-sustaining at [Business Name]:

  1. Custom AI Training Course (multi-module, role-specific)
  2. Role SOP Library (step-by-step AI workflows per role)
  3. Quick Reference Cards (one-page cheat sheet per role)
  4. Internal Newsletter System (3 ready-to-send issues)
  5. Internal Comms Pack (announcement + 5-email rollout sequence)
  6. 30-Day Adoption Calendar (daily rollout schedule)
  7. Role Training Video Scripts (async training, one per role)
  8. 30-Day AI Adoption Challenge (team competition + tracking)
  9. AI Wins Log (ongoing documentation + ROI tracking)

To run it, I'll need the call transcript (if not already parsed).

Reply:
  "yes" — run Content Engine now (I'll ask for the transcript)
  "skip" — complete delivery without Content Engine
  "later" — deliver now, run Content Engine separately

Command when ready: ./lib/run-agent.sh transcript-parser --client <client-id> --transcript <file>
Then: ./lib/run-agent.sh content-engine --client <client-id>
```

Wait for Justin's response before proceeding. If "yes": run transcript-parser first, then content-engine. If "skip" or no response: close out the delivery state.

## Safety Rails
- Never send the package to the client — only Justin does that
- Never skip the quality check — placeholder text in a delivery is embarrassing
- If quality check fails on >3 files, halt and alert Justin
- Content Engine is optional — never run it without Justin's confirmation
