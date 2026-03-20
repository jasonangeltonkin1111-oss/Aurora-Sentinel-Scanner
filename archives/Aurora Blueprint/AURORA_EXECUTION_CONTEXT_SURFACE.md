# AURORA EXECUTION CONTEXT SURFACE

## PURPOSE

This file defines the execution-context layer for Aurora.

Its job is to describe the conditions that determine whether a market that looks structurally interesting is also practically tradable.

This module exists because chart structure alone is not enough.
A market can show a clean state transition and still be poor deployment terrain because of spread, session quality, feed instability, thin conditions, or degraded execution behavior.

This file belongs beside the Market State Canon.

- The Market State Canon answers: **what is the market doing?**
- The Execution Context Surface answers: **how deployable is that market condition?**

This module is still pre-execution.
It does not place trades.
It does not choose entries.
It defines the tradability surface that sits between market reading and strategy deployment.

---

# 1. STATUS AND HONESTY RULE

## Current status
- Stage: FIRST-PASS EXECUTION CONTEXT SCAFFOLD
- Deep source extraction status: NOT YET COMPLETE
- Current basis:
  - `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
  - `AURORA_BOOK_MASTER_INDEX.md`
  - `AURORA_MARKET_STATE_CANON.md`
  - high-level archive indexing from `archives/Aurora/`

## Honesty rule
This file currently defines:
- the categories Aurora should use to judge tradability and execution quality
- the provisional context objects needed for later Wave 1 extraction
- the deployment-quality distinctions that must exist before strategy family comparison becomes mature

This file does NOT yet claim:
- that market microstructure books have been deeply extracted line by line
- that every execution concept here is already source-grounded to passages
- that deployment thresholds are finalized for live operation

This is the first stable target file for later Wave 1 execution-context extraction.

---

# 2. WHAT THIS MODULE MUST DO

The Execution Context Surface must let Aurora describe:

1. whether a market is practically tradable or only theoretically interesting
2. how spreads and friction degrade opportunity quality
3. when session conditions support or weaken deployment quality
4. whether a move is likely to be cleanly tradable versus structurally noisy
5. when microstructural instability should down-rank otherwise appealing setups
6. when a state is compatible in theory but hostile in practice

This module does not replace the Market State Canon.
It refines it by asking:

> even if the state is valid, is the surface good enough to trust?

---

# 3. PRIMARY WAVE 1 SOURCES FOR THIS MODULE

This module should be built primarily from:

- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`
- `market-microstructure-theory_compress.pdf`
- `Flash Boys - A Wall Street Revolt 2015.epub`
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`

Secondary support later:
- `Dynamic_Hedging-Taleb.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
- `pcmbrokers_(Wiley finance series) Adam Grimes.pdf`

---

# 4. EXECUTION-CONTEXT OBJECT TYPES USED IN THIS FILE

## 4.1 Context Object
Use when the item describes a practical quality of the trading surface.

Required fields:
- canonical name
- aliases
- plain-language definition
- why it matters
- degradation risk
- likely source cluster
- future extraction priority

## 4.2 Surface State Object
Use when the item describes a recurring deployment-quality condition.

Required fields:
- state name
- plain-language description
- observable characteristics
- what it supports
- what it degrades
- main risks
- extraction status

---

# 5. CORE CONTEXT CANON — FIRST PASS

## 5.1 Tradability
Type:
- Context Object

Aliases likely encountered:
- tradability
- executable quality
- practical deployability
- usable market surface

Plain-language definition:
- the degree to which a market condition can actually be acted on cleanly rather than only observed on chart

Why it matters:
- a setup that cannot be entered or managed with acceptable quality is not the same as a usable opportunity

Degradation risk:
- treating visual opportunity as deployable opportunity without checking execution conditions

Likely source cluster:
- microstructure / market mechanics

Future extraction priority:
- VERY HIGH

---

## 5.2 Friction
Type:
- Context Object

Aliases likely encountered:
- friction
- execution drag
- trading cost burden
- surface resistance

Plain-language definition:
- the hidden or explicit market costs that make opportunity harder to realize cleanly

Why it matters:
- friction can turn a valid structural read into a poor practical trade

Degradation risk:
- ignoring cost and quality effects because the pattern itself looks clean

Likely source cluster:
- microstructure / broker reality / execution mechanics

Future extraction priority:
- VERY HIGH

---

## 5.3 Spread Burden
Type:
- Context Object

Aliases likely encountered:
- spread cost
- spread burden
- quoted width
- relative spread pressure

Plain-language definition:
- the extent to which spread size degrades entry quality, stop geometry, and reward-to-friction efficiency

Why it matters:
- narrow structures are especially vulnerable to spread distortion

Degradation risk:
- treating all patterns equally regardless of spread environment

Likely source cluster:
- microstructure / broker specs / execution reality

Future extraction priority:
- VERY HIGH

---

## 5.4 Session Quality
Type:
- Context Object

Aliases likely encountered:
- session quality
- active session condition
- participation quality
- market-hour strength

Plain-language definition:
- the degree to which current session conditions support orderly participation and clean movement rather than weak, thin, or distorted activity

Why it matters:
- the same structure can behave very differently across session conditions

Degradation risk:
- assuming a pattern is equally good at all times of day or across all participation states

Likely source cluster:
- profile / participant behavior / market mechanics

Future extraction priority:
- HIGH

---

## 5.5 Feed Integrity / Quote Freshness
Type:
- Context Object

Aliases likely encountered:
- feed quality
- quote freshness
- stale market surface
- unreliable quote condition

Plain-language definition:
- the degree to which current pricing is fresh and trustworthy enough for Aurora to treat the market state as current reality

Why it matters:
- stale or degraded price surfaces invalidate otherwise clean interpretations

Degradation risk:
- acting on structural logic while the information surface itself is not current

Likely source cluster:
- market mechanics / broker reality / platform data truth

Future extraction priority:
- HIGH

---

## 5.6 Participation Depth
Type:
- Context Object

Aliases likely encountered:
- depth quality
- participation depth
- thin market condition
- shallow participation

Plain-language definition:
- the degree to which the market has enough real participation to support cleaner movement instead of fragile jumps and erratic fills

Why it matters:
- thin conditions distort the meaning of moves and can amplify trap-like behavior

Degradation risk:
- mistaking fragile movement for durable directional discovery

Likely source cluster:
- microstructure / profile / auction texts

Future extraction priority:
- HIGH

---

## 5.7 Hostile Deployment Surface
Type:
- Context Object

Aliases likely encountered:
- hostile surface
- degraded deployment terrain
- poor practical environment
- execution-hostile context

Plain-language definition:
- a condition where execution quality is weak enough that a structurally valid market state should be treated with caution or reduced trust

Why it matters:
- protects Aurora from equating structural clarity with operational quality

Degradation risk:
- continuing to escalate confidence because the state label is clean while the surface is hostile

Likely source cluster:
- microstructure / volatility / execution realism

Future extraction priority:
- VERY HIGH

---

# 6. SURFACE STATE CANON — FIRST PASS

## 6.1 Clean Tradable Surface
Type:
- Surface State Object

Plain-language description:
- a market condition where friction is low enough and participation quality is strong enough that structural opportunity is more likely to be practically usable

Observable characteristics:
- acceptable spread burden relative to structure
- stable enough quote surface
- session participation supports the move
- movement quality not obviously distorted by thin conditions

What it supports:
- higher trust in market-state interpretation
- cleaner deployment for continuation or reversal logic, depending on state

What it degrades:
- nothing by default, but still does not override bad structure

Main risks:
- overconfidence just because the surface is clean

Extraction status:
- PROVISIONAL / NOT DEEPLY EXTRACTED YET

---

## 6.2 Degraded but Tradable Surface
Type:
- Surface State Object

Plain-language description:
- a market condition where deployment is still possible, but friction or quality loss is meaningful enough that confidence should be reduced

Observable characteristics:
- non-trivial spread burden
- less stable movement quality
- partial participation weakness
- structurally valid setup, but poorer execution profile

What it supports:
- selective deployment only
- stronger need for structural clarity before trusting the setup

What it degrades:
- fragile setup families
- narrow-margin opportunity

Main risks:
- pretending degraded is the same as clean
- underestimating the cost of mediocre conditions

Extraction status:
- PROVISIONAL / NOT DEEPLY EXTRACTED YET

---

## 6.3 Thin / Fragile Surface
Type:
- Surface State Object

Plain-language description:
- a market condition where participation is weak enough that price behavior may look real but is too fragile to trust easily

Observable characteristics:
- weak participation quality
- jumpy or erratic movement
- poor hold quality beyond levels
- frequent false-looking expansion

What it supports:
- caution
- trap-awareness
- selective skepticism toward breakout quality

What it degrades:
- breakout continuation
- momentum logic
- tight geometry deployment

Main risks:
- mistaking low-quality movement for strong discovery

Extraction status:
- PROVISIONAL / HIGH PRIORITY FOR WAVE 1

---

## 6.4 Hostile Surface
Type:
- Surface State Object

Plain-language description:
- a market condition where the execution surface is poor enough that Aurora should meaningfully distrust practical deployability even if the structural story looks compelling

Observable characteristics:
- severe spread burden or visible quality degradation
- unstable or stale-looking surface
- high mismatch between apparent opportunity and practical usability
- poor session quality or distorted participation

What it supports:
- reduced confidence
- conservative deployment posture
- possible exclusion from active consideration later

What it degrades:
- most strategy families, especially those needing precision and flow quality

Main risks:
- forcing trades because the chart alone looks strong

Extraction status:
- PROVISIONAL / HIGH PRIORITY FOR WAVE 1

---

## 6.5 Session-Weak Surface
Type:
- Surface State Object

Plain-language description:
- a market condition where the current session does not provide strong enough participation quality to trust the structure at normal confidence

Observable characteristics:
- weak follow-through
- low participation energy
- unstable continuation quality
- increased susceptibility to fake breaks and reversion noise

What it supports:
- caution on directional claims
- increased skepticism toward breakout quality

What it degrades:
- session momentum
- breakout continuation
- chase-style continuation logic

Main risks:
- applying active-session assumptions during weak-session reality

Extraction status:
- PROVISIONAL / REQUIRES PROFILE + PARTICIPANT SOURCES

---

# 7. EXECUTION CONTEXT RULES — FIRST PASS

## Rule 1 — Structural clarity is not enough
A clean market-state label does not automatically imply clean deployability.

## Rule 2 — Surface quality must be judged relative to setup geometry
Spread and friction matter more when the structure is narrow, fragile, or timing-sensitive.

## Rule 3 — Session quality changes deployment trust
The same chart shape can be more or less trustworthy depending on participation context.

## Rule 4 — Thin conditions distort interpretation
A move in a weak surface should not be trusted like a move in a clean surface.

## Rule 5 — Hostile surface can overrule apparent pattern beauty
If the surface is hostile enough, Aurora should down-rank practical confidence even if the structure looks attractive.

## Rule 6 — Execution context stays pre-entry
This module rates deployability context.
It does not define exact execution tactics or order placement logic.

---

# 8. RELATIONSHIP TO OTHER AURORA MODULES

## Relationship to `AURORA_MARKET_STATE_CANON.md`
- Market State Canon defines the structural condition.
- Execution Context Surface defines the practical quality of acting in that condition.

## Relationship to `AURORA_STRATEGY_FAMILY_REGISTRY.md`
- strategy families should later declare which surface states they tolerate well and which ones degrade them badly

## Relationship to `AURORA_VOLATILITY_RISK_MODEL.md`
- volatility hostility and execution hostility will later overlap, but should not be collapsed too early

## Relationship to `AURORA_RESEARCH_METHOD.md`
- live and backtest review should track whether weak performance was driven by structure failure or surface degradation

---

# 9. WHAT STILL MUST BE EXTRACTED INTO THIS FILE LATER

Wave 1 deep extraction should still add:

- source-grounded definitions of execution friction
- cleaner spread burden logic
- participant quality and session-quality distinctions
- market plumbing realism notes that matter at chart-trading horizon
- thin-vs-clean deployment differences
- degradation cues that should down-rank otherwise strong states
- disagreement notes where profile language and microstructure language frame deployability differently

This file should later gain:
- source citations once books are deeply processed
- stronger coupling rules into strategy families
- later quantitative review fields for deployment-quality tagging

---

# 10. NEXT TARGETS AFTER THIS FILE

Best next moves after this module:

1. update `AURORA_COMPLETION_TRACKER.md` to record this module creation and stage advancement
2. create `AURORA_EXTRACTION_QUEUE.md`
3. deepen both:
   - `AURORA_MARKET_STATE_CANON.md`
   - `AURORA_EXECUTION_CONTEXT_SURFACE.md`
   with real Wave 1 source extraction
4. then begin:
   - `AURORA_STRATEGY_FAMILY_REGISTRY.md`

---

# 11. CURRENT JUDGMENT

Aurora now has both halves of its first research spine:

- **Market State Canon** = what the market is doing
- **Execution Context Surface** = how tradable that condition is

That is enough structure to begin genuine Wave 1 source extraction without drifting into vague summary work.

This file is still conservative and provisional.
Its job right now is to give future extraction work a stable home, not to pretend the source books have already been fully processed.
