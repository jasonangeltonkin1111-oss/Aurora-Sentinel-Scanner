# LAYERED BUILD ORDER

## Purpose
This file defines the required implementation order for ASC.

ASC must be built in verified stages.
No later stage may assume truth from an unfinished earlier stage.

---

## Stage 1 — Layer 1
Build and verify:
- broker symbol discovery hooks needed for session checks
- market-open truth per broker symbol
- session quote-window vs trade-window distinction
- session-truth sub-state handling for closed/disabled/no-quote/stale/unknown cases
- next-open / next-recheck scheduling
- deferred handling for closed or uncertain symbols

### Exit criteria
- open/closed truth is correct
- closed/disabled/no-quote/stale/unknown states are not collapsed into false openness
- closed or uncertain symbols are not treated as open
- recheck scheduling works

---

## Stage 2 — Layer 1.2
Build and verify:
- full broker-universe snapshot
- broker spec snapshot
- classification snapshot where available
- session metadata snapshot
- explicit missing/unknown preservation for unreadable fields

### Exit criteria
- full universe captured truthfully
- required minimum snapshot fields are preserved when readable
- snapshot does not become hidden dossier logic
- missing fields remain explicit, not guessed

---

## Stage 3 — Layer 2
Build and verify:
- surface scan for eligible open symbols
- M15 + H1 intake
- light calculations
- spread / friction surface logic
- ranking inputs
- summary output
- symbol surface files

### Exit criteria
- only eligible symbols are scanned
- ranking is valid
- summary shows top 5 per `PrimaryBucket`
- symbol files obey 3-section contract

---

## Stage 4 — Activation Gate
Build and verify:
- explicit ACTIVE / INACTIVE transitions
- promotion handling
- non-promotion handling
- summary-to-activation relationship

### Exit criteria
- only promoted symbols gain active dossier rights
- inactive symbols do not receive rolling dossier continuation

---

## Stage 5 — Layer 3
Build and verify:
- restore-first active dossier logic
- timestamp-aware gap detection
- rolling continuation
- atomic write flow
- suspension on integrity failure

### Exit criteria
- restart preserves prior truth
- only gaps/stale edges are refreshed
- active files survive partial-write failure safely

---

## Stage 6 — Layer 4 Expansion
Future only.
Examples:
- regime awareness
- richer ATR and indicator frameworks
- advanced symbol intelligence overlays

### Exit criteria
Only allowed after Stages 1 to 5 are confirmed stable.

---

## Review Law
Every stage requires:
1. worker completion
2. Clerk review
3. Debug review
4. HQ approval
before next stage begins.
