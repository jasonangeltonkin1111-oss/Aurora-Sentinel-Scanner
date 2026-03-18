# AURORA OPERATOR PROTOCOL

## PURPOSE

This file defines how Aurora Blueprint work must be operated so a new chat can continue safely without relying on bloated conversation memory.

This protocol is adapted from the ASC office/HQ control style, but translated for the Aurora Blueprint research-architecture project.

Aurora Blueprint work is not MT5 implementation work.
It is blueprint extraction, doctrine shaping, archive mapping, and continuity preservation.

---

# 1. AUTHORITY ORDER

Every future Aurora Blueprint run must obey authority in this order:

1. `README.md`
2. `INDEX.md`
3. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
4. `Aurora Blueprint/AURORA_RECOVERY_ORDER.md`
5. `Aurora Blueprint/AURORA_COMPLETION_TRACKER.md`
6. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
7. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
8. active Aurora Blueprint target modules
9. `archives/Aurora/` as source library only

If conflicts exist, the active Aurora Blueprint files override archive interpretation.
Archives are source material, not active doctrine.

---

# 2. PRIMARY LAWS

## Law 1 — Do not redesign privately
Do not restart architecture design from scratch unless a contradiction is proven and explicitly documented.

## Law 2 — Preserve layer order
Aurora Blueprint must continue in layers:
1. module map / continuity law
2. source inventory
3. market-state canon
4. execution-context surface
5. extraction queue
6. strategy-family registry
7. pattern atlas
8. research / volatility / review layers

## Law 3 — Archives are translated, not transplanted
Books and legacy files are source material only.
Nothing is imported as active doctrine without explicit Aurora mapping.

## Law 4 — No fake extraction claims
A scaffold file is a scaffold file.
Do not describe it as source-grounded extraction until actual source-grounded extraction happened.

## Law 5 — Tracker continuity is mandatory
Every meaningful run must update continuity artifacts before ending.
If the main tracker cannot be overwritten safely, an append-only run log must still be created.

## Law 6 — New files are safer than silent drift
If direct overwrite of a control file fails, create the required append-only run artifact rather than pretending the repo is updated.

---

# 3. REQUIRED START ROUTINE

Before changing anything, every new Aurora Blueprint run must:

1. read `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
2. read `Aurora Blueprint/AURORA_RECOVERY_ORDER.md`
3. read `Aurora Blueprint/AURORA_COMPLETION_TRACKER.md`
4. read `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
5. read `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
6. read the most recent append-only run file in `Aurora Blueprint/runs/` if one exists
7. read the target module(s) relevant to the next step

---

# 4. REQUIRED ARCHIVE CLASSIFICATION

Before using a source, classify it explicitly as one of:

- `TRANSLATE`
- `REFERENCE ONLY`
- `DO NOT USE`

For Aurora Blueprint book work, most archive books will begin as:
- `TRANSLATE` for concept extraction, state extraction, strategy-family extraction, or risk extraction
- `REFERENCE ONLY` when useful only for worldview or comparison
- `DO NOT USE` when out of scope, non-trading, or structurally incompatible

Every meaningful run should state which source class applied.

---

# 5. REQUIRED HANDOFF FORMAT

Every meaningful Aurora Blueprint run must record:

## 1. CHANGED FILES
Exact files created or modified.

## 2. PURPOSE OF THE RUN
What this run was trying to advance.

## 3. SOURCE USE NOTE
Which books, indexes, or archive files were used.
Classification for each:
- TRANSLATE
- REFERENCE ONLY
- DO NOT USE

## 4. COMPLETION CHANGE
What actual project progress changed.

## 5. OPEN RISKS
What remains unresolved.

## 6. NEXT RECOMMENDED ACTION
What the next chat should do next.

---

# 6. CONTINUITY SYSTEM

Aurora Blueprint continuity uses two layers:

## Layer A — Stable control files
These are the durable operating files:
- `AURORA_OPERATOR_PROTOCOL.md`
- `AURORA_RECOVERY_ORDER.md`
- `AURORA_COMPLETION_TRACKER.md`
- `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
- `AURORA_BOOK_MASTER_INDEX.md`

## Layer B — Append-only run files
These are immutable run records created inside:
- `Aurora Blueprint/runs/`

Append-only run files exist to reduce dependence on fragile overwrite flows.
They are not a replacement for the main tracker, but they preserve continuity if the main tracker update lags.

---

# 7. APPEND-ONLY RUN FILE LAW

If a meaningful run creates or advances real project state, it should create a run file in:

- `Aurora Blueprint/runs/AURORA_RUN_XXX.md`

The run file should include:
- date / run number
- files changed
- source use note
- completion delta
- next action

This creates a fallback continuity trail even when a direct overwrite of the main tracker is difficult.

---

# 8. UPDATE PRIORITY RULE

At the end of a meaningful run, update in this order:

1. create or update the actual blueprint deliverable(s)
2. update `AURORA_COMPLETION_TRACKER.md` if possible
3. always create or update the append-only run file for that run if tracker overwrite is uncertain

A run is not continuity-safe unless at least one continuity artifact reflects it.

---

# 9. CURRENT JUDGMENT

Aurora Blueprint is now large enough that fixed operating law is required.

The ASC office/HQ method is valuable here because it preserves:
- fixed reading order
- active-truth hierarchy
- bounded work
- archive classification
- explicit handoff law

Aurora Blueprint should copy those strengths without importing unrelated ASC implementation rules.
