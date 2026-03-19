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
- must still preserve prior valid structure when refreshed

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

If the most recent active file is unreadable or structurally broken:
- do not treat that as permission to wipe history
- search for the most recent still-valid fallback representation if policy provides one
- if no valid fallback exists, preserve corruption visibility and start from an explicit clean-state decision instead of a silent reset

---

## Fallback Acceptance Rule
Fallback use must be explicit and conservative.

A prior persisted representation may be accepted only if:
- it parses successfully
- required structural sections exist
- timestamp ordering is sane enough for continuation
- identity/classification ownership is not materially contradictory
- accepting it is safer than pretending there is no prior truth

Fallback must not be used to smuggle in incompatible schema or contradictory symbol identity.

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
- do not silently promote a new file over the corrupt record unless the replacement has been fully validated

Possible outcomes when corruption is detected:
- continue from last valid fallback if one exists
- suspend the symbol if continuation safety is not trustworthy
- start an explicit clean-state rebuild only when no trustworthy prior boundary remains and policy allows it

---

## Universe Snapshot Recovery Rule
Universe snapshot persistence may use simpler write flow than active dossier persistence, but recovery still must:
- prefer valid prior snapshot truth over destructive rebuild
- keep missing/unknown fields explicit during recovery
- avoid erasing valid symbol membership because one refresh pass is incomplete

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
- corruption handling prefers explicit fallback/suspension over silent destructive reset
