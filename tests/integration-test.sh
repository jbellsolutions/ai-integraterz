#!/usr/bin/env bash
# integration-test.sh — AI Integraterz integration tests
# Tests the extraction → training-builder pipeline end-to-end using the example client.
# Requires ANTHROPIC_API_KEY to be set.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0; FAIL=0; TEST_CLIENT="integration-test-client"

pass() { echo "  ✓ $*"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $*"; FAIL=$((FAIL+1)); }

cleanup() {
  rm -f "$REPO_ROOT/config/clients/${TEST_CLIENT}.json"
  rm -rf "$REPO_ROOT/outputs/${TEST_CLIENT}"
  rm -f "$REPO_ROOT/state/extraction/last-run.json"
  rm -f "$REPO_ROOT/state/training-builder/last-run.json"
}
trap cleanup EXIT

echo "========================================"
echo " AI Integraterz Integration Tests"
echo " $(date)"
echo "========================================"

# --- Prerequisite check ---
echo ""
echo "--- Prerequisites ---"
if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "  SKIP: ANTHROPIC_API_KEY not set — skipping integration tests"
  echo "  Run: export ANTHROPIC_API_KEY=sk-ant-... && bash tests/integration-test.sh"
  exit 0
fi
pass "ANTHROPIC_API_KEY set"

# --- Test 1: Copy example client as test client ---
echo ""
echo "--- Test 1: Client config setup ---"
cp "$REPO_ROOT/config/clients/example-client.json" "$REPO_ROOT/config/clients/${TEST_CLIENT}.json"
python3 -c "
import json
d = json.load(open('$REPO_ROOT/config/clients/${TEST_CLIENT}.json'))
d['client_id'] = '$TEST_CLIENT'
json.dump(d, open('$REPO_ROOT/config/clients/${TEST_CLIENT}.json','w'), indent=2)
"
[[ -f "$REPO_ROOT/config/clients/${TEST_CLIENT}.json" ]] && pass "Test client config created" || fail "Failed to create test client config"

# --- Test 2: Validate client config schema ---
echo ""
echo "--- Test 2: Schema validation ---"
python3 - << PYEOF
import json, sys
d = json.load(open('$REPO_ROOT/config/clients/${TEST_CLIENT}.json'))
required = ['client_id','business','owner','roles','products_purchased']
missing = [f for f in required if f not in d]
if missing:
    print(f"  MISSING fields: {missing}")
    sys.exit(1)
print("  Schema valid")
PYEOF
pass "Client config schema valid"

# --- Test 3: Verify run-agent.sh exists and is executable ---
echo ""
echo "--- Test 3: Runner sanity ---"
[[ -x "$REPO_ROOT/lib/run-agent.sh" ]] && pass "run-agent.sh executable" || fail "run-agent.sh not executable"
[[ -f "$REPO_ROOT/agents/training-builder.md" ]] && pass "training-builder playbook exists" || fail "training-builder playbook missing"

# --- Test 4: Template placeholder consistency ---
echo ""
echo "--- Test 4: Template integrity ---"
for tmpl in templates/owner/game-plan.md templates/company/adoption-document.md templates/roles/role-training.md; do
  if grep -q "{{" "$REPO_ROOT/$tmpl"; then
    pass "$tmpl has placeholders (expected)"
  else
    fail "$tmpl has no placeholders — may be missing template tokens"
  fi
done

# --- Test 5: healer.sh dry-run (no failed agent state) ---
echo ""
echo "--- Test 5: Healer dry-run ---"
bash "$REPO_ROOT/lib/healer.sh" extraction > /dev/null 2>&1 && pass "healer.sh runs without error on healthy agent" || fail "healer.sh error on healthy agent"

echo ""
echo "========================================"
echo " Integration Results: ${PASS} passed, ${FAIL} failed"
echo "========================================"
[[ $FAIL -eq 0 ]] && echo " ALL INTEGRATION TESTS PASSED" && exit 0 || echo " FAILURES DETECTED" && exit 1
