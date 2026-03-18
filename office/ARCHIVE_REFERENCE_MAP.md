# ARCHIVE REFERENCE MAP

## Purpose
This file is mandatory reading for every worker before changing `blueprint/`, `office/`, or `mt5/`.

Its role is to stop two failure modes:
- ignoring valuable legacy source material
- blindly reusing old systems that do not belong in ASC

Archives are a reference layer only.
They preserve provenance.
They do **not** define the active product directly.

Authority remains:
1. `README.md`
2. `INDEX.md`
3. active `blueprint/`
4. active `office/`
5. active `mt5/`
6. `archives/` as provenance and translation source

---

## Hard Laws
- `archives/` is read-only.
- Never edit archive source files.
- Never copy old modules into MT5 blindly.
- Never expand ASC by importing old Aurora systems.
- Every archive-derived implementation must be **translated**, not transplanted.
- If archive source conflicts with active blueprint, HQ must resolve the conflict before coding.
- If archive source is useful but too broad, extract only the minimum product-relevant truth.

---

## Required Worker Behavior
Before starting work, every worker must classify archive material into one of these states:

### 1) TRANSLATE
Use the archive as upstream truth, but rebuild it cleanly for ASC.

### 2) REFERENCE ONLY
Use for naming, field ideas, sequencing, or historical context.
Do not import structure directly.

### 3) DO NOT USE
Keep as provenance only.
Do not pull it into blueprint or MT5.

Workers must state which archive items they relied on in their handoff.

---

## Verified Archive Map

### A. `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
**State:** TRANSLATE

### Why this matters
This is a core upstream truth source from the legacy scanner system.
It contains:
- server-specific broker symbol rows
- `RawSymbol -> CanonicalSymbol` mapping
- `AssetClass`
- `PrimaryBucket`
- `Sector`
- `Industry`
- `ThemeBucket`
- `SubType`
- `AliasKind`
- classification confidence/review metadata
- symbol normalization helpers
- suffix stripping and alias handling

### What ASC may use from it
- canonical identity model
- broker suffix stripping rules
- punctuation normalization rules
- alias resolution approach
- server-aware matching
- resolved/unresolved classification behavior
- fallback discipline when no row exists

### What ASC must not do with it
- do not copy the file unchanged into `mt5/`
- do not let Output or Summary own bucket logic
- do not guess classification when lookup fails
- do not collapse its structure into a simplified hardcoded bucket hack

### ASC translation target
Rebuild this into the active Market module so Market becomes the single source of runtime identity truth.

---

### B. `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
**State:** REFERENCE ONLY (selective translation allowed)

### Why this matters
This file preserves the old scanner's shared field vocabulary and data surfaces.
It includes large shared structs, especially `AFS_UniverseSymbol`, with fields for:
- broker symbol identity
- classification fields
- broker specs
- quote state
- M15/H1 counts
- economics fields
- ATR/history/friction state
- scores and runtime timestamps

### What ASC may use from it
- field naming inspiration
- dossier field candidates
- spec/history/calculation grouping ideas
- minimal state naming for symbol records

### What ASC must not do with it
- do not import the full struct set wholesale
- do not import HUD/output mode machinery
- do not import pipeline/test enums
- do not import trader-intel, multi-mode, or publication scaffolding
- do not let legacy struct breadth bloat first-slice ASC

### ASC translation rule
Only pull the minimum fields needed for:
- Market identity
- Conditions intake
- Storage persistence
- Output publication

If a field is not required for the first working slice, leave it out.

---

### C. `archives/BLUEPRINT_REFERENCE/`
**State:** REFERENCE ONLY

### Why this matters
This area preserves older blueprint history and evolution intent.
It is useful for understanding how the project drifted and what complexity traps already existed.

### What ASC may use from it
- provenance
- old terminology mapping
- architectural lessons
- anti-drift awareness

### What ASC must not do with it
- do not re-import old architecture wholesale
- do not restore old Aurora scope
- do not use it to justify strategy, execution, vault, or journaling systems in ASC first slice

---

### D. `archives/BLUEPRINT_REFERENCE/AURORA.txt`
**State:** DO NOT USE for implementation

### Why this matters
This file documents the old AURORA-OS style system: multi-layer trading OS, vaults, arbitration, journaling, execution/risk governance, and broad live decision logic.

### ASC must not import from it
- strategy logic
- signal generation
- vault systems
- arbitration frameworks
- execution governance
- account/risk layers
- journaling systems
- research/live deployment layers

### Allowed use
Only as a warning reference for scope drift.
If a worker starts rebuilding anything that resembles old Aurora, stop and escalate to HQ.

---

### E. `archives/EXTRACTED_REFERENCE/`
**State:** REFERENCE ONLY unless HQ upgrades a file to TRANSLATE

### Why this matters
This area appears to preserve smaller extraction/reference utilities and cadence-related artifacts.

### Worker rule
Do not assume these are safe to import.
Use only after HQ names the exact file and translation purpose.

---

## Product Guardrail
ASC is:
- scanner
- classification-aware market intelligence engine
- ranking + shortlist system
- output publisher

ASC is **not**:
- the old Aurora system
- a trading EA
- a signal engine
- an execution system
- a vault framework

Archive use must always preserve this boundary.

---

## Mandatory Archive Decision Test
Before using any archive file, the worker must answer:

1. Is this upstream truth, or only historical design?
2. Does ASC need this for the first working slice?
3. Can the useful part be extracted without importing old system scope?
4. Which state applies: TRANSLATE, REFERENCE ONLY, or DO NOT USE?
5. What exact active module receives the translated result?

If those answers are not explicit, the worker is not ready to touch implementation.

---

## Worker Handoff Requirement
Every worker handoff must include an `ARCHIVE USE NOTE` block:

- Archive files consulted
- Classification for each file:
  - TRANSLATE
  - REFERENCE ONLY
  - DO NOT USE
- Exact truth extracted
- Exact legacy scope rejected
- Active files changed as a result

No handoff is complete without this note.

---

## HQ Interpretation Lock
For ASC first slice, the current HQ archive lock is:

- `AFS_Classification.mqh` -> TRANSLATE into Market
- `AFS_CoreTypes.mqh` -> selective field reference only
- old Aurora blueprints -> anti-drift reference only
- anything execution/strategy/vault related -> DO NOT USE

If future archive material becomes relevant, HQ must extend this file explicitly.
