# ASC PHASE 1 INDEX

This file indexes only the Aurora-library sources that are relevant to the current ASC task:

## Current ASC task
Build a usable scanner that produces:
- `SUMMARY.txt` with top 5 per bucket
- `SYMBOLS/<symbol>.txt` with exactly:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`

ASC-style indexing here means:
- narrow relevance to current Phase 1 scanner work
- no strategy extraction
- no automation expansion
- books may remove bad ideas or support clean measurement choices, but may not expand scope

---

# 1. DIRECTLY RELEVANT NOW

## `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
Useful now for:
- basic market vocabulary
- volatility/range framing
- broad metric sanity

ASC relevance:
- helps define familiar, readable calculation fields
- should not be used to inject signal logic

## `James_Dalton-Markets_in_Profile-EN.pdf`
Useful now for:
- understanding that different symbols have different activity and profile behavior
- reinforcing the need for symbol comparison and market state awareness

ASC relevance:
- supports the idea that summary selection should compare symbols meaningfully
- not needed for implementation complexity in Phase 1

## `Mind OverMarket.pdf`
Useful now for:
- participant/context awareness
- activity-state intuition

ASC relevance:
- can support thinking about bucket usefulness and inspection discipline
- not a reason to add profile logic yet

## `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`
Useful now for:
- spread, tradability, and execution reality awareness

ASC relevance:
- strongly supports `BROKER_SPEC` importance
- strongly supports using real broker conditions rather than fantasy metrics

## `market-microstructure-theory_compress.pdf`
Useful now for:
- execution friction awareness
- price-formation realism

ASC relevance:
- supports current focus on spreads/specs and truthful conditions

## `Auction Theory.pdf`
Useful now for:
- thinking in terms of market state and comparison rather than isolated indicators

ASC relevance:
- conceptual only right now
- do not add auction-engine complexity yet

## `AUCTION THEORY; A GUIDED TOUR.pdf`
Useful now for:
- same conceptual role as above

ASC relevance:
- conceptual only right now

## `Auction Theory2.pdf`
Useful now for:
- same conceptual role as above

ASC relevance:
- conceptual only right now

---

# 2. SUPPORTIVE BUT SECONDARY FOR PHASE 1

## `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf`
Useful now for:
- avoiding fake certainty
- resisting garbage metrics

ASC relevance:
- reinforces that calculations should be honest and testable

## `Systematic Trading PDF.pdf`
Useful now for:
- system cleanliness
- disciplined metric design

ASC relevance:
- useful mentally, but not a source of immediate scanner features

## `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf`
Useful now for:
- data-first workflow thinking

ASC relevance:
- light architectural support only

## `Adaptive Markets.pdf`
Useful now for:
- remembering that symbols behave differently across conditions

ASC relevance:
- supports bucket-based comparison mindset
- no direct implementation lift yet

## `Daniel Kahneman-Thinking, Fast and Slow  .pdf`
Useful now for:
- guarding against overcomplication and bias

ASC relevance:
- mental discipline support only

## `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf`
Useful now for:
- avoiding fragile assumptions

ASC relevance:
- supports truthful handling of missing or unstable values

## `Dynamic_Hedging-Taleb.pdf`
Useful now for:
- respecting nonlinear market behavior

ASC relevance:
- warning against naive simplification, not a Phase 1 feature source

---

# 3. NOT FOR PHASE 1 ASC BUILD

These may be valuable later, but should not influence the current scanner build:

- `advances-in-financial-machine-learning-1nbsped-9781119482109-9781119482116-9781119482086.pdf`
- `quantitative-trading-strategies-using-python.pdf`
- `statistical_arbitrage.pdf`
- `Option Volatility and Pricing.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `Thinking in Bets PDF.pdf`
- `philip_e._tetlock_-_superforecasting_the_art_and_science_of_prediction.pdf`
- `How-Countries-Go-Broke.pdf`
- `principles-for-navigating-big-debt-crises-paperbacknbsped-1732689806-9781732689800_compress.pdf`
- investing/value books such as `The Intelligent Investor`, `One Up On Wall Street`, `Common Stocks and Uncommon Profits`, and related titles
- mindset-only books such as `Reality transurfing...` and `Subconscious Mind Power...`

Reason:
- they do not help the immediate scanner milestone enough to justify scope growth now

---

# 4. PHASE 1 RULE

For the current ASC scanner build, books may:
- remove bad ideas
- support clean metric selection
- reinforce truthful broker/spec/condition handling

Books may not:
- add strategy logic
- add signal generation
- add automation layers
- expand output scope beyond summary + symbol files

---

# 5. PRACTICAL ASC TAKEAWAYS NOW

Current scanner should prioritize:
- truthful broker specs
- real spread/conditions
- clean recent OHLC persistence
- a small set of usable calculations
- readable top-5-per-bucket output

That is the only current mission.
