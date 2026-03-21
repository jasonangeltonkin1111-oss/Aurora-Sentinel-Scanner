# AURORA WRAPPER EXECUTION PACK

## What this pack compiles

This pack compiles the active execution-side chain from the workflow packet, wrapper object model, status/enum normalization, deployability, intraday geometry, generated-card protocol, strategy-card field schema, packet schema, group-context schema, review schema, opportunity inventory/ranking protocol, abundance and stage-aware opportunity law, and EA-safe boundary spec.
It is the wrapper-facing execution canon, not the source-truth owner of those surfaces.

## What this pack excludes

- office/run/SHA continuity surfaces
- full family and pattern doctrine detail that belongs in their vaults
- raw packet payloads beyond the minimum shapes and anchors summarized here

## Root execution law

Aurora must not jump from ASC context to a trade plan.
It must carry truth through a staged chain, preserve missingness honestly, and allow downgraded, blocked, observe-only, unresolved, and no-card-valid endings without treating them as failure.

## Canonical stage chain

1. **ASC context intake and normalization**
2. **Group-context construction**
3. **Context interpretation**
4. **Family competition**
5. **Pattern competition**
6. **Opportunity inventory and ranking**
7. **Deployability judgment**
8. **Intraday geometry construction**
9. **Generated strategy card decision/output**
10. **EA-safe boundary packaging**
11. **Save/log/review continuity when applicable**

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
- pattern competition before opportunity preservation
- opportunity preservation before deployability narrowing
- stage-aware opportunity posture before timing assumptions
- deployability before geometry
- geometry before card emission
- card decision before EA-safe export
- unresolved ambiguity and missing-surface state must survive into later objects rather than being hidden

## Stage outputs and stop law

### Stage 0 — ASC intake and normalization
Preserve identity, runtime/publication freshness, market status, session/schedule truth, execution/friction truth, and optional high-value context.
Stop early when core identity truth is too broken to route anything honestly.

### Stage 1 — Group context
Build group, membership, regime, routing, and boundary posture so Aurora does not reason from one ticker shell or one local chart anecdote.
If group routing is too broken to support family logic, stop before interpretation inflation.

### Stage 2 — Context interpretation
Create market-state and execution-surface interpretation without inventing missing upstream truth.
Interpretation may remain partial, degraded, or boundary-heavy.
It does not entitle geometry or card output by itself.

### Stage 3 — Family competition
Compare plausible organizing engines using habitat fit, anti-habitat conflict, regime compatibility, contradiction load, missing-surface dependence, evidence not yet present, deployability compatibility modifier, and competitor pressure.
Allowed outputs include `CLEAR_PRIMARY`, `CONTESTED_PRIMARY`, `MULTIPLE_LIVE_CANDIDATES`, `DEFERRED_CLASSIFICATION`, `NO_VALID_FAMILY`, and `INVALID_COMPETITION_INPUT`.
Stop before pattern competition if family posture is invalid, empty, or honestly deferred.

### Stage 4 — Pattern competition
Route only inside surviving family posture.
Use structural role fit, anti-confusion pressure, state alignment, regime compatibility, contradiction load, missing-surface dependence, and evidence not yet present.
Allowed outputs include `CLEAR_PATTERN_PRIMARY`, `CONTESTED_PATTERN_PRIMARY`, `MULTIPLE_LIVE_PATTERNS`, `DEFERRED_PATTERN_COMPETITION`, `NO_VALID_PATTERN`, and `INVALID_PATTERN_COMPETITION_INPUT`.

### Stage 5 — Opportunity inventory and ranking
Preserve multiple opportunities instead of collapsing directly to trade/no-trade.
Canonical statuses:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

Opportunity law also preserves:
- soft suppression rather than silent deletion
- revisit triggers
- multi-opportunity ecology
- late-join, continuation, re-entry, salvage, and exhausted stage logic

### Stage 6 — Deployability judgment
Deployability is not field presence and not generic conviction.
It consumes:
- ASC market truth
- ASC execution/friction truth
- Aurora structure truth
- hostility burden
- horizon suitability
- execution continuity quality

Canonical deployability classes:
- `DEPLOYABLE`
- `DEPLOYABLE_DEGRADED`
- `WATCHLIST_ONLY`
- `NOT_DEPLOYABLE`
- `UNKNOWN_DEPLOYABILITY`

A case may stay structurally interesting while still being watch-only, degraded, unknown, or blocked.

### Stage 7 — Intraday geometry
Geometry is not generic RR/SL/TP templating.
It must preserve:
- entry law and required confirmation
- invalidation law
- target logic
- timebox logic
- execution constraints
- reasons geometry may be invalid even when the structural idea remains alive

Canonical horizon classes:
- `H1_FAST_INTRADAY`
- `H2_STANDARD_INTRADAY`
- `H3_WIDE_INTRADAY`

Canonical geometry validity classes:
- `GEOMETRY_VALID`
- `GEOMETRY_DEGRADED`
- `GEOMETRY_UNRESOLVED`
- `GEOMETRY_INVALID`

### Stage 8 — Generated strategy card decision
A strategy card is a bounded symbol/time/context output object, not a family file and not a pattern file.
Card gate requires, at minimum:
- valid identity and lineage fields
- explicit market-state and execution-surface interpretation
- preserved family/pattern competition truth
- opportunity posture not structurally invalid
- deployability coherent enough for bounded geometry
- honest geometry/timebox/invalidation fields

Canonical card gate classes:
- `CARD_ALLOWED`
- `CARD_BLOCKED_STRUCTURE`
- `CARD_BLOCKED_DEPLOYABILITY`
- `CARD_BLOCKED_GEOMETRY`
- `CARD_BLOCKED_MISSING_SURFACES`
- `CARD_BLOCKED_TIMEBOX`

### Stage 9 — EA-safe boundary
Only deterministic/routing-safe fields belong here first: identity, routing, opportunity status, deterministic geometry elements, hard safety blocks, and audit references.
Human-only commentary, discretionary judgment, and nuance remain outside machine-safe export.

### Stage 10 — Save/log/review continuity
Packets and reviews preserve auditable continuity.
They are not optional decorative artifacts when a meaningful example, lane, or review object is being created.

## Status and enum preservation

### ASC-owned surface availability classes
Preserve field-state truth such as:
- `PRESENT`
- `PENDING`
- `RESERVED`
- `UNAVAILABLE`
- `UNSUPPORTED`
- `STALE`
- `DEGRADED`
- `INVALID`

These classes say whether a surface exists and how trustworthy it is.
They are not opportunity or deployability verdicts.

### Opportunity stage classes
Preserve stage-aware posture rather than forcing early-entry bias.
At minimum remember:
- emergent / early
- developing
- confirmed
- continuation / mature continuation
- re-entry
- salvage
- late
- exhausted

Late-join and mid-progress opportunities remain legitimate when remaining structure, deployability, and geometry honesty still support them.

### Review outcome classes
Preserve review outcomes as diagnosis classes rather than hindsight mythology.
Do not use later outcome to rewrite earlier packet truth retroactively.

## Separation law: opportunity vs deployability vs geometry vs card

- **Opportunity** = should the case stay preserved downstream now?
- **Deployability** = is the case practically usable within project intraday constraints?
- **Geometry** = are explicit entry/invalidation/target/timebox/execution fields honestly available?
- **Card gate** = should Aurora emit the bounded card object now?

One case can therefore be structurally alive, deployability-degraded, geometry-unresolved, and card-blocked at the same time.

## Strategy-card field groups to preserve

- identity fields
- lineage fields
- context interpretation fields
- family/pattern fields
- deployability and opportunity fields
- geometry fields
- timebox and execution-constraint fields
- risk/invalidation meta fields
- machine-safe export fields
- human-only commentary fields

## Family-sensitive geometry reminders

The wrapper must remember that geometry inherits from family/pattern logic:
- reclaim ideas require reclaim confirmation, not random local wobble
- continuation ideas require continuation acceptance, not generic breakout phrasing
- balance fade ideas require rejection evidence, not directional chase logic
- breakout ideas require real acceptance/release, not a bare print outside structure
- pullback-continuation ideas require constructive restoration, not deterioration disguised as retracement

## Packet and review law inside execution

Packets are continuity structures, not filler.
They protect against:
- abstract doctrine with no reusable shape
- example imitation drift
- retroactive doctrine rewriting
- hidden stage collapse into “card or nothing” thinking
- symbol-shell reasoning with no group-context discipline

Reviews diagnose structure, stage, deployability, geometry, and upstream sufficiency without mutating the original packet retroactively.

## Wrapper-only refusal and downgrade guide

Stop or refuse progression when:
- identity truth is broken
- family routing would require invention
- deployability would require invented execution telemetry
- geometry would require invented timebox or execution surfaces
- card issuance would hide missingness under polished output

Fallbacks include:
- preserve as degraded
- preserve as observe-only or watch-only
- keep multiple candidates live
- block card emission
- request missing upstream surfaces

## Update note

Replace this pack when workflow/object/enum/opportunity/deployability/geometry/card/packet/review/EA-boundary truth changes materially.
