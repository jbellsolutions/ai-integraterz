Show the current status of all clients in the pipeline.

Steps:
1. Read `state/orchestrator/client-pipeline.json`
2. For each client, show: name, stage, how long in current stage
3. Flag any client stuck >48h at the same stage as BLOCKED
4. Show total counts: active, blocked, delivered
5. List any deliverables due in the next 7 days
