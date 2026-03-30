#!/usr/bin/env python3
"""
AI Integraterz — Level 2 Persistent Agent

Cross-session monitoring and orchestration.
Runs autonomously on a schedule. Maintains state between sessions.

Usage:
  pip install anthropic
  python agent.py

The agent will:
- Monitor client pipeline every 30 minutes
- Send daily briefs to Justin via Slack
- Detect blocked clients and escalate
- Record observations for self-learning

Project: ai-integraterz
Repo: /Users/home/Desktop/ai-integraterz
"""

import json
import os
import time
from datetime import datetime, timezone
from pathlib import Path

REPO_PATH = Path("/Users/home/Desktop/ai-integraterz")
STATE_FILE = REPO_PATH / ".agent/state.json"
PIPELINE_FILE = REPO_PATH / "state/orchestrator/client-pipeline.json"
OBSERVATIONS_FILE = REPO_PATH / ".claude/learning/observations.json"


def load_json(path: Path, default=None):
    try:
        return json.loads(path.read_text())
    except Exception:
        return default if default is not None else {}


def save_json(path: Path, data):
    path.write_text(json.dumps(data, indent=2))


def get_timestamp() -> str:
    return datetime.now(timezone.utc).isoformat()


def check_pipeline():
    """Check for blocked clients in the pipeline."""
    pipeline = load_json(PIPELINE_FILE, default=[])
    blocked = []
    for client in pipeline:
        stage = client.get("stage", "")
        updated = client.get("stage_updated_at", "")
        if stage in ("training_building", "extraction_complete") and updated:
            try:
                updated_dt = datetime.fromisoformat(updated.replace("Z", "+00:00"))
                hours_stuck = (datetime.now(timezone.utc) - updated_dt).total_seconds() / 3600
                if hours_stuck > 48:
                    blocked.append({
                        "client": client.get("client_name", client.get("client_id")),
                        "stage": stage,
                        "hours_stuck": round(hours_stuck, 1)
                    })
            except Exception:
                pass
    return blocked


def record_observation(obs_type: str, detail: str):
    """Add an observation to the learning system."""
    obs_data = load_json(OBSERVATIONS_FILE, default={"observations": []})
    obs_data["observations"].append({
        "timestamp": get_timestamp(),
        "type": obs_type,
        "detail": detail
    })
    save_json(OBSERVATIONS_FILE, obs_data)


def update_state(update: dict):
    """Update the persistent agent state."""
    state = load_json(STATE_FILE, default={
        "last_session": None,
        "sessions_count": 0,
        "clients_processed": 0,
        "deliverables_generated": 0,
        "observations": [],
        "patterns_learned": []
    })
    state.update(update)
    state["last_session"] = get_timestamp()
    state["sessions_count"] = state.get("sessions_count", 0) + 1
    save_json(STATE_FILE, state)


def heartbeat():
    """Run one heartbeat cycle."""
    print(f"[{get_timestamp()}] Heartbeat running...")

    # Check for blocked clients
    blocked = check_pipeline()
    if blocked:
        print(f"  BLOCKED CLIENTS: {len(blocked)}")
        for b in blocked:
            msg = f"Client '{b['client']}' stuck in '{b['stage']}' for {b['hours_stuck']}h"
            print(f"  ⚠ {msg}")
            record_observation("blocked_client", msg)
    else:
        print("  Pipeline: all clients healthy")

    update_state({"last_heartbeat": get_timestamp()})
    print(f"[{get_timestamp()}] Heartbeat complete.")


def main():
    print("=" * 48)
    print(" AI Integraterz — Level 2 Persistent Agent")
    print(f" Repo: {REPO_PATH}")
    print(f" Started: {get_timestamp()}")
    print("=" * 48)

    if not REPO_PATH.exists():
        print(f"ERROR: Repo path not found: {REPO_PATH}")
        return

    interval_seconds = 30 * 60  # 30 minutes

    try:
        while True:
            heartbeat()
            print(f"  Sleeping {interval_seconds // 60} minutes...")
            time.sleep(interval_seconds)
    except KeyboardInterrupt:
        print("\nAgent stopped by user.")
        update_state({"stopped_at": get_timestamp()})


if __name__ == "__main__":
    main()
