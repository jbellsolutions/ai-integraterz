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

## Prerequisites
- Raw call notes, transcript, or summary available (provided in prompt or as file)
- `config/clients/example-client.json` template exists
- Client ID agreed upon with Justin

## Run Checklist

### Phase 1: Ingest Source Material
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
- `config/clients/<client-id>.json` — fully populated client config
- `state/extraction/last-run.json` — run log

## Safety Rails
- Never invent financial data (revenue, pricing) unless stated
- Flag ambiguous role titles — ask Justin to clarify rather than guess wrong
- Do not proceed to training-builder automatically — extraction must be reviewed first
