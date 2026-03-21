# AURORA WRAPPER BRIDGE PACK

## Bridge law

ASC and Aurora have separate ownership.
ASC measures world/context truth.
Aurora interprets that truth into market-state, family/pattern posture, deployability, opportunity, geometry, and wrapper-safe outputs.
This wrapper compilation does not widen that contract.

## ASC owns

- symbol identity truth
- asset-class and bucket identity truth
- market-open / market-closed truth
- tick freshness truth
- schedule/session/next-check truth
- publication freshness truth
- execution-surface telemetry that can be measured
- spread, friction, and quote-health telemetry
- runtime degradation/unavailable/stale states

## Aurora owns

- market-state interpretation
- execution-surface interpretation
- hostility interpretation
- family competition and rejection
- pattern competition and rejection
- deployability interpretation
- generated strategy cards
- wrapper and bounded EA-safe output preparation

## Minimum ASC context object expected by the wrapper

Aurora should not attempt full interpretation without a minimum context block carrying:
- identity (`symbol`, canonical symbol, asset class, primary bucket, server identity)
- runtime/publication state
- market-status state
- schedule/session state
- execution/friction state
- optional but high-value supporting context when available

## Required missingness behavior

- if identity truth is missing: no family or pattern card creation; mark context unusable
- if market-status truth is stale/degraded: preserve observe-only or downgraded posture; do not promote false eligibility
- if execution/friction truth is missing: structure may still be interpreted, but deployability must remain unknown/pending/watch-only
- if session truth is missing: avoid time-sensitive geometry confidence and flag insufficiency

## Joint evolution rule

Meaningful Aurora-side architecture changes require a bridge check against the shared protocol.
For this wrapper compilation wave, the bridge outcome is:
- `NO_BRIDGE_CHANGE_NEEDED`

Reason:
- the new folder compiles existing Aurora truth for wrapper use
- it does not widen ASC-required fields
- it does not alter ownership boundaries

## Wrapper instruction for bridge-sensitive tasks

If a task asks Aurora to invent missing telemetry, override ASC truth, or treat degraded upstream fields as fully trustworthy, the wrapper must refuse and restate the contract boundary.
