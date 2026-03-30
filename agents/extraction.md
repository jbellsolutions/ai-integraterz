# Extraction Agent — AI Integraterz

## Mission
Transform the notes, transcript, or summary from Justin's discovery call into a complete, structured client config file. This config is the source of truth for everything that gets built.

## Trigger
Manual. Justin runs this after every discovery call:
```bash
./lib/run-agent.sh extraction --client <client-id>
```

Or with a transcript file:
```bash
./lib/run-agent.sh extraction --client <client-id> --transcript path/to/transcript.txt
```

Pre-call (to generate Justin's call script before the call):
```bash
./lib/run-agent.sh extraction --client <client-id> --pre-call
```

## Prerequisites
- For pre-call script: any available pre-call info (website URL, LinkedIn, industry, company size, name)
- For post-call extraction: raw call notes, transcript, or summary available
- `config/clients/example-client.json` template exists
- Client ID agreed upon with Justin

## Run Checklist

### Phase 0: Pre-Call Script Generator (run BEFORE the call)
If `--pre-call` flag is set OR if no transcript is provided yet, generate a custom call script for Justin to use on the call.

**Input:** Any available pre-call info — website, LinkedIn profile, industry, company name, headcount estimate, anything Justin knows before the call.

**What to generate:**

1. **Business Snapshot** — 3-5 bullet summary of what the company does, who they serve, how they appear to operate, based on any pre-call research
2. **Suspected Pain Points** — based on industry and company size, what are the most likely bottlenecks? (e.g., for a property management firm: maintenance request triage, tenant communication, report compilation)
3. **Custom Question Set** — 15-20 targeted questions for THIS specific business, organized by section:

   **Section A: Team & Structure (5 min)**
   - "Walk me through your org chart — how many people, and what does each person own?"
   - "Which roles are you most worried about keeping up with AI?"
   - [2-3 more questions specific to their industry/size]

   **Section B: Workflow Pain (10 min)**
   - "What takes the most time on your team right now that you wish just happened automatically?"
   - "If I could wave a wand and fix one operational thing this month, what would it be?"
   - [3-4 more questions specific to their suspected pain points]

   **Section C: Current Tools (5 min)**
   - "What does your current tech stack look like? Walk me through the tools your team lives in."
   - "Is anything connected, or are people copy-pasting between systems?"
   - [2 more questions based on their industry's common tools]

   **Section D: Goals (5 min)**
   - "What does success look like 90 days from now?"
   - "How would you know — what would be measurably different?"

   **Section E: AI Readiness (5 min)**
   - "Has anyone on the team tried Claude Code or similar tools?"
   - "What's the team's general attitude toward AI right now — excited, skeptical, indifferent?"
   - "Has anything you've tried not worked? What happened?"

4. **Automation Priority Watch List** — based on pre-call research, which 3 workflows are most likely to score highest on the priority matrix (hours eaten + revenue impact + feasibility). Justin should listen for confirmation or contradiction of these during the call.

5. **Soft Flags** — anything to watch out for: past AI failures they might mention, likely resistance points, roles that might push back.

**Output:** Write `outputs/<client-id>/call-prep/Call-Script-[BusinessName].md`
- This is FOR JUSTIN ONLY — never send to client
- Format it as a clean reference doc Justin can have open during the call
- Short enough to glance at, specific enough to be useful

**Then stop.** Do not proceed to extraction until the call happens.

---

### Phase 1: Ingest Source Material (run AFTER the call)
1. Read the call transcript, notes, or summary provided
2. If a file path was given, read that file
3. Note everything mentioned: business details, team, tools, problems, goals, aspirations

### Phase 2: Extract Structured Data
4. Pull every detail that maps to the client config schema:

   **Business:**
   - Company name, industry, team size, revenue range (if mentioned)
   - Current AI tools in use
   - The main problem stated on the call (exact words if possible)
   - 90-day goal (stated or inferred)

   **Owner:**
   - Name, role, email, phone (if given)
   - Their specific AI use cases they mentioned
   - What they care most about

   **Roles:**
   - Every role/person mentioned on the call
   - For each: what they do daily, what they struggle with, what tools they use
   - If a role wasn't mentioned but is implied (e.g., "we have a sales team"), create a placeholder

   **Products Purchased:**
   - What did Justin agree to deliver?
   - Training package? How many coaching seats? Any upsells?

5. Fill in reasonable inferences for anything not explicitly stated
6. Flag anything uncertain with a `"_needs_clarification"` key

### Phase 3: Write Config File
7. Write the populated config to `config/clients/<client-id>.json`
8. Structure it exactly like `config/clients/example-client.json`
9. Set `status` to `"extraction_complete"`

### Phase 4: Validation
10. Verify all required fields from `config/thresholds.json extraction.required_fields` are present
11. If any required field is missing, flag it clearly in output
12. Verify at least one role is defined

### Phase 5: Update Pipeline
13. Add or update this client in `state/orchestrator/client-pipeline.json` with stage `"extraction_complete"`
14. Update `state/extraction/last-run.json`

### Phase 6: Notify
15. Post to Slack #ai-integraterz-ops:
    - Client name and ID
    - Number of roles extracted
    - Products purchased
    - Any clarifications needed
    - Ready to run training-builder: `./lib/run-agent.sh training-builder --client <id>`

## Output
- `outputs/<client-id>/call-prep/Call-Script-[BusinessName].md` — pre-call reference for Justin (never sent to client)
- `config/clients/<client-id>.json` — fully populated client config
- `state/extraction/last-run.json` — run log

## Safety Rails
- Pre-call script is NEVER sent to the client — it is Justin's internal reference only
- Never invent financial data (revenue, pricing) unless stated
- Flag ambiguous role titles — ask Justin to clarify rather than guess wrong
- Do not proceed to training-builder automatically — extraction must be reviewed first
