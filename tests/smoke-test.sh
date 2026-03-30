#!/usr/bin/env bash
# smoke-test.sh — AI Integraterz smoke tests
# Tests that the repo structure and configs are valid before any agent runs
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0; FAIL=0

pass() { echo "  ✓ $*"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $*"; FAIL=$((FAIL+1)); }

echo "========================================"
echo " AI Integraterz Smoke Tests"
echo " $(date)"
echo "========================================"

echo ""
echo "--- Required Files ---"
for f in README.md CLAUDE.md WALKTHROUGH.md ETHOS.md ARCHITECTURE.md AGENTS.md CHANGELOG.md TODOS.md VERSION llms.txt .env.example; do
  if [[ -f "$REPO_ROOT/$f" ]]; then
    pass "$f exists"
  else
    fail "$f MISSING"
  fi
done

echo ""
echo "--- Config Files ---"
for f in config/project.json config/thresholds.json config/clients/example-client.json; do
  if [[ -f "$REPO_ROOT/$f" ]]; then
    if command -v jq &>/dev/null; then
      if jq '.' "$REPO_ROOT/$f" > /dev/null 2>&1; then
        pass "$f valid JSON"
      else
        fail "$f invalid JSON"
      fi
    else
      pass "$f exists (jq not installed, skipping JSON validation)"
    fi
  else
    fail "$f MISSING"
  fi
done

echo ""
echo "--- Agent Playbooks ---"
for agent in orchestrator extraction training-builder coaching-setup delivery-packager expert-series; do
  [[ -f "$REPO_ROOT/agents/${agent}.md" ]] && pass "agents/${agent}.md" || fail "agents/${agent}.md MISSING"
done

echo ""
echo "--- Lib Scripts ---"
for script in lib/run-agent.sh lib/new-client.sh lib/package-delivery.sh; do
  if [[ -f "$REPO_ROOT/$script" ]]; then
    [[ -x "$REPO_ROOT/$script" ]] && pass "$script exists and is executable" || fail "$script exists but not executable (run: chmod +x $script)"
  else
    fail "$script MISSING"
  fi
done

echo ""
echo "--- Templates ---"
for t in templates/owner/game-plan.md templates/company/adoption-document.md templates/company/toolkit.md templates/roles/role-training.md templates/roles/claude-config.md templates/va/va-guide.md templates/course/claude-certification.md; do
  [[ -f "$REPO_ROOT/$t" ]] && pass "$t" || fail "$t MISSING"
done

echo ""
echo "--- State Directories ---"
for d in state/orchestrator state/extraction state/training-builder state/coaching-setup; do
  [[ -d "$REPO_ROOT/$d" ]] && pass "$d exists" || fail "$d MISSING"
done

echo ""
echo "--- AI/AGI Files ---"
for f in .claude/CLAUDE.md .claude/settings.json .claude/healing/patterns.json .claude/learning/observations.json .claude/GENOME.md .claude/MEMORY.md .agent/identity.json .agent/state.json; do
  [[ -f "$REPO_ROOT/$f" ]] && pass "$f" || fail "$f MISSING"
done

echo ""
echo "--- Placeholder Check (templates) ---"
# Check that example client config has no unreplaced placeholders
if grep -r "{{" "$REPO_ROOT/config/" 2>/dev/null | grep -v "_comment" | grep -q "{{"; then
  fail "Config files contain unresolved placeholders"
else
  pass "Config files are placeholder-free"
fi

echo ""
echo "========================================"
echo " Results: ${PASS} passed, ${FAIL} failed"
echo "========================================"

[[ $FAIL -eq 0 ]] && echo " ALL TESTS PASSED" && exit 0 || echo " FAILURES DETECTED" && exit 1
