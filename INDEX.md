# INDEX

This file is the permanent navigation map for the Aurora Sentinel Scanner repository.

It explains what each major area is for, what belongs there, and what does **not** belong there.
It is intended to remain stable even as implementation grows.

This is a navigation and orientation file.
If any detail here ever conflicts with a contract inside `blueprint/`, the relevant `blueprint/` file wins.

---

# 1. REPOSITORY PURPOSE

Aurora Sentinel Scanner is a broker-aware MT5 market intelligence system.

It is built around four top-level areas:
- `blueprint/`
- `office/`
- `mt5/`
- `archives/`

These four roots must remain visually clear and conceptually separate.

---

# 2. TOP-LEVEL MAP

## `README.md`
Human-friendly front door.
Use it to understand the repo at a glance.

## `INDEX.md`
Permanent navigation map.
Use it to understand where everything belongs.

## `blueprint/`
The constitutional source of truth.
Contains architecture, contracts, boundaries, schemas, and system meaning.

## `office/`
The master/worker governance space.
Contains decisions, locks, project ownership, handoffs, and build sequencing.

## `mt5/`
The production MT5 product space.
Contains the actual EA deployment tree and product-facing code structure.

## `archives/`
Historical preserved reference material.
Contains old blueprints, maps, legacy systems, and extracted references.

---

# 3. WHAT EACH ROOT IS FOR

## `blueprint/` — CONSTITUTION

Use `blueprint/` when you need to answer:
- what the system is
- how the runtime works
- what each module owns
- how persistence behaves
- how outputs must look
- where UI stops and internal logic begins

`blueprint/` is for stable system truth, not daily coordination.

### Contents
- `README.md` — overview of the blueprint folder
- `SYSTEM_OVERVIEW.md` — high-level definition of Aurora Sentinel Core
- `ARCHITECTURE_RULES.md` — hard system rules and forbidden patterns
- `LAYER_MODEL.md` — 3-layer rolling runtime model
- `MODULE_MAP.md` — logical module separation and responsibilities
- `MARKET_IDENTITY_MAP.md` — contract-level explanation of broker symbol identity and bucket mapping
- `PERSISTENCE_CONTRACT.md` — startup restore, stale detection, and gap-fill behavior
- `OUTPUT_CONTRACT.md` — canonical output definitions
- `SUMMARY_SCHEMA.md` — trader-facing summary rules
- `SYMBOL_FILE_SCHEMA.md` — per-symbol deep file contract
- `RUNTIME_RULES.md` — runtime behavior and build-order intent
- `UI_BOUNDARY.md` — separation between internal logic and HUD/menu/display
- `CHANGELOG.md` — blueprint-era changes worth preserving

### Does belong here
- rules
- contracts
- schemas
- architectural meaning
- preserved operating assumptions

### Does not belong here
- worker chatter
- active handoffs
- MT5 code
- temporary experiments

---

## `office/` — GOVERNANCE

Use `office/` when you need to answer:
- who is working on what
- what is locked
- what decisions are already locked
- what order modules should be built in
- what the master should assign next

`office/` is the internal operating floor.
It is markdown-only.
No MT5 code belongs here.

### Contents
- `README.md` — overview of office purpose
- `TASK_BOARD.md` — current project/build state
- `FILE_LOCKS.md` — lock register for safe parallel work
- `DECISIONS.md` — locked operational/project decisions
- `MASTER_LOG.md` — master-level running notes
- `WORKER_RULES.md` — worker discipline and boundaries
- `MASTER_RULES.md` — master discipline and boundaries
- `MODULE_OWNERSHIP.md` — which worker/project owns which product area
- `BUILD_ORDER.md` — intended module build sequence
- `SHA_LEDGER.md` — old/new SHA tracking guidance for updates
- `ACTIVE_PROJECTS/` — current bounded project packets or active project notes
- `HANDOFFS/` — internal worker handoffs only

### Does belong here
- coordination
- ownership
- project state
- locks
- decisions
- handoffs

### Does not belong here
- MT5 product code
- archived raw maps
- trader-facing outputs

---

## `mt5/` — PRODUCT

Use `mt5/` when you need to answer:
- what goes into the terminal
- what the deployable EA looks like
- where `.mq5` and `.mqh` files belong

This is the product side only.

### Current deployment rule
The MT5 deployment layout is flat.
That means all product `.mq5` and `.mqh` files live directly in one EA folder when used in the terminal.
No nested product module folders are used in terminal deployment.

### Flat deployment clarification
The repo may contain the single deployment folder `mt5/AuroraSentinelCore/`.
Inside that folder, product `.mq5` and `.mqh` files must still remain flat.

Allowed:
- `mt5/AuroraSentinelCore/AuroraSentinel.mq5`
- `mt5/AuroraSentinelCore/ASC_Engine.mqh`
- `mt5/AuroraSentinelCore/ASC_Market.mqh`

Not allowed:
- `mt5/AuroraSentinelCore/market/`
- `mt5/AuroraSentinelCore/storage/`
- `mt5/AuroraSentinelCore/dev/`

### Contents
- `README.md` — product rules
- `AuroraSentinelCore/` — the flat deployment folder that maps to:
  - `MQL5/Experts/AuroraSentinelCore/`

### File naming rule
Product files must use domain/system naming only.
They must not use:
- task wording
- worker wording
- phase wording
- blueprint wording
- office wording

### Planned product file pattern
Examples of intended file names:
- `AuroraSentinel.mq5`
- `ASC_Common.mqh`
- `ASC_Types.mqh`
- `ASC_Constants.mqh`
- `ASC_Engine.mqh`
- `ASC_Market.mqh`
- `ASC_Conditions.mqh`
- `ASC_Surface.mqh`
- `ASC_Ranking.mqh`
- `ASC_Output.mqh`
- `ASC_Storage.mqh`
- `ASC_UI.mqh`
- `ASC_Diagnostics.mqh`

### Output location rule
The EA does **not** publish trader-facing files inside the repo.
The end product is written at runtime into MT5 Common Files:

`Common\\Files\\AuroraSentinelCore\\`

Broker-level output pattern:
- `<Broker>.Summary.txt`
- `<Broker>.Symbols/<Symbol>.txt`

### Does belong here
- `.mq5`
- `.mqh`
- flat EA deployment structure
- product-facing implementation

### Does not belong here
- worker instructions
- archived source material
- blueprint prose

---

## `archives/` — PRESERVED REFERENCE

Use `archives/` when you need to answer:
- what older blueprint versions said
- what legacy systems looked like
- what raw symbol/classification maps already exist
- what design intent must not drift from

`archives/` is reference material, not active implementation.

### Contents
- `README.md` — overview of archive purpose
- `blueprints/` — old blueprint material
- `maps/` — preserved raw maps and classification assets
- `legacy_systems/` — older systems preserved for reference
- `extracted_reference/` — extracted materials worth keeping visible

### Important archive role
The historical classification map is a foundational source asset.
Its meaning must be preserved through:
- archive preservation
- blueprint contract translation
- clean MT5 production implementation

### Does belong here
- historical source material
- old blueprints
- old maps
- extracted reference

### Does not belong here
- current coordination state
- active worker code
- trader-facing runtime outputs

---

# 4. LOGICAL FLOW BETWEEN ROOTS

The intended flow is:

`archives/` -> `blueprint/` -> `office/` -> `mt5/`

Meaning:
- `archives/` preserves source intent and raw historical material
- `blueprint/` converts stable meaning into contracts and rules
- `office/` controls who builds what and in what order
- `mt5/` contains the final product implementation

The flow must not reverse accidentally.
For example:
- workers should not invent architecture directly inside `mt5/`
- archive files should not be treated as active product code without blueprint translation

---

# 5. NON-NEGOTIABLE SYSTEM RULES

These rules define what the whole repository is trying to protect.

## System Rules
- one EA only in normal operation
- broker-level output, not account-level output
- rolling persistence first
- read existing broker state before doing new work
- fill gaps, refresh stale, avoid blind rebuilds
- writers format only
- summary shows top 5 per bucket only
- symbol files contain exactly 3 major sections:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`
- MT5 product code contains no dev/task/phase/worker wording
- UI is isolated from internal logic

---

# 6. IF YOU ARE A MASTER CHAT

Read in this order:
1. `README.md`
2. `INDEX.md`
3. `blueprint/README.md`
4. `blueprint/SYSTEM_OVERVIEW.md`
5. `blueprint/ARCHITECTURE_RULES.md`
6. `blueprint/MODULE_MAP.md`
7. `blueprint/PERSISTENCE_CONTRACT.md`
8. `blueprint/OUTPUT_CONTRACT.md`
9. `office/MASTER_RULES.md`
10. `office/MODULE_OWNERSHIP.md`
11. `office/BUILD_ORDER.md`
12. `office/TASK_BOARD.md`

Use `archives/` only when you need source provenance or no-drift checking.

---

# 7. IF YOU ARE A WORKER CHAT

Read in this order:
1. `README.md`
2. `INDEX.md`
3. relevant blueprint file(s)
4. `office/WORKER_RULES.md`
5. `office/FILE_LOCKS.md`
6. your assigned project packet in `office/ACTIVE_PROJECTS/`

Then stay inside your assigned product area.
Do not freeload across roots.
Do not put dev wording into MT5 product code.
Do not modify files already locked by another worker.

---

# 8. IF YOU ARE LOOKING FOR SOMETHING SPECIFIC

## Want system meaning?
Go to `blueprint/`

## Want worker/master coordination?
Go to `office/`

## Want actual MT5 product files?
Go to `mt5/`

## Want old source material or preserved references?
Go to `archives/`

---

# 9. STABILITY INTENT

This file should remain stable even as implementation grows.

Future additions should normally fit inside the existing four-root model rather than forcing new top-level folders.
If a new folder is ever proposed at root, that should be treated as an architectural event, not casual growth.
