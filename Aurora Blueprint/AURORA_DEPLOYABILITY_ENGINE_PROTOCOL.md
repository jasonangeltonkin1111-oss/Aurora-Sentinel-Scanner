# AURORA DEPLOYABILITY ENGINE PROTOCOL

## PURPOSE

This file defines how Aurora converts live ASC truth, structural path logic, and hostility context into a deployability judgment.

It exists because structural validity and deployability are not the same thing.

A setup can be structurally coherent but still be poorly deployable now.

---

# 1. ROOT LAW

Measured deployability beats category prejudice.

Aurora must not assume:
- major = deployable
- exotic = unusable
- stock = wide spread
- low spread = good opportunity
- high spread = automatic veto

Buckets give priors only.
Deployability is determined by measured context.

Spread is a cost input that changes:
- required path
- usable geometry
- usable intraday horizon
- opportunity classification

---

# 2. DEFINITION

Deployability is the ability to realize a setup’s intended structural path inside the allowed holding horizon after execution burden is absorbed.

Project constraint:
- intraday is the maximum allowed holding horizon

Therefore a setup is deployable only if its expected usable path can reasonably be realized inside intraday bounds after burden is accounted for.

---

# 3. MINIMUM INPUT SURFACES

Aurora should not produce a confident deployability judgment unless it has, at minimum:

## 3.1 ASC market truth
- market-open / market-closed truth
- tick freshness
- quote continuity
- current session / timebox truth

## 3.2 ASC execution truth
- current spread
- rolling median spread
- spread instability state
- stale tick risk
- execution continuity state

## 3.3 Aurora structure truth
- current state classification
- family candidate
- pattern candidate if present
- structural invalidation logic
- structural target logic

## 3.4 Hostility truth
- hostility type
- hostility location
- hostility effect class
- hostility persistence / stage

If these are missing, deployability must degrade to an Aurora-normalized downstream posture such as:
- `UNKNOWN_DEPLOYABILITY`
- `WATCH_ONLY`
- `OBSERVE_ONLY` opportunity preservation

Do not treat those as interchangeable labels.

---

# 4. CORE COMPONENTS

Aurora should evaluate deployability through five components.

## 4.1 Structural path potential
What conservative usable path remains before the thesis is exhausted or invalidated?

Examples:
- return-to-value path
- next acceptance zone
- next rejection boundary
- next continuation objective

This must come from structural meaning, not generic RR.

## 4.2 Total execution burden
At minimum this includes:
- spread burden
- expected slippage burden if inferable
- execution instability burden
- session-end / time-compression burden

## 4.3 Horizon suitability
Suggested classes:
- `H1_FAST_INTRADAY`
- `H2_STANDARD_INTRADAY`
- `H3_WIDE_INTRADAY`

If required horizon exceeds intraday, the setup is not deployable in this project.

## 4.4 Execution continuity quality
Examples of degradation:
- unstable spread regime
- stale ticks
- discontinuous prints
- dead session transition
- low trust participation

## 4.5 Hostility burden
How much does the current hostile environment degrade deployability even if structure remains coherent?

This must remain separate from structural invalidation.

---

# 5. COMPARISON LAW

Aurora should explicitly compare:

`usable_path_potential` versus `total_execution_burden`

The key question is not:
- is spread high?

The key question is:
- is the expected usable path large and clean enough relative to total burden?

---

# 6. DEPLOYABILITY CLASS AND DOWNSTREAM OPPORTUNITY POSTURE

Canonical enum ownership is defined in `AURORA_STATUS_AND_ENUM_ALIGNMENT_SPEC_001.md`.

## 6.1 Canonical deployability classes
- `DEPLOYABLE`
- `DEPLOYABLE_DEGRADED`
- `WATCH_ONLY`
- `NOT_DEPLOYABLE`
- `UNKNOWN_DEPLOYABILITY`

These answer the deployability question only.

## 6.2 Typical downstream opportunity-status outcomes
Deployability often feeds one of these downstream opportunity postures:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`

`STRUCTURE_INVALID` remains a structure-layer or opportunity-layer outcome, not a deployability-class value.

---

# 7. HORIZON ADAPTATION LAW

Aurora must not react to higher spread or friction with a generic veto.

Instead it should ask:
- does the family support a wider intraday hold?
- does structure still offer enough usable path?
- is the session/timebox compatible with that hold?

If yes:
- move the candidate into a wider intraday geometry class

If no:
- degrade or invalidate deployability

This replaces “spread too high, skip.”

---

# 8. RELATIONSHIP TO WAVE 4 HOSTILITY

Deployability should use Wave 4 hostility objects directly.

Examples:
- spread burden may degrade deployability without invalidating structure
- macro hostility may require stronger evidence but not suppress everything
- execution hostility may produce observe-only or execution-invalid states

Deployability must not collapse all hostility into one fear score.

---

# 9. FORBIDDEN SHORTCUTS

Aurora must not:
- veto by bucket alone
- veto by spread alone
- assume low spread means good opportunity
- assume high spread means no opportunity
- use one deployability rule across all families
- hide missing execution truth behind clean wrapper language

---

# 10. OUTPUT FIELDS

A deployability object should later include at least:
- `deployability_class`
- `opportunity_status` when a downstream posture has already been assigned
- `horizon_class`
- `usable_path_potential`
- `execution_burden_class`
- `spread_state_class`
- `execution_continuity_state`
- `hostility_contribution`
- `missing_surfaces`
- `why_not_fully_eligible`

---

# 11. CURRENT JUDGMENT

Aurora now has an explicit deployability law:
- structure validity is separate from deployability
- spread is a constraint, not an automatic veto
- burden must be compared to usable path
- horizon may widen inside intraday rather than collapsing to no-trade
- opportunities should be degraded intelligently rather than starved
