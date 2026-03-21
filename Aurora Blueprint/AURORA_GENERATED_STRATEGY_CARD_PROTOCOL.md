# AURORA GENERATED STRATEGY CARD PROTOCOL

## PURPOSE

This file defines the missing bridge layer between:
- family doctrine
- pattern doctrine
- wrapper interpretation
- later EA-safe translation

A generated strategy card is not a family file.
A generated strategy card is not a pattern file.
A generated strategy card is a time-bounded, symbol-specific, context-specific output object created from:
- ASC truth
- Aurora state interpretation
- Aurora execution-surface interpretation
- deployability judgment
- family eligibility
- pattern confirmation when available

This protocol exists so Aurora can become machine-usable without polluting the doctrine layers with false precision.

---

# 1. ROOT LAW

A generated strategy card is conditional, expiring, and assumption-tagged.

It must never pretend to be:
- timeless doctrine
- family definition
- universal entry recipe
- broker-agnostic certainty

It is a generated output built for one symbol, one context, and one intraday timebox.

---

# 2. WHY THIS LAYER IS NEEDED

Current doctrine already defines:
- market-state canon
- execution-context doctrine
- strategy families
- pattern schemas
- wrapper / EA translation direction

But these layers intentionally stop before full order geometry.

This protocol fills that gap by defining how Aurora can emit a machine-usable strategy object without contaminating the upstream doctrine files.

---

# 3. REQUIRED INPUTS

Aurora should not generate a strategy card unless it has:

## 3.1 ASC context truth
- symbol identity
- asset class / bucket
- market status
- session / timebox state
- spread / execution truth
- freshness / continuity truth

## 3.2 Aurora interpretation truth
- market state
- execution surface
- hostility context
- deployability class
- eligible families
- pattern candidate if available

---

# 4. CARD IDENTITY BLOCK

Every generated strategy card should include:
- `strategy_card_id`
- `symbol`
- `asset_class`
- `bucket_prior`
- `opportunity_stage`
- `generated_at`
- `expiry_at`
- `asc_context_ref`
- `lineage_refs`

`lineage_refs` should point back to:
- family card used
- pattern card used if any
- deployability protocol
- relevant doctrine surfaces

---

# 5. REQUIRED INTERPRETATION BLOCK

Every card should include:
- `market_state`
- `state_evidence_markers`
- `execution_surface`
- `surface_trust_flags`
- `hostility_objects`
- `deployability_class`
- `horizon_class`
- `opportunity_status`

`opportunity_status` must be one of:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

---

# 6. FAMILY / PATTERN BLOCK

Every card should include:
- `primary_family_id`
- `family_competitors_considered`
- `why_primary_family_won`
- `why_competitors_lost`
- `pattern_id` if applicable
- `pattern_rejection_conditions`

Aurora must preserve family competition truth.
It must not act like a family appeared from nowhere.

The card must also preserve whether the live opportunity is emergent, developing, confirmed, mature, late, continuation, re-entry, salvage, or exhausted enough to block issuance.
That timing truth belongs in the card layer when it materially affects deployability, geometry freedom, or remaining path quality.

---

# 7. GEOMETRY BLOCK

This is the first layer where explicit geometry is allowed.

## 7.1 Entry
Include:
- `entry_type`
- `entry_trigger_conditions`
- `entry_zone`
- `entry_confirmation_requirements`
- `entry_expiry_conditions`
- `order_constraints`

## 7.2 Invalidation
Include:
- `structural_invalidation_conditions`
- `hard_stop_mapping`
- `time_invalidation_conditions`
- `execution_invalidation_conditions`

## 7.3 Targets
Include:
- `primary_target_logic`
- `secondary_target_logic` if allowed
- `partials_policy`
- `break_even_policy`
- `trailing_policy`

These must remain tied to structural meaning and deployability.
No generic fixed RR law is allowed here.

## 7.4 Timebox
Include:
- `session_dependency`
- `latest_valid_holding_window`
- `force_expiry_conditions`

---

# 8. MACHINE-SAFE VS HUMAN-ONLY FIELDS

Every generated card should explicitly separate:

## 8.1 Machine-safe fields
Fields suitable for later bounded EA use, such as:
- symbol
- direction if applicable
- entry trigger conditions
- hard invalidation mapping
- expiry conditions
- opportunity status
- do-not-trade conditions

## 8.2 Human-only fields
Fields that remain interpretive or explanatory, such as:
- narrative summary
- doctrine explanation
- family competition commentary
- uncertainty notes

Aurora must not blur these categories.

---

# 9. FORBIDDEN SHORTCUTS

A generated strategy card must not:
- use last-high / last-low as universal SL/TP logic
- use one-size-fits-all RR
- ignore deployability class
- hide missing ASC truth
- behave like a family card is already an executable trade plan

---

# 10. CURRENT JUDGMENT

Aurora now has a clear machine-usable bridge layer:
- doctrine stays doctrinal
- strategy cards become the explicit generated output layer
- geometry lives here, not in the family or pattern definitions
- later EA-safe translation can be bounded from this layer rather than guessed from prose
