# ASC Blueprint Pack

This folder is the **new canonical EA design pack** for ASC.

It is **not** an office/control pack, not an Aurora pack, and not a worker-management pack.  
It defines **how the EA itself must work**.

## Scope

ASC is a **restore-first, timer-driven market scanner** that:

- discovers the broker universe
- determines truthful market-open/market-closed state per symbol
- captures a truthful broker snapshot for the whole universe
- performs a cheap open-symbol surface ranking every 10 minutes
- promotes only the strongest symbols per bucket for deep enrichment
- persists rolling data safely with atomic writes
- publishes a universe dump, a top-5-by-bucket summary, and one file per symbol
- exposes operator/trader HUD surfaces that only display prepared truth

ASC does **not**:

- place trades
- generate entry signals
- act as Aurora
- behave like a dev workflow
- recompute the full universe deeply on every timer cycle
- wipe state on restart
- hide unknown truth behind fake neat states

## Read order

1. `01_ASC_SYSTEM_BLUEPRINT.md`
2. `02_ASC_RUNTIME_NERVOUS_SYSTEM.md`
3. `03_ASC_DATA_PERSISTENCE_AND_PUBLICATION.md`
4. `04_ASC_SURFACE_RANKING_AND_DEEP_ENRICHMENT.md`
5. `05_ASC_BUILD_STAGES_AND_ACCEPTANCE.md`

## Integrated legacy lineage

This pack was deliberately shaped using the strongest ideas that survived pressure from the old systems.

### Preserved from legacy
- restore-first runtime, not restart-from-zero
- timer-driven orchestration
- bounded round-robin work
- active-set promotion for expensive work
- dossier/symbol publication before summary publication
- explicit stale/degraded/warmup truth
- per-symbol continuity, not giant monolithic blobs
- freeze-over-forget behavior when symbols leave the promoted set
- HUD displays prepared state only
- continuity/load/save honesty

### Adapted for ASC
- Layer 1 / 1.2 / 2 / 3 runtime spine
- kernel scheduler with due services and budgets
- truth-weighted ranking instead of overusing hard pass/fail gates
- top-5-per-bucket competition
- full-universe broker snapshot plus promoted deep rolling state
- rolling OHLC / ATR / tick stores with domain-specific cadences

### Rejected from legacy
- full-universe deep recomputation
- publication from half-complete refreshes
- giant unreadable continuity blobs
- HUDs that compute or mutate scanner truth
- mixing trader-facing surfaces with dev workflow wording
- scattering control language inside product outputs

## Major contradictions fixed from the current ASC tree

The current live ASC still does too much in one pass.

Examples of the current collapse that this pack corrects:

- init enables history, ATR, surface, publication, HUD, and menu at once
- engine performs discovery, symbol processing, snapshot save, and publish in the same runtime sweep
- HUD exposes internal workflow text like `Layer 1 / Layer 1.2 / Surface`
- summary publication happens from the same general pass that is still filling truth
- persistence exists, but the runtime nervous system is not explicit enough yet

This pack fixes that by splitting the EA into:
- kernel
- market truth
- broker snapshot
- surface competition
- promotion
- deep enrichment
- publication
- UI/logging

## Canonical laws snapshot

1. **Closed is the only hard market block.** Everything else remains visible and scored.
2. **Restart means restore and continue, not wipe and guess.**
3. **The kernel decides what is due; layers do not run blindly.**
4. **Every data domain owns its own freshness clock.**
5. **Deep work belongs only to promoted symbols.**
6. **Summary output is last; it can only point to files already safely published.**
7. **HUD/menu never calculate heavy truth.**
8. **Unknown stays explicit.**
9. **No symbol is forgotten merely because it is currently weak or closed.**
10. **Product surfaces must speak trader/operator language, not dev workflow language.**
