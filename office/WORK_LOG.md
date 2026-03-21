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
- finalized Market State Detection menu grouping with explicit Market Status Detection and Dossiers & Publication sections
- strengthened runtime continuity loading with `.last-good` fallback and richer continuity metadata
- improved heartbeat repair behavior for missing dossiers and added clearer recovery and bounded-work logging
- refreshed office task, decision, work-log, and SHA-checkpoint discipline to match the new pass

### Result
ASC is still bounded to scanner-foundation scope, but it is now more explicit about what it must preserve for Aurora later and more controlled about how runtime continuity and office checkpoints are handled.

---
## 2026-03-20 — Market State Detection promotion failure stabilization

### Why
Market State Detection was running but leaving only `.tmp` files behind, which blocked real dossier, runtime, scheduler, and summary publication.

### What changed
- replaced text-mode temp validation reads with binary-safe whole-file reads so atomic validation compares the actual written payload instead of a line-truncated text read
- added explicit atomic write error reporting around temp write, validation, promote, and rollback paths
- changed heartbeat accounting so failed dossier promotions still advance fairness and show up in per-heartbeat summaries instead of starving the queue
- changed save cadence handling so failed runtime, scheduler, and summary saves retry honestly instead of pretending a save timestamp succeeded
- reduced repair spam by summarizing queued missing dossier repairs while keeping per-symbol detail for debug verbosity

### Result
Market State Detection publication is materially easier to verify: real promotion attempts are now diagnosable, bounded work remains fair under failure, and continuity saves no longer hide write failures.

---
## 2026-03-20 — ASC capability naming and working-stage ledger hardening

### Why
The active ASC foundation was working, but active canon still preferred numeric layer wording in too many places and lacked a compact regression ledger tied to the current Market State Detection boundary.

### What changed
- shifted active blueprint and deep-pack references toward capability-first naming while keeping the ordered capability stack explicit
- hardened the Market State Detection ownership boundary and kept later capabilities visibly reserved
- renamed runtime placeholder inputs/hooks away from numeric layer wording without changing behavior
- created an operational `office/WORKING_STAGE_LEDGER.md` for current working-stage regression checks

### Result
The current foundation stays behaviorally intact, future insertion points remain explicit, and regressions against the working Market State Detection pass should now be easier to localize.

---
## 2026-03-20 — Market State Detection hardening and Explorer shell activation

### Why
The active foundation was close, but it still needed a final hardening sweep around write safety, session-truth classification, dossier consistency, menu discipline, and a real Explorer shell that stayed presentation-only.

### What changed
- introduced explicit wrapper/header identity discipline at version 1.001 across runtime, continuity, dossier, and explorer surfaces
- hardened atomic promotion with stale-temp cleanup, post-promote validation, and clearer rollback behavior
- tightened market-state truth so broker session evidence can override stale fresh-tick ambiguity instead of falsely claiming open markets
- improved heartbeat fairness and degraded logging so cursor progression remains honest without repeated warning spam
- added a dedicated Explorer HUD shell with overview, bucket placeholder, symbol detail, back/home navigation, scroll controls, and strict chart-object ownership
- cleaned the EA menu into active versus reserved ownership groups without implying future capability activation

### Result
Market State Detection is materially more trustworthy at the edges, the Explorer HUD shell is now active for Layer 1 truth display, and later capabilities remain visible only as honest placeholders.

---
## 2026-03-20 — Compile-fix and correctness debug pass

### Why
The prior hardening pass introduced useful structure, but MT5 compile feedback exposed unsupported HUD symbol fields and a file-read type warning that needed a focused correction pass.

### What changed
- fixed the `FileReadArray` type warning by reading into an unsigned count with safe casts only at string conversion boundaries
- replaced unsupported HUD symbol-detail fields with compile-safe live fields: Bid, Ask, Spread, Day High, Day Low, and Market Watch Update Time
- removed unsafe `MathMax`/`MathMin` mixed-type usage in scheduler and HUD selection paths where straightforward integer-only logic was clearer
- rechecked HUD action routing, prefix ownership, placeholder honesty, and Layer 1 wording without widening capability scope

### Result
The active runtime should now be materially closer to MT5 compile-clean status while preserving Market State Detection as the only working capability and keeping the Explorer shell truthful.

---
## 2026-03-21 — HUD v2 and menu refinement pass

### Why
The Explorer shell was structurally correct, but it still felt too flat, bucket navigation skipped an important step, reserved menu groups were noisier than necessary, and version bumps were not yet enforced as a standing rule.

### What changed
- bumped the wrapper to 1.020 and the explorer subsystem to 0.300 for a meaningful HUD/menu subsystem expansion
- added explicit blueprint and runtime discipline that every meaningful edit must bump version
- refined the menu so reserved groups stay visible but more intentional, with timeframe placeholders returned to the correct reserved homes
- upgraded the explorer to HUD v2 with a stronger console hierarchy, bucket detail view, stat detail shell, right-side control rail, and block-based overview and symbol pages
- kept Market State Detection as the only working capability and preserved future capability surfaces as honest placeholders

### Result
The active Layer 1 console is now visually stronger, navigation-safe, future-safe, and explicitly version-disciplined without widening beyond the current capability boundary.
