# AURORA BOOK MASTER INDEX

## PURPOSE

This file is the master inventory for the `archives/Aurora/` research library as used by the Aurora Blueprint project.

Its function is to turn the archive from a preserved book dump into a controlled extraction inventory.

This file does not claim deep extraction.
It records:
- what the source is
- what cluster it belongs to
- what kind of Aurora value it likely contains
- what target module(s) it should feed
- what priority it currently has
- what extraction status it currently has
- whether it is core, supportive, or reference-only

This file must remain honest.
If a source has not been opened and processed, it must not be described as deeply extracted.

---

# 1. STATUS LEGEND

## Extraction status labels
- `NOT STARTED`
- `OPENED`
- `PARTIALLY EXTRACTED`
- `FULLY EXTRACTED`
- `REFERENCE ONLY`
- `DEFERRED`

## Importance labels
- `CORE`
- `SUPPORTIVE`
- `REFERENCE`

## Priority labels
- `WAVE 1`
- `WAVE 2`
- `WAVE 3`
- `WAVE 4`
- `WAVE 5`
- `LATER`

## Aurora target module abbreviations
- `MSC` = MARKET STATE CANON
- `SFR` = STRATEGY FAMILY REGISTRY
- `SPA` = SETUP PATTERN ATLAS
- `ECS` = EXECUTION CONTEXT SURFACE
- `VRM` = VOLATILITY / RISK MODEL
- `RTM` = RESEARCH / TESTING METHOD
- `RAL` = REVIEW / ADAPTATION LAYER
- `REF` = reference layer only

---

# 2. MASTER INVENTORY TABLE

| Source | Cluster | Likely Aurora value | Target module(s) | Importance | Priority | Extraction status | Notes |
|---|---|---|---|---|---|---|---|
| `AURORA — UNIVERSAL MULTI-ASSET MARK.txt` | Core Aurora / legacy blueprint | old Aurora doctrine, layered system logic, scenario-model thinking | REF, later architectural comparison | SUPPORTIVE | LATER | NOT STARTED | useful as legacy doctrine comparison, not as automatic source of truth |
| `Auction Theory.pdf` | Microstructure / auction | auction dynamics, acceptance/rejection, value discovery | MSC, ECS | CORE | WAVE 1 | NOT STARTED | one of the main market-language sources |
| `Auction Theory2.pdf` | Microstructure / auction | alternative auction framing, reinforcement / comparison | MSC, ECS | SUPPORTIVE | WAVE 1 | NOT STARTED | secondary auction source for comparison and disagreement tracking |
| `AUCTION THEORY; A GUIDED TOUR.pdf` | Microstructure / auction | structured auction grounding, market structure interpretation | MSC, ECS | CORE | WAVE 1 | NOT STARTED | likely strong source for clean state definitions |
| `James_Dalton-Markets_in_Profile-EN.pdf` | Microstructure / auction | profile logic, auction framing, balance / imbalance language | MSC, ECS | CORE | WAVE 1 | NOT STARTED | one of the highest-value market-state books |
| `Mind OverMarket.pdf` | Microstructure / auction | participant behavior, activity-state context, profile framing | MSC, ECS, RAL | CORE | WAVE 1 | NOT STARTED | useful for activity-state language and weak/strong auction context |
| `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub` | Microstructure / auction | venue mechanics, execution constraints, tradability realism | ECS, VRM | CORE | WAVE 1 | NOT STARTED | one of the strongest sources for execution-context realism |
| `market-microstructure-theory_compress.pdf` | Microstructure / auction | price formation, friction, execution realism | ECS, VRM, MSC | CORE | WAVE 1 | NOT STARTED | useful for keeping Aurora honest about tradability and market mechanics |
| `Flash Boys - A Wall Street Revolt 2015.epub` | Microstructure / auction | market plumbing, fairness, latency reality | ECS, REF | SUPPORTIVE | WAVE 1 | NOT STARTED | context source, not direct chart-level strategy logic |
| `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf` | Technical analysis / price behavior | broad TA vocabulary, structure framing, volatility/range language | SPA, SFR, MSC | CORE | WAVE 2 | NOT STARTED | broad source, useful but must be filtered to avoid indicator dumping |
| `Steve_Nison-Japanese_Candlestick_Charting_Techniques-EN.pdf` | Technical analysis / price behavior | candlestick taxonomy, contextual pattern naming | SPA | SUPPORTIVE | WAVE 2 | NOT STARTED | useful for naming and examples, not standalone strategy authority |
| `Bulkowski ,Thomas N.Encyclopedia of Chart Patterns.pdf` | Technical analysis / price behavior | large pattern catalog, comparative pattern language | SPA, SFR | SUPPORTIVE | WAVE 2 | NOT STARTED | pattern source, must be filtered heavily through market-state context |
| `technical-analysis-and-stock-market-profits.pdf` | Technical analysis / price behavior | legacy TA framing, older market-reading methods | SPA, REF | REFERENCE | WAVE 2 | NOT STARTED | comparison source, lower priority than Murphy / Grimes |
| `pcmbrokers_(Wiley finance series) Adam Grimes.pdf` | Technical analysis / price behavior | discretionary price action, structure, execution context | SFR, SPA, MSC | CORE | WAVE 2 | NOT STARTED | likely one of the best bridges between structure and usable strategy families |
| `The Alchemy of Finance - Reading the Mind of the Market 2nd edition 1994.pdf` | Technical analysis / macro-reflexivity | reflexivity, macro/market interaction thinking | MSC, RAL, REF | SUPPORTIVE | WAVE 2 | NOT STARTED | useful as mental model support, not direct setup engine |
| `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf` | Systematic / quant | algorithmic workflow, data-first hypothesis design | RTM, SFR | SUPPORTIVE | WAVE 3 | NOT STARTED | helps structure research discipline rather than define market language |
| `advances-in-financial-machine-learning-1nbsped-9781119482109-9781119482116-9781119482086.pdf` | Systematic / quant | modern quant research, ML signal engineering, validation concepts | RTM, REF | REFERENCE | WAVE 3 | NOT STARTED | high-complexity source, must not dictate early Aurora architecture |
| `quantitative-trading-strategies-using-python.pdf` | Systematic / quant | implementation-oriented quant examples, statistical workflow | RTM, SFR | SUPPORTIVE | WAVE 3 | NOT STARTED | useful for turning ideas into testable structures later |
| `statistical_arbitrage.pdf` | Systematic / quant | mean reversion / relative value framing | SFR, RTM | SUPPORTIVE | WAVE 3 | NOT STARTED | likely later-use family source, lower immediate priority |
| `Algorithmic_Trading__Winning_Strategies.pdf` | Systematic / quant | strategy family comparisons, system-building examples | SFR, RTM | SUPPORTIVE | WAVE 3 | NOT STARTED | useful for family cataloging, not direct live doctrine |
| `Systematic Trading PDF.pdf` | Systematic / quant | process discipline, robustness thinking, systematic portfolio framing | RTM | CORE | WAVE 3 | NOT STARTED | one of the main research-method sources |
| `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf` | Systematic / quant | evidence-first signal evaluation, anti-handwavy testing discipline | RTM, RAL | CORE | WAVE 3 | NOT STARTED | one of the highest-value methodology sources |
| `Lec-Markov_note.pdf` | Systematic / quant | stochastic process background, state-transition ideas | RTM, REF | REFERENCE | WAVE 3 | NOT STARTED | useful only if Aurora later needs formal state-transition support |
| `Models and Methods in Economics and Management Science.txt` | Systematic / quant | general systems/modeling reference | RTM, REF | REFERENCE | WAVE 3 | NOT STARTED | broad support text, not likely a first-pass priority |
| `against-the-gods-the-remarkable-story-of-risk-1996-peter-l-bernstein.pdf` | Risk / uncertainty / volatility | history of risk, probabilistic framing, uncertainty culture | VRM, RTM | SUPPORTIVE | WAVE 4 | NOT STARTED | useful for risk worldview and decision realism |
| `Thinking in Bets PDF.pdf` | Risk / uncertainty / volatility | decision quality under uncertainty, scenario framing | RTM, RAL | CORE | WAVE 3 | NOT STARTED | belongs earlier than some risk books because it improves testing discipline |
| `philip_e._tetlock_-_superforecasting_the_art_and_science_of_prediction.pdf` | Risk / uncertainty / volatility | calibration, humility, uncertainty handling | RTM, RAL | CORE | WAVE 3 | NOT STARTED | supports research and review discipline strongly |
| `Dynamic_Hedging-Taleb.pdf` | Risk / uncertainty / volatility | nonlinear risk, convexity, volatility regime awareness | VRM, ECS | CORE | WAVE 4 | NOT STARTED | high-value hostile-environment realism source |
| `Option Volatility and Pricing.pdf` | Risk / uncertainty / volatility | volatility and implied-risk thinking | VRM, REF | SUPPORTIVE | WAVE 4 | NOT STARTED | useful conceptually, but options-specific details must be filtered |
| `Volatility Trading, + Website-Wiley (2013).pdf` | Risk / uncertainty / volatility | vol products, regime concepts, volatility behavior | VRM | SUPPORTIVE | WAVE 4 | NOT STARTED | useful for volatility-state language, not direct spot-price doctrine |
| `MathematicsMoneyManagement.pdf` | Risk / uncertainty / volatility | position sizing and money-management ideas | RTM, REF | SUPPORTIVE | WAVE 4 | NOT STARTED | useful later, but should not override strategy-context logic |
| `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf` | Risk / uncertainty / volatility | tail-risk awareness, anti-fragility mindset | VRM, RAL | SUPPORTIVE | WAVE 4 | NOT STARTED | strong warning source against fragile assumptions |
| `Daniel Kahneman-Thinking, Fast and Slow  .pdf` | Behavioral / psychology / adaptation | cognitive bias map, decision errors | RAL | CORE | WAVE 5 | NOT STARTED | review-layer essential, not market-state source |
| `Misbehaving_The_Making_of_Behavioral_Economics_by_.pdf` | Behavioral / psychology / adaptation | real-world deviations from rationality | RAL | SUPPORTIVE | WAVE 5 | NOT STARTED | helps review logic and behavior framing |
| `The Hour Between Dog and Wolf PDF.pdf` | Behavioral / psychology / adaptation | trader state, physiology of risk-taking, stress context | RAL | SUPPORTIVE | WAVE 5 | NOT STARTED | useful for operator review prompts and live-test reflection |
| `Adaptive Markets.pdf` | Behavioral / psychology / adaptation | evolutionary market behavior, changing environmental fit | MSC, RAL, RTM | CORE | WAVE 5 | NOT STARTED | key bridge between market-state realism and adaptation logic |
| `Subconscious Mind Power How to Use the Hidden Power of Your Subconscious Mind ( PDFDrive ).pdf` | Behavioral / psychology / adaptation | possible mindset reference | REF | REFERENCE | LATER | NOT STARTED | not core trading-blueprint material |
| `Reality transurfing. Steps I-V ( PDFDrive ).pdf` | Behavioral / psychology / adaptation | symbolic / mindset reference | REF | REFERENCE | LATER | NOT STARTED | do not promote into core Aurora logic |
| `A Random Walk Down Wall Street - The Time-Tested Strategy for Successful Investing 11th edition 2015.epub` | Investing / fundamental / long-horizon | market efficiency critique baseline | REF | REFERENCE | LATER | NOT STARTED | useful as challenge source to active-trading claims |
| `Common Stocks and Uncommon Profits and Other Writings 2nd edition 2003.pdf` | Investing / fundamental / long-horizon | business-quality and investing perspective | REF | REFERENCE | LATER | NOT STARTED | not short-horizon setup architecture |
| `The Intelligent Investor - A Book of Practical Counsel 2003.mobi` | Investing / fundamental / long-horizon | conservative decision framing, value-investing philosophy | REF | REFERENCE | LATER | NOT STARTED | worldview support only |
| `One Up On Wall Street 2000.epub` | Investing / fundamental / long-horizon | practical investing heuristics | REF | REFERENCE | LATER | NOT STARTED | not a current Aurora trading engine source |
| `The Little Book That Beats the Market 2006.pdf` | Investing / fundamental / long-horizon | simple factor/system framing | REF | REFERENCE | LATER | NOT STARTED | long-horizon and style-specific |
| `Beating the Financial markets.pdf` | Investing / fundamental / long-horizon | broad market outperformance framing | REF | REFERENCE | LATER | NOT STARTED | reference until explicitly evaluated |
| `How-Countries-Go-Broke.pdf` | Macro / debt / cross-asset | sovereign debt and macro fragility context | REF, later macro overlay | SUPPORTIVE | LATER | NOT STARTED | useful for future macro-context support, not near-term core |
| `principles-for-navigating-big-debt-crises-paperbacknbsped-1732689806-9781732689800_compress.pdf` | Macro / debt / cross-asset | debt cycles, macro regime framing | REF, later macro overlay | SUPPORTIVE | LATER | NOT STARTED | likely future macro-context source |
| `EXPECTED RETURNS ON MAJOR.pdf` | Macro / debt / cross-asset | long-horizon return expectation context | REF | REFERENCE | LATER | NOT STARTED | reference-only for now |
| `BFI_WP_2023-100.pdf` | Macro / debt / cross-asset | academic macro/finance research context | REF | REFERENCE | LATER | NOT STARTED | unknown exact value until opened |
| `pdfcoffee.com_value-based-power-trading-pdf-free.pdf` | Specialized / energy / misc | power/energy market specialization reference | REF | REFERENCE | LATER | NOT STARTED | domain-specialized; keep out of core until needed |
| `toaz.info-value-based-power-trading-pr_675b73dba1cfa97402b06b798a4d8f29.pdf` | Specialized / energy / misc | reinforcement of power-trading specialization | REF | REFERENCE | LATER | NOT STARTED | same as above |
| `L-G-0000569355-0015276344.pdf` | Specialized / misc unknown | unknown until opened | REF | REFERENCE | LATER | NOT STARTED | unknown source, must be inspected before any mapping |

---

# 3. CLUSTER SUMMARIES

## 3.1 Wave 1 core cluster
Primary purpose:
- build Aurora’s first stable market-state language
- ground execution-context realism
- avoid fake chart-only simplifications that ignore market mechanics

Highest-priority sources:
- `James_Dalton-Markets_in_Profile-EN.pdf`
- `Mind OverMarket.pdf`
- `Auction Theory.pdf`
- `AUCTION THEORY; A GUIDED TOUR.pdf`
- `market-microstructure-theory_compress.pdf`
- `dokumen.pub_trading-and-exchanges-market-microstructure-for-practitioners-9780195144703-0-19-514470-8.epub`

## 3.2 Wave 2 core cluster
Primary purpose:
- convert broad pattern literature into a filtered strategy-family and setup-pattern structure
- preserve useful chart language without letting canned pattern logic dominate Aurora

Highest-priority sources:
- `John_J._Murphy_-_Technical_Analysis_Of_The_Financial_Markets.pdf`
- `pcmbrokers_(Wiley finance series) Adam Grimes.pdf`
- `Bulkowski ,Thomas N.Encyclopedia of Chart Patterns.pdf`
- `Steve_Nison-Japanese_Candlestick_Charting_Techniques-EN.pdf`

## 3.3 Wave 3 core cluster
Primary purpose:
- build the research discipline that keeps strategy extraction testable and honest

Highest-priority sources:
- `Evidence-Based Technical Analysis - Applying the Scientific Method and Statistical Inference to Trading Signals 2007.pdf`
- `Systematic Trading PDF.pdf`
- `Thinking in Bets PDF.pdf`
- `philip_e._tetlock_-_superforecasting_the_art_and_science_of_prediction.pdf`
- `Quantitative Trading_ How to Build Your Own Algorithmic Trading Business-Wiley (2008).pdf`

## 3.4 Wave 4 core cluster
Primary purpose:
- teach Aurora when market environments become hostile, nonlinear, or volatility-sensitive

Highest-priority sources:
- `Dynamic_Hedging-Taleb.pdf`
- `Option Volatility and Pricing.pdf`
- `Volatility Trading, + Website-Wiley (2013).pdf`
- `the-black-swan_-the-impact-of-the-highly-improbable-second-edition-pdfdrive.com-.pdf`

## 3.5 Wave 5 core cluster
Primary purpose:
- strengthen review discipline, adaptation logic, and operator-bias awareness

Highest-priority sources:
- `Adaptive Markets.pdf`
- `Daniel Kahneman-Thinking, Fast and Slow  .pdf`
- `Misbehaving_The_Making_of_Behavioral_Economics_by_.pdf`
- `The Hour Between Dog and Wolf PDF.pdf`

---

# 4. INDEX MAINTENANCE RULES

This file must be updated whenever:
- a book is opened for serious work
- a book’s extraction status changes
- a new target module relationship is discovered
- a book is downgraded to reference-only
- a book is split across multiple Aurora modules more precisely

This file must remain conservative.
It should never claim completed extraction without explicit supporting work in the target module files.

---

# 5. CURRENT JUDGMENT

At this stage, the Aurora archive is now inventory-mapped at the source level, but not yet concept-extracted.

The next highest-value move is:
1. create `AURORA_MARKET_STATE_CANON.md`
2. begin Wave 1 extraction from Dalton, Mind Over Markets, Auction Theory, and the microstructure texts
3. convert the first market-language pass into canonical Aurora state and concept objects

This file exists to prevent future chats from losing track of the source universe while deeper extraction is still incomplete.
