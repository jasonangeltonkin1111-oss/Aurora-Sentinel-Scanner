# TEST AND VERIFICATION PLAN

## Purpose
This file defines how ASC stages are verified before progression.

Testing is stage-gated.
No layer is trusted because code exists.
A layer is trusted only after structured verification.

---

## Verification Actors

### Worker
Implements one bounded slice.

### Clerk
Checks:
- file placement
- naming
- contract completeness
- module boundaries
- no accidental drift

### Debug
Checks:
- logic correctness
- truth handling
- invalid-data behavior
- promotion safety
- persistence safety
- restart behavior where applicable

### HQ
Approves or blocks stage progression.

---

## Stage Verification Matrix

### Stage 1 — Layer 1
Verify:
- open/closed truth per broker symbol
- session-truth sub-states are distinguished honestly (`CLOSED_SESSION`, `TRADE_DISABLED`, `NO_QUOTE`, `STALE_FEED`, `UNKNOWN`, etc.)
- next-recheck scheduling follows broker-symbol-specific truth rather than one generic retry loop
- broker/session edge cases
- no closed or uncertain symbol treated as surface-eligible by default

### Stage 2 — Layer 1.2
Verify:
- all discoverable symbols appear in snapshot
- required minimum record fields are preserved when readable
- specs/session/classification snapshot truth is preserved honestly
- missing fields remain explicit
- raw broker identity is not overwritten by translated identity
- snapshot does not accumulate hidden ranking/deep fields

### Stage 3 — Layer 2
Verify:
- only Layer-1-eligible symbols are scanned
- classification is respected
- M15/H1 retrieval is valid
- light calculations are real
- invalid data fails fast
- summary top 5 per `PrimaryBucket` is correct
- symbol files obey section contract

### Stage 4 — Activation Gate
Verify:
- promoted symbols become ACTIVE deterministically
- non-promoted symbols remain INACTIVE
- active rights are not granted accidentally
- summary and activation state do not contradict each other

### Stage 5 — Layer 3
Verify:
- restore-first behavior on restart
- timestamp continuity
- gap-fill only
- rolling edge refresh only
- atomic write protection
- fallback acceptance is explicit and conservative
- corruption triggers fallback/suspension, not destructive overwrite

### Stage 6 — Layer 4
Verify:
- expansion stays outside first-slice contracts
- added intelligence does not destabilize earlier layers

---

## Required Evidence
A stage is not complete without evidence such as:
- sample outputs
- explicit validity/failure cases
- restart behavior proof where relevant
- boundary compliance proof

---

## Fail Rule
If Clerk or Debug finds a load-bearing failure:
- stage is not complete
- next stage is blocked
- fix within current scope before progression
