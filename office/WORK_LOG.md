# Work Log

This file is append-only.

## 2026-03-21 — Layer 1 readiness warmup-rule replacement pass

### Why
The active runtime still carried warmup language that could be mistaken for dossier-missing gating, but Layer 1 readiness is now owned by promoted compressed-priority buckets plus first-pass market-state coverage.

### What changed
- replaced the warmup exit rule with Layer 1-only readiness checks based on promoted priority-set-1 prepared truth and configurable discovered-symbol assessment share
- added persisted runtime readiness fields for total discovered symbols, compressed primary readiness, warmup minimum state, background completion, and readiness percent
- updated HUD wording and active blueprint/control files so warmup, primary loading, and background completion read honestly and consistently

### Result
Warmup now exits on truthful Layer 1 readiness rather than dossier-missing heuristics, while lower-priority completion remains visible and non-blocking.

---
## 2026-03-20 — Office normalization baseline

### Why
The archive office proved useful control patterns, but it also proved that too many narrow files create drag.

### What was reviewed
Archive office patterns were checked across:
- `archives/Asc Archive/office/SHA_LEDGER.md`
- `archives/Asc Archive/office/TASK_BOARD.md`
- `archives/Asc Archive/office/MASTER_LOG.md`
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

---
## 2026-03-21 — Dynamic bucket architecture pass

### Why
The HUD bucket flow was still locked to a fixed placeholder list and fixed seed counts, which would make future identity activation and later bucket-aware layers harder to thread in cleanly.

### What changed
- replaced fixed bucket placeholder helpers with a dynamic bucket definition and render view-model layer
- added bucket detail display modes for Top 3, Top 5, and All with navigation-state persistence and all-mode scroll handling
- reshaped bucket detail into header, mode strip, symbol lane, summary, and reserved future strip regions
- removed fake broker-specific equity suffix claims from placeholder references and kept canonical references explicit
- bumped wrapper and explorer subsystem versions for the structural HUD expansion

### Result
Bucket List and Bucket Detail are now dynamic-ready for future identity activation while Market State Detection remains the only active truth surface.

---
## 2026-03-21 — Consolidated HUD fix and hardening pass

### Why
The Explorer HUD still depended on brittle bucket scrolling, bucket detail was collapsing vertically, placeholder bucket content risked implying too much maturity, and File I/O still reported a remaining type-conversion warning.

### What changed
- bumped the wrapper to 1.040 and the explorer subsystem to 0.320 for a meaningful HUD/navigation/filtering expansion
- replaced bucket-list scrolling with dynamic page calculation and per-page button rendering tied to the visible viewport
- replaced all-mode bucket symbol scrolling with dynamic pagination and persistent page state
- added an operator-visible Market Filter with All Symbols and Open Only modes that stays presentation-only and does not invent live identity truth
- rebuilt bucket detail into a fixed header, control strip, split symbol-lane and summary region, and muted reserved future strip
- added safer text fitting, stronger semantic row labels, and richer scanner-console hierarchy across bucket, symbol, stat, and status surfaces
- cleared the remaining File I/O size-read conversion warning without weakening atomic validation or rollback behavior

### Result
The Explorer surface is more navigable, more honest, and better prepared for future layer insertion while preserving Market State Detection as the only active capability.

---
## 2026-03-21 — Universal HUD and identity hardening pass

### Why
The Explorer HUD was close, but cross-broker symbol resolution, Open Only truth, render diagnostics, and rail fit still had honesty and reliability gaps across sampled terminals.

### What changed
- bumped the wrapper to 1.060 and the explorer subsystem to 0.360 for a meaningful universal HUD hardening pass
- added evidence-based symbol normalization helpers for safe canonical-to-broker matching across sampled suffix families such as `.nx`, `.m`, `.c`, `.o`, `.OQ`, `.xhkg`, and `cash` variants
- fixed bucket Open Only logic so only resolved live symbols in `ASC_MARKET_OPEN` qualify while unresolved placeholders remain visible only in All Symbols
- completed and evened out the placeholder bucket catalog, including a full FX Major set and more balanced index, metals, energy, crypto, and equity families
- hardened HUD render entry with bounded diagnostics, compact fallback rendering, richer status context, and a less overloaded global control rail
- strengthened scanner-console hierarchy so resolved/open, warning, reserved, and muted states read more decisively without widening beyond Layer 1 truth

### Result
The active Explorer HUD remains presentation-only, but it is now more truthful across brokers, more diagnosable across terminals, and cleaner about what is resolved live truth versus canonical placeholder structure.

- 2026-03-21: Migrated Explorer bucket truth to standalone ASC classification and dynamic live-broker buckets; Open Only now hides zero-open classified buckets and bucket detail uses real classified symbols.

---
## 2026-03-21 — HQ continuity office-control and task-map hardening pass

### Why
The repo had reached the point where the shallow task board and optimistic stage wording were no longer enough. The next wave needs a tighter control layer that maps what is complete, half-done, provisional, wrong, fragile, and blocked — while enforcing version and SHA discipline on every meaningful pass.

### What was reviewed
Active control and evidence surfaces were checked across:
- `office/TASK_BOARD.md`
- `office/WORKING_STAGE_LEDGER.md`
- `office/SHA_LEDGER.md`
- `office/WORK_LOG.md`
- `office/OFFICE_CANON.md`
- `mt5_runtime_flat/ASC_Common.mqh`

Repo-state and runtime truth from the current audit were also used to re-evaluate explorer ownership, dynamic bucket maturity, and version-discipline expectations.

### What changed
- expanded the task board into a standing execution map covering complete, half-done, fragile, blocked, and immediate-next streams
- embedded mandatory version-bump, SHA-ledger, and fault-finding rules into active office control
- corrected the working-stage ledger so explorer/runtime ownership leakage is described honestly instead of over-claiming presentation-only purity
- recorded dynamic classification and bucket truth as active but provisional rather than fully reserved or fully trustworthy
- bumped the wrapper version to 1.071 and the explorer subsystem version to 0.371 for this meaningful control and runtime-facing truth-discipline pass
- refreshed the SHA ledger for all changed tracked files

### Result
The repo now has a much clearer HQ execution map for moving quickly without getting sloppy: every meaningful pass must carry version discipline, SHA-ledger maintenance, and a fault-finding sweep, while the next implementation order is kept anchored to runtime truth rather than convenience.

---
## 2026-03-21 — Final bounded truth-alignment and logging hardening pass

### Why
Shared version constants, blueprint 11 doctrine, and file-log failure visibility had drifted away from current live runtime truth.

### What changed
- aligned `ASC_Common.mqh` wrapper and explorer subsystem constants to the live runtime header state at 1.080 / 0.380
- corrected blueprint 11 so symbol identity and bucketing are described as blueprint-active and runtime-active but provisional, with runtime-owned prepared buckets consumed by the explorer
- added one-time terminal visibility when file logging cannot open or append, while preserving normal terminal printing and existing append behavior when the file path works

### Result
Current repo truth is tighter: shared version constants now match the live runtime header, blueprint doctrine no longer understates active prepared-bucket behavior, and file-log failure is no longer silent.

---
## 2026-03-21 — Layer 1 readiness warmup threshold pass

### Why
Warmup was still coupled too closely to missing dossier count, which meant the runtime could stay in warmup long after the minimum Layer 1 scanner truth was already available.

### What changed
- bumped the wrapper to 1.090 and the explorer subsystem to 0.390 for this runtime, persistence, HUD, and control-surface readiness pass
- replaced dossier-count-only warmup gating with a Layer 1 readiness model based on first-pass assessment coverage plus all currently discovered compressed priority-set-1 buckets
- added explicit runtime readiness fields for initial assessed symbols, primary-bucket assessed symbols, warmup minimum status, warmup progress percent, and background hydration activity
- persisted the new readiness fields in runtime continuity and surfaced them in the Explorer header, overview, and status banner
- updated active blueprint and office control surfaces so warmup/steady semantics match the new runtime truth

### Result
Boot and recovery now enter warmup honestly, promote to steady once the minimum Layer 1 threshold is met, and keep lower-priority preparation visible as background hydration instead of trapping the runtime in warmup forever.

---
## 2026-03-21 — Compressed Layer 1 bucket adapter pass

### Why
The active classification taxonomy was rich enough for future drilldown, but the first operator surface still exposed overly granular main buckets instead of a compressed Layer 1 menu.

### What changed
- bumped the wrapper to 1.091 and the explorer subsystem to 0.391 for this runtime, HUD, and control-surface bucketing pass
- kept the standalone classification taxonomy intact while adding a compressed Layer 1 bucket adapter for exactly six main buckets: FX, Indices, Metals, Energy, Crypto, and Stocks
- updated prepared bucket naming and lookup so bucket list pages use compressed IDs/names while prepared symbol metadata still carries `primary_bucket`, sector, industry, theme bucket, and subtype for later drilldown
- updated bucket detail HUD wording so future regional stock grouping can surface as metadata without becoming first-class main pages
- aligned active blueprint and office control surfaces to state the compressed Layer 1 bucket law explicitly

### Result
The first operator surface is now simpler and truer to Layer 1 intent: main navigation stays compressed, while deeper classification truth remains preserved for later stock-region and sector drilldown work.

---
## 2026-03-21 — Rolling prepared-state scaffold pass

### Why
Explorer bucket truth still depended on a rebuild-everything path. The next safe step was to move to rolling, batch-scoped prepared-state promotion without pretending the later persistence or deep stock taxonomy phases are complete.

### What changed
- bumped the wrapper to 1.092 and the explorer subsystem to 0.392 for this runtime-owned prepared-state scaffold pass
- added lightweight prepared-state diagnostics for batch timings, warmup/readiness counters, batch promotion counts, and bounded-work pressure summary
- split bucket preparation into named phases for classification, bucket sort, prepared-symbol reorder, and final promotion timing capture
- introduced a first rolling-state scaffold with working-batch output, last-good prepared state, atomic promotion of completed batch output, and unchanged-batch reuse markers
- switched bucket preparation from whole-universe rebuild semantics to the first three compressed batches: priority-set mains, stock main/regional grouping, and finer stock taxonomy metadata
- wired the EA so explorer navigation always consumes the last-good promoted prepared state instead of requiring a full rebuild at navigation time
- persisted only minimal rolling-prepared continuity metadata in runtime state: last batch id, promoted batch count, pending batch count, and bounded-work summary

### Incomplete on purpose
- stock batch reuse is scaffold-grade and still recomputes the targeted batch from current classifier truth rather than diffing individual symbol deltas
- finer stock taxonomy metadata currently enriches the stock bucket in-place and does not yet persist a separate prepared snapshot artifact
- MT5 / MetaEditor compile verification still needs to be run in the target toolchain before claiming the scaffold compile-clean

### Result
Prepared bucket truth is now rolling-state capable in a first safe form: the explorer reads a promoted last-good snapshot, batch work is measurable, and incomplete deeper persistence remains explicitly out of scope for this pass.

---
## 2026-03-21 — Layer 1 diagnostics observability pass

### Why
Prepared-bucket hydration, heartbeat dispatch, and HUD render timing had become important to runtime honesty, but the repo did not yet preserve a compact observability surface for last-value diagnostics, warmup/readiness transitions, bounded-work pressure shifts, or action-to-render latency.

### What changed
- bumped the wrapper to 1.111 and the explorer subsystem to 0.431 for this runtime observability hardening pass
- added compact Layer 1 diagnostics fields for bucket preparation, classification, sorting, reorder, promotion, heartbeat dispatch, HUD render, page-switch latency, warmup/readiness, bounded-work pressure, last promoted batch, and active hydration priority set
- timed prepared-batch work, heartbeat dispatch, and HUD render/page-switch paths with low-cost last-value plus cheap rolling max/avg tracking
- constrained diagnostics logging to summary lines triggered by material change, threshold breach, warmup movement, and bounded-work pressure shifts
- extended runtime continuity so the compact diagnostics state survives restart without creating a new persistence artifact
- updated office control truth to record diagnostics continuity as part of the current runtime-owned Layer 1 surface

### Result
Layer 1 observability is now explicit, compact, and continuity-safe: operators can see prep/dispatch/render pressure in the HUD and runtime state without per-symbol or per-frame log spam.
