# ASC Blueprint Pack — Complete EA Design

This folder is the **canonical EA design pack** for **Aurora Sentinel Scanner (ASC)**.

It defines **how the EA itself must behave at runtime**.
It does **not** define office workflow, Aurora doctrine, worker roles, or repo governance.

---

## 1. Scope

ASC is a **restore-first, timer-driven, multi-layer scanner EA** that must:

- discover and preserve the full broker universe
- determine truthful present market state per symbol
- capture a truthful broker snapshot for the entire universe
- surface-rank open symbols every 10 minutes to find the strongest current leaders per bucket
- promote only a bounded shortlist for deeper rolling enrichment
- persist rolling truth safely without destructive rewrites
- publish a full universe dump, a top-5-by-bucket summary, one canonical file per symbol, runtime state, and logs
- expose operator/trader HUD and menu surfaces that **display prepared state only**

ASC must **not**:

- place trades
- choose trade entries or exits
- act as Aurora
- pretend weak truth is strong truth
- restart from zero on every load
- run full-universe deep analytics on every timer cycle
- let UI own heavy calculations
- let developer workflow language leak into trader-facing product surfaces

---

## 2. Read order

1. `01_ASC_SYSTEM_BLUEPRINT.md`
2. `02_ASC_RUNTIME_NERVOUS_SYSTEM.md`
3. `03_ASC_DATA_PERSISTENCE_AND_PUBLICATION.md`
4. `04_ASC_SURFACE_RANKING_AND_DEEP_ENRICHMENT.md`
5. `05_ASC_BUILD_STAGES_AND_ACCEPTANCE.md`
6. `06_ASC_REFOUNDATION_AUDIT_AND_RUNTIME_CANON.md`

---

## 3. Canonical laws snapshot

1. **Restore first.** Restart means restore and continue, not wipe and guess.
2. **Closed is the only hard market block.** Most other weaknesses remain visible and are scored down rather than hidden.
3. **The kernel decides what is due.** Layers do not run blindly.
4. **Every data domain owns its own freshness clock.**
5. **Cheap broad first, expensive narrow second.**
6. **Promotion gives budget rights, not permanent privilege.**
7. **Published files are atomic. Summary is last.**
8. **Unknown stays explicit.**
9. **No symbol is forgotten because it is weak, closed, stale, or demoted.**
10. **HUD/menu display prepared truth only.**
11. **Product surfaces speak operator/trader language, not dev workflow language.**
12. **Rolling continuity outranks cosmetic cleanliness.**

---

## 4. Legacy lineage deliberately preserved here

This pack was shaped by the strongest survivable ideas from the old systems:

- **AFS BP1 / BP2 / BP3 / scanner notes**
  - timer-driven heartbeat
  - warm-state continuity
  - dossier-first / summary-last publication discipline
  - HUD truthfulness
  - explicit pending / stale / weak / known distinctions
  - stage-specific cadence and bounded enrichment

- **EA1 marketcore lineage**
  - timer-only runtime identity
  - OnTick empty / OnTimer orchestration
  - SymbolInfoTick and CopyTicks as distinct truth paths
  - authoritative snapshot-path vs history-path separation
  - bounded publish flow and truthful partial publication
  - re-entry guard, tick ring, session model, state summary model

- **ISSX runtime / scheduler / persistence lineage**
  - kernel phases for boot, clock, budget, due scan, publish fastlane
  - budget and fairness surfaces
  - service classes and resumable runtime state
  - continuity discipline and honest decode / restore failure handling

These ideas are **translated** into ASC rather than copied raw.

---

## 5. What this pack deliberately corrects from the current tree

The current repo already contains strong ideas, but the live implementation and older blueprint set still show the same recurring collapse:

- startup enables too much later-stage work too early
- discovery, truth fill, ranking, publication, and UI are too tightly coupled
- publication is too close to in-progress truth filling
- workflow text leaks into product surfaces
- persistence exists without a fully explicit kernel/service/freshness constitution

This blueprint pack fixes that by forcing a runtime shape of:

- contradiction and missing-function closure from the full ASC refoundation audit
- canonical runtime spine details for implementation staging
- kernel
- Layer 1 market truth
- Layer 1.2 broker snapshot
- Layer 2 surface competition
- promotion
- Layer 3 deep enrichment
- publication
- UI/logging

---

## 6. File count discipline

This pack intentionally stays **small**.

It uses a few major constitutional documents rather than dozens of scattered mini-docs.
The EA itself should reflect the same principle:

- one canonical universe dump
- one canonical summary
- one canonical runtime state file
- one rolling log family
- one canonical file per symbol

No front-door file explosion.

---

## 7. How to use this pack

Use this pack in two ways:

### A. As runtime truth
When deciding how the EA should behave, this pack outranks older scattered design notes.

### B. As build order law
When implementing the EA, the build stages in `05_ASC_BUILD_STAGES_AND_ACCEPTANCE.md` must be followed in order.
No stage may quietly assume a later subsystem already exists.

---

## 8. Final definition

ASC is correct only when it behaves like this:

- restore prior good state
- fill missing minimum truths without a destructive full reset
- maintain explicit market truth and broker truth for the whole universe
- re-rank open symbols every 10 minutes on cheap broad logic
- deepen only a bounded promoted set
- write rolling state atomically and honestly
- keep UI read-only and lightweight
- preserve weak, stale, frozen, deferred, and resumed states explicitly
- publish a truthful shortlist without hiding the universe behind it
