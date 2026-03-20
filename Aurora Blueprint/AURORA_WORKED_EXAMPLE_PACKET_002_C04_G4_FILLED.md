# AURORA WORKED EXAMPLE PACKET 002 — C-04 / G4 FILLED

## PURPOSE

This file is the first filled worked-example artifact for the C-04 / G4 lane.

It is an illustrative build-phase architecture demonstration.
It is not a claim of verified live execution history.
It exists to prove:
- group-aware routing logic
- family/pattern competition logic
- packet shape
- opportunity classification logic
- no-card-valid honesty when appropriate

---

# 1. PACKET IDENTITY

- `packet_id`: `AURORA_WORKED_EXAMPLE_PACKET_002_C04_G4_FILLED`
- `packet_type`: `WORKED_EXAMPLE_PACKET`
- `packet_version`: `2`
- `family_anchor`: `C-04`
- `pattern_anchor`: `G4`
- `status`: `ILLUSTRATIVE_FILLED_BUILD_PHASE_EXAMPLE`
- `supersedes_for_filled_example_use`: `AURORA_WORKED_EXAMPLE_PACKET_001_C04_G4.md`

---

# 2. INPUT REQUIREMENTS AND HONESTY POSTURE

- `raw_context_attached`: `NO_VERIFIED_LIVE_ASC_CONTEXT_ATTACHED`
- `example_posture`: `ILLUSTRATIVE_ARCHITECTURE_DEMONSTRATION`
- `group_context_ref`: `AURORA_GROUP_CONTEXT_OBJECT_EXAMPLE_001_C04_G4.md`
- `family_card_ref`: `strategy_families/CARDS/C-04_Failed_Break_Trap_Reversal.card.md`
- `pattern_card_ref`: `patterns/G4_Failed_Break_Reclaim.card.md`

What this packet is allowed to prove:
- routing shape
- competition shape
- packet completeness
- honest no-card outcome handling

What this packet is not allowed to claim:
- verified live trade history
- verified live telemetry
- verified broker-execution path

---

# 3. SYMBOL AND BROADER CONTEXT

## Symbol shell
- `symbol`: `EURUSD` illustrative instance shell only
- `asset_class`: `FX_SPOT_MAJOR`
- `primary_bucket`: `G10_FX`
- `group_or_subtype`: `USD-led major intraday failure/reclaim cluster`
- `related_symbols_or_related_classes`:
  - `GBPUSD`
  - `AUDUSD`
  - `major FX class responding to broad USD pressure`

## Family logic versus symbol-specific constraint
- `family_logic`:
  - failed break loses acceptance and reclaims prior structure, shifting meaning toward reversal or return-to-structure behavior
- `symbol_specific_constraint`:
  - EURUSD may exhibit cleaner reclaim sequencing and tighter execution conditions than sibling majors, but that is instance truth rather than doctrine truth

## Group / regime posture
- `group_regime_label`: `failed directional attempt returning toward prior acceptance`
- `broader_class_truth`: `responsive reversal logic is becoming more relevant than continuation`
- `symbol_bound_warning`: `this packet uses one symbol shell only to instantiate the object chain`

---

# 4. STAGE 0 — ASC CONTEXT INTAKE

## ASC_CONTEXT_TRUTH_SUMMARY
- identity shell is sufficient for doctrine routing demonstration
- live execution fields are intentionally not claimed as measured live truth
- freshness, spread, and continuity are treated as architecture placeholders rather than fabricated data

## Surface-state preservation
- `current_spread`: `PENDING`
- `rolling_median_spread`: `PENDING`
- `quote_health_state`: `PENDING`
- `execution_continuity_state`: `PENDING`
- `minutes_to_session_close`: `DEGRADED`

## Stage judgment
- enough truth exists for architecture demonstration
- not enough truth exists for a live-faithful execution-grade card

---

# 5. STAGE 1 — GROUP CONTEXT

## Group-context outcome
- broader class supports failed-break / reclaim analysis across liquid majors
- related symbols help prevent symbol doctrine drift
- group posture is directional-failure-first, not stable-balance-first

## Why this matters
- C-04 logic belongs to a broader failed-break class
- G4 is a pattern expression within that class
- one symbol shell should not be mistaken for universal family behavior

---

# 6. STAGE 2 — CONTEXT INTERPRETATION

## MARKET_STATE_INTERPRETATION
- `primary_state`: `Failed Break / Trap State becoming clearer than continuation`
- `competing_states`:
  - `Unresolved breakout continuation`
  - `Unstable chop without clean hierarchy`
- `why_primary_state_won`:
  - the illustrative case is framed around rejection of a visible directional attempt and reclaim of initiating structure rather than continued acceptance beyond the break

## EXECUTION_SURFACE_INTERPRETATION
- current execution truth is incomplete
- deployability cannot be promoted confidently
- the setup remains structurally interesting without becoming execution-ready by default

## DEPLOYABILITY_PREVIEW
- `deployability_preview`: `WATCH_ONLY bias because structure may be coherent but execution/timebox truth is incomplete`

## Stop-or-continue judgment
- continue to competition and opportunity classification
- do not force geometry confidence

---

# 7. STAGE 3 — FAMILY COMPETITION

## PRIMARY_FAMILY_CANDIDATE
- `C-04 Failed Break / Trap Reversal`

## Why C-04 wins
- the meaning of the case is failure and reclaim, not orderly continuation
- return-to-structure logic is stronger than extension logic in this illustrative framing

## Main competing families
- `C-03 Breakout / Compression Release`
  - remains alive only if the reclaim is too weak and the break reasserts
- `C-01 Trend Continuation`
  - loses because continuation authority is no longer the cleaner explanatory frame
- `C-05 Balance Rotation / Range Mean-Reversion`
  - loses because the case is not framed as already accepted balance first

## Competition honesty note
- C-03 remains the most important competitor because a fake reclaim can still revert into genuine breakout continuation

---

# 8. STAGE 4 — PATTERN COMPETITION

## PATTERN_CANDIDATE
- `G4 Failed Break / Reclaim`

## Why G4 is plausible
- attempted break occurred in the scenario shell
- continuation could not maintain authority in the scenario shell
- reclaim of prior structure is the dominant pattern meaning being evaluated

## Main G4 misread risks
- ordinary pullback mislabeled as failure
- unresolved breakout mislabeled as reclaim
- unstable alternating chop mislabeled as clean trap reversal

## Pattern competition truth
- `pattern_status`: `CANDIDATE_TO_CONFIRMED_BOUNDARY`
- reason:
  - pattern thesis is coherent, but the build-phase packet does not fabricate stronger evidence than the scenario shell actually provides

---

# 9. STAGE 5 — OPPORTUNITY CLASSIFICATION

## Canonical classifications
- `deployability_class`: `WATCH_ONLY`
- `opportunity_status`: `OBSERVE_ONLY`
- `horizon_class`: `H2_STANDARD_INTRADAY`
- `geometry_validity`: `GEOMETRY_INVALID`
- `card_eligibility_gate`: `CARD_BLOCKED_GEOMETRY`

## Why these classifications were chosen
- structure can be interesting without earning deployment confidence
- execution/timebox truth is incomplete enough to keep deployability at watch-only posture
- the packet can frame an intraday horizon conceptually, but not justify honest entry/invalidation geometry
- card emission would overstate precision

## Idea-valid-but-geometry-invalid truth
- `idea_valid_but_geometry_invalid_flag`: `YES`
- reason:
  - family and pattern routing remain coherent enough to preserve
  - geometry cannot be emitted honestly from the available illustrative truth set

---

# 10. STAGE 6 — GENERATED STRATEGY CARD DECISION

## Card outcome
- `generated_card_emitted`: `NO`
- `no_card_valid_reason`:
  - geometry is not honestly defensible
  - execution truth is too incomplete for machine-useful precision
  - timebox cleanliness is not strong enough to justify intraday execution packaging

## What would have been required for a card
- cleaner reclaim confirmation
- stronger session/timebox support
- actual measured execution continuity and spread truth
- explicit entry/invalidation geometry justified from those truths

## Why no-card is the correct result
- forcing a card would invent execution precision Aurora does not own here
- preserving the opportunity object is more honest than pretending the scenario is executable

---

# 11. STAGE 7 — LATER REVIEW HOOK

## Review posture
- if later evidence existed, the correct review question would not be “why was no trade taken?” alone
- the correct question would be whether observe-only preservation and geometry blockage were the right calls

## Linked review artifact
- `AURORA_REVIEW_PACKET_001_C04_G4.md`

---

# 12. LESSONS PRESERVED

- family competition truth matters because C-03 remains a live competing explanation until reclaim quality is clearer
- pattern competition truth matters because G4 can be plausible before it is cleanly confirmed
- deployability is not the same as structure quality
- geometry validity is not the same as opportunity preservation
- no-card-valid is sometimes the most accurate result

---

# 13. CURRENT JUDGMENT

Aurora now has its first filled C-04 / G4 worked-example artifact.

It is group-aware, bucket-aware, regime-aware, non-symbol-doctrinal, and explicit about why the honest result in this first illustrative filled packet is preserved opportunity plus no generated card.
