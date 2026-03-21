# AURORA WRAPPER EXECUTION PACK

## What this pack compiles

This pack compiles the active execution-side chain from the workflow packet, wrapper object model, status/enum normalization, opportunity, deployability, geometry, generated-card, packet, review, and EA-boundary files.
It is the wrapper-facing execution canon, not the source-truth owner of those protocols.

## What this pack excludes

- office/run/SHA continuity surfaces
- family and pattern doctrine details that belong in their dedicated vaults
- full example payloads beyond the minimum anchors summarized here

## Root execution law

Aurora must not jump from ASC context to a trade plan.
It must carry truth through a fixed staged chain and preserve uncertainty, missingness, invalidity, downgrade logic, and no-card-valid outcomes at every step.

## Required stage chain

1. **ASC context intake and normalization** — consume ASC-owned truth and preserve field-state classes.
2. **Group-context construction** — build group, bucket, regime, routing, and boundary posture.
3. **Context interpretation** — derive market-state and execution-surface interpretation without inventing missing truth.
4. **Family competition** — compare plausible families; allow contested, deferred, or no-valid outcomes.
5. **Pattern competition** — compare patterns only inside surviving family posture.
6. **Opportunity inventory and ranking** — preserve multiple opportunities and their downgrade reasons without collapsing to trade/no-trade.
7. **Deployability judgment** — assess structure versus execution burden, hostility, continuity, and horizon fit.
8. **Intraday geometry construction** — only build explicit geometry when deployability and context permit it.
9. **Generated strategy card** — emit a bounded symbol/time/context-specific card only when the card gate is satisfied.
10. **EA-safe boundary** — expose only deterministic/routing-safe fields suitable for later bounded automation.

## Canonical object chain

1. `ASC_CONTEXT_OBJECT`
2. `AURORA_GROUP_CONTEXT_OBJECT`
3. `AURORA_MARKET_STATE_OBJECT`
4. `AURORA_EXECUTION_SURFACE_OBJECT`
5. `AURORA_FAMILY_COMPETITION_OBJECT`
6. `AURORA_PATTERN_COMPETITION_OBJECT`
7. `AURORA_OPPORTUNITY_OBJECT`
8. `AURORA_DEPLOYABILITY_OBJECT`
9. `AURORA_INTRADAY_GEOMETRY_OBJECT`
10. `AURORA_GENERATED_STRATEGY_CARD`
11. `AURORA_EA_SAFE_OUTPUT_OBJECT`

## Global transformation rules

- context before interpretation
- interpretation before family competition
- family competition before pattern competition
- pattern competition before opportunity preservation and ranking
- opportunity preservation before deployability narrowing
- deployability before geometry
- geometry before generated card
- generated card before EA-safe export
- unresolved ambiguity must survive rather than being hidden in later objects

## Stage-by-stage stop and refusal law

### Stop before family competition when
- identity truth is too broken for routing
- minimum ASC context contract surfaces are absent
- no structural basis exists for any honest family candidate

### Stop before pattern competition when
- family competition returned `INVALID_COMPETITION_INPUT`
- family competition returned `NO_VALID_FAMILY`
- family posture is real but still requires `DEFERRED_CLASSIFICATION`

### Stop before card generation when
- opportunity posture is `STRUCTURE_INVALID` or `EXECUTION_INVALID`
- deployability is `NOT_DEPLOYABLE` or still effectively unknown for card use
- geometry is `GEOMETRY_INVALID` or `GEOMETRY_UNRESOLVED`
- timebox/session truth makes intraday packaging dishonest
- missing surfaces would force invented geometry or fake certainty

## Status and enum preservation

### ASC-owned field-state truth
Preserve statuses such as `PRESENT`, `PENDING`, `RESERVED`, `UNAVAILABLE`, `UNSUPPORTED`, `STALE`, `DEGRADED`, and `INVALID` as surface-truth classes.
These say whether a surface exists and how trustworthy it is; they are not deployability or opportunity verdicts.

### Family/pattern competition statuses
Preserve explicit competition outcomes, including:
- `CLEAR_PRIMARY`
- `CONTESTED_PRIMARY`
- `MULTIPLE_LIVE_CANDIDATES`
- `DEFERRED_CLASSIFICATION` / `DEFERRED_PATTERN_COMPETITION`
- `NO_VALID_FAMILY` / `NO_VALID_PATTERN`
- `INVALID_INPUT`

### Opportunity statuses
Preserve opportunity inventory classes rather than binary trade/no-trade collapse:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

### Other required alignment classes
- deployability class
- horizon class
- geometry validity
- card eligibility gate
- review outcome class
- machine-safe versus human-only output class

## Separation law: opportunity vs deployability vs geometry vs card

- **Opportunity** answers whether the case should stay preserved downstream now.
- **Deployability** answers whether the case is practically usable inside project intraday limits after burden is absorbed.
- **Geometry** answers whether entry/invalidation/target/timebox/execution fields are explicit and usable.
- **Card gate** answers whether Aurora should emit a generated strategy card now.

A case may therefore remain structurally interesting while being:
- `OBSERVE_ONLY` at opportunity level,
- `WATCH_ONLY` or `UNKNOWN_DEPLOYABILITY` at deployability level,
- `GEOMETRY_INVALID` or `GEOMETRY_UNRESOLVED` at geometry level,
- and blocked from card emission.

## Opportunity and ranking law

Opportunity inventory exists because Aurora must preserve structurally interesting cases even when they are not currently deployable.
Rank using separable judgments such as structural coherence, competition outcome, deployability quality, hostility burden, surface completeness, and horizon compatibility.
Do not compress those judgments into one hidden master score.

Typical revisit triggers include:
- spread normalization
- session improvement
- pattern confirmation
- missing-surface arrival
- hostility decay
- path expansion large enough to change deployability

## Deployability law

Deployability is not field presence and not generic conviction.
It consumes:
- ASC market truth
- ASC execution/friction truth
- Aurora structure truth
- hostility burden
- horizon suitability
- execution continuity quality

Deployability may keep a case watch-only, degraded, unknown, or blocked even when family/pattern logic is structurally coherent.
Do not veto or bless a case by bucket alone, spread alone, or a single family-agnostic rule.

## Intraday geometry law

Geometry is not generic RR/SL/TP templating.
It must preserve:
- entry law and confirmation requirements
- invalidation law
- target logic
- timebox logic
- execution constraints
- reasons geometry can be invalid even when the underlying idea remains structurally interesting

Family-specific geometry examples the wrapper must remember at high level:
- reclaim ideas require reclaim confirmation rather than mere local wobble
- continuation ideas require continuation acceptance rather than generic breakout wording
- balance fade ideas require rejection evidence rather than directional chase logic
- breakout ideas require evidence the move is more than a print through a boundary

## Generated strategy-card law

A generated strategy card is not a family file and not a pattern file.
It is a time-bounded, symbol-specific, context-specific output object created from staged Aurora truth.

### Card gate
A card should only be generated when Aurora has, at minimum:
- a valid case identity and lineage block
- explicit market-state and execution-surface interpretation
- preserved family and pattern competition truth
- an opportunity status that is not structurally invalid
- a deployability judgment coherent enough to support bounded geometry
- geometry fields and timebox logic that are honest about missingness and invalidation

### Blocking classes the wrapper must preserve
- `CARD_BLOCKED_STRUCTURE`
- `CARD_BLOCKED_DEPLOYABILITY`
- `CARD_BLOCKED_GEOMETRY`
- `CARD_BLOCKED_MISSING_SURFACES`
- `CARD_BLOCKED_TIMEBOX`

### Card field groups the wrapper must preserve
- identity fields
- lineage fields
- context interpretation fields
- family/pattern fields
- deployability and opportunity fields
- geometry/timebox/invalidation fields
- machine-safe export fields
- human-only commentary/assumption fields

A symbol may retain an opportunity without earning a live generated strategy card.

## Packet and review law

Aurora's active packet family includes:
- workflow packet
- family-lane packet
- worked-example packet
- review packet

Review packets are diagnosis artifacts, not casual notes.
They must preserve target reference, original state summary, actual outcome summary, review classification, learned changes, and stability notes without mutating historical packet meaning retroactively.
Review is used to diagnose whether the issue was structural, deployability, geometry, timebox, or upstream-truth insufficiency.
Do not use review as a backdoor to rewrite doctrine from one illustrative outcome.

## EA-safe boundary

Only bounded deterministic or routing-safe fields may approach EA-safe export first.
Narrative interpretation, unresolved competition commentary, and doctrine reasoning remain human-only or wrapper-only.
Aurora must not expose fake automation certainty merely because a generated card exists.

## Replace/update note

Replace this pack when execution-side protocols, schema layers, generated-card law, or machine-boundary law change materially.
For full shapes or worked case anchors, refresh the packet/example vault instead of bloating this pack.
