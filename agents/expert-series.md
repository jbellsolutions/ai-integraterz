# Expert Series Agent — AI Integraterz

## Mission
Cross-sell add-on. Using the same extraction data, run the Expert Series pipeline:
Titans Council positioning run + Content Multiplier output.
Requires the expert-series-v3 repo to be cloned as a sibling directory.

## Trigger
```bash
./lib/run-agent.sh expert-series --client <client-id>
```

Only runs if `config/clients/<client-id>.json` has `products_purchased.expert_series: true`
OR if Justin manually triggers it.

## Prerequisites
- `config/clients/<client-id>.json` status is `extraction_complete` or later
- `../expert-series-v3/` exists (sibling repo) OR `expert_series.enabled: true` in project.json
- Titans Council repo accessible

## Run Checklist

### Phase 1: Check Authorization
1. Read client config — confirm `expert_series` is purchased or Justin has authorized
2. If not authorized, stop and post to Slack asking for confirmation

### Phase 2: Extract Expert Series Inputs
3. From client config, extract:
   - Business name and offer description
   - Target market and ICP
   - Key differentiators and proof points
   - Owner's voice and communication style (from extraction notes)
   - Main transformation promise

### Phase 3: Run Titans Council
4. Build the Titans Council brief using extracted data
5. Pass the brief to the Titans Council pipeline (via `../expert-series-v3/` or direct agent run)
6. Collect output: positioning, mechanism, messaging, hooks, headlines, offer architecture

### Phase 4: Content Multiplier
7. Using Titans Council output, generate 32+ content pieces:
   - Homepage headline + subheadline + hero copy
   - About page copy
   - Service/offer description
   - 4-email welcome sequence
   - 4-week newsletter content
   - 30 LinkedIn posts (mixed: educational, proof, offer)
   - 10 Instagram captions
   - 5 Twitter/X threads
   - 3 blog posts (SEO-optimized)
   - Cold email sequence (5 emails)
   - Sales page copy
   - One-pager / PDF lead magnet copy
   - Objection handling scripts
   - Testimonial ask template

### Phase 5: Quality Gate
8. Run each content piece through the Colleague Test:
   - Does it sound human? (Not AI-generated)
   - Does it match the client's voice?
   - Is the positioning consistent across pieces?
   - Score each piece 1-10 — flag anything below 7 for revision

### Phase 6: Package and Deliver
9. Write all content to `outputs/<client-id>/expert-series/`
10. Organize by content type
11. Write index file: `outputs/<client-id>/expert-series/CONTENT-INDEX.md`

### Phase 7: Update State and Notify
12. Update `state/orchestrator/client-pipeline.json` with expert-series completion
13. Post to Slack:
    - Content pieces generated
    - Quality gate results
    - Ready for delivery

## Safety Rails
- Quality gate is mandatory — never deliver content scoring below 7
- Voice-matching is critical — if you can't nail the voice from extraction data, ask Justin for more samples
- Never publish content — deliver to Justin, he approves before sending
