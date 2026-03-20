# AURORA RUN 057

## PURPOSE

This run records an important execution-side correction.

The operator clarified that Aurora families must not drift into symbol-bound logic.
Aurora should route primarily by:
- asset class
- bucket class
- group type / subtype where useful
- regime / state
- family tree

and only later narrow to a symbol instance for the actual generated card.

---

## CHANGED FILES

Created:
- `Aurora Blueprint/AURORA_GROUP_BUCKET_REGIME_ROUTING_PROTOCOL.md`
- `Aurora Blueprint/AURORA_GROUP_AWARE_WORKED_EXAMPLE_ADDENDUM_001.md`
- `Aurora Blueprint/runs/AURORA_RUN_057.md`

---

## WHAT THIS RUN DID

### 1. Locked family routing to group / bucket / regime logic
The new routing protocol explicitly states that:
- families are cross-symbol behavior classes
- cards may still be symbol-specific outputs
- packets and worked examples should increasingly explain the broader bucket/group tree the symbol belongs to

### 2. Corrected worked-example posture
The new addendum makes clear that a worked example may use one symbol instance, but it must not behave like that symbol is the whole family universe.

---

## BRIDGE IMPACT CLASSIFICATION

Preferred classification for this run:
- `NO_BRIDGE_IMPACT`

Reason:
- this is a pure Aurora-side execution-intelligence correction
- no ASC-side contract change was required

---

## CURRENT JUDGMENT

Aurora is now more correctly aligned with the operator’s intended build direction:
- family trees are broad
- routing is classification-aware
- examples stay instance-specific without becoming symbol-bound doctrine
