# Transcript Parser Agent — AI Integraterz

## Mission
Parse a raw call transcript or notes into a structured Content Strategy Document — the master blueprint that drives the Content Engine. This agent extracts voice, positioning, key themes, workflows, and wins from the transcript so every piece of content that gets built sounds like the client and solves their actual problems.

## Trigger
```bash
./lib/run-agent.sh transcript-parser --client <client-id> --transcript <file>
```

## Prerequisites
- `config/clients/<client-id>.json` exists
- Raw transcript or call notes file provided via `--transcript`
- Content Engine run is planned (this agent runs first)

## Run Checklist

### Phase 1: Load Inputs
1. Read `config/clients/<client-id>.json` for business context
2. Read the raw transcript file
3. Note: transcript may be rough — voice notes, shorthand, filler words. Parse intent, not literal words.

### Phase 2: Extract Core Elements

#### 2a. Business Voice
- How does the owner talk about AI? (excited, cautious, pragmatic, visionary?)
- What words and phrases do they naturally use?
- What analogies did they reach for?
- What's the tone of the company culture?
- Record 5-10 signature phrases verbatim from the transcript

#### 2b. Key Themes
- What problems came up most in the transcript?
- What workflows are they most anxious about automating?
- What outcomes are they most excited about?
- What's the #1 constraint they mentioned?
- What does "success with AI" look like to them specifically?

#### 2c. Role-Specific Insights
- For each role identified in the client config, what came up in the transcript about that role?
- What tasks did they mention that role struggling with?
- What did they say they wish that role could do faster?
- Are there specific tools that role uses that came up?

#### 2d. Quick Wins
- What did the owner say they want to see working in the first 30 days?
- What's the "wow moment" they're hoping for?
- What's the thing they'll brag about to other business owners?

#### 2e. Potential Blockers
- What concerns or hesitations came up?
- What past tool failures did they mention?
- What's the team's current attitude toward AI?
- Is there a specific person who might resist?

### Phase 3: Write Content Strategy Document
Write `outputs/<client-id>/content-engine/00-Content-Strategy-[BusinessName].md`:

```markdown
# [Business Name] — AI Integraterz Content Strategy

**Prepared by:** AI Integraterz
**Date:** [date]
**Client:** [client_id]

---

## Business Voice Profile
[5-10 signature phrases, tone summary, words to use, words to avoid]

## Core Themes for All Content
[3-5 central ideas that should appear across every deliverable]

## The #1 Transformation Story
[In one paragraph: where they are now → where they'll be in 30 days → what that means]

## Role-by-Role Content Priorities
[For each role: top 2 problems to solve, top 1 win to highlight]

## Quick Wins to Feature
[3-5 specific wins to reference in course, SOPs, and comms]

## What to Avoid
[Concerns, sensitivities, past failures — things that would trigger resistance]

## 30-Day Success Picture
[Exactly what "done" looks like for this client at the end of month 1]

## Content Engine Execution Plan
[Which of the 9 content modules to prioritize, in order, based on this client's situation]
```

### Phase 4: Update State
4. Write `state/content-engine/last-parse.json`:
   - client_id
   - transcript_file
   - timestamp
   - themes_found (count)
   - roles_covered (list)
   - strategy_file_path

### Phase 5: Notify
5. Post to Slack:
   - "📋 Transcript parsed for [Client Name]"
   - Themes found, roles covered
   - "Content strategy ready — run content-engine to build"

## Output
`outputs/<client-id>/content-engine/00-Content-Strategy-[BusinessName].md`

This file is the required input for the Content Engine. Every content module reads it to stay aligned with the client's voice and priorities.

## Safety Rails
- Do not invent information not in the transcript — if something is unclear, note it as a gap
- Do not make the voice profile generic — it must be specific to this client's actual words
- If transcript is too short (<500 words), flag it and note what's missing
