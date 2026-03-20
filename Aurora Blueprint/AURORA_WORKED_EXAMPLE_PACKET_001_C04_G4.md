# AURORA WORKED EXAMPLE PACKET 001 — C-04 / G4

## PURPOSE

This file is the first family-specific worked-example packet scaffold.

It is tied to:
- `C-04_Failed_Break_Trap_Reversal.card.md`
- `G4_Failed_Break_Reclaim.card.md`
- `AURORA_FAMILY_LANE_PACKET_001_C04_G4.md`

It exists so the operator can run one real symbol through the exact C-04 / G4 lane without starting from a generic blank example each time.

This is still a scaffold.
It does not contain a filled live example yet.
It gives the correct shape for the first real worked example on this lane.

---

# 1. PACKET IDENTITY

- `packet_id`: `AURORA_WORKED_EXAMPLE_PACKET_001_C04_G4`
- `packet_type`: `WORKED_EXAMPLE_PACKET`
- `packet_version`: `1`
- `family_anchor`: `C-04`
- `pattern_anchor`: `G4`
- `status`: `READY_FOR_FIRST_REAL_EXAMPLE`

---

# 2. INPUT REQUIREMENTS

Required before using this packet:
- one real symbol
- one real ASC context block
- enough state / surface truth to judge failed-break versus continuation

Hard blockers:
- no visible break attempt
- no usable context block
- reclaim cannot be distinguished from ordinary pullback

---

# 3. SYMBOL AND RAW CONTEXT

## Symbol
- `symbol:`
- `asset_class:`
- `bucket_prior:`
- `timestamp:`

## Raw ASC context attached?
- yes / no

## Required upstream truths present?
- market status:
- session/timebox:
- spread / execution truth:
- freshness / degradation truth:

## Missing upstream surfaces
- 
- 
- 

---

# 4. STAGE 1 — CONTEXT INTERPRETATION FOR C-04 / G4

## ASC_CONTEXT_TRUTH_SUMMARY
- 

## MARKET_STATE_INTERPRETATION
- primary state:
- competing states:
- why primary state won:

## EXECUTION_SURFACE_INTERPRETATION
- 

## DEPLOYABILITY_PREVIEW
- 

## C-04 / G4 RELEVANCE CHECK
- was there an actual break attempt?
- is continuation losing authority?
- is reclaim / return-to-structure logic becoming dominant?

## STOP OR CONTINUE?
- 

---

# 5. STAGE 2 — FAMILY COMPETITION FOR C-04

## PRIMARY_FAMILY_CANDIDATE
- 

## DOES C-04 WIN?
- yes / no
- reason:

## MAIN COMPETING FAMILIES
- breakout / compression release:
- trend continuation:
- balance rotation / range mean-reversion:

## WHY COMPETITORS LOSE OR REMAIN ALIVE
- 

## ANTI_HABITAT WARNINGS
- 

## STOP OR CONTINUE?
- 

---

# 6. STAGE 3 — PATTERN CHECK FOR G4

## PATTERN_CANDIDATE
- is `G4 Failed Break / Reclaim` actually present?

## REQUIRED G4 TRUTHS
- attempted break occurred:
- continuation failed to hold:
- reclaim of prior structure is real enough:

## MAIN G4 MISREAD RISKS
- ordinary pullback mistaken for failed break:
- unresolved breakout mistaken for reclaim:
- unstable chop mistaken for meaningful trap reversal:

## PATTERN REJECTION CONDITIONS MET?
- 

## STOP OR CONTINUE?
- 

---

# 7. STAGE 4 — OPPORTUNITY CLASSIFICATION

## OPPORTUNITY STATUS
Choose one:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

## WHY THIS STATUS WAS CHOSEN
- 

## IDEA VALID BUT GEOMETRY INVALID?
- yes / no
- reason:

---

# 8. STAGE 5 — GENERATED STRATEGY CARD (ONLY IF JUSTIFIED)

## CARD ELIGIBILITY GATE
- yes / no
- reason:

## CARD IDENTITY
- 

## INTERPRETATION SUMMARY
- 

## ENTRY GEOMETRY
- 

## INVALIDATION GEOMETRY
- 

## TARGET GEOMETRY
- 

## TIMEBOX AND EXECUTION CONSTRAINTS
- 

## MACHINE-SAFE FIELDS
- 

## HUMAN-ONLY FIELDS
- 

---

# 9. STAGE 6 — LATER REVIEW / DIAGNOSIS

## WHAT ACTUALLY HAPPENED
- 

## FAILURE OR SUCCESS CLASSIFICATION
- structure right, execution wrong
- structure wrong
- deployability misread
- geometry poor
- timing / session weak
- upstream truth insufficient
- correctly degraded / observe-only

## WHAT THIS LANE SHOULD LEARN
- 

---

# 10. WHAT TO SAVE AFTER THIS EXAMPLE

Save:
- raw ASC context
- context interpretation output
- family competition output
- pattern check output
- opportunity classification
- card if emitted
- review result later

This is the minimum evidence set for the first real C-04 / G4 example library.

---

# 11. CURRENT JUDGMENT

Aurora now has the first family-specific worked-example packet scaffold.

The next correct move is to fill this with one real symbol case so the C-04 / G4 lane becomes not only architecturally defined, but practically demonstrated.
