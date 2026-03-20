# AURORA STRATEGY CARD FIELD SCHEMA

## PURPOSE

This file expands the generated strategy-card protocol into a more explicit field schema.

It exists because Aurora now needs sharper execution-side precision.
The protocol defines the card layer conceptually.
This file makes the card fields more explicit so:
- packets become easier to build
- worked examples become easier to compare
- wrapper outputs become less vague
- later EA-safe filtering becomes easier

This file does not authorize automation.
It only hardens the strategy-card schema.

---

# 1. ROOT LAW

A strategy card should be explicit enough to be:
- operator-readable
- wrapper-usable
- machine-parseable in bounded ways later

But it must not become fake precision.

If a field cannot be justified from upstream truth or downstream interpretation, Aurora should mark it as:
- pending
- unknown
- not justified
- not emitted

rather than inventing certainty.

---

# 2. CARD FIELD GROUPS

Every generated strategy card should be organized into these field groups:

1. identity fields
2. lineage fields
3. context interpretation fields
4. family/pattern fields
5. deployability fields
6. geometry fields
7. timebox and execution-constraint fields
8. risk and invalidation fields
9. machine-safe export fields
10. human-only commentary fields

---

# 3. IDENTITY FIELDS

Required identity fields:
- `strategy_card_id`
- `symbol`
- `asset_class`
- `bucket_prior`
- `generated_at`
- `expiry_at`
- `card_schema_version`

Purpose:
- card identity
- sorting
- lifecycle / expiry management

---

# 4. LINEAGE FIELDS

Required lineage fields:
- `asc_context_ref`
- `market_state_ref`
- `execution_surface_ref`
- `deployability_ref`
- `primary_family_id`
- `pattern_id` if present
- `lineage_refs`

Recommended additional lineage fields:
- `related_protocol_refs`
- `related_wave_refs`

Purpose:
- prove what upstream reasoning the card came from
- avoid detached card generation

---

# 5. CONTEXT INTERPRETATION FIELDS

Required fields:
- `market_state`
- `state_evidence_markers`
- `execution_surface`
- `surface_trust_flags`
- `hostility_objects`
- `context_gaps`

Recommended fields:
- `anti_habitat_flags`
- `market_state_competitors_considered`

Purpose:
- preserve the current interpreted context without pretending it is timeless doctrine

---

# 6. FAMILY / PATTERN FIELDS

Required fields:
- `primary_family_id`
- `why_primary_family_won`
- `family_competitors_considered`
- `why_competitors_lost`
- `pattern_id` if applicable
- `pattern_confirmation_conditions`
- `pattern_rejection_conditions`

Recommended fields:
- `family_conflict_notes`
- `pattern_dependency_notes`

Purpose:
- preserve that the card is a result of family/pattern competition, not magical appearance

---

# 7. DEPLOYABILITY FIELDS

Required fields:
- `deployability_class`
- `opportunity_status`
- `horizon_class`
- `usable_path_potential_summary`
- `execution_burden_class`
- `why_not_fully_eligible`
- `missing_surfaces`

Recommended fields:
- `spread_state_class`
- `execution_continuity_state`
- `hostility_contribution`

Purpose:
- keep structure validity separate from practical usability

---

# 8. GEOMETRY FIELDS

## 8.1 Entry geometry fields
Required:
- `entry_type`
- `entry_trigger_conditions`
- `entry_zone`
- `entry_confirmation_requirements`
- `entry_expiry_conditions`
- `allowed_order_constraints`

Recommended:
- `entry_style_notes`
- `do_not_chase_conditions`

## 8.2 Invalidation geometry fields
Required:
- `structural_invalidation_conditions`
- `hard_stop_mapping`
- `time_invalidation_conditions`
- `execution_invalidation_conditions`

Recommended:
- `invalidation_reasoning_summary`

## 8.3 Target geometry fields
Required:
- `primary_target_logic`
- `secondary_target_logic` if allowed
- `partials_policy`
- `break_even_policy`
- `trailing_policy`

Recommended:
- `target_compression_warning`
- `extension_condition_notes`

Purpose:
- make geometry explicit without using generic RR language

---

# 9. TIMEBOX AND EXECUTION-CONSTRAINT FIELDS

Required fields:
- `session_dependency`
- `latest_valid_holding_window`
- `force_expiry_conditions`
- `max_spread_state_allowed`
- `max_execution_instability_allowed`
- `stale_tick_block`
- `slippage_tolerance_class`
- `do_not_trade_conditions`

Purpose:
- keep cards intraday-bounded and execution-aware

---

# 10. RISK / INVALIDATION META FIELDS

Required fields:
- `idea_valid_but_geometry_invalid_flag`
- `degradation_reason`
- `card_eligibility_gate`

Recommended fields:
- `observe_only_reason`
- `execution_invalid_reason`
- `structure_invalid_reason`

Purpose:
- preserve the difference between interesting ideas and usable cards

---

# 11. MACHINE-SAFE EXPORT FIELDS

Machine-safe candidate fields should be explicitly grouped, such as:
- `symbol`
- `primary_family_id`
- `pattern_id` if present
- `opportunity_status`
- `deployability_class`
- `horizon_class`
- `entry_trigger_conditions`
- `entry_expiry_conditions`
- `hard_stop_mapping`
- `time_invalidation_conditions`
- `execution_invalidation_conditions`
- `force_expiry_conditions`
- `do_not_trade_conditions`

Purpose:
- later bounded export shaping

---

# 12. HUMAN-ONLY COMMENTARY FIELDS

Human-only fields should be explicitly grouped, such as:
- `narrative_summary`
- `family_competition_commentary`
- `uncertainty_notes`
- `operator_attention_note`
- `doctrine_explanation`

Purpose:
- preserve interpretive richness without pretending it is automation-safe

---

# 13. FORBIDDEN CARD SHAPE

A valid strategy card must not reduce to:
- direction only
- entry plus stop only
- fixed RR template only
- one confidence score with hidden assumptions
- generic support/resistance talk
- last-high / last-low stop mapping

That is not a valid Aurora card.

---

# 14. CURRENT JUDGMENT

Aurora now has a more explicit strategy-card field schema.

This should make future packet building, worked examples, and wrapper outputs:
- clearer
- less vague
- more consistent
- more machine-usable later
without turning the card layer into fake precision.
