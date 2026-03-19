# 04 ASC Surface Ranking and Deep Enrichment

## 1. Layer 1 market truth contract

Layer 1 answers one question first:

> Is this symbol truly open enough to remain in active competition now?

### 1.1 Triple confirmation rule
Closed truth must not be declared from broker flags alone.

Use three evidence paths:

#### Evidence A: live quote usability
- bid readable
- ask readable
- both positive and structurally usable

#### Evidence B: live tick evidence
- tick exists
- tick timestamp available
- tick freshness within policy threshold

#### Evidence C: broker session/trade reference
- quote session windows
- trade session windows
- trade mode
- session metadata
- next open reference where available

### 1.2 Decision outcomes
- `OPEN_TRADABLE`
- `CLOSED_SESSION`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `NO_QUOTE`
- `STALE_FEED`
- `UNKNOWN`

### 1.3 Truth policy
- broker session reference informs timing and future rechecks
- live quote + live tick dominate present-open truth
- conflicting evidence becomes pending/uncertain truth, not fake closure

### 1.4 Layer 1 output fields
- market state
- session state
- quote freshness
- tick freshness
- reason code
- next recheck time
- next expected open time
- evidence confidence

## 2. Layer 1.2 broker snapshot contract

Layer 1.2 captures full-universe broker truth separate from ranking.

### 2.1 Snapshot purpose
- preserve discoverable universe membership
- preserve broker-provided instrument fields
- support later conditions and cost awareness
- carry known truth even for currently closed symbols

### 2.2 Required snapshot fields
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
- order mode
- fill mode
- session summaries
- snapshot timestamp
- unknown / suspicious markers

### 2.3 Suspicious-zero policy
A zero field is not silently accepted when it is probably bad.

Handle each field as:
- valid zero
- suspicious zero
- unreadable
- missing
- broker-explicit zero

## 3. Layer 2 surface competition

Layer 2 is the broad open-symbol competition layer.

Its job is to cheaply determine the strongest top candidates per bucket.

### 3.1 Layer 2 population
Only symbols that are not currently closed enter active competition.

Closed symbols remain in the universe but do not compete until open again.

### 3.2 Layer 2 philosophy
Ranking is not hard gating.  
Ranking is structured preference.

Weak truth lowers score; it does not usually erase the symbol.

### 3.3 Core score families

#### A. Cost efficiency family
Measures how expensive the symbol is relative to its usable movement.

Signals include:
- spread size
- spread relative to point / ATR / realized range
- freeze and stops burden
- tick value usability
- contract size usability
- volume rule friendliness

#### B. Movement quality family
Measures whether the symbol is actually moving enough to matter.

Signals include:
- recent realized range
- ATR ratios
- movement continuity
- session-aligned activity
- expansion versus dead drift

#### C. Execution usability family
Measures whether the symbol is practically usable.

Signals include:
- trade mode support
- order/fill mode acceptability
- volume min/max/step coherence
- suspicious economics penalties
- classification clarity

#### D. Data quality family
Measures how trustworthy the current reading is.

Signals include:
- fresh quote
- fresh tick
- snapshot completeness
- history sufficiency
- continuity stability
- unresolved fields penalties

#### E. Environment family
Measures the current operating environment.

Signals include:
- active or quiet regime
- compression versus expansion
- directional cleanliness versus noisy chop
- session energy
- near-open / post-open behavior
- spread regime stability

### 3.4 Penalty family
Strong penalties apply for:
- stale feed
- no quote
- suspicious zero economics
- thin history
- unresolved bucket
- degraded continuity
- high friction relative to movement
- incoherent broker fields

## 4. Surface score model

The exact numeric coefficients may be tuned later, but the blueprint intent is fixed:

### 4.1 Suggested high-level weighting
- cost efficiency: 30%
- movement quality: 25%
- execution usability: 20%
- data quality: 15%
- environment quality: 10%

Then apply penalties.

### 4.2 Promotion floors
A symbol may remain surface-visible even with a mediocre score.  
Promotion to top-5 summary should require:
- active market truth
- enough current fields to justify comparison
- score above a floor appropriate to the bucket

### 4.3 Bucket quota law
Top 5 is a maximum, not an obligation.

If a bucket only has three good symbols, publish three.

Do not pad the summary with junk to satisfy a quota.

## 5. Bucket logic

### 5.1 Primary bucket
Every symbol competes first within its `PrimaryBucket`.

### 5.2 Unknown bucket handling
Unknown classification may remain visible in the universe dump, but it should carry a heavy ranking penalty and should not routinely win promotion unless evidence quality is otherwise exceptional and policy explicitly allows it.

### 5.3 Cross-bucket fairness
No bucket may steal another bucket’s ranking space.

## 6. Promotion model

### 6.1 Promotion rights
Promotion means:
- this symbol receives Layer 3 budget
- this symbol is eligible for summary leadership
- this symbol may receive faster deep-refresh cadences

### 6.2 Promotion does not mean
- permanent deep ownership
- deletion of weaker symbols
- hard exclusion of non-promoted symbols from the universe dump

### 6.3 Promotion churn control
To avoid thrashing:
- minor score noise should not constantly reshuffle deep rights
- tie-break rules should stabilize close contests
- demotion should freeze, not delete, recent deep context

## 7. Layer 3 deep enrichment

Layer 3 exists only for promoted symbols and carefully chosen near-promoted symbols if budget allows.

### 7.1 Deep domains
- rolling tick window
- M1 OHLC ring
- M5 OHLC ring
- M15 OHLC ring
- H1/H4/D1 rings
- ATR families
- EMA/RSI or other later approved indicators
- regime and environment
- friction and cost persistence
- continuity and freshness diagnostics

### 7.2 Deep purpose
Provide enough context that a trader-facing consumer can decide which of the promoted leaders deserves attention without the EA pretending to be the trade decision-maker.

### 7.3 Deep output philosophy
The deep block should be:
- bounded
- readable
- current enough
- explicit about freshness
- explicit about pending domains

## 8. Regime and environment split

### 8.1 Surface regime
Cheap broad regime fields belong in Layer 2:
- quiet
- active
- compressing
- expanding
- directional
- rotational
- unstable

### 8.2 Deep regime
Richer regime fields belong in Layer 3:
- multi-timeframe structure
- range/trend bias context
- volatility persistence
- environment quality
- drift between timeframes

## 9. Cost awareness

The system must remain cost-aware at every ranking layer.

### 9.1 Cost matters in surface
A symbol with huge movement but terrible spread, stops, freeze, or unusable economics must be penalized hard.

### 9.2 Cost matters in deep
Deep enrichment should preserve:
- relative spread regime
- friction trends
- stability of execution conditions
- whether movement quality remains worth the cost burden

## 10. Summary requirements for trader-chat usefulness

The top-5-by-bucket summary must expose enough data for a trader-facing consumer to choose among leaders without reading every full symbol file.

Required leader fields:
- symbol
- bucket
- market freshness
- surface score
- score family highlights
- key penalties
- spread/cost summary
- movement summary
- environment/regime summary
- last deep refresh age if promoted
- pointer to symbol file

## 11. Symbol file deep section requirements

A promoted symbol file should expose:
- current market truth
- current broker conditions
- rolling timeframe freshness
- ATR and movement context
- regime/environment context
- key penalties and caveats
- continuity origin and stale warnings

## 12. Failure points and countermeasures

### 12.1 Quiet symbols rank well due to low spread
Fix:
- cost must be relative to movement, not absolute

### 12.2 Fast-moving garbage symbols dominate
Fix:
- heavy penalties for suspicious economics, stale feed, degraded continuity, weak history

### 12.3 Thin buckets fill with trash
Fix:
- top-5 ceiling only; enforce quality floor

### 12.4 Deep churn from tiny score changes
Fix:
- promotion hysteresis and tie-break stability

### 12.5 Layer 3 redefines Layer 2 truth
Fix:
- deep layer enriches; it does not own active market truth or broad ranking authority

## 13. What to carry forward from old systems

### Preserve
- broad heartbeat first
- shortlist-only heavy work
- explicit stale/degraded states
- freeze-over-delete on demotion
- bounded readable deep symbol packages

### Adapt
- dossier-first / summary-last into symbol-file-first / summary-last
- deeper analytics into promoted deep context only

### Reject
- giant deep output dumps for the full universe
- hidden ranking inside prose-like files
