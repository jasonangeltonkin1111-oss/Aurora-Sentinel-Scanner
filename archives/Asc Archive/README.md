# Aurora Sentinel Scanner

Aurora Sentinel Scanner is a broker-aware MT5 market intelligence system.

Its current mission is simple and strict:
- produce a broker-level `SUMMARY.txt`
- produce one deep symbol file per shortlisted symbol

This project is building a scanner and market-selection tool first.
It is not currently building an auto-trader, a strategy engine, or the full old Aurora research OS.

---

## What the product does

Aurora Sentinel Scanner is designed to:
- discover the broker symbol universe
- classify symbols into usable buckets
- read truthful broker conditions and symbol state
- build bounded symbol dossiers
- rank symbols inside their `PrimaryBucket`
- publish compact trader-facing outputs

The intended operator flow is:
1. open `SUMMARY.txt`
2. inspect the top 5 symbols per `PrimaryBucket`
3. choose a symbol
4. open `SYMBOLS/<symbol>.txt`
5. review broker specs, OHLC history, and calculations
6. make a manual trading decision outside the EA

---

## What the product is not

Aurora Sentinel Scanner is not:
- a trade executor
- a position manager
- an account-history engine
- a strategy extractor
- a book-mining engine
- the full historical Aurora research framework

That distinction is intentional.
Current scope is a truthful, usable scanner.

---

## Canonical outputs

Aurora Sentinel Scanner exposes only two trader-facing outputs.

They are written at runtime to:

`Common\\Files\\AuroraSentinelCore\\`

### 1. `<Broker>.Summary.txt`
Purpose:
- show which symbols deserve attention now

Rules:
- top 5 per `PrimaryBucket` only
- compact and readable
- no raw OHLC dump
- no writer-side calculations
- no fake placeholder values

### 2. `<Broker>.Symbols/<Symbol>.txt`
Purpose:
- show deeper symbol intelligence for one shortlisted symbol

Rules:
- exactly 3 major sections:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`
- section names must not drift

---

## Core principles

- one EA
- broker-level output, not account-level output
- rolling persistence first: read existing broker state, then fill gaps
- writers format only
- top 5 per `PrimaryBucket` only in summary output
- symbol files contain exactly 3 major sections
- no fake zero values for missing truth
- no dev/task/phase/worker wording in MT5 product code
- MT5 product deployment is one flat EA folder
- archives are preserved reference only, not active implementation

If a navigation file and a blueprint contract ever disagree, the blueprint contract wins.

---

## Repository structure

### `blueprint/`
The constitutional source of truth.
Contains architecture, contracts, schemas, persistence rules, output contracts, and module meaning.

### `office/`
The governance layer.
Contains master/worker rules, execution protocol, ownership, locks, decisions, task state, and the HQ continuity manual.

### `mt5/`
The production product space.
Contains the flat MT5 deployment folder and product-facing code/docs only.

### `archives/`
The preserved source-memory layer.
Contains old blueprints, maps, legacy systems, extracted references, and the Aurora research library.
This layer is hardlocked and reference-only.

The intended repo flow is:

`archives/` -> `blueprint/` -> `office/` -> `mt5/`

---

## Build model

The project uses a controlled master/worker model.

### Locked 7-role control model
- HQ
- Engine Worker
- Market Worker
- Conditions Worker
- Storage + Output Worker
- Clerk
- Debug

Additional product domains such as Surface, Ranking, Diagnostics, and UI may exist in the blueprint/module map, but they do not automatically create extra worker roles in the control layer.

Execution law:
- only one build worker may run at a time
- Clerk and Debug run only when the system is idle
- archives are never edited except for additive markdown indexing/navigation

---

## Current build target

The active target is the first working scanner slice.

That slice must:
- start cleanly
- discover broker symbols
- read broker conditions
- restore broker state first
- write truthful broker-level outputs

The active first-slice modules are:
- Engine
- Market
- Conditions
- Storage + Output

Only after that are deeper modules expanded.

---

## Read order

### If you are a new HQ / master chat
1. `README.md`
2. `INDEX.md`
3. `office/HQ_OPERATOR_MANUAL.md`
4. `blueprint/SYSTEM_OVERVIEW.md`
5. `office/HQ_STATE.md`
6. `office/HQ_TASK_FLOW.md`
7. `office/HQ_DECISION_LOG.md`
8. `office/MODULE_OWNERSHIP.md`
9. `office/TASK_BOARD.md`
10. the active blueprint law named in `office/HQ_OPERATOR_MANUAL.md`

### If you are a worker chat
1. `README.md`
2. `INDEX.md`
3. relevant `blueprint/` contract files
4. `office/WORKER_RULES.md`
5. `office/ARCHIVE_REFERENCE_MAP.md`
6. your HQ-assigned packet or review scope

---

## Design intent

Aurora Sentinel Scanner should feel like a finished machine, not a chaotic prototype.

The system is strongest when it stays:
- truthful
- bounded
- deterministic
- readable
- useful to the trader quickly

The project fails if it drifts into:
- fake completeness
- archive mutation
- uncontrolled complexity
- strategy leakage into scanner layers
- MT5 folder bloat

---

## Project status

Current state:
- repo structure locked
- archive hardlock active
- HQ continuity manual added
- master/worker system active
- current mission still focused on the first usable scanner milestone

That milestone is reached when the operator can trust:
- `SUMMARY.txt`
- `SYMBOLS/<symbol>.txt`

and use them to trade manually with speed and clarity.
