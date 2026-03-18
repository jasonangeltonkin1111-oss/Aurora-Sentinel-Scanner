# TASK BOARD

## Rule
HQ assigns bounded projects by domain concern and verified stage readiness.
Product naming must stay domain-based, not task-number-based.

---

## Current Control-State Summary
- root layout locked
- archive layer remains static reference only
- blueprint baseline is active system truth
- MT5 flat deployment rule is locked
- execution protocol is locked
- Clerk and Debug are idle-only post-run workers
- the real control roster is the locked 7-role system:
  - HQ
  - Engine Worker
  - Market Worker
  - Conditions Worker
  - Storage + Output Worker
  - Clerk
  - Debug
- first milestone remains the active implementation target
- blueprint integrity hardening is complete; merged MT5 Wave 1 fixes now require post-fix review normalization before progression
- later product domains are acknowledged but not opened as separate worker classes:
  - Surface
  - Ranking
  - Diagnostics
  - UI

---

## Current Objective
Reach the first working scanner slice that:
- starts cleanly
- discovers broker symbols
- reads broker conditions
- restores broker state first
- writes truthful broker-level outputs

---

## First Milestone Locked Scope

### Active first-slice ownership domains
- Engine
- Market
- Conditions
- Storage
- Output

### Stage sequence
1. Layer 1 = Market Truth
2. Layer 1.2 = Universe Snapshot
3. Layer 2 = Surface scan foundations required for the first shortlist
4. Activation Gate
5. Layer 3 = ACTIVE-only rolling dossier persistence

### Locked first-milestone runtime shape
- summary grouping uses `PrimaryBucket`
- promotion/activation also use `PrimaryBucket`
- top 5 per `PrimaryBucket` only
- first milestone timeframe set:
  - `M15`
  - `H1`
- first milestone cadence:
  - `OnInit` full bounded pass after restore
  - `OnTimer` bounded refresh passes
  - `OnTick` no heavy scanner work

### Hard first-milestone laws
- classification is upstream truth
- writers never compute
- no fake values
- restore first
- never wipe
- gap-fill only
- atomic writes protect active dossier continuation
- only ACTIVE symbols may receive rolling dossier continuation

---

## Later-Slice Domains (Recognized, Not Open by Default)
These domains are part of the system map, but they must not leak into first-slice implementation unless HQ explicitly opens a later packet:
- Surface refinement
- Ranking refinement
- Diagnostics product features
- UI product features
- Layer 4 expansion work

Recognition does not equal active build authorization.

---

## Blocking Rules
The following are blocked until prior truth is verified:
- Activation Gate work before Layer 2 shortlist truth exists
- Layer 3 rolling dossier continuation before ACTIVE rights are defined and verified
- Layer 4 expansion before Layers 1, 1.2, 2, Activation Gate, and Layer 3 are stable
- Diagnostics/UI product work before first-slice scanner truth is working

---

## Post-Run Sequence
After each completed build-worker run, HQ may invoke in order:
1. Clerk
2. Debug

No build worker may overlap with Clerk or Debug.

---

## Current Correction Gate
Before any progression decision, HQ must require:
1. live control docs aligned to the merged Wave 1 fix state
2. handoff normalization for the active Wave 1 worker records
3. a fresh Debug rerun against the merged MT5 files
4. compliance with `office/BLUEPRINT_INTEGRITY_AUDIT.md`
5. no new feature or later-slice expansion

Blueprint hardening reduced ambiguity. The merged fix wave improved the live product, but progression still depends on truthful post-fix review state.
