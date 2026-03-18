# ATOMIC WRITE AND PERSISTENCE RULES

## Status
Active blueprint law.

This file defines persistence behavior for ASC.

---

## Core Principle
ASC is restore-first.
ASC never treats restart as a reason to wipe intelligence history.

Persistence must preserve accumulated truth and extend it safely.

---

## Global Laws
- Always read existing persisted data first.
- Persisted records must contain timestamps sufficient for gap detection.
- Only fill missing or stale ranges.
- Only roll forward what needs to advance.
- Never wipe old data blindly.
- Never replace valid long-lived records with partial runtime output.
- Any active dossier write that can fail mid-write must be atomic.

---

## Two Persistence Classes

### 1. Universe Snapshot Persistence
Applies to:
- discovery state
- broker symbol inventory
- broker specs snapshot
- classification snapshot
- session truth snapshot

Characteristics:
- broad coverage
- not deep rolling intelligence
- may be updated in simpler fashion
- does not grant deep dossier rights

### 2. Active Dossier Persistence
Applies only to ACTIVE symbols.

Characteristics:
- restore-first
- timestamp-aware
- rolling continuation
- gap-fill only
- atomic writes required
- no destructive reset

---

## Atomic Write Rule
For any rolling dossier file or active persistent intelligence file:
1. read existing active file
2. validate existing parse/integrity state
3. build updated representation separately
4. validate updated representation
5. write to temp/staging target
6. confirm temp/staging write success
7. atomically replace active target only after success

Forbidden:
- writing directly into active target progressively
- truncating active target before replacement is secure
- silent fallback to partial file

---

## Restart Rule
On EA restart:
- do not assume zero state
- do not wipe prior symbol history
- load existing persisted state first
- inspect timestamp coverage
- inspect integrity status
- continue from last valid boundary

---

## Gap Fill Rule
When historical or computed data is incomplete:
- detect missing range precisely
- fill only missing range
- preserve prior valid ranges
- avoid recomputing the entire history unless controlled migration requires it

---

## Stale Refresh Rule
When data is stale but structurally valid:
- refresh only the stale rolling edge
- avoid destructive rebuild
- preserve timestamp continuity

---

## Corruption Rule
If persisted dossier data is corrupt:
- do not overwrite blindly with partial truth
- mark integrity failure explicitly
- suspend continuation if necessary
- preserve forensic visibility where possible

---

## Writer Purity Rule
Writers format and persist already-computed truth.
Writers do not invent values, repair missing calculations by guessing, or substitute placeholder zeros.

---

## Completion Standard
Persistence is only considered correct when restart tests prove:
- prior data survives restart
- only gaps are filled
- rolling edge updates correctly
- partial-write failure cannot destroy active truth
