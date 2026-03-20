# AURORA BOOK EXTRACTION MODULE MAP

## PURPOSE

This document defines how the `archives/Aurora/` research library is converted into usable Aurora knowledge without turning the archive into an unstructured note dump.

This is a blueprint for:
- what kinds of truth must be extracted
- which books are the best source for each kind of truth
- which Aurora module or layer should receive that truth
- what must remain reference-only
- how future extraction work should proceed in controlled waves

This is not product code.
This is not a strategy dump.
This is not permission to force every book into the active system.

The goal is to build Aurora as a layered trading intelligence system that can:
- understand market state
- host multiple strategy families
- test and compare them in parallel
- learn from live and backtest feedback
- retire weak logic over time

---

# 1. SYSTEM INTENT

## 1.1 What this library should do for Aurora

The Aurora book library exists to support five major capabilities:

1. **Market-state language**
   - balance / imbalance
   - acceptance / rejection
   - expansion / compression
   - structural transition
   - execution friction awareness

2. **Strategy-family design**
   - define setup families
   - identify native market habitats
   - identify failure habitats
   - define setup conditions and invalid conditions

3. **Testing and evaluation discipline**
   - convert ideas into hypotheses
   - design backtestable / replay-testable structures
   - avoid fake certainty and hand-wavy edges
   - compare strategies by market environment

4. **Risk and volatility realism**
   - understand hostile conditions
   - understand regime dependence
   - understand nonlinear behavior and tail events

5. **Review and adaptation discipline**
   - detect operator bias
   - detect system drift
   - refine, split, or retire strategy families over time

## 1.2 What this library should NOT do

The book library must not be used to:
- dump disconnected summaries into the repo
- inject random indicator logic into Aurora
- import academic ideas directly into live trading without translation
- expand Aurora with features that have no testing path
- confuse market understanding with execution instructions
- treat every book as equally valid or equally important

---

# 2. AURORA TARGET ARCHITECTURE

Book extraction must feed Aurora through defined target modules.

## 2.1 Aurora target modules

### A. MARKET STATE CANON
Purpose:
- define the core language Aurora uses to describe what the market is doing

Examples:
- balance
- trend expansion
- pullback continuation
- compression
- failed break
- reclaim
- acceptance
- rejection
- trap
- activity shift
- friction state

### B. STRATEGY FAMILY REGISTRY
Purpose:
- maintain a controlled catalog of strategy families Aurora can test and compare

Examples:
- trend continuation
- pullback continuation
- range rotation
- breakout / release
- failed break / trap reversal
- session momentum
- volatility expansion

### C. SETUP PATTERN ATLAS
Purpose:
- hold pattern-level structures, examples, aliases, and failure signatures

Examples:
- breakout continuation patterns
- false breakout patterns
- inside compression patterns
- reversal signatures
- continuation pullback structures

### D. EXECUTION CONTEXT SURFACE
Purpose:
- define execution-relevant context without turning Aurora into an execution bot

Examples:
- spread sensitivity
- friction conditions
- symbol tradability constraints
- session-specific quality
- execution-surface hostility

### E. VOLATILITY / RISK MODEL
Purpose:
- teach Aurora which market environments amplify or degrade certain strategy families

Examples:
- compression vs expansion
- volatility clustering
- trend persistence vs failure
- hostile event regimes
- tail-risk awareness

### F. RESEARCH / TESTING METHOD
Purpose:
- define how Aurora converts extracted ideas into testable hypotheses

Examples:
- what counts as a strategy hypothesis
- what must be tracked in backtests
- how live tests are tagged
- when a strategy should be split, refined, or retired

### G. REVIEW / ADAPTATION LAYER
Purpose:
- support post-test review and long-horizon system refinement

Examples:
- operator bias checks
- regime mismatch detection
- semantic drift warnings
- adaptation prompts

---

# 3. EXTRACTION OBJECT TYPES

Every extraction from a book must be converted into one or more of the following object types.

## 3.1 Concept Object
Use when the book provides a reusable idea or term.

Fields:
- canonical name
- aliases used by authors
- plain-language definition
- structural meaning
- misuse risk
- Aurora target module
- source book(s)

Example:
- Acceptance
- Balance
- Failed auction
- Compression

## 3.2 State Object
Use when the book describes a market condition or phase.

Fields:
- state name
- state description
- observable characteristics
- adjacent states
- transition triggers
- hostile strategies in this state
- compatible strategies in this state
- source book(s)

## 3.3 Strategy Family Object
Use when the book presents a reusable family of trading logic.

Fields:
- family name
- thesis
- native habitat
- invalid habitat
- common entry style
- common failure mode
- observable requirements
- backtestability notes
- live-test notes
- source book(s)

## 3.4 Pattern Object
Use when the book describes a recurring chart or structural pattern.

Fields:
- pattern name
- family
- context required
- observable shape
- common false-positive conditions
- relationship to broader market state
- source book(s)

## 3.5 Evaluation Rule Object
Use when the book helps decide how to test or judge strategy quality.

Fields:
- rule name
- rule purpose
- what it prevents
- what it requires
- application stage
- source book(s)

## 3.6 Risk Object
Use when the book provides a volatility or hostile-environment concept.

Fields:
- risk concept name
- market relevance
- affected strategies
- affected states
- symptoms / warning signs
- source book(s)

---

# 4. MASTER EXTRACTION LAW

## 4.1 Extract by usefulness, not by literary completeness
A book does not need to be fully summarized to be useful.
The job is to pull out Aurora-relevant truth.

## 4.2 Extract by module destination
Every extraction must answer:
- what is this?
- where does it belong?
- how will Aurora use it?

If no clear destination exists, the material remains reference-only.

## 4.3 Preserve disagreement
Books often conflict.
Do not flatten disagreement too early.
Track:
- competing explanations
- competing strategy families
- context differences
- assumptions that differ by author

## 4.4 Separate concept extraction from strategy authorization
A useful idea can enter the concept base long before a strategy family becomes test-ready.

## 4.5 Start small, but architect for scale
Aurora should begin with a small set of high-value families and concepts, while keeping the structure ready for later expansion.

---

# 5. BOOK CLUSTERS AND WHAT TO EXTRACT

## 5.1 MICROSTRUCTURE / AUCTION / MARKET MECHANICS CLUSTER

Primary books:
- `Auction Theory.pdf`
- `Auction Theory2.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`
- `market-microstructure-theory_compress.pdf`
- `Flash Boys - A Wall Street Revolt 2015.epub`

### What to extract

#### A. Market-state language
Extract:
- balance
- imbalance
- value discovery
- acceptance
- rejection
- auction continuation
- failed auction
- rotation vs directional discovery
- initiative vs responsive activity
- participation change
- structure around migration from one value area to another

Aurora destination:
- MARKET STATE CANON
- EXECUTION CONTEXT SURFACE

#### B. State transitions
Extract:
- how markets move from balance to imbalance
- how failed directional attempts behave
- how overlapping structure signals poor directional clarity
- how activity shifts when price is accepted vs rejected

Aurora destination:
- MARKET STATE CANON
- VOLATILITY / RISK MODEL

#### C. Execution realism
Extract:
- spread and tradability awareness
- friction and venue effects
- why apparent opportunity can be degraded by execution conditions
- why market mechanics matter even when the setup looks good

Aurora destination:
- EXECUTION CONTEXT SURFACE
- VOLATILITY / RISK MODEL

#### D. Structural warnings
Extract:
- when a market looks active but is actually rotational
- when price discovery is weak
- when context is too unstable for clean continuation logic

Aurora destination:
- MARKET STATE CANON
- REVIEW / ADAPTATION LAYER

### What NOT to import directly
- exchange-specific implementation detail that cannot be observed in Aurora’s data surface
- pure market-profile mechanics that require tools Aurora does not have yet
- HFT/latency logic as if it were usable chart-level strategy logic

---

## 5.2 TECHNICAL ANALYSIS / PRICE BEHAVIOR / PATTERN CLUSTER

Primary books:
- `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
- `Steve_Nison-Japanese_Candlestick_Charting_Techniques-EN.pdf`
- `Bulkowski ,Thomas N.Encyclopedia of Chart Patterns.pdf`
- `technical-analysis-and-stock-market-profits.pdf`
- `pcmbrokers_(Wiley finance series) Adam Grimes.pdf`
- `The Alchemy of Finance - Reading the Mind of the Market 2nd edition 1994.pdf`

### What to extract

#### A. Pattern families
Extract:
- continuation patterns
- reversal patterns
- failed break patterns
- compression patterns
- trend pullback patterns
- chart pattern aliases across books

Aurora destination:
- SETUP PATTERN ATLAS
- STRATEGY FAMILY REGISTRY

#### B. Price behavior descriptors
Extract:
- thrust vs drift behavior
- breakout quality conditions
- reclaim and failure signatures
- wick-heavy invalid structures
- trend exhaustion signs
- reversal context rules

Aurora destination:
- MARKET STATE CANON
- SETUP PATTERN ATLAS

#### C. Strategy-family candidates
Extract:
- breakout continuation family
- pullback continuation family
- range rotation family
- failed break reversal family
- trend exhaustion / reversal family

Aurora destination:
- STRATEGY FAMILY REGISTRY

#### D. Pattern-failure logic
Extract:
- when a classic pattern should not be trusted
- common false positives
- where pattern names overlap but contexts differ
- when indicator dependence weakens structural clarity

Aurora destination:
- SETUP PATTERN ATLAS
- REVIEW / ADAPTATION LAYER

### What NOT to import directly
- canned indicator recipes as final truth
- pattern rules that ignore context or regime
- pattern names without structural definitions

---

## 5.3 SYSTEMATIC / QUANT / STATISTICAL TRADING CLUSTER

Primary books:
- `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf`
- `advances-in-financial-machine-learning-1nbsped-9781119482109-9781119482116-9781119482086.pdf`
- `quantitative-trading-strategies-using-python.pdf`
- `statistical_arbitrage.pdf`
- `Algorithmic_Trading__Winning_Strategies.pdf`
- `Systematic Trading PDF.pdf`
- `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf`
- `Lec-Markov_note.pdf`
- `Models and Methods in Economics and Management Science.txt`

### What to extract

#### A. Hypothesis design rules
Extract:
- how to express a tradable hypothesis clearly
- how to turn a vague edge claim into testable conditions
- how to separate research intuition from validation

Aurora destination:
- RESEARCH / TESTING METHOD

#### B. Evaluation methodology
Extract:
- robustness checks
- false-discovery warnings
- overfitting traps
- walk-forward / regime segmentation ideas
- why one dataset is not enough
- why many “winning” strategies are fragile

Aurora destination:
- RESEARCH / TESTING METHOD
- REVIEW / ADAPTATION LAYER

#### C. Strategy-family framing
Extract:
- trend following families
- mean-reversion families
- relative-value families
- session / time-effect families
- volatility-sensitive families

Aurora destination:
- STRATEGY FAMILY REGISTRY

#### D. Feature sanity rules
Extract:
- what kinds of inputs are valid
- what kinds of features are likely to produce nonsense
- when complexity cost outweighs learning value

Aurora destination:
- RESEARCH / TESTING METHOD
- REVIEW / ADAPTATION LAYER

### What NOT to import directly
- model complexity Aurora cannot support yet
- ML pipelines without a clear incremental value case
- code-level examples treated as architectural law

---

## 5.4 RISK / UNCERTAINTY / VOLATILITY CLUSTER

Primary books:
- `against-the-gods-the-remarkable-story-of-risk-1996-peter-l-bernstein.pdf`
- `Thinking in Bets PDF.pdf`
- `philip_e._tetlock_-_superforecasting_the_art_and-science-of-prediction.pdf`
- `Dynamic_Hedging-Taleb.pdf`
- `Option Volatility and Pricing.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `MathematicsMoneyManagement.pdf`
- `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf`

### What to extract

#### A. Volatility-state concepts
Extract:
- volatility clustering
- expansion after compression
- nonlinear shifts
- asymmetry under stress
- calm vs unstable regime differences

Aurora destination:
- VOLATILITY / RISK MODEL
- MARKET STATE CANON

#### B. Hostility and degradation conditions
Extract:
- conditions under which strategies fail faster
- when risk rises faster than pattern quality
- why tail conditions invalidate naive assumptions

Aurora destination:
- VOLATILITY / RISK MODEL
- EXECUTION CONTEXT SURFACE

#### C. Decision quality under uncertainty
Extract:
- uncertainty framing
- scenario-based reasoning
- overconfidence warnings
- forecast humility

Aurora destination:
- RESEARCH / TESTING METHOD
- REVIEW / ADAPTATION LAYER

#### D. Risk measurement and position logic
Extract:
- sizing frameworks
- drawdown awareness
- nonlinear exposure awareness
- why capital preservation matters

Aurora destination:
- RESEARCH / TESTING METHOD
- future execution-risk doctrine

### What NOT to import directly
- options-specific mechanics as if they apply directly to spot price charts
- abstract probability language with no market-state translation
- money-management formulas detached from strategy context

---

## 5.5 BEHAVIORAL / PSYCHOLOGY / ADAPTATION CLUSTER

Primary books:
- `Daniel Kahneman-Thinking, Fast and Slow  .pdf`
- `Misbehaving_The_Making_of_Behavioral_Economics_by_.pdf`
- `The Hour Between Dog and Wolf PDF.pdf`
- `Adaptive Markets.pdf`

### What to extract

#### A. Bias maps
Extract:
- confirmation bias
- recency bias
- overconfidence
- story-fitting
- survivorship bias
- illusion of control

Aurora destination:
- REVIEW / ADAPTATION LAYER

#### B. Adaptation logic
Extract:
- why market behavior changes over time
- why a strategy’s habitat can decay
- why environmental fit matters more than static belief

Aurora destination:
- MARKET STATE CANON
- REVIEW / ADAPTATION LAYER
- RESEARCH / TESTING METHOD

#### C. Operator review prompts
Extract:
- review questions for live-test failures
- prompts for detecting semantic drift
- prompts for detecting bad regime labeling

Aurora destination:
- REVIEW / ADAPTATION LAYER

### What NOT to import directly
- generic mindset coaching
- motivational language as system doctrine
- psychological theory without operational use in review

---

## 5.6 INVESTING / MACRO / LONG-HORIZON PHILOSOPHY CLUSTER

Primary books:
- `A Random Walk Down Wall Street - The Time-Tested Strategy for Successful Investing 11th edition 2015.epub`
- `Common Stocks and Uncommon Profits and Other Writings 2nd edition 2003.pdf`
- `The Intelligent Investor - A Book of Practical Counsel 2003.mobi`
- `One Up On Wall Street 2000.epub`
- `The Little Book That Beats the Market 2006.pdf`
- `Beating the Financial markets.pdf`
- `How-Countries-Go-Broke.pdf`
- `principles-for-navigating-big-debt-crises-paperbacknbsped-1732689806-9781732689800_compress.pdf`
- `EXPECTED RETURNS ON MAJOR.pdf`
- `BFI_WP_2023-100.pdf`

### What to extract

#### A. Critique and worldview objects
Extract:
- challenges to active trading assumptions
- long-horizon market efficiency arguments
- return expectation realism
- debt-cycle and macro-regime context

Aurora destination:
- REFERENCE layer
- optional macro-context notes

#### B. Macro condition support
Extract:
- debt regime ideas
- long-cycle instability concepts
- macro backdrop logic relevant to cross-asset context

Aurora destination:
- future macro-context layer
- future risk overlay

### What NOT to import directly
- value-investing doctrine as if it were short-horizon trading logic
- long-horizon asset-allocation rules into short-horizon setup design
- broad philosophy without a defined Aurora destination

---

# 6. PRIORITY WAVES

## Wave 1 — Build Aurora market language first
Books:
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`
- `market-microstructure-theory_compress.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`

Output targets:
- `AURORA_MARKET_STATE_CANON.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE.md`

Why first:
- Aurora needs a stable language for describing markets before strategy extraction can stay coherent.

## Wave 2 — Populate strategy families and pattern atlas
Books:
- `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
- `pcmbrokers_(Wiley finance series) Adam Grimes.pdf`
- `Bulkowski ,Thomas N.Encyclopedia of Chart Patterns.pdf`
- `Steve_Nison-Japanese_Candlestick_Charting_Techniques-EN.pdf`
- academic strategy archive material

Output targets:
- `AURORA_STRATEGY_FAMILY_REGISTRY.md`
- `AURORA_SETUP_PATTERN_ATLAS.md`

Why second:
- once market-state language is stable, pattern and family extraction can be mapped consistently.

## Wave 3 — Lock research discipline
Books:
- `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf`
- `Systematic Trading PDF.pdf`
- `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf`
- `Thinking in Bets PDF.pdf`
- `philip_e._tetlock_-_superforecasting_the_art_and-science-of-prediction.pdf`

Output targets:
- `AURORA_RESEARCH_METHOD.md`
- `AURORA_STRATEGY_REVIEW_PROTOCOL.md`

Why third:
- after concepts and families exist, Aurora needs controlled testing and pruning rules.

## Wave 4 — Add volatility and hostile-environment realism
Books:
- `Dynamic_Hedging-Taleb.pdf`
- `Option Volatility and Pricing.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf`
- `against-the-gods-the-remarkable-story-of-risk-1996-peter-l-bernstein.pdf`

Output targets:
- `AURORA_VOLATILITY_RISK_MODEL.md`
- hostile-environment warnings integrated into family registry

Why fourth:
- volatility and tail-risk concepts should refine, not define, the first layer of system language.

## Wave 5 — Add adaptation and review depth
Books:
- `Adaptive Markets.pdf`
- `Daniel Kahneman-Thinking, Fast and Slow  .pdf`
- `Misbehaving_The_Making_of_Behavioral_Economics_by_.pdf`
- `The Hour Between Dog and Wolf PDF.pdf`

Output targets:
- `AURORA_REVIEW_AND_ADAPTATION_LAYER.md`

Why fifth:
- these materials are highly valuable, but they should support evaluation and refinement rather than dictate first-pass architecture.

---

# 7. BOOK-TO-MODULE MAPPING TABLE

| Book / Cluster | Primary Extraction Focus | Aurora Destination | Priority |
|---|---|---|---|
| Dalton / Mind Over Markets / Auction books | balance, acceptance, rejection, value migration, failed auction | MARKET STATE CANON | Wave 1 |
| Microstructure texts | friction, tradability realism, price-formation context | EXECUTION CONTEXT SURFACE, VOLATILITY / RISK MODEL | Wave 1 |
| Murphy / Grimes / Bulkowski / Nison | chart vocabulary, setup families, pattern failure states | STRATEGY FAMILY REGISTRY, SETUP PATTERN ATLAS | Wave 2 |
| Evidence-Based TA / Systematic Trading / Quant books | hypothesis design, robustness, false-discovery protection | RESEARCH / TESTING METHOD | Wave 3 |
| Taleb / vol / risk books | hostile regimes, nonlinear behavior, asymmetry | VOLATILITY / RISK MODEL | Wave 4 |
| Kahneman / Adaptive Markets / behavioral texts | bias review, adaptation, drift detection | REVIEW / ADAPTATION LAYER | Wave 5 |
| Investing / macro / debt books | worldview, critique, long-cycle context | REFERENCE / future macro layer | Later |

---

# 8. REQUIRED OUTPUT FILES FOR THIS SYSTEM

The following files should eventually exist in the `Aurora Blueprint/` layer:

1. `AURORA_BOOK_MASTER_INDEX.md`
2. `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
3. `AURORA_MARKET_STATE_CANON.md`
4. `AURORA_STRATEGY_FAMILY_REGISTRY.md`
5. `AURORA_SETUP_PATTERN_ATLAS.md`
6. `AURORA_EXECUTION_CONTEXT_SURFACE.md`
7. `AURORA_VOLATILITY_RISK_MODEL.md`
8. `AURORA_RESEARCH_METHOD.md`
9. `AURORA_STRATEGY_REVIEW_PROTOCOL.md`
10. `AURORA_REVIEW_AND_ADAPTATION_LAYER.md`
11. `AURORA_EXTRACTION_QUEUE.md`

---

# 9. EXTRACTION TEMPLATE RULES

Every future book extraction should answer these questions explicitly:

1. What Aurora-relevant problem does this source help solve?
2. Which target module receives the extracted material?
3. Is the extracted item a concept, state, strategy family, pattern, evaluation rule, or risk object?
4. Is this material core, supportive, or reference-only?
5. Can this be tested, observed, or reviewed later?
6. What should be kept out to avoid scope creep or fake precision?

---

# 10. INITIAL SMALL-START RECOMMENDATION

Aurora should not try to activate every strategy family at once.
It should begin with a small but broad starter set that covers distinct market habitats.

Recommended initial family starter pack:
- trend continuation
- pullback continuation
- breakout / compression release
- failed break / trap reversal
- range rotation

Why these first:
- together they cover the main structural habitats without requiring excessive specialization
- they can be mapped to many of the archive books
- they are testable in both backtest and live review frameworks

---

# 11. FOUNDATION JUDGMENT

This blueprint treats the Aurora archive as a structured research source, not a pile of books to summarize.

The order of construction is:
1. market language
2. family registry
3. pattern atlas
4. research discipline
5. volatility realism
6. adaptation and review depth

That sequence keeps Aurora coherent while still allowing multiple strategy families, parallel testing, live feedback, and later pruning.

Aurora should learn in layers.
It should not import entire books blindly.
It should extract only what can be mapped, tested, reviewed, or preserved as reference with a clear reason.
