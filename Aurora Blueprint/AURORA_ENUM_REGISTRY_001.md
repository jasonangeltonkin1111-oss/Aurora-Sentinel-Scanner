# AURORA ENUM REGISTRY 001

## PURPOSE

This file creates the first explicit enum registry for Aurora.

It exists because Aurora now has enough protocols, cards, packets, and object layers that free-text status language will create drift.

This file is not decorative.
It is the first machine-precision lock for shared vocabulary.

---

# 1. ROOT LAW

Where Aurora requires a repeated status/class/gate vocabulary, it should prefer enums from this registry.

Do not invent near-synonyms in later files when a registry value already exists.

If a new enum is needed:
- add it explicitly later
- do not improvise it silently

---

# 2. DATA AVAILABILITY ENUMS

## 2.1 Surface availability
Allowed values:
- `PRESENT`
- `PENDING`
- `UNAVAILABLE`
- `STALE`
- `INVALID`

Use for:
- context surfaces
- input surfaces
- machine export surfaces

## 2.2 Knowledge confidence state
Allowed values:
- `KNOWN`
- `PARTIAL`
- `UNKNOWN`

Use for:
- interpretation confidence labels where a simple bounded state is enough

---

# 3. MARKET / STRUCTURE INTERPRETATION ENUMS

## 3.1 Opportunity status
Allowed values:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

Use for:
- opportunity objects
- packets
- worked examples
- review outputs

## 3.2 Family result state
Allowed values:
- `PRIMARY`
- `COMPETING`
- `REJECTED`
- `UNRESOLVED`

Use for:
- family competition outputs

## 3.3 Pattern result state
Allowed values:
- `CONFIRMED`
- `CANDIDATE`
- `REJECTED`
- `UNRESOLVED`

Use for:
- pattern competition outputs

---

# 4. DEPLOYABILITY ENUMS

## 4.1 Deployability class
Allowed values:
- `DEPLOYABLE`
- `DEPLOYABLE_DEGRADED`
- `WATCH_ONLY`
- `NOT_DEPLOYABLE`
- `UNKNOWN_DEPLOYABILITY`

Use for:
- deployability objects
- card gating
- review outputs

## 4.2 Execution burden class
Allowed values:
- `LOW`
- `MODERATE`
- `HIGH`
- `EXTREME`
- `UNKNOWN`

## 4.3 Spread state class
Allowed values:
- `TIGHT`
- `NORMAL`
- `ELEVATED`
- `WIDE`
- `UNKNOWN`

## 4.4 Execution continuity state
Allowed values:
- `STABLE`
- `DEGRADED`
- `UNSTABLE`
- `UNKNOWN`

---

# 5. HORIZON / TIMEBOX ENUMS

## 5.1 Horizon class
Allowed values:
- `SCALP`
- `SHORT_INTRADAY`
- `FULL_INTRADAY`
- `UNSUITABLE`
- `UNKNOWN`

Aurora law still applies:
- intraday is the maximum allowed holding horizon

---

# 6. CARD ELIGIBILITY ENUMS

## 6.1 Card eligibility gate
Allowed values:
- `CARD_ALLOWED`
- `CARD_BLOCKED_STRUCTURE`
- `CARD_BLOCKED_DEPLOYABILITY`
- `CARD_BLOCKED_GEOMETRY`
- `CARD_BLOCKED_MISSING_SURFACES`
- `CARD_BLOCKED_TIMEBOX`

## 6.2 Geometry validity
Allowed values:
- `GEOMETRY_VALID`
- `GEOMETRY_DEGRADED`
- `GEOMETRY_INVALID`
- `GEOMETRY_UNRESOLVED`

---

# 7. REVIEW ENUMS

## 7.1 Review outcome class
Allowed values:
- `STRUCTURE_RIGHT_EXECUTION_WRONG`
- `STRUCTURE_WRONG`
- `DEPLOYABILITY_MISREAD`
- `GEOMETRY_POOR`
- `TIMEBOX_POOR`
- `UPSTREAM_TRUTH_INSUFFICIENT`
- `CORRECTLY_DEGRADED`
- `CORRECTLY_OBSERVED_ONLY`
- `UNRESOLVED_REVIEW`

---

# 8. MACHINE EXPORT HONESTY LAW

When exporting later:
- prefer explicit enum states from this registry
- do not collapse unknowns into false defaults
- do not replace `UNKNOWN` with invented certainty

---

# 9. CURRENT JUDGMENT

Aurora now has its first explicit enum registry.

This is one of the key tightening steps required before wrapper outputs can become more machine-usable in a stable way.
