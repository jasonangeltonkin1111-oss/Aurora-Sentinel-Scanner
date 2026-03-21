# AURORA WRAPPER BRIDGE PACK

## What this pack compiles

This pack compiles the active ASC→Aurora context contract, joint evolution protocol, and real ASC intake anchor for wrapper use.
It records ownership boundaries, minimum context expectations, missingness behavior, and the current bridge-check outcome.

## What this pack excludes

- any widening of the ASC contract not already ratified in Blueprint
- execution-side doctrine that belongs in the execution pack
- office/run/SHA continuity surfaces

## Bridge law

ASC and Aurora have separate ownership.
ASC measures world/context truth.
Aurora interprets that truth into market state, family/pattern posture, opportunity posture, deployability, geometry, and wrapper-safe outputs.
This wrapper compilation does not widen that contract.

## ASC owns

- symbol and venue identity truth
- asset-class and bucket identity truth
- market-open / market-closed truth
- tick freshness and publication freshness truth
- schedule/session/next-check truth
- execution/friction/quote-health telemetry that can be measured
- runtime degradation, unavailable, stale, and invalid states

## Aurora owns

- market-state and execution-surface interpretation
- hostility interpretation
- family competition and rejection
- pattern competition and rejection
- opportunity inventory posture
- deployability judgment
- geometry generation
- generated strategy cards and bounded EA-safe output preparation

## Minimum ASC context block expected by Aurora

Aurora should not attempt full downstream interpretation without, at minimum:
- identity block
- runtime/publication block
- market-status block
- session/schedule block
- execution/friction block
- any clearly available supporting context, while still preserving missingness explicitly

## Missingness and stop laws

- if identity truth is missing, Aurora should stop before family/pattern/card generation
- if market-status truth is stale or degraded, Aurora may preserve structural interpretation but must downgrade opportunity/deployability honestly
- if execution/friction truth is missing, deployability should remain unknown, pending, watch-only, or blocked rather than invented
- if session truth is missing, time-sensitive geometry confidence must be downgraded
- the real ASC intake anchor confirms the correct behavior: preserve missingness and stop before invention

## Joint evolution rule

Meaningful update waves require a bridge check against the shared protocol.
Current bridge outcome:
- `NO_BRIDGE_CHANGE_NEEDED`

Reason:
- this pass strengthens Aurora-internal wrapper fidelity
- no new ASC-owned fields were required
- ownership boundaries did not move

## Wrapper refusal rule

If a task asks Aurora to invent telemetry, overwrite ASC truth, or treat degraded upstream context as fully trustworthy, the wrapper must refuse and restate the contract boundary.

## Replace/update note

Replace this pack only when the ASC contract, joint-evolution law, or real-intake anchor changes materially.
Wrapper convenience alone is not enough reason to widen bridge scope.
