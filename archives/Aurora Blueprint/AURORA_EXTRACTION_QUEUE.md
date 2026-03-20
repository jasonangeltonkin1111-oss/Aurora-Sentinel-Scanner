# AURORA EXTRACTION QUEUE

## PURPOSE

This file converts the Aurora Blueprint architecture into an operational extraction order.

Its job is to stop future chats from doing ad hoc book work.
It defines:
- what gets extracted first
- which source books belong to each pass
- which target module receives the extraction
- what completion condition ends each queue item
- what should explicitly wait until later

This file is not a book summary.
It is the work-order map for the extraction project.

---

# 1. OPERATING LAW

Aurora Blueprint extraction must remain **destination-led**.

That means:
- first define the target module
- then choose the source books
- then extract only the truth needed for that destination

Do **not** read books randomly and dump notes into the repo.

---

# 2. CURRENT PROJECT POSITION

At the time this file was created, Aurora Blueprint already has:
- `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
- `AURORA_BOOK_MASTER_INDEX.md`
- `AURORA_MARKET_STATE_CANON.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE.md`
- `AURORA_PROGRESS_TRACKER.md`

This means the project is ready to begin **real Wave 1 source-grounded extraction**.

---

# 3. QUEUE STATUS LABELS

Use these labels for queue items:
- `LOCKED` = active next priority
- `READY` = can begin once the locked item is complete enough
- `BLOCKED` = should not be started yet
- `LATER` = recognized future work, not active yet
- `DONE` = sufficiently completed for current stage

---

# 4. ACTIVE EXTRACTION QUEUE

## Q1 — Wave 1 source grounding for Market State Canon
Status:
- LOCKED

Target file:
- `Aurora Blueprint/AURORA_MARKET_STATE_CANON.md`

Primary source books:
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`
- `Auction Theory2.pdf`

Secondary support:
- `market-microstructure-theory_compress.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`

Source classification:
- TRANSLATE

What to extract:
- source-grounded definitions of balance
- source-grounded definitions of imbalance / directional discovery
- acceptance vs rejection distinctions
- value migration logic
- failed auction / failed break distinctions
- rotation vs genuine discovery separation
- structural transitions between the main states
- competing terminology across sources

What not to do:
- do not expand into entry tactics
- do not start broad pattern cataloging yet
- do not force strategy-family detail into this pass

Completion condition:
- `AURORA_MARKET_STATE_CANON.md` contains source-grounded upgrades for the core Wave 1 concepts and states
- the file clearly marks which definitions are now source-grounded versus still provisional
- major alias conflicts are noted instead of hidden

---

## Q2 — Wave 1 source grounding for Execution Context Surface
Status:
- READY

Target file:
- `Aurora Blueprint/AURORA_EXECUTION_CONTEXT_SURFACE.md`

Primary source books:
- `market-microstructure-theory_compress.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`
- `Flash Boys - A Wall Street Revolt 2015.epub`

Secondary support:
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`

Source classification:
- TRANSLATE

What to extract:
- source-grounded friction definitions
- tradability vs visible chart opportunity distinctions
- spread burden logic
- participation depth / thinness distinctions
- session-quality distinctions that affect deployability
- hostile surface conditions
- why structurally valid states can still be practically degraded

What not to do:
- do not turn this into order-placement doctrine
- do not introduce broker-specific operational hacks as universal truth
- do not collapse volatility hostility and execution hostility into one concept too early

Completion condition:
- `AURORA_EXECUTION_CONTEXT_SURFACE.md` contains source-grounded execution-context definitions
- the surface states are no longer scaffold-only
- the file clearly distinguishes tradability loss from structural invalidity

---

## Q3 — Cross-link Wave 1 modules after first grounding pass
Status:
- READY

Target files:
- `AURORA_MARKET_STATE_CANON.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE.md`

What to do:
- add explicit cross-links between structural state and deployment surface
- identify where a clean structural state is commonly degraded by hostile context
- mark which concepts belong strictly to state and which belong strictly to execution surface

Completion condition:
- both Wave 1 files reference each other cleanly
- state-vs-surface boundary becomes sharper

---

## Q4 — Build Strategy Family Registry skeleton
Status:
- BLOCKED
n
Target file:
- `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`

Why blocked:
- strategy families should not be stabilized before Wave 1 market-state language is source-grounded enough to host them

When to unlock:
- Q1 is materially complete
- Q2 is materially complete
- state language and deployment-surface language are no longer scaffold-only for the core concepts

Initial family starter pack once unlocked:
- trend continuation
- pullback continuation
- breakout / compression release
- failed break / trap reversal
- range rotation

---

## Q5 — Build Setup Pattern Atlas skeleton
Status:
- BLOCKED

Target file:
- `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`

Why blocked:
- pattern language depends on strategy-family structure and stable market-state language

When to unlock:
- Q4 is opened and strategy-family naming is stable enough

---

## Q6 — Build Research / Testing Method
Status:
- BLOCKED

Target file:
- `Aurora Blueprint/AURORA_RESEARCH_METHOD.md`

Primary source books when unlocked:
- `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf`
- `Systematic Trading PDF.pdf`
- `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf`
- `Thinking in Bets PDF.pdf`
- `philip_e._tetlock_-_superforecasting_the_art_and_science_of_prediction.pdf`

Why blocked:
- the first job is still to stabilize Wave 1 doctrine destinations before building formal testing doctrine around later strategy work

---

## Q7 — Build Volatility / Risk Model
Status:
- BLOCKED

Target file:
- `Aurora Blueprint/AURORA_VOLATILITY_RISK_MODEL.md`

Primary source books when unlocked:
- `Dynamic_Hedging-Taleb.pdf`
- `Option Volatility and Pricing.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf`
- `against-the-gods-the-remarkable-story-of-risk-1996-peter-l-bernstein.pdf`

Why blocked:
- volatility/risk language should refine the system after Wave 1 base language is properly grounded

---

## Q8 — Build Review / Adaptation Layer
Status:
- BLOCKED

Target file:
- `Aurora Blueprint/AURORA_REVIEW_AND_ADAPTATION_LAYER.md`

Primary source books when unlocked:
- `Adaptive Markets.pdf`
- `Daniel Kahneman-Thinking, Fast and Slow  .pdf`
- `Misbehaving_The_Making_of_Behavioral_Economics_by_.pdf`
- `The Hour Between Dog and Wolf PDF.pdf`

Why blocked:
- this should support extraction and refinement after base doctrine is more mature

---

# 5. RUN-SIZE RULE

Each extraction run should stay bounded.

Preferred run shape:
- one target module at a time
- one small source cluster at a time
- explicit completion delta at the end
- tracker/run-log update before ending

Do not attempt to process the whole library in one run.

---

# 6. BOOK-USE LAW FOR QUEUE WORK

For each queue item, every source must be classified as:
- TRANSLATE
- REFERENCE ONLY
- DO NOT USE

For Q1 and Q2, the named primary books are presumed TRANSLATE unless a specific section proves unusable or out of scope.

---

# 7. NEXT RECOMMENDED EXECUTION ORDER

Immediate next work sequence:

1. execute Q1
2. execute Q2
3. execute Q3
4. unlock Q4
5. build `AURORA_STRATEGY_FAMILY_REGISTRY.md`

This is the cleanest progression that preserves layer logic.

---

# 8. CURRENT JUDGMENT

Aurora Blueprint now has enough structure to stop planning endlessly.

The project should now move from:
- architecture setup
- continuity repair
- destination scaffolding

into:
- controlled source-grounded Wave 1 extraction

This queue file exists to enforce that shift.
