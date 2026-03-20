# AURORA STATUS AND ENUM ALIGNMENT SPEC 001

## PURPOSE

This file is the explicit Aurora normalization layer for status, enum, class, and gate language across the active execution-side stack.

It exists because the current Aurora files already contain the right concepts, but some of them use overlapping or historically mixed wording.
The purpose of this file is to resolve that drift without flattening distinct meanings into one blended status system.

This file does not change ASC ownership.
It aligns Aurora-internal interpretation and packet language so future packets, examples, and generated cards stop drifting.

---

# 1. ROOT LAW

Aurora must keep these classes distinct:
- ASC field-state / surface-state availability
- Aurora deployability class
- Aurora opportunity status
- Aurora horizon class
- Aurora geometry validity
- Aurora card eligibility gate
- Aurora review outcome class

These are not synonyms.
They answer different questions.

Aurora must not collapse them into one convenience label such as “good,” “bad,” or “tradable.”

---

# 2. OWNERSHIP BOUNDARY

## 2.1 ASC-owned field-state truth
ASC owns field-level and surface-level availability truth for upstream context.
That includes the state classes already locked in `ASC_TO_AURORA_CONTEXT_CONTRACT.md`:
- `present`
- `pending`
- `reserved`
- `unavailable`
- `unsupported`
- `stale`
- `degraded`
- `invalid`

Aurora must preserve those meanings.
Aurora must not rewrite them into prettier but weaker wording.

## 2.2 Aurora-owned interpretation classes
Aurora owns:
- deployability interpretation
- opportunity preservation and classification
- horizon classification for generated geometry
- geometry validity
- card eligibility gates
- review outcome classes

Those Aurora-owned classes may be normalized into uppercase machine enums, but they must not overwrite ASC field semantics.

---

# 3. CANONICAL CLASS SETS

## 3.1 Surface availability class
Canonical owner:
- ASC for upstream context fields
- Aurora for preserving the same states downstream when surfaces remain missing or degraded

Canonical values:
- `PRESENT`
- `PENDING`
- `RESERVED`
- `UNAVAILABLE`
- `UNSUPPORTED`
- `STALE`
- `DEGRADED`
- `INVALID`

Interpretation law:
- this class answers “what is the state of the required field or surface?”
- it does not answer whether a setup is deployable
- it does not answer whether a card should be emitted

Normalization rule:
- lowercase ASC contract wording is the bridge-owned external form
- uppercase Aurora enum wording is the registry form
- these are one-to-one equivalents, not different concepts

## 3.2 Deployability class
Canonical owner:
- Aurora deployability engine

Canonical values:
- `DEPLOYABLE`
- `DEPLOYABLE_DEGRADED`
- `WATCH_ONLY`
- `NOT_DEPLOYABLE`
- `UNKNOWN_DEPLOYABILITY`

Interpretation law:
- this class answers “can the thesis be practically deployed inside project intraday limits after burden is absorbed?”
- it is execution/practicality focused
- it is not the same as structure validity
- it is not the same as final opportunity preservation status

## 3.3 Opportunity status
Canonical owner:
- Aurora opportunity object and downstream packets/cards

Canonical values:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

Interpretation law:
- this class answers “what honest downstream opportunity posture should Aurora preserve now?”
- it is the action-facing summary class for packets and cards
- it can preserve an interesting but non-card-ready idea

## 3.4 Horizon class
Canonical owner:
- Aurora deployability and geometry layers

Canonical values:
- `H1_FAST_INTRADAY`
- `H2_STANDARD_INTRADAY`
- `H3_WIDE_INTRADAY`
- `HORIZON_UNSUITABLE`
- `HORIZON_UNKNOWN`

Interpretation law:
- this class answers “what intraday holding shape is still plausible if geometry is later emitted?”
- it does not answer whether geometry is valid yet
- it does not answer whether a card is allowed yet
- when execution/timebox evidence is too incomplete to justify even a provisional intraday shape, `HORIZON_UNKNOWN` is the conservative result

## 3.5 Geometry validity
Canonical owner:
- Aurora geometry layer

Canonical values:
- `GEOMETRY_VALID`
- `GEOMETRY_DEGRADED`
- `GEOMETRY_INVALID`
- `GEOMETRY_UNRESOLVED`

Interpretation law:
- this class answers “is the generated execution geometry structurally and operationally usable?”
- a setup may still be interesting when geometry is invalid
- geometry validity must stay separate from opportunity status and deployability class

## 3.6 Card eligibility gate
Canonical owner:
- Aurora generated-card layer

Canonical values:
- `CARD_ALLOWED`
- `CARD_BLOCKED_STRUCTURE`
- `CARD_BLOCKED_DEPLOYABILITY`
- `CARD_BLOCKED_GEOMETRY`
- `CARD_BLOCKED_MISSING_SURFACES`
- `CARD_BLOCKED_TIMEBOX`

Interpretation law:
- this class answers “should Aurora emit a generated strategy card now?”
- it is output gating logic
- it is not a synonym for structure quality or deployability quality

## 3.7 Review outcome class
Canonical owner:
- Aurora review packet layer

Canonical values:
- `STRUCTURE_RIGHT_EXECUTION_WRONG`
- `STRUCTURE_WRONG`
- `DEPLOYABILITY_MISREAD`
- `GEOMETRY_POOR`
- `TIMEBOX_POOR`
- `UPSTREAM_TRUTH_INSUFFICIENT`
- `CORRECTLY_DEGRADED`
- `CORRECTLY_OBSERVED_ONLY`
- `UNRESOLVED_REVIEW`

Interpretation law:
- this class answers “what did later review most honestly diagnose?”
- it must not retroactively rewrite the original packet into fake certainty

---

# 4. DISTINCTION TABLE

## 4.1 Field/surface availability versus deployability
Example:
- spread field state may be `STALE`
- deployability class may therefore become `UNKNOWN_DEPLOYABILITY` or `WATCH_ONLY`

These are not the same layer.
The first is an upstream truth state.
The second is Aurora’s downstream interpretation result.

## 4.2 Deployability versus opportunity status
Example:
- deployability class may be `WATCH_ONLY`
- opportunity status may be `OBSERVE_ONLY`

Relation:
- deployability class is the execution-practicality diagnosis
- opportunity status is the preserved downstream posture

## 4.3 Structure validity versus opportunity status
Example:
- structure may be coherent
- opportunity status may still be `EXECUTION_INVALID`

That means the thesis was interesting but not honestly deployable.

## 4.4 Geometry validity versus card eligibility gate
Example:
- geometry validity may be `GEOMETRY_INVALID`
- card eligibility gate should therefore be `CARD_BLOCKED_GEOMETRY`

The first describes geometry quality.
The second describes output permission.

## 4.5 Opportunity status versus card eligibility gate
Example:
- opportunity status may be `ELIGIBLE_DEGRADED`
- card eligibility gate may still be `CARD_BLOCKED_TIMEBOX`

A preserved opportunity does not automatically justify a card.

---

# 5. HISTORICAL WORDING MAP

The following wording already exists in active files but should now be interpreted carefully:

## 5.1 Historical deployability protocol wording
Historical wording in `AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md` section 6:
- `STRUCTURE_INVALID`
- `EXECUTION_INVALID`
- `OBSERVE_ONLY`
- `ELIGIBLE_DEGRADED`
- `ELIGIBLE`

Canonical interpretation now:
- those labels are opportunity-facing downstream outcomes
- they are canonical under `opportunity_status`
- they are not the canonical `deployability_class` enum set

## 5.2 Historical horizon wording in enum registry
Historical wording in `AURORA_ENUM_REGISTRY_001.md` used:
- `SCALP`
- `SHORT_INTRADAY`
- `FULL_INTRADAY`
- `UNSUITABLE`
- `UNKNOWN`

Canonical interpretation now:
- replace with the explicit horizon-class set in section 3.4 of this file
- geometry and deployability files already use the H1/H2/H3 naming
- that H1/H2/H3 family is now canonical

## 5.3 Historical partial surface-availability registry
Historical wording in `AURORA_ENUM_REGISTRY_001.md` section 2.1 omitted:
- `RESERVED`
- `UNSUPPORTED`
- `DEGRADED`

Canonical interpretation now:
- the full eight-state set is canonical
- omission in the registry was an incompleteness issue, not a semantic rejection of those states

---

# 6. NORMALIZATION RULES FOR ACTIVE FILES

Active Aurora files should now follow these rules:

1. use the full surface-availability set when field/surface state is being described
2. use `deployability_class` only for the deployability-class set
3. use `opportunity_status` only for the opportunity-status set
4. use the H1/H2/H3 horizon naming as canonical horizon language
5. use `geometry_validity` only for geometry output quality
6. use `card_eligibility_gate` only for generated-card permission
7. use `review_outcome_class` only for review diagnosis output

If an older file still contains mixed historical wording, it should either:
- be patched directly
- or explicitly cross-reference this alignment spec

Do not invent new synonyms.

---

# 7. BRIDGE SAFETY NOTE

This alignment spec is Aurora-internal except for one preservation rule:
Aurora must keep the ASC contract’s surface-state semantics intact.

This spec does not require new ASC telemetry.
It does not widen the ASC→Aurora context contract.
It only normalizes how Aurora interprets and preserves those states downstream.

---

# 8. CURRENT JUDGMENT

Aurora now has an explicit normalization surface for the status and enum drift that emerged across the current wrapper/object/deployability/geometry/card/review stack.

This resolves drift by clarifying ownership and mapping historical wording without collapsing distinct classes into a single blended status system.
