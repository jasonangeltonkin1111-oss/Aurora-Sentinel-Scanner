# AURORA PATTERN COMPETITION OBJECT SCHEMA

## PURPOSE

This file defines the exact shape of `AURORA_PATTERN_COMPETITION_OBJECT`.

It exists so the pattern competition stage can become machine-shapable without forcing false precision.
The schema preserves:
- lineage
- input ownership
- parent-family dependence
- candidate visibility
- rejection reasons
- unresolvedness
- downstream usefulness for opportunity and card layers

Cross-reference:
- `AURORA_PATTERN_COMPETITION_ENGINE_PROTOCOL.md`
- `AURORA_FAMILY_COMPETITION_OBJECT_SCHEMA.md`
- `AURORA_WRAPPER_OBJECT_MODEL.md`

---

# 1. OBJECT IDENTITY

Required fields:
- `object_type`: `AURORA_PATTERN_COMPETITION_OBJECT`
- `object_version`
- `generated_at`
- `pattern_competition_object_id`
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
- `family_competition_object_ref`

Optional source refs:
- `pattern_atlas_ref`
- `pattern_card_refs`
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
- `missing_surfaces_that_limit_pattern_competition`
- `missing_surfaces_that_would_change_result`

Each missing surface record should preserve:
- `surface_name`
- `surface_state`
- `why_it_matters`

---

# 5. PATTERN COMPETITION STATUS FIELDS

Required fields:
- `pattern_competition_status`
- `confidence_posture`
- `pattern_competition_validity_note`
- `ambiguity_notes`

Allowed `pattern_competition_status` values:
- `CLEAR_PATTERN_PRIMARY`
- `CONTESTED_PATTERN_PRIMARY`
- `MULTIPLE_LIVE_PATTERNS`
- `DEFERRED_PATTERN_COMPETITION`
- `NO_VALID_PATTERN`
- `INVALID_PATTERN_COMPETITION_INPUT`

Allowed `confidence_posture` values:
- `KNOWN`
- `PARTIAL`
- `UNKNOWN`

---

# 6. PARENT FAMILY BLOCK

Required fields:
- `parent_family_competition_status`
- `surviving_parent_families`
- `primary_parent_family_if_any`
- `pattern_scope_basis_note`

Rule:
- pattern competition must preserve its dependence on upstream family competition
- if the parent family basis is too unresolved, that must remain visible here

---

# 7. CANDIDATE PATTERN BLOCK

Required field:
- `candidate_patterns`

Each candidate entry should preserve:
- `pattern_id_or_group`
- `pattern_name`
- `parent_family_ref`
- `pattern_result_state`
- `parent_family_compatibility_note`
- `structural_role_fit_note`
- `anti_confusion_pressure_note`
- `state_alignment_note`
- `regime_compatibility_note`
- `contradiction_load_note`
- `dependence_on_missing_surfaces`
- `evidence_not_yet_present`
- `deployability_compatibility_note`
- `reason_summary`

Allowed `pattern_result_state` values:
- `CONFIRMED`
- `CANDIDATE`
- `REJECTED`
- `UNRESOLVED`

---

# 8. REJECTED PATTERN BLOCK

Required field:
- `rejected_patterns`

Each rejected-pattern entry should preserve:
- `pattern_id_or_group`
- `pattern_name`
- `parent_family_ref`
- `rejection_reasons`
- `rejection_basis_refs`
- `can_reenter_later`
- `reentry_condition_if_any`

`rejection_reasons` must be explicit.
Do not use generic phrases such as only `low confidence`.

---

# 9. SURVIVING PATTERN BLOCK

Required fields:
- `surviving_patterns`
- `primary_pattern_candidate`
- `primary_pattern_reason`
- `competing_pattern_pressure_summary`

Rules:
- `surviving_patterns` may contain one or many entries
- `primary_pattern_candidate` may be `NONE`
- `primary_pattern_reason` must be present when a primary exists
- `competing_pattern_pressure_summary` must remain explicit when status is `CONTESTED_PATTERN_PRIMARY` or `MULTIPLE_LIVE_PATTERNS`

---

# 10. WHAT WOULD CHANGE THE RESULT

Required fields:
- `what_would_confirm_primary_pattern`
- `what_would_invalidate_primary_pattern`
- `what_would_reduce_pattern_ambiguity`

These fields exist to support later opportunity review without pretending the current result is final.

---

# 11. MINIMUM VALIDITY CONSTRAINTS

An `AURORA_PATTERN_COMPETITION_OBJECT` is minimally valid only if all of the following are true:
- `object_type` is correct
- `pattern_competition_status` is present
- `confidence_posture` is present
- `family_competition_object_ref` is present
- `source_inputs` or source refs are present
- `missing_surfaces` is present even if empty
- at least one of the following is present:
  - `candidate_patterns`
  - `rejected_patterns`
  - explicit `INVALID_PATTERN_COMPETITION_INPUT` note
- if `pattern_competition_status = CLEAR_PATTERN_PRIMARY` or `CONTESTED_PATTERN_PRIMARY`, then `primary_pattern_candidate` must not be `NONE`
- if `pattern_competition_status = MULTIPLE_LIVE_PATTERNS`, then `surviving_patterns` must contain more than one live pattern
- if `pattern_competition_status = NO_VALID_PATTERN`, then `primary_pattern_candidate` must be `NONE`
- if `pattern_competition_status = INVALID_PATTERN_COMPETITION_INPUT`, the object must explain why the input basis failed

---

# 12. NON-GOALS

This object must not contain:
- opportunity-status fields
- card-eligibility fields
- geometry fields
- execution plan fields
- numeric confidence totals

Those belong downstream.

---

# 13. CURRENT JUDGMENT

Aurora now has an explicit schema for `AURORA_PATTERN_COMPETITION_OBJECT` that preserves machine-shapable pattern comparison without turning unresolved local structure into fake certainty.
