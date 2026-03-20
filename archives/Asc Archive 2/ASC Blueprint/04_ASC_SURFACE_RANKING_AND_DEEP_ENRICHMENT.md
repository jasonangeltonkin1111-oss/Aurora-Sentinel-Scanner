# 04 ASC Surface Ranking and Deep Enrichment

## 1. Overview

This document defines the scanning layers that matter most to trader usefulness:

- Layer 1 market truth
- Layer 1.2 broker snapshot
- Layer 2 surface competition
- promotion logic
- Layer 3 deep enrichment

It is where ASC decides **what deserves attention**, without pretending to be the trading brain.

## 2. Layer 1 market truth contract

Layer 1 answers:

> Is this symbol truly open enough to remain in active competition now?

### 2.1 Triple confirmation rule
Closed truth must not be declared from broker flags alone.
Use three evidence paths:

#### Evidence A — live quote usability
- bid readable
- ask readable
- both positive and structurally usable

#### Evidence B — live tick evidence
- tick exists
- tick timestamp available
- freshness within policy threshold

#### Evidence C — broker session/trade reference
- quote sessions
- trade sessions
- trade mode
- next-open reference where available

### 2.2 Decision outcomes
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`

### 2.3 Truth policy
- broker session reference informs timing and future rechecks
- live quote + live tick dominate present-open truth
- conflicting evidence becomes pending or weak truth, not fake closure

### 2.4 Layer 1 output fields
- market state
- session state
- quote freshness
- tick freshness
- reason code
- next recheck time
- next expected open time
- evidence confidence

## 3. Layer 1.2 broker snapshot contract

Layer 1.2 captures full-universe broker truth separate from ranking.

### 3.1 Purpose
- preserve discoverable universe membership
- preserve broker-provided instrument fields
- support cost awareness and conditions analysis
- preserve known truth even for closed symbols

### 3.2 Required snapshot fields
- raw symbol
- normalized/canonical symbol
- description/path/exchange
- broker sector/industry if present
- asset class
- primary bucket
- digits
- point
- tick size
- tick value
- contract size
- volume min/max/step/limit
- stops level
- freeze level
- calc mode
- margin/profit modes
- order/fill modes
- session summaries
- snapshot timestamp
- suspicious/missing markers

### 3.3 Suspicious-zero policy
A zero field is not silently accepted when probably wrong.
Each field must land as one of:
- valid zero
- broker-explicit zero
- suspicious zero
- unreadable
- missing

## 4. Layer 2 surface competition

Layer 2 is the broad open-symbol competition layer.
It exists to cheaply find the strongest current leaders per bucket.

### 4.1 Eligible population
Symbols that are not currently closed enter active competition.
Closed symbols remain represented in the universe but do not compete until open again.

### 4.2 Ranking philosophy
Ranking is structured preference, not overuse of hard gating.
Weak truth lowers score; it does not usually erase the symbol.

### 4.3 Surface score families

#### A. Cost efficiency family
Measures how expensive the symbol is relative to usable movement.
Signals may include:
- current spread
- spread relative to point
- spread relative to ATR/range
- stops/freeze burden
- tick value usability
- volume friendliness

#### B. Movement quality family
Measures whether the symbol is actually moving enough to matter.
Signals may include:
- realized short-range movement
- ATR ratios
- movement continuity
- expansion versus dead drift
- session-aligned activity

#### C. Execution usability family
Measures whether the symbol is practically usable.
Signals may include:
- trade mode support
- fill/order mode acceptability
- volume-rule coherence
- classification clarity
- economics trust level

#### D. Data quality family
Measures whether the current read is trustworthy.
Signals may include:
- fresh quote
- fresh tick
- snapshot completeness
- history sufficiency
- continuity stability
- unresolved field penalties

#### E. Environment family
Measures current operating environment.
Signals may include:
- quiet vs active regime
- compression vs expansion
- directional cleanliness vs noisy chop
- session energy
- near-open / post-open behavior
- spread regime stability

### 4.4 Penalty family
Strong penalties apply for:
- stale feed
- no quote
- suspicious-zero economics
- thin history
- unresolved bucket/classification
- degraded continuity
- incoherent broker fields
- excessive friction relative to movement

## 5. Score model

The exact coefficients may be tuned later, but the score structure is fixed.

### 5.1 Suggested high-level weighting
- cost efficiency: 30%
- movement quality: 25%
- execution usability: 20%
- data quality: 15%
- environment quality: 10%

Then apply penalties.

### 5.2 Normalization law
Each family score must be normalized to avoid one raw metric dominating solely because of scale.

### 5.3 Floor law
A symbol may remain visible in the universe with a mediocre score.
Promotion to summary leadership requires score above a bucket-appropriate floor.

## 6. Bucket logic

### 6.1 Primary bucket
Every symbol competes first within `PrimaryBucket`.

### 6.2 Unknown bucket handling
Unknown classification may remain visible in the universe dump but should carry a heavy surface penalty and should not routinely win promotion unless policy explicitly allows it.

### 6.3 Bucket quota law
Top 5 is a ceiling, not an obligation.
If a bucket has only two or three good candidates, publish fewer than five.
Do not pad with junk.

## 7. Cost awareness

### 7.1 Surface level
A symbol with large movement but terrible spread, freeze, stops, or unusable economics must be penalized hard.

### 7.2 Deep level
Deep enrichment must preserve whether movement remains worth the friction burden.
Cost is not a one-time static field; it has regime and persistence.

## 8. Regime and environment split

### 8.1 Surface regime
Cheap broad regime belongs in Layer 2:
- quiet
- active
- compressing
- expanding
- directional
- rotational
- unstable

### 8.2 Deep regime
Richer regime belongs in Layer 3:
- multi-timeframe structure
- trend/range context
- volatility persistence
- timeframe disagreement
- environment durability

## 9. Promotion model

### 9.1 Promotion rights
Promotion means:
- receives Layer 3 budget
- may appear as a leader in the summary
- may refresh on faster deep cadences

### 9.2 Promotion does not mean
- permanent privilege
- deletion of weaker symbols
- exclusion from the universe dump for non-promoted symbols

### 9.3 Hysteresis and churn control
To avoid thrashing:
- small score noise should not constantly reshuffle the promoted set
- tie-break rules must stabilize close contests
- symbols already promoted may retain deep rights unless clearly displaced

### 9.4 Near-promoted allowance
A very small number of near-promoted candidates may receive limited deep budget if healthy runtime budget allows.
This prevents the summary from being blind to rapidly improving candidates.

## 10. Layer 3 deep enrichment

Layer 3 exists for promoted symbols and carefully chosen near-promoted symbols only.

### 10.1 Deep domains
- bounded tick window
- M1/M5/M15/H1/H4/D1 OHLC rings
- ATR families
- approved indicator families
- regime and environment
- friction persistence
- continuity/freshness diagnostics

### 10.2 Deep purpose
Provide enough context that a trader-facing consumer can decide which promoted leader deserves attention, without the EA pretending to make the trade decision.

### 10.3 Deep output law
The deep block must be:
- bounded
- readable
- freshness-aware
- pending-aware
- explicit about degraded domains

## 11. Deep cadence by domain

### 11.1 10-second domain
- tick window maintenance
- micro spread regime
- micro freshness

### 11.2 1-minute domain
- M1 OHLC
- short tactical stats
- recent spread context

### 11.3 5-minute domain
- M5 OHLC
- M5 ATR
- short intraday environment

### 11.4 15-minute domain
- M15 OHLC
- M15 ATR
- medium context and regime drift

### 11.5 60-minute domain
- H1 OHLC
- H1 ATR
- slower environment/cost persistence

### 11.6 New-bar-only domain
- H4
- D1
- slower families

## 12. Trader summary requirements

For each promoted leader, the summary must expose enough information for a trader-facing consumer to choose among leaders without reading every symbol file.
Required leader fields:
- symbol
- bucket
- market freshness
- surface score
- score family highlights
- key penalties
- spread/cost headline
- movement headline
- environment/regime headline
- last deep refresh age
- symbol-file pointer

## 13. Edge cases

### 13.1 Quiet cheap symbols
Low spread alone must not make a quiet dead symbol look attractive.
Movement-relative cost matters.

### 13.2 Fast-moving garbage symbols
Violent movement alone must not dominate if economics or freshness are poor.

### 13.3 Market just opened
Near-open and just-open behavior may need penalties for unstable spreads and incomplete early evidence.

### 13.4 Stale but visible quotes
Stock-like products may show plausible last prices while closed.
Freshness and session evidence must punish them heavily.

### 13.5 Crypto-like products
Do not let weak session metadata force fake closure or exclusion when live tick/quote evidence remains strong.

## 14. Failure points and countermeasures

### 14.1 Thin buckets fill with trash
Countermeasure:
- top-5 ceiling only
- bucket quality floors

### 14.2 Deep churn from tiny score changes
Countermeasure:
- hysteresis and tie-break stability

### 14.3 Layer 3 redefines Layer 2 truth
Countermeasure:
- deep layer enriches; it does not own present market truth or broad ranking authority

### 14.4 Promotion starvation of broad coverage
Countermeasure:
- promotion gives budget rights only within the kernel’s fairness budget

## 15. What is preserved from old systems

### Preserve
- broad heartbeat first
- shortlist-only heavy work
- explicit stale/degraded states
- freeze-over-delete on demotion
- bounded readable symbol packages

### Adapt
- dossier-first / summary-last becomes symbol-file-first / summary-last
- later analytics become promoted deep context only

### Reject
- full-universe deep dumps
- hidden ranking buried in prose
- giant deep output for every symbol all the time
