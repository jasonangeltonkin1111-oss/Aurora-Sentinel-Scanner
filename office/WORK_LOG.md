# Work Log

This file is append-only.

## 2026-03-20 — Office normalization baseline

### Why
The archive office proved useful control patterns, but it also proved that too many narrow files create drag.

### What was reviewed
Archive office patterns were checked across:
- `archives/Asc Archive/office/SHA_LEDGER.md`
- `archives/Asc Archive/office/TASK_BOARD.md`
- `archives/Asc Archive/office/MASTER_LOG.md`
- `archives/Asc Archive/office/DECISIONS.md`
- `ASC Office/ASC_OFFICE_CANON.md`

### What was kept
- canonical office law
- task board
- decision log
- work log
- SHA ledger

### What was dropped
- active HQ sprawl
- handoff sprawl
- wave packet clutter
- many tiny office files

### Result
Created a new compact `office/` root intended to be the active long-lived control layer.

---
## 2026-03-20 — Deep foundation hardening and Aurora bridge pass

### Why
The first hardening pass removed obvious naming drift, but the repo still needed clearer scanner-to-Aurora boundaries, better continuity fallback doctrine, stronger office checkpoint discipline, and more explicit runtime recovery detail.

### What was reviewed
Active surfaces were checked across:
- `blueprint/`
- `asc-mt5-scanner-blueprint/`
- `mt5_runtime_flat/`
- `office/`

Read-only evidence was also checked in:
- `archives/Asc Archive/blueprint/`
- `archives/BLUEPRINT_REFERENCE/`
- `Aurora Blueprint/`

### What changed
- added explicit ASC-to-Aurora bridge requirements in the active blueprint and deep implementation pack
- tightened runtime and publication docs around restore fallback, fairness, degraded behavior, and dossier bridge use
- added a dedicated menu/input and staged-test blueprint so the runtime can grow into later layers without menu retrofit drift
- finalized Layer 1 menu grouping with explicit Market Status Detection and Dossiers & Publication sections
- strengthened runtime continuity loading with `.last-good` fallback and richer continuity metadata
- improved heartbeat repair behavior for missing dossiers and added clearer recovery and bounded-work logging
- refreshed office task, decision, work-log, and SHA-checkpoint discipline to match the new pass

### Result
ASC is still bounded to scanner-foundation scope, but it is now more explicit about what it must preserve for Aurora later and more controlled about how runtime continuity and office checkpoints are handled.

---
## 2026-03-20 — Layer 1 promotion failure stabilization

### Why
Layer 1 was running but leaving only `.tmp` files behind, which blocked real dossier, runtime, scheduler, and summary publication.

### What changed
- replaced text-mode temp validation reads with binary-safe whole-file reads so atomic validation compares the actual written payload instead of a line-truncated text read
- added explicit atomic write error reporting around temp write, validation, promote, and rollback paths
- changed heartbeat accounting so failed dossier promotions still advance fairness and show up in per-heartbeat summaries instead of starving the queue
- changed save cadence handling so failed runtime, scheduler, and summary saves retry honestly instead of pretending a save timestamp succeeded
- reduced repair spam by summarizing queued missing dossier repairs while keeping per-symbol detail for debug verbosity

### Result
Layer 1 publication is materially easier to verify: real promotion attempts are now diagnosable, bounded work remains fair under failure, and continuity saves no longer hide write failures.
