# SYMBOL LIFECYCLE AND ACTIVATION

## Status
Active blueprint law.

This file defines symbol state transitions and write permissions.

---

## Core Principle
Not every known symbol is allowed deep rolling dossier activity.

A symbol may be:
- known
- classified
- snapshotted
- surface scanned
and still remain inactive.

Activity is earned through promotion.

---

## Symbol States

### 1. DISCOVERED
The symbol exists in the broker universe.

### 2. DEFERRED
The symbol failed Layer 1 eligibility for now.
Examples:
- market closed
- symbol disabled
- recheck scheduled later

### 3. SNAPSHOTTED
The symbol has a Layer 1.2 universe snapshot record.
This may include broker specs and classification truth.

### 4. SURFACE_ELIGIBLE
The symbol passed Layer 1 and may be scanned by Layer 2.

### 5. INACTIVE
The symbol was evaluated in Layer 2 but was not promoted.
It must not receive rolling dossier continuation.

### 6. ACTIVE
The symbol was promoted by Layer 2 ranking and is allowed Layer 3 restore/continuation.

### 7. SUSPENDED
The symbol was previously active but is temporarily blocked from continued deep updates.
This may happen due to integrity failure, classification conflict, broken persistence state, or explicit HQ/logic rule.

---

## Write Permissions by State

### DISCOVERED
Allowed:
- discovery listing

Forbidden:
- dossier writes
- calculations
- deep persistence

### DEFERRED
Allowed:
- session truth state
- next recheck time
- universe snapshot updates if appropriate

Forbidden:
- Layer 2 computation
- Layer 3 continuation

### SNAPSHOTTED
Allowed:
- broker spec snapshot
- classification snapshot
- session metadata snapshot

Forbidden:
- rolling dossier logic
- Layer 2 calculations persisted as dossier intelligence
- deep history continuation

### SURFACE_ELIGIBLE
Allowed:
- Layer 2 read/compute/rank operations
- shortlist participation

Forbidden:
- Layer 3 rolling dossier continuation unless promoted

### INACTIVE
Allowed:
- remain visible in summary/ranking context
- future re-evaluation in later scans

Forbidden:
- atomic dossier continuation
- rolling deep writes
- resume-from-history deep processing

### ACTIVE
Allowed:
- restore prior dossier state
- fill gaps
- append rolling history
- recompute rolling intelligence windows
- atomic dossier writes

### SUSPENDED
Allowed:
- preserve prior history
- log suspension reason
- await resumption decision

Forbidden:
- destructive reset
- silent continuation while invalid

---

## Promotion Rule
A symbol becomes ACTIVE only if:
- it passed Layer 1 eligibility
- it participated in Layer 2 surface scan
- it ranked within the promoted set for its `PrimaryBucket`
- integrity conditions required by Layer 2 are satisfied

Promotion is not based on trade signaling.
Promotion is based on worthiness for deep computation budget.

---

## Demotion / Non-Promotion Rule
A symbol must remain INACTIVE if:
- it was not in the promoted set
- classification truth is unresolved and policy does not allow promotion
- required surface data is invalid or incomplete
- broker/symbol integrity is too weak for reliable deep continuation

---

## Suspension Rule
An ACTIVE symbol may be SUSPENDED if:
- persistent file integrity fails
- timestamp chain is broken
- required classification truth changes materially
- restart recovery detects corruption
- broker truth invalidates continuation assumptions

Suspension does not imply deletion.
Suspension blocks continuation until resolved.

---

## Summary Relationship
`SUMMARY.txt` is not just an informational report.
It is the visible activation authority list.

Summary reflects which symbols are currently promoted and therefore eligible for active dossier continuation.
Writers publish the promoted set; they do not compute or expand activation rights on their own.

---

## Hard Laws
- All symbols may receive discovery and snapshot truth.
- Only promoted ACTIVE symbols may receive rolling dossier continuation.
- INACTIVE symbols must not silently accumulate deep dossier state.
- Demotion/suspension must never wipe preserved intelligence history blindly.
- State transitions must be explicit and inspectable.
