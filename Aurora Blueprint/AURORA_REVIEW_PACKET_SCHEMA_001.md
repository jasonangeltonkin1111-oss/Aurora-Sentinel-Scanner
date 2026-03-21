# AURORA REVIEW PACKET SCHEMA 001

## PURPOSE

This file creates the first explicit review-packet schema for Aurora.

It exists because review and diagnosis are already part of Aurora, but the packet layer is still under-specified.

A review packet should not be a casual note.
It should be a structured learning object.

---

# 1. ROOT LAW

A review packet should diagnose the correct layer of success or failure.

It must not:
- rewrite history into certainty
- casually rewrite doctrine because of one miss
- treat all bad outcomes as family failure
- ignore deployability or geometry error

---

# 2. REVIEW PACKET PURPOSE

A `REVIEW_PACKET` should capture:
- what the system knew at the time
- what the system did not know
- what was generated
- what actually happened
- what layer failed or succeeded
- what should change and what should remain stable

---

# 3. REQUIRED FIELD GROUPS

Every review packet should contain:
- packet identity
- target reference
- original context summary
- original decision summary
- actual outcome summary
- review classification
- learned changes
- stability notes

---

# 4. REQUIRED FIELDS

## 4.1 Packet identity
- `packet_id`
- `packet_type`
- `packet_version`
- `review_timestamp`

## 4.2 Target reference
- `review_target_type`
- `review_target_ref`
- `family_id` if relevant
- `pattern_id` if relevant

## 4.3 Original state summary
- `original_context_ref`
- `original_opportunity_status`
- `original_opportunity_stage` if relevant
- `original_deployability_class`
- `original_card_eligibility_gate`
- `original_geometry_validity`

## 4.4 Actual outcome summary
- `actual_outcome_summary`
- `actual_path_notes`
- `miss_or_hit_notes`

## 4.5 Review classification
Use the enum registry review outcomes.
Required field:
- `review_outcome_class`

## 4.6 Learned changes
- `what_should_change`
- `what_should_not_change`
- `upstream_needs_noted` if any
- `downstream_needs_noted` if any

## 4.7 Stability notes
- `is_this_local_or_structural`
- `confidence_in_review`
- `needs_more_examples`

---

# 5. REVIEW DECISION LAW

A review packet must answer:
- was the issue structural?
- was the issue stage classification or stage exhaustion?
- was the issue deployability?
- was the issue geometry?
- was the issue timing / timebox?
- was the issue missing truth?
- was the system correct to preserve a late-join, re-entry, salvage, degrade, or observe-only posture?

If the review cannot answer this, it should remain unresolved rather than inventing certainty.

---

# 6. WHAT SHOULD NOT CHANGE FROM ONE REVIEW

One review should not automatically rewrite:
- family doctrine
- pattern doctrine
- routing law
- global card schema

unless the failure is clearly structural and repeated.

This protects Aurora from overreacting to noise.

---

# 7. CURRENT JUDGMENT

Aurora now has a first explicit review-packet schema.

This is one of the missing machine-readiness and learning-library layers the audit correctly called out.
