Run any AI Integraterz agent.

Usage: /run-agent <agent-name> [--client <client-id>]

Available agents: orchestrator, extraction, training-builder, coaching-setup, delivery-packager, expert-series

Steps:
1. Parse agent name and optional client-id from $ARGUMENTS
2. Run `./lib/run-agent.sh <agent-name> [--client <client-id>]`
3. Report the result and any next steps
