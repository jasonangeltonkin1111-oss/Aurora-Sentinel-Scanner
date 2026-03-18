# MODULE OWNERSHIP

## Purpose
This file locks domain ownership inside the real ASC control model.

Ownership names below are logical domains, not required MT5 deployment folders.
Module ownership does not authorize nested terminal folders.
The MT5 product layout remains flat.

---

## Locked Worker Roster
The active control layer uses exactly these 7 roles:
- HQ
- Engine Worker
- Market Worker
- Conditions Worker
- Storage + Output Worker
- Clerk
- Debug

Surface, Ranking, Diagnostics, and UI are valid product domains, but they are **not** separate worker roles in the locked control model.

---

## Worker-to-Domain Ownership

### HQ
Owns:
- system-level coordination
- contradiction resolution
- task packet definition
- stage approval
- cross-domain shared meaning protection

### Engine Worker
Primary ownership:
- Engine domain

Typical concerns:
- startup sequence
- timer cadence
- bounded scheduling and next-recheck orchestration
- guarded call order between Layer 1, Layer 1.2, Layer 2, Activation, and Layer 3
- stage-safe runtime control
- retry/backoff discipline for non-ready work
- engine-side shared call flow

### Market Worker
Primary ownership:
- Market domain

Typical concerns:
- broker symbol discovery
- canonical symbol identity
- suffix stripping and alias resolution
- classification translation from archive truth
- `PrimaryBucket` and related identity fields
- Layer 1 session/trade-window/quote-window truth
- Layer 1 session-truth status and next-recheck inputs
- Layer 1.2 identity-side universe snapshot truth

### Conditions Worker
Primary ownership:
- Conditions domain

Typical concerns:
- spec intake
- spread/tradability/contract-condition truth
- spec integrity / missing-field truth
- conditions validity needed by Layer 2 eligibility
- condition fields used by ranking and output consumers

### Storage + Output Worker
Primary ownership:
- Storage domain
- Output domain

Typical concerns:
- broker path and naming rules
- restore/read/merge logic
- stale detection and persistence guards
- fallback/corruption recovery handling
- atomic write flow
- summary rendering
- symbol dossier rendering

Hard boundary:
- writers do not compute
- this worker formats and persists downstream truth but does not invent market classification or ranking logic

### Clerk
Post-run ownership only:
- structure review
- naming review
- boundary review
- ledger/handoff normalization

### Debug
Post-run ownership only:
- logic review
- fail-fast review
- activation/persistence integrity review
- contradiction/drift detection after implementation runs

---

## Module-to-Worker Mapping

### First-slice modules
- **Common** -> shared contract surface coordinated by HQ; no single worker may silently redefine it
- **Engine** -> Engine Worker
- **Market** -> Market Worker
- **Conditions** -> Conditions Worker
- **Storage** -> Storage + Output Worker
- **Output** -> Storage + Output Worker

### Later-slice modules
These domains are real and must remain visible in planning, but they are blocked from first-slice expansion unless HQ explicitly opens them.

- **Surface** -> later product domain; assign through a bounded HQ packet without creating a new worker class
- **Ranking** -> later product domain; assign through a bounded HQ packet without creating a new worker class
- **Diagnostics** -> later product domain; distinct from the Debug post-run worker
- **UI** -> later product domain

---

## Cross-Domain Boundaries That Must Stay Clear

### Market vs Output
- Market owns classification truth.
- Output consumes classification truth.
- Output must not replace `PrimaryBucket` with ad hoc bucket systems.

### Ranking vs Output
- Ranking/promotion decides shortlist authority.
- Output renders the shortlist.
- Output must not compute promotion on its own.

### Storage vs Output
- Storage protects restore/merge/write integrity.
- Output controls formatting.
- Neither may invent missing truth to make files look complete.

### Diagnostics vs Debug
- Diagnostics is a future product module.
- Debug is an office post-run reviewer.
- These must never be treated as the same thing.

### UI vs Office language
- UI is a future product surface.
- Office task/stage/worker wording must not leak into UI or trader-facing outputs.

---

## High-Friction Zones
These areas need extra HQ scrutiny because multiple domains depend on them:
- Common domain
- Engine orchestration boundaries
- Market classification and `PrimaryBucket` truth
- Storage persistence rules
- Output language boundary

---

## Ownership Lock
If a task touches more than one primary ownership area, HQ must explicitly state:
- why the overlap is necessary
- which worker is authoritative
- what remains out of scope

No worker may use “module adjacency” as permission to redesign neighboring domains.
