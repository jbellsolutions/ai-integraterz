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
   └── 07-self-install/
       └── configs/
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

### Phase 7: Notify
11. Post to Slack #ai-integraterz-ops:
    - "✅ Delivery package ready for [Client Name]"
    - Path to delivery-repo folder
    - Quality check summary
    - Action needed: "Review and send to client"

## Safety Rails
- Never send the package to the client — only Justin does that
- Never skip the quality check — placeholder text in a delivery is embarrassing
- If quality check fails on >3 files, halt and alert Justin
