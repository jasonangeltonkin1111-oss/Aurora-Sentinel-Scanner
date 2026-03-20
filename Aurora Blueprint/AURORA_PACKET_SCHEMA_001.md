# AURORA PACKET SCHEMA 001

## PURPOSE

This file expands Aurora packet design beyond the first scaffold layer.

It exists because strategy cards alone are not enough.
Aurora also needs packets that gather related objects into one usable operator unit.

A packet is broader than a card.
A packet may contain:
- context
- interpretation
- competition outcome
- one card if justified
- review hooks
- operator guidance

This file makes packet structure more explicit so Aurora can grow in a cleaner execution-side direction.

---

# 1. ROOT LAW

A packet is an operator/use workflow object.

A packet is not:
- timeless doctrine
- a family definition
- a pattern definition
- an EA order ticket

It is the structured bundle that helps the operator move through one Aurora workflow or one family lane cleanly.

---

# 2. PRIMARY PACKET TYPES

Aurora should distinguish between at least these packet types:

## 2.1 Workflow packet
Purpose:
- describe the stage order and operator flow

## 2.2 Family-lane packet
Purpose:
- show how one family should move through the object chain

## 2.3 Worked-example packet
Purpose:
- show one real symbol/case through the chain

## 2.4 Review packet
Purpose:
- diagnose one completed, expired, or missed opportunity

## 2.5 Export packet later
Purpose:
- gather machine-safe subsets for later bounded export

---

# 3. REQUIRED PACKET FIELD GROUPS

Every packet should explicitly contain some combination of:
- packet identity
- packet purpose
- input requirements
- stage order
- object chain references
- output expectations
- stop conditions
- operator notes
- follow-up notes

---

# 4. PACKET IDENTITY FIELDS

Required fields:
- `packet_id`
- `packet_type`
- `packet_version`
- `created_for`
- `scope`
- `status`

Purpose:
- identify what kind of packet this is
- keep scaffolds from being mistaken for final law

---

# 5. INPUT REQUIREMENT FIELDS

Required fields:
- `required_upstream_objects`
- `required_protocol_refs`
- `minimum_surface_requirements`
- `hard_blockers`

Purpose:
- make it clear what must exist before the packet can be used meaningfully

---

# 6. STAGE ORDER FIELDS

Required fields:
- `stage_sequence`
- `stage_entry_conditions`
- `stage_exit_conditions`
- `stage_stop_conditions`

Purpose:
- keep Aurora packets from becoming vague “read this and think” documents

---

# 7. OBJECT CHAIN FIELDS

Required fields:
- `objects_read`
- `objects_created`
- `objects_updated`
- `object_dependencies`

Purpose:
- tie packet execution back to Aurora’s explicit object model

---

# 8. OUTPUT EXPECTATION FIELDS

Required fields:
- `expected_output_type`
- `expected_output_quality`
- `when_no_output_is_correct`

Purpose:
- preserve the rule that no card / no packet outcome can be the correct result

---

# 9. OPERATOR NOTE FIELDS

Recommended fields:
- `operator_attention_points`
- `common_failure_modes`
- `what_not_to_force`
- `what_to_save_after_run`

Purpose:
- make packets more usable without polluting them with generic trading talk

---

# 10. FAMILY-LANE PACKET SPECIAL FIELDS

For family-lane packets, add:
- `primary_family_id`
- `main_competing_families`
- `typical_pattern_candidates`
- `common_geometry_failure_modes`
- `common_deployability_failure_modes`
- `typical_review_questions`

---

# 11. WORKED-EXAMPLE PACKET SPECIAL FIELDS

For worked-example packets, add:
- `symbol`
- `timestamp`
- `raw_context_attached`
- `stage_outputs`
- `review_outcome` later
- `lessons_learned`

---

# 12. FORBIDDEN PACKET SHAPE

A valid packet must not be:
- a vague prose note
- a motivational guide
- a compressed trade call
- a one-line setup idea
- a generic checklist detached from Aurora objects

---

# 13. CURRENT JUDGMENT

Aurora now has a more explicit packet schema direction.

This should make family packets, worked examples, workflow packets, and later export packets:
- easier to build
- easier to compare
- less vague
- more operator-usable
