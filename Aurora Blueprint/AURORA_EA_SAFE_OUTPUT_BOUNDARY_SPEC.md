# AURORA EA-SAFE OUTPUT BOUNDARY SPEC

## PURPOSE

This file defines what parts of Aurora output may later be translated into bounded EA-safe execution logic and what parts must remain human-interpretive or wrapper-only for now.

It exists to prevent premature automation drift.

Aurora should not become an EA by accident.
Aurora should first become a trustworthy doctrine and strategy-card engine.

---

# 1. ROOT LAW

EA translation comes only after:
- context truth is stable
- deployability logic is explicit
- strategy-card geometry is explicit
- machine-safe fields are separated from human-only interpretation

If those conditions are not met, automation is premature.

---

# 2. WHAT MAY BECOME EA-SAFE FIRST

The following output fields are candidates for bounded EA-safe translation once they are generated from stable upstream truth:

## 2.1 Identity / routing
- `symbol`
- `asset_class`
- `bucket_prior`
- `primary_family_id`
- `pattern_id` if present

## 2.2 Opportunity status
- `opportunity_status`
- `deployability_class`
- `horizon_class`

## 2.3 Deterministic geometry fields
- `entry_trigger_conditions`
- `entry_expiry_conditions`
- `hard_stop_mapping`
- `time_invalidation_conditions`
- `primary_target_logic` when explicitly machine-bounded
- `force_expiry_conditions`

## 2.4 Hard safety blocks
- `do_not_trade_conditions`
- `execution_invalidation_conditions`
- `missing_surface_blockers`

## 2.5 Audit references
- `asc_context_ref`
- `lineage_refs`
- `generated_at`
- `expiry_at`

---

# 3. WHAT MUST REMAIN HUMAN-ONLY OR WRAPPER-ONLY FOR NOW

The following should not be translated directly into EA logic at the current stage:

- narrative summaries
- doctrine explanation prose
- family competition commentary
- low-evidence contextual interpretation
- discretionary override notes
- soft uncertainty language
- any geometry field not yet bounded by explicit protocol

If a field cannot be machine-checked, it should not be treated as EA-safe.

---

# 4. REQUIRED CONTROLS BEFORE EA TRANSLATION

Before any Aurora output becomes executable, the system should have:
- stable context contract from ASC
- stable deployability classes
- stable generated strategy-card schema
- explicit do-not-trade conditions
- deterministic expiry behavior
- logging and replay capability
- fail-safe handling for stale or degraded ASC truth

Without these, automation creates hidden risk.

---

# 5. EARLY EA TRANSLATION POSTURE

The correct early posture is not:
- full autonomy

The correct early posture is:
- bounded routing
- bounded eligibility
- bounded safety rejection
- bounded order geometry only where deterministic

Everything else should remain wrapper-supervised until the evidence base is stronger.

---

# 6. FORBIDDEN SHORTCUTS

Aurora must not:
- automate from family cards directly
- automate from pattern cards directly
- automate from wrapper prose
- automate from hidden confidence judgments
- automate around missing ASC truth
- automate around degraded deployability classes as if they were fully eligible

---

# 7. CURRENT JUDGMENT

Aurora now has an explicit automation boundary:
- doctrine first
- generated strategy cards next
- EA-safe subset only after machine-safe fields are explicit

This keeps future automation bounded and auditable instead of vague or overconfident.
