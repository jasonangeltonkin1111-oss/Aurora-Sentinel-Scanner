# AURORA WRAPPER EXECUTION PACK

## Root execution law

Aurora must not jump from ASC context to a trade plan.
It transforms truth through a fixed staged chain and preserves uncertainty, missingness, and invalidity at each stage.

## Required stage chain

1. **ASC context intake and normalization** — consume the ASC-owned context object and preserve field states.
2. **Group-context construction** — build group, bucket, regime, and routing posture.
3. **Context interpretation** — derive market-state and execution-surface interpretation.
4. **Family competition** — compare plausible families without hidden scoring.
5. **Pattern competition** — compare patterns only after family posture is known.
6. **Opportunity inventory and ranking** — preserve downstream posture and relative ordering without collapsing reasoning.
7. **Deployability and intraday geometry** — convert coherent opportunity posture into bounded execution geometry.
8. **Generated strategy card** — package the decision into a machine-conscious artifact.
9. **EA-safe boundary** — expose only bounded machine-safe fields when allowed.

## Object chain

1. `ASC_CONTEXT_OBJECT`
2. `AURORA_MARKET_STATE_OBJECT`
3. `AURORA_EXECUTION_SURFACE_OBJECT`
4. `AURORA_DEPLOYABILITY_OBJECT`
5. `AURORA_FAMILY_COMPETITION_OBJECT`
6. `AURORA_PATTERN_CANDIDATE_OBJECT`
7. `AURORA_OPPORTUNITY_OBJECT`
8. `AURORA_GENERATED_STRATEGY_CARD`
9. `AURORA_EA_SAFE_OUTPUT_OBJECT`

## Transformation rules

- context before interpretation
- state before deployability
- deployability before geometry
- family competition before pattern commitment
- opportunity object before strategy card
- strategy card before EA-safe export

## Required distinctions and statuses

### Surface availability class
Use field-state truth such as `PRESENT`, `PENDING`, `RESERVED`, `UNAVAILABLE`, `UNSUPPORTED`, `STALE`, `DEGRADED`, and `INVALID` to answer whether a required surface exists and how trustworthy it is.
This is upstream truth, not downstream deployability.

### Deployability classes
Use deployability to express execution practicality, not mere field presence.
Wrapper use should preserve distinctions such as deployable, watch-only, unknown, or blocked posture rather than compressing them into yes/no.

### Opportunity statuses
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

### Other alignment classes the wrapper must preserve
- horizon class
- geometry validity
- card eligibility gate
- review outcome class
- family competition status
- pattern competition status

## Deployability engine

Deployability consumes:
- ASC market truth
- ASC execution truth
- Aurora structure truth
- hostility burden

Its core lenses are:
- structural path potential
- total execution burden
- horizon suitability
- execution continuity quality
- hostility burden

Deployability is upstream of explicit entry/stop/target geometry.
If deployability is weak, geometry must adapt or the opportunity must remain non-eligible.

## Intraday geometry law

Geometry is not generic RR/SL/TP templating.
It must preserve:
- entry law and confirmation requirements
- invalidation law
- target logic
- timebox logic
- execution constraints
- reasons geometry can be invalid even when the idea itself remains structurally interesting

## Strategy-card law

A generated strategy card must include:
- identity and lineage refs
- interpretation block (`market_state`, `execution_surface`, `deployability_class`, `horizon_class`, `opportunity_status`)
- family/pattern block with competition truth preserved
- geometry block (entry, invalidation, targets, timebox)
- machine-safe vs human-only separation

A symbol may retain an opportunity without earning a live strategy card.

## Packet and schema layer

Aurora’s active packet family includes:
- workflow packet
- family-lane packet
- worked-example packet
- review packet

Required object/schema surfaces compiled into this pack:
- packet schema
- group-context object schema
- review-packet schema
- strategy-card field schema

## Ranking law

Aurora should rank by preserving separable judgments:
- structural coherence
- family competition outcome
- pattern clarity when actually run
- deployability quality
- hostility burden
- surface completeness
- timebox compatibility

Do not replace these with one hidden master score.

## EA-safe boundary

Only bounded deterministic or routing-safe fields may approach EA-safe export early.
Narrative explanation, unresolved interpretive commentary, and doctrine reasoning remain human-only or wrapper-only.
