# AURORA SETUP PATTERN ATLAS

## PURPOSE

This file is the first organized setup-pattern atlas for Aurora Blueprint.

It exists to connect:
- market-state doctrine
- execution-context doctrine
- strategy-family definitions
- strategy-family cards
- future wrapper / EA routing

The Pattern Atlas is the layer below strategy families.
It does not decide the family by itself.
It supplies the structured pattern children that families may call once the family choice becomes credible.

This file is therefore:
- a pattern-organization file
- a family-child file
- a future enrichment file

This file is **not**:
- a giant indiscriminate candlestick dump
- a blind import of every textbook pattern ever named
- a final implementation ruleset
- a substitute for state/surface classification

---

# 1. ROOT LAW OF THE PATTERN ATLAS

Aurora must not choose patterns first.

The correct order is:
1. identify state
2. identify surface trust
3. identify plausible family
4. only then call pattern children from the atlas

Pattern-first thinking is invalid because the same visible shape can mean different things under different state/surface conditions.

---

# 2. WHAT A PATTERN IS IN AURORA

A pattern is not an isolated visual object.

In Aurora, a pattern is:
- a repeatable local structure
- whose meaning depends on the current family habitat
- whose trust depends on the current execution-context surface
- whose final value may improve when additional data surfaces exist

So the atlas is not a flat catalog.
It is a family-attached pattern system.

---

# 3. PATTERN CLASSIFICATION MODEL

Patterns in Aurora should be organized by **family child role** rather than by generic textbook shape alone.

Main pattern classes:
- continuation patterns
- pullback continuation patterns
- release / breakout patterns
- failed-state / reclaim patterns
- rotation / rejection patterns
- conditional session/timebox patterns
- preserved non-chart-native microstructure or relational patterns later

---

# 4. CURRENT FAMILY-TO-PATTERN MAP

## Family C-01 — Trend Continuation

### Pattern class
Continuation patterns

### First child pattern group
- accepted break-and-hold
- orderly continuation structure
- shallow continuation pullback after acceptance
- post-balance directional hold

### Pattern role
These patterns help confirm that continuation remains the dominant interpretation rather than:
- failure
- exhaustion
- return to balance

---

## Family C-02 — Trend Pullback / Pullback Continuation

### Pattern class
Pullback continuation patterns

### First child pattern group
- orderly pullback hold
- directional retracement that remains subordinate to prior move
- trend resumption after accepted retracement
- pullback rejection in intact directional structure

### Pattern role
These patterns help confirm that retracement remains temporary rather than becoming:
- failed state
- balance re-formation
- unstable overlap

---

## Family C-03 — Breakout / Compression Release

### Pattern class
Release / breakout patterns

### First child pattern group
- compression release
- balance break and hold
- post-break acceptance structure
- range escape with persistence

### Pattern role
These patterns help confirm that release is becoming genuine expansion rather than:
- cheap excursion
- wick-only break
- false release / trap

---

## Family C-04 — Failed Break / Trap Reversal

### Pattern class
Failed-state / reclaim patterns

### First child pattern group
- failed break and reclaim
- false release rejection
- return through initiating structure
- trap reversal structure

### Pattern role
These patterns help confirm that failure and reversal dominate over:
- unresolved breakout continuation
- ordinary pullback
- unstable back-and-forth noise

---

## Family C-05 — Balance Rotation / Range Mean-Reversion

### Pattern class
Rotation / rejection patterns

### First child pattern group
- range boundary rejection
- return-to-value structure
- opposite-boundary rotation setup
- stable internal rotational rejection

### Pattern role
These patterns help confirm that rotation remains stronger than:
- breakout acceptance
- directional migration
- unstable range degradation

---

# 5. PATTERN CARD MODEL

Future pattern work should usually create **pattern cards**, not giant raw lists.

Each future pattern card should eventually contain:
- pattern_id
- pattern_name
- parent_family
- canonical idea
- native habitat
- anti-habitat
- structural meaning
- common misreads
- required data surfaces
- supporting data surfaces
- testing notes
- enrichment notes

This keeps patterns machine-usable later.

---

# 6. CURRENT FIRST PATTERN GROUPS

Aurora now has enough doctrine to recognize these first pattern groups as legitimate atlas children:

## G1 — Accepted break-and-hold patterns
Primary parent:
- Trend Continuation
- Breakout / Compression Release

## G2 — Orderly continuation pullback patterns
Primary parent:
- Trend Pullback / Pullback Continuation
- Trend Continuation

## G3 — Compression release patterns
Primary parent:
- Breakout / Compression Release

## G4 — Failed break / reclaim patterns
Primary parent:
- Failed Break / Trap Reversal

## G5 — Range rejection / return-to-value patterns
Primary parent:
- Balance Rotation / Range Mean-Reversion

These are not yet fully expanded pattern cards.
They are the first approved atlas child groups.

---

# 7. PATTERN COMPETITION RULE

Every pattern group must remain attached to its competing family interpretations.

Examples:
- an apparent breakout pattern may actually belong to Failed Break / Trap Reversal
- an apparent pullback pattern may actually belong to Balance Rotation if direction has degraded
- an apparent boundary rejection may actually be early breakout failure or early release instability

This rule protects Aurora from treating pattern shapes as self-explanatory.

---

# 8. DATA-SURFACE AWARE PATTERN ENRICHMENT

The first atlas is chart-first, but not chart-only forever.

Future data-surface enrichment should be allowed explicitly:

## S1 — Chart / Structure Surface
Provides the first visible pattern form.

## S2 — ASC Scanner / Internal Feature Surface
Can later improve:
- pattern filtering
- symbol pre-selection
- cross-symbol ranking before pattern activation

## S3 — Live Execution / Microstructure Surface
Can later improve:
- breakout trust
- failure trust
- reversal quality
- execution viability of pattern expression

## S4 — Macro / Regime Surface
Can later improve:
- suppression or weighting of pattern groups
- context-sensitive failure or continuation expectations

## S5 — Cross-Asset / Relative Surface
Can later improve:
- relative confirmation or contradiction
- spread/relational pattern enrichment

## S6 — Calendar / Session / Timebox Surface
Can later improve:
- ORB-like children
- session-conditioned breakout/reversal patterns
- time-window-conditioned continuation or failure patterns

---

# 9. WHAT IS DELIBERATELY NOT DONE YET

This first atlas does not yet create:
- one card for every pattern child
- session-specialized pattern atlases
- order-book pattern modules
- options/derivatives pattern layers
- final entry templates
- final stop/target formula libraries

Those remain later work.

---

# 10. EVOLUTION LAW

As more books are processed, the Pattern Atlas should usually evolve by:
- adding new child pattern groups to existing families
- refining pattern meaning and anti-confusions
- adding new data-surface dependencies
- splitting overly broad pattern groups into smaller cards
- promoting conditional pattern groups when doctrine and evidence improve

Do not explode the atlas into hundreds of unplaced pattern names.
All new patterns must be attached to:
- a family
- a habitat
- a meaning
- anti-confusions

---

# 11. NEXT CHILD FILES THIS ATLAS SHOULD FEED

The next likely atlas children are:
- family-linked pattern cards
- a pattern-card schema
- session-conditioned pattern appendices later
- family testing notes linked to pattern groups

Recommended immediate children:
- `Aurora Blueprint/patterns/PATTERN_CARD_SCHEMA.md`
- `Aurora Blueprint/patterns/G1_Accepted_Break_And_Hold.card.md`
- `Aurora Blueprint/patterns/G2_Orderly_Continuation_Pullback.card.md`
- `Aurora Blueprint/patterns/G3_Compression_Release.card.md`
- `Aurora Blueprint/patterns/G4_Failed_Break_Reclaim.card.md`
- `Aurora Blueprint/patterns/G5_Range_Rejection_Return_To_Value.card.md`

---

# 12. CURRENT JUDGMENT

Aurora now has a real Pattern Atlas layer.

It is not final and not exhaustive, but it successfully does three important things:
- prevents pattern-first drift
- connects patterns to families and doctrine
- creates a clean expansion path for future book-driven enrichment

This means the strategy side can now evolve from:
- doctrine -> family -> pattern
without losing structure or turning into a messy textbook pattern dump.
