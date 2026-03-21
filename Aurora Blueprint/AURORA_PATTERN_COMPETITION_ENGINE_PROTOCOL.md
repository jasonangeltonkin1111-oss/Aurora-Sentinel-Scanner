# AURORA PATTERN COMPETITION ENGINE PROTOCOL

## PURPOSE

This file is the canonical protocol for the Aurora pattern competition stage.

It exists to stop four failure modes:
- pattern-first drift that ignores upstream family competition
- fake certainty where one visible shape is treated as self-explanatory
- hidden collapse from contested family posture into premature pattern commitment
- doctrine duplication where pattern meaning is copied out of the atlas or pattern cards instead of consumed from them

This layer sits between family competition and downstream opportunity classification.
It makes Aurora answer, in structured form:
- whether pattern competition is valid to run now
- which pattern hypotheses are alive within the surviving family set
- which pattern hypotheses are rejected
- why each status was assigned
- how unresolved the result remains

This protocol does not replace the pattern atlas or pattern cards.
It consumes them.

---

# 1. POSITION IN THE AURORA CHAIN

The pattern competition engine runs after:
1. ASC context intake
2. group-context construction
3. context interpretation
4. family competition

The pattern competition engine runs before:
1. opportunity classification
2. generated strategy-card decisions
3. geometry production

Canonical chain:
- `ASC_CONTEXT_OBJECT`
- `AURORA_GROUP_CONTEXT_OBJECT`
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`
- `AURORA_FAMILY_COMPETITION_OBJECT`
- `AURORA_PATTERN_COMPETITION_OBJECT`
- `AURORA_OPPORTUNITY_OBJECT` later
- `AURORA_GENERATED_STRATEGY_CARD` later if justified

---

# 2. ROOT LAWS

## 2.1 Family-first law
Pattern competition must consume the family competition result.
It must not reopen family selection from scratch.

## 2.2 No-force law
Aurora may not force a pattern winner merely because downstream stages prefer a cleaner answer.

## 2.3 No numeric-confidence law
This engine must not use weighted scoring, synthetic totals, or hidden score logic.

## 2.4 Atlas-consumption law
Pattern meaning, parent-family attachment, anti-confusions, and structural role remain owned by:
- `AURORA_SETUP_PATTERN_ATLAS.md`
- `patterns/*.card.md` where cards exist

The engine only records how those truths apply to the current case.
It must not restate the whole atlas as a second canon.

## 2.5 Missingness law
If required input surfaces are too thin, stale, degraded, invalid, or too dependent on unresolved upstream family ambiguity, the engine must preserve that openly and may stop with:
- `DEFERRED_PATTERN_COMPETITION`
- `NO_VALID_PATTERN`
- `INVALID_PATTERN_COMPETITION_INPUT`

## 2.6 Opportunity-boundary law
Pattern selection is not opportunity declaration.
This engine may shape downstream opportunity posture, but it must not emit opportunity status, card eligibility, or geometry.

---

# 3. REQUIRED INPUTS

The pattern competition engine may consume the following inputs when present:
- `asc_context_ref`
- `group_context_ref`
- `market_state_object_ref`
- `execution_surface_object_ref`
- `deployability_object_ref`
- `family_competition_object_ref`
- `missing_surface_record`
- `pattern_atlas_ref`
- relevant `pattern_card_refs` when present
- optional structural hints already allowed by active Aurora files

Allowed structural hints are limited to active interpretation surfaces such as:
- upstream family competition status
- surviving family set
- primary family candidate if any
- market-state read
- group/regime posture
- deployability compatibility as a modifier
- visible structural pattern hints already present in the case

The engine must not require geometry, entry logic, or opportunity ranking inputs.

---

# 4. INPUT VALIDITY GATE

Pattern competition input is valid only if Aurora has enough truth to compare patterns honestly inside an already-shaped family set.

Minimum basis:
- a valid family competition result exists
- at least one surviving family or family-neighborhood route exists
- at least one plausible pattern group can be named from the atlas or active pattern cards
- missingness has been recorded explicitly

Return `INVALID_PATTERN_COMPETITION_INPUT` when:
- no valid upstream family-competition basis exists
- the case contains only placeholder language with no pattern-comparison basis
- the pattern layer would be entirely invented from absent evidence

Return `DEFERRED_PATTERN_COMPETITION` when:
- the family-competition result remains too unresolved to narrow the parent set honestly
- the candidate set is real but evidence is too thin to reject or promote patterns safely

---

# 5. CANDIDATE PATTERN GENERATION

## 5.1 Candidate generation sources
Pattern candidates become live from the combination of:
- surviving family set from `AURORA_FAMILY_COMPETITION_OBJECT`
- pattern atlas family-child map
- existing pattern cards where available
- market-state interpretation
- group/bucket/regime posture
- explicit worked-example or packet lineage when the case belongs to an existing lane

## 5.2 Parent-family law
At minimum, live pattern candidates should come from:
- the primary surviving family when one exists
- any materially alive competing family when family competition is contested and the pattern meaning would differ materially

## 5.3 Weak-but-plausible law
A weaker pattern candidate remains visible when:
- its parent family is still alive
- its structural role is still partially present
- rejection would depend on surfaces that are still missing

Weak visibility does not make a pattern primary.
It prevents premature collapse.

---

# 6. COMPETITION DIMENSIONS

The pattern competition engine must use structured, non-numeric comparison dimensions.

## 6.1 Parent-family compatibility
Does the pattern fit the surviving family set honestly, or would it require a different family winner?

## 6.2 Structural role fit
Does the visible structure match the pattern’s intended local role as defined by the atlas or card?

## 6.3 Anti-confusion pressure
Is the pattern materially colliding with the common misreads or anti-confusions already attached to it?

## 6.4 State alignment
Does the current market-state interpretation support this pattern more directly than its competitors?

## 6.5 Regime compatibility
Does the group/bucket/regime posture reinforce or weaken the pattern without becoming symbol doctrine?

## 6.6 Contradiction load
How many active case facts cut directly against the pattern thesis?

## 6.7 Dependence on missing surfaces
Would the pattern require still-missing surfaces before it could be promoted or rejected honestly?

## 6.8 Evidence not yet present
What evidence would need to appear before the pattern could strengthen materially?

## 6.9 Deployability compatibility modifier
Deployability may shape practical posture, but it is not a pattern gate by itself.
A structurally valid pattern may survive even when deployability is weak.

These dimensions must be expressed as explicit notes or field-level judgments, not as a hidden composite.

---

# 7. ELIMINATION LAW

## 7.1 Rejected pattern
A pattern becomes `REJECTED` when current evidence shows one or more of the following:
- parent-family compatibility is materially broken
- the required local structure is contradicted by the case
- a stronger competing pattern explains the same case while the rejected pattern loses its structural basis
- the pattern would require invented evidence to remain alive

Each rejected pattern must record explicit rejection reasons.

## 7.2 Candidate pattern
A pattern remains `CANDIDATE` when:
- it still fits part of the visible local structure
- no decisive anti-confusion conflict has invalidated it
- stronger proof is still required before confirmation

## 7.3 Confirmed pattern
A pattern becomes `CONFIRMED` only when:
- it currently explains the local structure better than all live competitors
- the main competitors have explicit rejection or inferiority reasons
- remaining missingness does not invalidate the pattern reading itself

## 7.4 Unresolved pattern posture
A pattern remains `UNRESOLVED` when:
- both supportive and conflicting evidence coexist
- missing surfaces are material
- the case may move toward confirmation or rejection later

---

# 8. AMBIGUITY HANDLING

The pattern competition engine must emit one canonical competition status:
- `CLEAR_PATTERN_PRIMARY`
- `CONTESTED_PATTERN_PRIMARY`
- `MULTIPLE_LIVE_PATTERNS`
- `DEFERRED_PATTERN_COMPETITION`
- `NO_VALID_PATTERN`
- `INVALID_PATTERN_COMPETITION_INPUT`

## 8.1 `CLEAR_PATTERN_PRIMARY`
One pattern is primary and competing alternatives have been reduced to secondary or rejected status without material ambiguity.

## 8.2 `CONTESTED_PATTERN_PRIMARY`
One pattern currently leads, but at least one competitor remains materially alive.

## 8.3 `MULTIPLE_LIVE_PATTERNS`
Multiple patterns remain genuinely live and no honest primary can be named.

## 8.4 `DEFERRED_PATTERN_COMPETITION`
Family routing is plausible, but the case is too thin or too contested for valid pattern promotion.

## 8.5 `NO_VALID_PATTERN`
The case fails to sustain any valid pattern thesis from the available set.

## 8.6 `INVALID_PATTERN_COMPETITION_INPUT`
The engine could not run honestly because its input basis was invalid.

---

# 9. CONFIDENCE POSTURE

The pattern competition engine may record only bounded posture language:
- `KNOWN`
- `PARTIAL`
- `UNKNOWN`

This posture describes how complete the pattern judgment is.
It is not a score.

---

# 10. RELATIONSHIP TO LATER LAYERS

This engine does not do any of the following:
- no opportunity declaration
- no card eligibility decision
- no geometry generation
- no entry / invalidation / target logic

Its role is narrower:
- shape downstream opportunity interpretation
- preserve structured pattern ambiguity
- give later opportunity classification an explicit upstream pattern result

---

# 11. CURRENT JUDGMENT

Aurora now has a dedicated pattern competition protocol that formalizes a previously scattered layer without duplicating atlas doctrine or swallowing downstream opportunity, card, or geometry logic.
