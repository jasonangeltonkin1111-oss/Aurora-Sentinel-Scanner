# AURORA INTRADAY GEOMETRY PROTOCOL

## PURPOSE

This file defines how Aurora should build explicit intraday trade geometry from:
- ASC context truth
- Aurora state interpretation
- execution-surface interpretation
- deployability judgment
- family and pattern meaning

It exists because family files and pattern files are not final execution recipes.
This protocol creates the missing geometry layer without contaminating doctrine with false precision.

---

# 1. ROOT LAW

Geometry must come from structural meaning plus measured deployability.

Aurora must not use:
- last high / last low as universal stop logic
- fixed RR as universal target logic
- one entry style across all families
- spread alone as a geometry veto

A valid setup can still have invalid geometry.
A degraded setup can still have usable geometry under a wider intraday horizon.

---

# 2. INTRADAY HORIZON CLASSES

Aurora should express geometry inside one of three horizon classes:

## 2.1 `H1_FAST_INTRADAY`
Use only when:
- spread / burden is light
- execution continuity is strong
- session support is strong
- structure is clean enough for tighter timing

## 2.2 `H2_STANDARD_INTRADAY`
Use when:
- burden is acceptable
- path quality is adequate
- the setup does not require extreme compression or extreme extension

## 2.3 `H3_WIDE_INTRADAY`
Use when:
- burden is heavier but still absorbable
- the family / pattern can tolerate slower realization
- the structure offers enough usable path inside intraday bounds

If the geometry needs more than wide intraday, the setup is outside project limits.

---

# 3. GEOMETRY COMPONENTS

Every generated geometry plan should include:
- entry geometry
- invalidation geometry
- target geometry
- timebox geometry
- execution geometry

---

# 4. ENTRY GEOMETRY

Entry geometry must define how the trade becomes valid.

Required fields:
- `entry_type`
- `entry_trigger_conditions`
- `entry_zone`
- `entry_confirmation_requirements`
- `entry_expiry_conditions`
- `allowed_order_constraints`

### Entry law
Entry should be tied to the meaning of the pattern or family.
Examples:
- reclaim must require reclaim confirmation
- continuation must require continuation acceptance
- fade must require rejection evidence
- breakout must require evidence that the move is more than a print through a boundary

Entry geometry must become more conservative when:
- burden rises
- hostility rises
- session support weakens

---

# 5. INVALIDATION GEOMETRY

Invalidation geometry defines where the thesis is actually broken.

Required fields:
- `structural_invalidation_conditions`
- `hard_stop_mapping`
- `time_invalidation_conditions`
- `execution_invalidation_conditions`

### Invalidation law
Invalidation must come from the thesis failing, not from arbitrary distance.

Examples:
- reclaim thesis fails if acceptance returns beyond the failed break boundary
- balance fade thesis fails if acceptance and directional performance establish outside the range edge
- continuation thesis fails if the breakout becomes a failed auction or acceptance collapses back inside prior structure

Aurora must not treat invalidation as a generic swing extreme rule.

---

# 6. TARGET GEOMETRY

Target geometry defines where the thesis is considered meaningfully achieved.

Required fields:
- `primary_target_logic`
- `secondary_target_logic` if allowed
- `partials_policy`
- `break_even_policy`
- `trailing_policy`

### Target law
Targets must come from structural objectives and path logic.

Examples:
- return-to-value objective
- next acceptance zone
- next rejection boundary
- next continuation objective

Aurora must not derive targets from universal RR templates.

### Management law
Partials, break-even, and trailing are conditional tools.
They should not be assumed active for every family.

---

# 7. TIMEBOX GEOMETRY

Because intraday is the maximum allowed holding horizon, every geometry plan must include timebox logic.

Required fields:
- `session_dependency`
- `latest_valid_holding_window`
- `force_expiry_conditions`

### Timebox law
A structurally valid idea becomes non-deployable if it needs more time than the project allows.

---

# 8. EXECUTION GEOMETRY

Execution geometry translates deployability into practical order constraints.

Required fields:
- `max_spread_state_allowed`
- `max_execution_instability_allowed`
- `stale_tick_block`
- `slippage_tolerance_class`
- `do_not_trade_conditions`

### Execution law
Execution geometry must hard-block trades when measured context breaks the assumptions that made the setup eligible.

---

# 9. WHEN GEOMETRY IS INVALID EVEN IF THE IDEA IS VALID

Aurora must be able to say:
- idea valid
- geometry invalid

Examples:
- usable path too compressed relative to burden
- invalidation too far for intraday bounds
- session support too weak for required realization time
- execution continuity too poor for the entry style

This distinction is critical.

---

# 10. RELATIONSHIP TO DEPLOYABILITY

Deployability tells Aurora whether a setup is usable now.
Geometry tells Aurora how that use should be expressed.

Therefore:
- `ELIGIBLE` may map to H1 or H2 geometry
- `ELIGIBLE_DEGRADED` may map to H2 or H3 geometry
- `OBSERVE_ONLY` should not emit a live executable geometry plan
- `EXECUTION_INVALID` must not emit actionable geometry

---

# 11. FORBIDDEN SHORTCUTS

Aurora must not:
- use one geometry template across all families
- use one stop rule across all patterns
- use one target rule across all assets
- let geometry ignore session truth
- let geometry ignore burden / spread / execution continuity

---

# 12. CURRENT JUDGMENT

Aurora now has an explicit intraday geometry law:
- geometry is derived from structural meaning
- geometry adapts to burden and horizon
- a valid idea can still have invalid geometry
- entries, stops, targets, timeboxes, and execution constraints are now a separate protocol surface
