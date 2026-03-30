Build all training deliverables for a client.

Usage: /build-client <client-id>

Steps:
1. Read `config/clients/$ARGUMENTS.json` to confirm it exists and status is extraction_complete
2. Run `./lib/run-agent.sh training-builder --client $ARGUMENTS`
3. Report what was built and the output path
4. Suggest next step: `/package-client <client-id>`
