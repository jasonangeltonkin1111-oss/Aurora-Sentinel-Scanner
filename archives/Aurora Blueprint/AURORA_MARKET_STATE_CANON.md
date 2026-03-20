# AURORA MARKET STATE CANON

## PURPOSE

This file is the canonical market-language layer for Aurora.

Its job is to define the core words, states, transitions, and structural distinctions Aurora uses to describe what the market is doing before any strategy family is evaluated.

This file is foundational because strategy families, setup patterns, volatility logic, and review logic all depend on stable market-state language.

Without a clean canon here, the rest of Aurora will drift.

---

# 1. STATUS AND HONESTY RULE

## Current status
- Stage: FIRST-PASS CANON SCAFFOLD
- Deep book extraction status: NOT YET COMPLETE
- Source basis right now:
  - `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
  - `AURORA_BOOK_MASTER_INDEX.md`
  - high-level archive indexing from `archives/Aurora/`

## Honesty rule
This file currently defines:
- the canonical structure Aurora should use for market-state extraction
- the first-pass vocabulary Aurora is expected to stabilize
- provisional state objects and concept objects for later deep extraction

This file does NOT yet claim:
- that Dalton, auction theory texts, or microstructure books were fully extracted line by line
- that every definition here is already text-grounded to book passages
- that all conflicts between sources are resolved

This file is the first stable target for future Wave 1 extraction.
It is not the final doctrinal finish.

---

# 2. WHAT THIS MODULE MUST DO

The Market State Canon must let Aurora describe:

1. what structural condition the market is in
2. whether price is rotating or discovering
3. whether directional continuation is clean or degraded
4. whether context is stable, unstable, or hostile
5. how a state transitions into another state
6. which strategy families are naturally compatible or incompatible with each state

This module must stay above strategy execution.
It describes the market.
It does not tell the trader where to enter.

---

# 3. PRIMARY WAVE 1 SOURCES FOR THIS MODULE

This module should be built primarily from these books:

- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`
- `Auction Theory2.pdf`
- `market-microstructure-theory_compress.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`

Secondary support later:
- `Adaptive Markets.pdf`
- `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
- `pcmbrokers_(Wiley finance series) Adam Grimes.pdf`
- `Dynamic_Hedging-Taleb.pdf`

---

# 4. MARKET-STATE OBJECT TYPES USED IN THIS FILE

This module uses two main object types.

## 4.1 Concept Object
Use when the item is a reusable structural idea.

Required fields:
- canonical name
- aliases
- plain-language definition
- structural meaning
- misuse risk
- likely source cluster
- future extraction priority

## 4.2 State Object
Use when the item describes a recurring market condition.

Required fields:
- state name
- plain-language description
- observable characteristics
- typical transitions in
- typical transitions out
- compatible strategy families
- hostile strategy families
- state risks
- extraction status

---

# 5. CORE CONCEPT CANON — FIRST PASS

## 5.1 Balance
Type:
- Concept Object

Aliases likely encountered:
- balance
- equilibrium
- rotation zone
- value area behavior
- two-sided trade

Plain-language definition:
- a condition where price is being accepted within a contained area and directional discovery is not yet dominant

Structural meaning:
- the market is spending energy rotating within a zone rather than cleanly migrating away from it

Misuse risk:
- labeling every sideways patch as true balance when the underlying auction is actually weak continuation or pre-break compression

Likely source cluster:
- Dalton / Mind Over Markets / auction theory

Future extraction priority:
- HIGH

---

## 5.2 Imbalance
Type:
- Concept Object

Aliases likely encountered:
- imbalance
- directional discovery
- initiative activity
- directional acceptance

Plain-language definition:
- a condition where one side is strong enough to push price away from prior balance and keep it accepted beyond the old area

Structural meaning:
- the market is no longer simply rotating; it is attempting to migrate and discover value elsewhere

Misuse risk:
- confusing a brief price spike or thin breakout with real imbalance

Likely source cluster:
- auction theory / profile / microstructure

Future extraction priority:
- HIGH

---

## 5.3 Acceptance
Type:
- Concept Object

Aliases likely encountered:
- acceptance
- holding beyond reference
- sustaining outside prior value
- continued trade at new area

Plain-language definition:
- price remains active beyond a prior reference long enough or cleanly enough to suggest the move is being accepted rather than instantly rejected

Structural meaning:
- continuation has earned credibility
- directional movement is not just a transient excursion

Misuse risk:
- treating any close outside a level as acceptance without considering follow-through, hold quality, or contextual stability

Likely source cluster:
- auction theory / Dalton / microstructure

Future extraction priority:
- VERY HIGH

---

## 5.4 Rejection
Type:
- Concept Object

Aliases likely encountered:
- rejection
- failed acceptance
- reclaim
- snap back
- excursion failure

Plain-language definition:
- price attempts to trade beyond an area but cannot remain accepted there and returns back through the attempted move

Structural meaning:
- the market has denied the attempted migration

Misuse risk:
- calling every retracement a rejection when it may just be a pullback inside continuing discovery

Likely source cluster:
- auction theory / Dalton / profile

Future extraction priority:
- VERY HIGH

---

## 5.5 Rotation
Type:
- Concept Object

Aliases likely encountered:
- rotation
- two-sided movement
- back-and-forth auction
- responsive trade

Plain-language definition:
- repeated movement through an accepted area without clean directional escape

Structural meaning:
- the market is facilitating two-way trade rather than trending cleanly

Misuse risk:
- treating noisy trend pullbacks as rotation just because candles overlap briefly

Likely source cluster:
- Dalton / Mind Over Markets / auction texts

Future extraction priority:
- HIGH

---

## 5.6 Value Migration
Type:
- Concept Object

Aliases likely encountered:
- migration to a new value area
- value shift
- acceptance at new area

Plain-language definition:
- the center of accepted trade shifts away from the old area and stabilizes elsewhere

Structural meaning:
- the market is repricing what it considers fair enough to trade around

Misuse risk:
- marking temporary excursion as migration before new acceptance is actually established

Likely source cluster:
- Dalton / profile / auction texts

Future extraction priority:
- HIGH

---

## 5.7 Failed Auction / Failed Break
Type:
- Concept Object

Aliases likely encountered:
- failed auction
- failed breakout
- trap
- false break
- reclaim event

Plain-language definition:
- an attempted move away from a reference area that cannot sustain and reverses back through the launch point or prior structure

Structural meaning:
- directional commitment was attempted but denied

Misuse risk:
- overusing the label in normal pullback conditions

Likely source cluster:
- auction theory / profile / price-action books

Future extraction priority:
- VERY HIGH

---

## 5.8 Compression
Type:
- Concept Object

Aliases likely encountered:
- compression
- contraction
- narrowing trade
- reduced range activity
- coiling

Plain-language definition:
- a condition where movement tightens, expansion fades, and the market stores potential energy without yet resolving directionally

Structural meaning:
- the market is narrowing and may later resolve, but the direction and quality of that resolution are not yet earned

Misuse risk:
- front-running breakout logic before structural commitment is visible

Likely source cluster:
- microstructure / volatility / price-behavior support

Future extraction priority:
- HIGH

---

## 5.9 Expansion
Type:
- Concept Object

Aliases likely encountered:
- expansion
- range expansion
- directional release
- impulse movement

Plain-language definition:
- movement broadens, range stretches, and directional displacement becomes visible relative to prior behavior

Structural meaning:
- the market is no longer quiet; energy is being spent in a visible direction or on a visible repricing move

Misuse risk:
- calling any large bar expansion without checking if the move is sustained or accepted

Likely source cluster:
- auction theory / volatility / price behavior

Future extraction priority:
- HIGH

---

## 5.10 Friction State
Type:
- Concept Object

Aliases likely encountered:
- friction
- poor tradability
- degraded execution surface
- hostile market quality

Plain-language definition:
- a market condition where spreads, execution quality, or microstructural behavior make apparent opportunity less tradable than it looks on chart alone

Structural meaning:
- the market may appear structurally interesting while still being poor for deployment quality

Misuse risk:
- ignoring friction because the chart pattern looks good

Likely source cluster:
- market microstructure texts

Future extraction priority:
- HIGH

---

# 6. CORE STATE CANON — FIRST PASS

## 6.1 Balance State
Type:
- State Object

Plain-language description:
- the market is accepted within a contained zone and is rotating rather than discovering strongly in one direction

Observable characteristics:
- repeated return through a central area
- poor follow-through outside boundaries
- overlapping movement and two-sided trade
- directional breaks struggle to sustain

Typical transitions in:
- failed expansion
- post-trend exhaustion
- acceptance after wide movement stabilizes

Typical transitions out:
- clean directional acceptance beyond the range
- repeated edge testing followed by migration
- failed breakout that returns deeper into the structure first

Compatible strategy families:
- range rotation
- selective failed-break reversal

Hostile strategy families:
- blind trend continuation
- late breakout chasing inside the center of balance

State risks:
- fake directional conviction
- overtrading the middle
- false breakout labeling noise as discovery

Extraction status:
- PROVISIONAL / NOT DEEPLY EXTRACTED YET

---

## 6.2 Imbalance / Directional Discovery State
Type:
- State Object

Plain-language description:
- the market is moving away from prior balance and establishing trade in a new area with directional authority

Observable characteristics:
- visible displacement from prior zone
- better follow-through than rotation states
- acceptance beyond old structure
- reduced tendency to immediately fully revert

Typical transitions in:
- breakout from balance with acceptance
- post-compression expansion that sustains
- successful reclaim into directional continuation

Typical transitions out:
- exhaustion into degraded continuation
- failed acceptance and return to balance
- transition into pullback continuation state

Compatible strategy families:
- breakout continuation
- pullback continuation
- session momentum when aligned

Hostile strategy families:
- blind mean reversion against fresh discovery

State risks:
- mistaking one-off impulse for real discovery
- chasing late expansion after the clean move is already spent

Extraction status:
- PROVISIONAL / NOT DEEPLY EXTRACTED YET

---

## 6.3 Pullback Continuation State
Type:
- State Object

Plain-language description:
- the market has already shown directional discovery and is retracing or pausing without yet structurally failing that directional condition

Observable characteristics:
- prior expansion exists
- retracement remains contained relative to the preceding move
- context still favors continuation more than reversal
- pullback does not fully collapse the prior discovery zone

Typical transitions in:
- expansion slows after directional move
- pause or retrace after accepted breakout

Typical transitions out:
- renewed directional expansion
- deeper failure back into balance
- failed break / trap if reclaim logic appears

Compatible strategy families:
- pullback continuation
- selective trend continuation

Hostile strategy families:
- automatic reversal calls without structural failure

State risks:
- confusing healthy pullback with trend death
- entering too early while the retracement is still unresolved

Extraction status:
- PROVISIONAL / REQUIRES MORE PRICE-BEHAVIOR SOURCES

---

## 6.4 Compression State
Type:
- State Object

Plain-language description:
- the market is contracting, directional edge is not yet earned, and potential energy may be building without confirmed release

Observable characteristics:
- shrinking range behavior
- reduced directional commitment
- repeated containment of movement
- breakout attempts often weak or unconfirmed

Typical transitions in:
- post-balance narrowing
- post-trend stall
- pre-event contraction

Typical transitions out:
- expansion with acceptance
- failed break and reclaim
- return to broader rotation if contraction resolves poorly

Compatible strategy families:
- breakout / release only after confirmation
- selective trap logic after failed release

Hostile strategy families:
- anticipatory breakout entries without commitment
- blind continuation assumptions

State risks:
- forcing direction too early
- misreading quiet conditions as clean opportunity

Extraction status:
- PROVISIONAL / NOT DEEPLY EXTRACTED YET

---

## 6.5 Failed Break / Trap State
Type:
- State Object

Plain-language description:
- the market attempted directional escape but lost it, creating a reclaim condition that can reverse expectation and punish late continuation logic

Observable characteristics:
- visible attempt through prior structure
- inability to sustain beyond the break
- reclaim back into prior area
- continuation traders likely trapped

Typical transitions in:
- rejected breakout
- failed directional migration
- thin expansion that cannot hold

Typical transitions out:
- rotation back through balance
- directional move opposite the failed break
- degraded chop if both sides keep failing

Compatible strategy families:
- trap reversal
- failed-break return-to-range

Hostile strategy families:
- breakout continuation after failure is already confirmed

State risks:
- entering before the failure is actually confirmed
- overcalling failed breaks in ordinary pullbacks

Extraction status:
- PROVISIONAL / HIGH PRIORITY FOR WAVE 1 + WAVE 2

---

## 6.6 Transitional / Unstable State
Type:
- State Object

Plain-language description:
- the market is shifting between clearer conditions, but the next stable state is not yet well established

Observable characteristics:
- mixed evidence
- state labels compete with each other
- directional claims and rotational claims both remain weak
- context feels unstable rather than cleanly resolved

Typical transitions in:
- degradation of directional discovery
- failed balance breakout without full return to stable rotation yet
- session shift or event distortion

Typical transitions out:
- stabilization into balance
- acceptance into directional discovery
- deeper compression before release

Compatible strategy families:
- highly selective only
- mostly wait-state behavior

Hostile strategy families:
- aggressive continuation
- aggressive mean reversion
- pattern trading that depends on stable habitat

State risks:
- forcing labels too early
- overfitting a preferred narrative to unstable structure

Extraction status:
- PROVISIONAL / REQUIRES WAVE 1 + ADAPTATION SUPPORT

---

# 7. RELATIONSHIP MAP BETWEEN STATES

## High-level transition map

### Balance can transition to:
- Imbalance / Directional Discovery
- Compression
- Failed Break / Trap

### Compression can transition to:
- Imbalance / Directional Discovery
- Failed Break / Trap
- broader Balance

### Imbalance / Directional Discovery can transition to:
- Pullback Continuation
- Failed Break / Trap
- Balance
- Transitional / Unstable

### Pullback Continuation can transition to:
- renewed Imbalance / Directional Discovery
- Failed Break / Trap
- Balance

### Failed Break / Trap can transition to:
- Balance
- directional discovery in the opposite direction
- Transitional / Unstable

### Transitional / Unstable can transition to:
- any stable state once structure resolves cleanly

---

# 8. INITIAL AURORA MARKET-LANGUAGE RULES

## Rule 1 — State before strategy
Aurora must describe the market state before evaluating strategy families.

## Rule 2 — Acceptance matters more than excursion
A move beyond a reference is not enough by itself.
Sustained behavior matters more than a simple print outside structure.

## Rule 3 — Rotation and discovery must not be confused
Two-sided accepted trade is different from real directional migration.

## Rule 4 — Failed directional attempts are first-class information
Failed breaks are not noise.
They are a distinct state transition source.

## Rule 5 — Friction can invalidate apparent opportunity
A structurally interesting move can still be low quality if the execution surface is degraded.

## Rule 6 — Market-state labels must stay structural
Do not define states using entry tactics or indicator recipes.

---

# 9. WHAT STILL MUST BE EXTRACTED INTO THIS FILE LATER

Wave 1 deep extraction should still add:

- direct source-grounded definitions from Dalton and auction texts
- clearer acceptance vs rejection tests
- balance vs weak trend drift distinction
- initiative vs responsive behavior distinctions
- value migration logic
- state degradation cues
- friction / market-quality language pulled from microstructure texts
- disagreement notes where books frame the same phenomenon differently

This file should later gain:
- source citations inside the file once books are deeply processed
- conflict notes between profile language and broader price-action language
- sharper distinction between state objects and family objects
- links into `AURORA_EXECUTION_CONTEXT_SURFACE.md`
- links into `AURORA_STRATEGY_FAMILY_REGISTRY.md`

---

# 10. NEXT EXTRACTION TARGETS AFTER THIS FILE

After this first-pass canon exists, the best next companion work is:

1. `AURORA_EXECUTION_CONTEXT_SURFACE.md`
   - friction
   - tradability
   - hostile execution environments
   - microstructure realism

2. deepen this file with Wave 1 source extraction
   - Dalton
   - Mind Over Markets
   - Auction Theory texts
   - microstructure texts

3. then begin:
- `AURORA_STRATEGY_FAMILY_REGISTRY.md`
- `AURORA_SETUP_PATTERN_ATLAS.md`

---

# 11. CURRENT JUDGMENT

This file establishes Aurora’s first stable market-language target.

It is intentionally conservative:
- broad enough to support future strategy mapping
- structured enough to prevent language drift
- honest enough not to fake deep extraction

Aurora now has:
- a module map
- a completion tracker
- a source-level master index
- a first-pass market-state canon target

The next real quality leap will come from turning Wave 1 books into source-grounded definitions inside this file.
