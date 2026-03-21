# AURORA FAMILY COMPETITION OBJECT SCHEMA

## PURPOSE

This file defines the exact shape of `AURORA_FAMILY_COMPETITION_OBJECT`.

It exists so the family competition stage can become machine-shapable without forcing false precision.
The schema preserves:
- lineage
- input ownership
- candidate visibility
- rejection reasons
- unresolvedness
- downstream usefulness for pattern and opportunity layers

Cross-reference:
- `AURORA_FAMILY_COMPETITION_ENGINE_PROTOCOL.md`
- `AURORA_WRAPPER_OBJECT_MODEL.md`
- `AURORA_ENUM_REGISTRY_001.md`

---

# 1. OBJECT IDENTITY

Required fields:
- `object_type`: `AURORA_FAMILY_COMPETITION_OBJECT`
- `object_version`
- `generated_at`
- `competition_object_id`
- `status`

Recommended `status` posture for build-phase examples:
- `BUILD_PHASE_ACTIVE`
- `ILLUSTRATIVE_BUILD_PHASE_SPECIMEN`
- `REAL_CONTEXT_DERIVED`

---

# 2. LINEAGE AND SOURCE REFS

Required fields:
- `lineage_refs`
- `source_inputs`
- `asc_context_ref`
- `group_context_ref`
- `market_state_object_ref`
- `execution_surface_object_ref`
- `deployability_object_ref`

Optional source refs:
- `family_registry_ref`
- `family_file_refs`
- `family_card_refs`
- `worked_example_refs`
- `family_lane_packet_refs`

---

# 3. CASE IDENTITY FIELDS

Include when known:
- `symbol`
- `asset_class`
- `primary_bucket`
- `group_or_subtype`
- `regime_label`

If unknown, preserve the surface state through `missing_surfaces` rather than inventing a value.

---

# 4. REQUIRED MISSINGNESS FIELDS

Required field:
- `missing_surfaces`

Optional detail fields:
- `missing_surfaces_that_limit_competition`
- `missing_surfaces_that_would_change_result`

Each missing surface record should preserve:
- `surface_name`
- `surface_state`
- `why_it_matters`

Use surface-state enums from `AURORA_ENUM_REGISTRY_001.md`.

---

# 5. COMPETITION STATUS FIELDS

Required fields:
- `competition_status`
- `confidence_posture`
- `competition_validity_note`
- `ambiguity_notes`

Allowed `competition_status` values:
- `CLEAR_PRIMARY`
- `CONTESTED_PRIMARY`
- `MULTIPLE_LIVE`
- `DEFERRED_CLASSIFICATION`
- `NO_VALID_FAMILY`
- `INVALID_COMPETITION_INPUT`

Allowed `confidence_posture` values:
- `KNOWN`
- `PARTIAL`
- `UNKNOWN`

---

# 6. CANDIDATE FAMILY BLOCK

Required field:
- `candidate_families`

Each candidate entry should preserve:
- `family_id`
- `family_name`
- `candidate_status`
- `family_result_state`
- `habitat_fit_note`
- `anti_habitat_conflict_note`
- `state_alignment_note`
- `regime_compatibility_note`
- `contradiction_load_note`
- `dependence_on_missing_surfaces`
- `evidence_not_yet_present`
- `deployability_compatibility_note`
- `competitor_pressure_note`
- `reason_summary`

Allowed `family_result_state` values:
- `PRIMARY`
- `COMPETING`
- `REJECTED`
- `UNRESOLVED`

`candidate_status` is a free-text structural note only if needed.
Do not replace `family_result_state` with synonyms.

---

# 7. REJECTED FAMILY BLOCK

Required field:
- `rejected_families`

Each rejected-family entry should preserve:
- `family_id`
- `family_name`
- `rejection_reasons`
- `rejection_basis_refs`
- `can_reenter_later`
- `reentry_condition_if_any`

`rejection_reasons` must be explicit.
Do not use generic phrases such as only `low confidence`.

---

# 8. SURVIVING FAMILY BLOCK

Required fields:
- `surviving_families`
- `primary_family_candidate`
- `primary_family_reason`
- `competing_family_pressure_summary`

Rules:
- `surviving_families` may contain one or many entries
- `primary_family_candidate` may be `NONE`
- `primary_family_reason` must be present when a primary exists
- `competing_family_pressure_summary` must remain explicit when status is `CONTESTED_PRIMARY` or `MULTIPLE_LIVE`

---

# 9. WHAT WOULD CHANGE THE RESULT

Required fields:
- `what_would_confirm_primary`
- `what_would_invalidate_primary`
- `what_would_reduce_ambiguity`

These fields exist to support later pattern competition and opportunity review without pretending the current result is final.

---

# 10. MINIMUM VALIDITY CONSTRAINTS

An `AURORA_FAMILY_COMPETITION_OBJECT` is minimally valid only if all of the following are true:
- `object_type` is correct
- `competition_status` is present
- `confidence_posture` is present
- `source_inputs` or source refs are present
- `missing_surfaces` is present even if empty
- at least one of the following is present:
  - `candidate_families`
  - `rejected_families`
  - explicit `INVALID_COMPETITION_INPUT` note
- if `competition_status = CLEAR_PRIMARY` or `CONTESTED_PRIMARY`, then `primary_family_candidate` must not be `NONE`
- if `competition_status = MULTIPLE_LIVE`, then `surviving_families` must contain more than one live family
- if `competition_status = NO_VALID_FAMILY`, then `primary_family_candidate` must be `NONE`
- if `competition_status = INVALID_COMPETITION_INPUT`, the object must explain why the input basis failed

---

# 11. NON-GOALS

This object must not contain:
- pattern winner fields
- opportunity-status fields
- card-eligibility fields
- geometry fields
- execution plan fields
- numeric confidence totals

Those belong downstream.

---

# 12. CURRENT JUDGMENT

Aurora now has an explicit schema for `AURORA_FAMILY_COMPETITION_OBJECT` that preserves machine-shapable family comparison without turning unresolved structure into fake certainty.
