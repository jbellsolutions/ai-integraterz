# Security Policy

## What Contains Sensitive Data

| Path | What's in it | How it's protected |
|------|-------------|-------------------|
| `.env` | API keys, tokens | Gitignored |
| `config/clients/*.json` | Client business data | Gitignored (except example) |
| `outputs/` | Client deliverables | Gitignored |
| `state/` | Operational state | No secrets — safe to commit |

## Reporting a Vulnerability

If you find a security issue (exposed secrets, client data leakage, injection risk in scripts):

**Email:** justin@usingaitoscale.com
**Subject:** `[SECURITY] ai-integraterz — <brief description>`

Do not open a public GitHub issue for security vulnerabilities.

## What We Consider a Security Issue

- API keys or credentials committed to git
- Client data (names, emails, business info) committed to git
- Shell injection vulnerabilities in `lib/` scripts
- Prompt injection vulnerabilities in agent playbooks that could cause data exfiltration

## What We Don't Consider a Security Issue

- Agents that require valid API keys to run (expected behavior)
- State files containing run metadata (no PII, no secrets)

## Security Practices in This Repo

1. **`.gitignore` enforces client data separation** — `config/clients/*.json` and `outputs/` are never committed
2. **`.env` is never committed** — `.env.example` documents required vars without values
3. **Agents draft, never send** — all external communications are drafts requiring Justin's approval
4. **No eval of untrusted input** — agent playbooks do not execute arbitrary user-provided strings
