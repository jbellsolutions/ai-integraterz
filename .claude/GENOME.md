# AGI-1 Genome Notice

This repo participates in the AGI-1 genome system. When `/agi-1` or `/agi-sync` is run, patterns learned in this repo (self-healing fixes, instruction improvements, anti-patterns) may be promoted to the shared genome at `~/.claude/agi-1-genome/`.

## What Gets Shared
- Healing patterns that successfully fixed recurring errors (confidence ≥ 0.8, occurrences ≥ 5)
- Instruction improvements that raised the AI-readiness score
- Anti-patterns that caused score regressions

## What Never Gets Shared
- Client data (`config/clients/`)
- Client deliverables (`outputs/`)
- API keys or credentials (`.env`)
- State files containing operational data

## To Opt Out
Remove this file. The genome sync will skip this repo.

## More Information
See `~/.claude/agi-1-genome/genome.json` for the full shared genome.
