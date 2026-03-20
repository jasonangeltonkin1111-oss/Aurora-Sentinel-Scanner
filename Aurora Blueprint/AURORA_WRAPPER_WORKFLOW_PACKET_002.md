# AURORA WRAPPER WORKFLOW PACKET 002

## PURPOSE

This file is the active Aurora wrapper workflow packet.

It supersedes `AURORA_WRAPPER_WORKFLOW_PACKET_001.md` for active wrapper execution because the current Aurora stack now includes:
- the group-context object layer
- the review-packet layer
- stronger opportunity-preservation law
- explicit enum/status normalization
- a clearer object/packet separation than v1 captured

This packet remains build-phase only.
It does not authorize automation.
It does not redesign ASC.

---

# 1. ROOT LAW

Run Aurora in explicit stages.
Do not jump from ASC context directly to a generated card.
Do not force a card when the honest result is opportunity preservation or no-card-valid.

The active stage order is:
1. ASC context intake and surface-state preservation
2. group-context construction
3. context interpretation
4. family and pattern competition
5. opportunity classification
6. generated-card decision and geometry if justified
7. save/log packaging
8. later review packet creation

---

# 2. REQUIRED INPUTS

Before using this workflow, the operator should have at minimum:
- one ASC context block or dossier extract satisfying the bridge contract
- enough identity truth to avoid context unusable state
- enough structural evidence to run family competition honestly

Required protocol references:
- `ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `AURORA_WRAPPER_OBJECT_MODEL.md`
- `AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`
- `AURORA_GENERATED_STRATEGY_CARD_PROTOCOL.md`
- `AURORA_STRATEGY_CARD_FIELD_SCHEMA.md`
- `AURORA_GROUP_CONTEXT_OBJECT_SCHEMA.md`
- `AURORA_REVIEW_PACKET_SCHEMA_001.md`
- `AURORA_STATUS_AND_ENUM_ALIGNMENT_SPEC_001.md`
- `AURORA_ENUM_REGISTRY_001.md`

Hard blockers:
- missing identity truth
- missing minimum ASC context contract surfaces
- no family-competition basis at all

If those blockers are present, stop before interpretation and record the insufficiency honestly.

---

# 3. STAGE 0 — ASC CONTEXT INTAKE AND NORMALIZATION

## Goal
Preserve ASC truth exactly as published before Aurora interprets anything.

## Required outputs
- `ASC_CONTEXT_OBJECT` reference or equivalent stable context block
- explicit list of any fields whose surface state is:
  - `PENDING`
  - `RESERVED`
  - `UNAVAILABLE`
  - `UNSUPPORTED`
  - `STALE`
  - `DEGRADED`
  - `INVALID`

## Stop condition
If identity truth is incomplete, stop and record context unusable.

## Save rule
Save the original ASC context reference used by the run.

---

# 4. STAGE 1 — GROUP-CONTEXT CONSTRUCTION

## Goal
Create or attach an `AURORA_GROUP_CONTEXT_OBJECT` before symbol-level doctrine is allowed to become too narrow.

## Required outputs
- asset class
- primary bucket
- group / subtype / theme if useful
- related symbols or related classes
- group regime hypothesis
- family logic versus symbol-specific constraint

## Pass condition
The case is now framed as a member of a broader class rather than as symbol doctrine.

## Stop condition
If group context cannot be justified, continue only if the packet explicitly marks that group-context truth is partial.
Do not pretend the symbol shell is the doctrine.

---

# 5. STAGE 2 — CONTEXT INTERPRETATION

## Goal
Convert ASC truth plus group context into:
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- preliminary deployability view
- missing-surface record

## Pass condition
- interpretation remains close to measured truth
- no geometry yet
- no forced family conclusion yet

## Stop condition
If missing or degraded surfaces prevent honest interpretation, preserve opportunity as `OBSERVE_ONLY` or stop earlier if even that is not justified.

---

# 6. STAGE 3 — FAMILY AND PATTERN COMPETITION

## Goal
Determine the primary family lane and any viable pattern candidate while preserving competition truth.

## Required outputs
- `AURORA_FAMILY_COMPETITION_OBJECT`
- `AURORA_PATTERN_CANDIDATE_OBJECT` if a candidate exists
- named competitors and rejection reasons

## Pass condition
- one primary family candidate is justified
- competing families remain explicit
- pattern candidate is confirmed, candidate-level, or rejected honestly

## Stop condition
If no family or pattern is settled enough, preserve an opportunity object only.
No card is forced.

---

# 7. STAGE 4 — OPPORTUNITY CLASSIFICATION

## Goal
Create the `AURORA_OPPORTUNITY_OBJECT` before deciding whether a strategy card should exist.

## Required outputs
- `deployability_class`
- `opportunity_status`
- `horizon_class`
- `missing_surfaces`
- `revisit_trigger`
- `expiry_at` if known

## Preservation law
Opportunity preservation is mandatory when the case is structurally interesting but not honestly card-ready.

Examples:
- `WATCH_ONLY` deployability may map to `OBSERVE_ONLY` opportunity status
- valid structure with bad execution continuity may map to `EXECUTION_INVALID`
- unresolved surface truth may map to `OBSERVE_ONLY` rather than false eligibility

## Stop condition
If the honest result is `OBSERVE_ONLY`, `EXECUTION_INVALID`, or `STRUCTURE_INVALID`, a card may still be blocked even though the opportunity object is kept.

---

# 8. STAGE 5 — GENERATED-CARD DECISION AND GEOMETRY

## Goal
Emit `AURORA_GENERATED_STRATEGY_CARD` only when card gating is satisfied.

## Required gate checks
- structure is not invalid
- deployability is not blocked for current use
- geometry validity is explicit
- timebox remains intraday-valid
- missing surfaces do not make the card dishonest

## Required outputs when card is allowed
- `card_eligibility_gate = CARD_ALLOWED`
- geometry built from structure plus deployability
- explicit machine-safe versus human-only field separation

## Required outputs when card is blocked
- `card_eligibility_gate` must name the blocking layer
- if geometry is the issue, record `geometry_validity`
- preserve whether the idea remained interesting despite card blockage

## No-card-valid rule
A no-card-valid result is correct when:
- geometry is invalid or unresolved
- timebox makes intraday realization dishonest
- missing ASC truth prevents safe precision
- family/pattern competition remains unresolved

Do not manufacture geometry to avoid a no-card-valid outcome.

---

# 9. STAGE 6 — SAVE / LOG PACKAGING

## Save each run
- ASC context reference used
- group-context object or example used
- context interpretation output
- family/pattern competition output
- opportunity object
- generated card if any
- explicit no-card-valid reason if no card was emitted
- review packet later if one is created

## Log rules
- preserve lineage references
- preserve historical packet versions rather than deleting them
- use normalized enums from the alignment spec and registry

---

# 10. STAGE 7 — LATER REVIEW PACKET CREATION

## Goal
If later evidence exists, create a `REVIEW_PACKET` diagnosing the correct layer.

## Required review questions
- was the structure read correctly?
- was deployability read correctly?
- was geometry poor even when the idea was valid?
- was timing/timebox the real issue?
- was upstream truth insufficient?
- was observe-only preservation the correct result?

## Output rule
Review should emit `review_outcome_class` from the canonical review enum set.

---

# 11. OBJECT CHAIN CREATED OR UPDATED

This workflow should read or produce the following objects in order:
- `ASC_CONTEXT_OBJECT`
- `AURORA_GROUP_CONTEXT_OBJECT`
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`
- `AURORA_FAMILY_COMPETITION_OBJECT`
- `AURORA_PATTERN_CANDIDATE_OBJECT` if justified
- `AURORA_OPPORTUNITY_OBJECT`
- `AURORA_GENERATED_STRATEGY_CARD` only if justified
- `REVIEW_PACKET` later if evidence exists

---

# 12. WHAT NOT TO DO

Do not:
- skip the group-context stage
- blend surface-state availability with deployability
- blend deployability with opportunity status
- treat geometry validity as the same thing as card eligibility
- force a generated card to avoid a preserved opportunity outcome
- drift into automation or EA behavior from this packet

---

# 13. CURRENT JUDGMENT

Aurora now has an active wrapper workflow packet that matches the current object, routing, review, and opportunity-preservation stack more closely than v1.

This is the correct build-phase workflow packet until a later version supersedes it.
