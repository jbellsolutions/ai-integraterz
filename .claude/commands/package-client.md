Package a client's deliverables into the final delivery repo.

Usage: /package-client <client-id>

Steps:
1. Confirm `outputs/$ARGUMENTS/` exists with training-builder outputs
2. Run `./lib/package-delivery.sh $ARGUMENTS`
3. Report the delivery repo path: `outputs/$ARGUMENTS/delivery-repo/`
4. Remind: review DELIVERY-SUMMARY.md before sending to client
