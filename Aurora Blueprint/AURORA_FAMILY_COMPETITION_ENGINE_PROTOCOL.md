# AURORA FAMILY COMPETITION ENGINE PROTOCOL

## PURPOSE

This file is the canonical protocol for the Aurora family competition stage.

It exists to stop three failure modes:
- forced family assignment when context is partial
- hidden score drift that masks why families are alive or rejected
- doctrine duplication where family habitat truth is copied out of the family system instead of consumed from it

This layer sits between context interpretation and downstream family-child interpretation.
It makes Aurora answer, in structured form:
- which family hypotheses are alive
- which family hypotheses are rejected
- why each status was assigned
- how unresolved the current result remains

This protocol does not replace the family registry, family files, or family cards.
It consumes them.

---

# 1. POSITION IN THE AURORA CHAIN

The family competition engine runs after:
1. ASC context intake
2. group-context construction
3. context interpretation

The family competition engine runs before:
1. pattern competition
2. opportunity classification
3. generated strategy-card decisions
4. geometry production

Canonical chain:
- `ASC_CONTEXT_OBJECT`
- `AURORA_GROUP_CONTEXT_OBJECT`
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`
- `AURORA_FAMILY_COMPETITION_OBJECT`
- `AURORA_PATTERN_CANDIDATE_OBJECT` later if justified
- `AURORA_OPPORTUNITY_OBJECT` later
- `AURORA_GENERATED_STRATEGY_CARD` later if justified

---

# 2. ROOT LAWS

## 2.1 No-force law
Aurora may not force one family winner merely because downstream stages prefer a cleaner answer.

## 2.2 No numeric-confidence law
This engine must not use weighted scoring, synthetic totals, or hidden score logic.

## 2.3 Doctrine-consumption law
Habitat, anti-habitat, structural signatures, and anti-confusions remain owned by:
- `AURORA_STRATEGY_FAMILY_REGISTRY.md`
- `strategy_families/CORE/*.md`
- `strategy_families/CARDS/*.card.md`

The engine only records how those truths apply to the current case.
It must not restate the whole doctrine as a second canon.

## 2.4 Missingness law
If required input surfaces are too thin, stale, degraded, or invalid, the engine must preserve that openly and may stop with:
- `DEFERRED_CLASSIFICATION`
- `NO_VALID_FAMILY`
- `INVALID_COMPETITION_INPUT`

## 2.5 Pattern-boundary law
Pattern selection is not performed here.
This engine may identify pattern implications only as downstream routing notes.
It must not declare a pattern winner.

---

# 3. REQUIRED INPUTS

The family competition engine may consume the following inputs when present:
- `asc_context_ref`
- `group_context_ref`
- `market_state_object_ref`
- `execution_surface_object_ref`
- `deployability_object_ref`
- `missing_surface_record`
- `family_registry_ref`
- relevant `family_file_refs`
- relevant `family_card_refs`
- optional structural hints already allowed by active Aurora files

Allowed structural hints are limited to the already active interpretation surfaces, such as:
- primary market-state read
- competing state interpretations
- group or regime posture
- family-logic-versus-symbol-constraint note
- deployability compatibility as a modifier

The engine must not require geometry, entry logic, or opportunity ranking inputs.

---

# 4. INPUT VALIDITY GATE

Competition input is valid only if Aurora has enough truth to compare families honestly.

Minimum basis:
- identity is not context-unusable
- at least one structural interpretation exists
- at least one plausible family candidate can be named from routing, market state, or family doctrine
- missingness has been recorded explicitly

Return `INVALID_COMPETITION_INPUT` when:
- identity or group routing is too broken to name a valid family set
- structural interpretation never reached a usable state
- the case contains only placeholder language with no family-comparison basis

Return `DEFERRED_CLASSIFICATION` when:
- the candidate set is real
- but evidence is too thin to reject or promote honestly

---

# 5. CANDIDATE FAMILY GENERATION

## 5.1 Candidate generation sources
Candidate families become live from the combination of:
- market-state interpretation
- group/bucket/regime routing
- family-card competitor lists
- family-file anti-confusion boundaries
- explicit worked-example or packet lineage when the case belongs to an existing lane

## 5.2 Routing law
Routing may narrow the field, but it must not over-collapse it.

Examples:
- a failed-directional-attempt regime may narrow toward `C-04`, `C-03`, and `C-01`
- a balance-first regime may narrow toward `C-05` while still keeping `C-03` or `C-04` visible if breakout/failure tension remains alive

## 5.3 Competitor inclusion law
At minimum, live candidates should include:
- the family most aligned with the current primary state interpretation
- the main doctrinal competitors named by the relevant family files or cards
- any weaker but still plausible family not yet disproven by current evidence

## 5.4 Weak-but-plausible law
A weaker candidate remains visible when:
- its habitat is still partially present
- its anti-habitat is not yet decisive
- rejection would depend on surfaces that are still missing

Weak visibility does not make a family primary.
It prevents premature collapse.

---

# 6. COMPETITION DIMENSIONS

The family competition engine must use structured, non-numeric comparison dimensions.

## 6.1 Habitat fit
Does the case match the family's native habitat as defined in its doctrine files?

## 6.2 Anti-habitat conflict
Is the case materially colliding with conditions the family says should suppress or reject it?

## 6.3 State alignment
Does the current market-state interpretation support this family more directly than its competitors?

## 6.4 Regime compatibility
Does group/bucket/regime routing reinforce or weaken the family without becoming symbol doctrine?

## 6.5 Contradiction load
How many active case facts cut directly against the family thesis?

## 6.6 Dependence on missing surfaces
Would the family require still-missing surfaces before it could be promoted or rejected honestly?

## 6.7 Evidence not yet present
What evidence would need to appear before the family could strengthen materially?

## 6.8 Deployability compatibility modifier
Deployability may shape practical posture, but it is not a family gate by itself.
A structurally valid family may survive even when deployability is weak.

## 6.9 Competitor pressure
Which other live family is currently applying the strongest doctrinal pressure against this family?

These dimensions must be expressed as explicit notes or field-level judgments, not as a hidden composite.

---

# 7. ELIMINATION LAW

## 7.1 Rejected family
A family becomes `REJECTED` when current evidence shows one or more of the following:
- anti-habitat conflict is decisive
- the required family thesis is contradicted by the case structure
- a stronger competing family explains the same case while the rejected family loses its required structural basis
- the family would require invented evidence to remain alive

Each rejected family must record explicit rejection reasons.

## 7.2 Still-competing family
A family remains `COMPETING` when:
- it still matches part of the active habitat
- no decisive anti-habitat conflict has invalidated it
- a stronger family may currently lead, but rejection would be premature

## 7.3 Unresolved family posture
A family remains unresolved when:
- both supportive and conflicting evidence coexist
- missing surfaces are material
- the case may move toward confirmation or rejection later

## 7.4 Primary family
A family becomes `PRIMARY` only when:
- it currently explains the case better than all live competitors
- the main competitors have explicit rejection or inferiority reasons
- remaining missingness does not invalidate the primary reading itself

## 7.5 Deferral
The engine must defer classification when:
- several families remain live and none can be promoted honestly
- the evidence basis is too thin to reject competitors safely
- the context is structurally interesting but still transition-heavy

---

# 8. AMBIGUITY HANDLING

The family competition engine must emit one canonical competition status:
- `CLEAR_PRIMARY`
- `CONTESTED_PRIMARY`
- `MULTIPLE_LIVE`
- `DEFERRED_CLASSIFICATION`
- `NO_VALID_FAMILY`
- `INVALID_COMPETITION_INPUT`

## 8.1 `CLEAR_PRIMARY`
One family is primary and competing alternatives have been reduced to secondary or rejected status without material ambiguity.

## 8.2 `CONTESTED_PRIMARY`
One family currently leads, but at least one competitor remains materially alive.

## 8.3 `MULTIPLE_LIVE`
Multiple families remain genuinely live and no honest primary can be named.

## 8.4 `DEFERRED_CLASSIFICATION`
Routing is plausible, but the case is too thin or too transitional for valid promotion.

## 8.5 `NO_VALID_FAMILY`
The case fails to sustain any valid family thesis from the available set.

## 8.6 `INVALID_COMPETITION_INPUT`
The engine could not run honestly because its input basis was invalid.

---

# 9. CONFIDENCE POSTURE

The family competition engine may record only bounded posture language:
- `KNOWN`
- `PARTIAL`
- `UNKNOWN`

This posture describes how complete the competition judgment is.
It is not a score.

---

# 10. RELATIONSHIP TO LATER LAYERS

This engine does not do any of the following:
- no pattern commitment
- no opportunity declaration
- no card eligibility decision
- no geometry generation
- no entry / invalidation / target logic

Its role is narrower:
- shape downstream interpretation
- preserve structured family ambiguity
- give later pattern competition a disciplined parent set
- give later opportunity classification an explicit upstream family result

---

# 11. CURRENT JUDGMENT

Aurora now has a dedicated family competition protocol that formalizes a previously scattered layer without duplicating family doctrine or swallowing downstream pattern, opportunity, or card logic.
