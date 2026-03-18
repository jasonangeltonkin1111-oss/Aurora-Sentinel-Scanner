## 1. Overall red-team verdict

**BUILD RISK**
Phase 1 is still buildable, but it is not small. It is a full scanner foundation plus broker-hardening-lite plus usability foundation. The main danger is not coding volume by itself. The danger is that several “small” items in the blueprint are actually ambiguity multipliers: classification normalization, economics sanity, friction/activity realism, and mode-selective inspection. Those can quietly turn one phase into three phases’ worth of edge handling.

**DESIGN RISK**
The architecture is mostly sound and does not need redesign. The biggest structural risk is that `ScanRecord` becomes a dumping ground for unresolved semantics, especially around economics trust, practicality, freshness, and ranking inputs. If field meanings are not frozen now, Phase 2+ will become repair work instead of additive growth.

**LIVE RISK**
The most dangerous live failure mode is false confidence: symbols appear valid, rank highly, and look clean in the HUD, while one or more of these is wrong under real broker conditions: tick economics, quote freshness, session state, spread realism, or classification aliasing. The scanner can be “working” while being wrong in the exact places a trader will trust most.

**WATCH**
You are very close to the boundary where a practical grouped design can stay disciplined or become a hidden monolith. The wrapper, `MarketCore`, and `OutputDebug` are the three places most likely to absorb too much.

---

## 2. Biggest Phase 1 risks

**BUILD RISK**
Phase 1 is still too big for “usable ASAP” if implemented literally at equal fidelity across all asset classes in one pass. The biggest risk to usable ASAP is not ranking or HUD. It is **Step 5 + Step 7 together**: economics sanity across broker asset classes plus friction/activity realism. Those are where MT5 symbols stop behaving uniformly.

**BUILD RISK**
The biggest sinkhole is **Step 5 Market/spec/economics core**. It looks contained, but it is where you discover:

* broker-specific tick value oddities
* profit currency vs margin currency mismatches
* contract-size inconsistencies
* CFD calc-mode variance
* symbols that are visible but practically unusable
* symbols where raw fields exist but derived economics are misleading

That step can consume disproportionate build time because every later step depends on trusting it enough.

**DESIGN RISK**
The Phase 1 step most likely to create future structural pain if done badly now is **Step 4 classification normalization + canonical mapping**. If raw symbol → canonical identity is fuzzy, everything downstream gets contaminated:

* duplicate economic comparisons
* duplicate shortlist entries
* bad bucket grouping
* wrong correlation interpretation
* bad cross-broker consistency later

A sloppy classification layer will force future repair work across every module.

**SIMPLIFY NOW**
Minimum safe Phase 1 that still keeps the scanner useful:

* universe load
* scope filtering
* classification with hard quarantine
* minimal economics sanity only for tradability/practicality gates
* ATR M15/H1
* current spread + simple sampled median spread
* basic tick age / update count freshness
* eligibility
* compact ranking
* shortlist correlation on finalists only
* Top 3 per bucket
* clean Trader HUD

What should be reduced in ambition now:

* do not overbuild “coarse validation” into pseudo-Phase-2 economics certainty
* do not make liveliness/freshness a sophisticated model yet
* do not let ranking become a multi-factor theory project
* do not produce too many debug artifact types before the core contracts stabilize

**SIMPLIFY NOW**
The part that must be simplified even if elegant on paper is **friction/activity scoring**. In Phase 1, it should stay interpretable:

* spread state
* tick age
* update count
* one freshness/liveliness score each
  Not a layered microstructure model. Otherwise you will spend too much time explaining scores you do not yet trust.

**BUILD RISK**
The Phase 1 step most likely to quietly become a sinkhole after implementation begins is **Step 10 shortlist correlation** if you allow:

* inconsistent bar alignment
* cross-asset correlation without guardrails
* insufficient history window normalization
* duplicate canonical underlyings
* one symbol correlating to a synthetic cousin rather than a true peer

It is safe only if kept strictly shortlist-only and context-only.

---

## 3. Biggest design risks

**DESIGN RISK**
The most important contract to freeze now is the semantic contract of `ScanRecord`. Not just field names. Field meaning. Especially:

* what counts as raw vs derived vs validated
* what each trust/status field means
* whether scores are normalized, bounded, or ordinal
* whether reject/weak codes are cumulative or first-hit
* whether missing data is different from failed data

If those meanings drift, growth will not be additive.

**DESIGN RISK**
`AFS_MarketCore.mqh` is the grouped module most likely to become overloaded later. It already owns:

* raw spec reading
* economics derivation
* validation
* asset-class-aware handling
* margin/tick/contract sanity

That is a lot of semantic authority. If later phases add more correctness logic there without contract boundaries, `MarketCore` becomes the hidden brain of the system.

**DESIGN RISK**
The wrapper is also a future entanglement risk because it already owns:

* settings
* lifecycle
* mode
* timer
* call order
* HUD
* top-level logging
* export decisions

That is okay only if it remains orchestration-only. The minute module-specific exception logic starts accumulating in the wrapper, repair work begins.

**DESIGN RISK**
`OutputDebug` is at risk of becoming a second monolith. Export formatting, anomaly logging, summary generation, and mode-specific visibility can easily become a place where business logic leaks. Output code must not decide eligibility meanings, ranking meanings, or trust semantics.

**WATCH**
What should remain internal helper logic and not become separate modules:

* score normalization helpers
* field formatting helpers
* HUD text layout helpers
* alias cleanup helpers used only by Classification
* spread sample summarization helpers used only by HistoryFriction

Those are helpers, not architecture.

**WATCH**
What should be watched so this does not become an ISSX-style monster:

* proliferation of status fields with overlapping meanings
* too many toggles that can create invalid mode combinations
* module-specific special cases living in wrapper
* too many debug file types
* ranking score additions before field semantics are stable
* “temporary” broker exceptions that never get formalized

---

## 4. Biggest live-runtime broker risks

**LIVE RISK**
The most dangerous calculations if wrong are:

* spread/ATR ratio
* movement capacity score
* cost efficiency score
* any normalization relying on tick value / tick size / contract size
* freshness/liveliness gating
* shortlist correlation when symbols are duplicates or session-misaligned

These directly affect whether a symbol survives and ranks high.

**LIVE RISK**
Deposit-currency normalization is likely to go wrong where:

* profit currency differs from deposit currency and conversion symbol is missing or stale
* broker-provided tick value is account-currency dependent but inconsistent
* CFDs expose usable raw values that do not behave consistently in practice
* inverse/quoted relationships are assumed but not available
* weekend or off-session conversion quotes are stale but not obviously dead

A scanner can look right numerically while being economically wrong enough to distort ranking.

**LIVE RISK**
Types of symbols most likely to break assumptions:

* stock CFDs with exchange-session gaps
* cash indices vs futures-like index CFDs
* metals with non-FX-like point/tick conventions
* crypto symbols with broker-specific contract sizing
* JPY pairs due to quote precision habits
* broker suffix/prefix variants that normalize incorrectly
* synthetic/mini/micro variants sharing a canonical name when they should not
* symbols visible in Market Watch but not really tradable now

**LIVE RISK**
Behavior that differs most across brokers:

* symbol naming and aliasing
* tick value reliability
* contract size conventions
* quote update behavior for off-session CFDs
* spread widening regimes
* trade mode / symbol visibility semantics
* history completeness by timeframe
* whether inactive symbols keep last quote appearing “fresh enough”

**LIVE RISK**
False confidence happens even if code looks correct when:

* `SYMBOL_TRADE_MODE` says usable but session is effectively closed
* current spread is fine but sampled regime is bad
* ATR is present but history is thin, stale, or structurally unrepresentative
* tick age is low because one recent update occurred, while actual liveliness is poor
* classification says equity/sector bucket but the instrument is a synthetic basket CFD
* raw tick value is accepted without validated disagreement tracking

**TEST FIRST**
Across FX, JPY, metals, indices, stock CFDs, crypto, and odd symbols, early live testing must cover:

* raw `Point`, `TickSize`, `Digits`, `TickValueRaw`, `ContractSize`
* derived pip-like movement assumptions
* spread units vs price units vs ATR units
* session-open vs visible-but-dead behavior
* M15/H1 bar sufficiency and recency
* update count meaning during quiet periods
* whether one canonical maps to multiple broker variants incorrectly
* whether shortlist duplicates survive under different raw symbols

**TEST FIRST**
Raw / derived / validated disagreements that should be explicitly logged:

* raw tick value vs validated P/L behavior
* raw margin expectations vs `OrderCalcMargin`
* raw tradable/visible flags vs actual practicality status
* raw quote timestamp vs computed freshness state
* classification canonical vs symbol spec family mismatch
* derived cost efficiency vs reject/weak result
* ATR present vs bars sufficiency / recency state
* current spread vs median spread vs max spread disagreement
* canonical identity vs correlation duplicate suspicion

**LIVE RISK**
One major omission risk in the blueprint is that “economics sanity” can become overly centered on margin/tick math while underweighting session/tradability realism. For a scanner, a symbol that is economically sane but operationally inactive is still a bad survivor.

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK**
The settings design is at risk of contradictory state combinations. The worst offender is having both:

* `DevMode`
* `TraderMode`
  as booleans

That creates illegal combinations unless one is strictly derived from the other. Two booleans for one mode choice is a human-factors trap.

**SIMPLIFY NOW**
Mode selection should behave as one authoritative mode state, even if the internal blueprint keeps both concepts. The UI must not allow:

* both true
* both false with ambiguous fallback
* Trader Mode selected while Phase 1 gate silently blocks it

That is confusion waiting to happen.

**BUILD RISK**
The menu is too dense in Phase 1 if all listed toggles are exposed immediately. There are too many overlapping control surfaces:

* Scope filters
* Pipeline toggles
* Testing toggles
* Debug toggles
* Output toggles
* HUD toggles

That is powerful, but also close to operator overload.

**SIMPLIFY NOW**
Settings most likely to become messy:

* `RunX` pipeline toggles plus `TestXOnly` toggles
* `ScanVisibleOnly` vs `ScanSelectedScope`
* multiple export booleans with overlapping intent
* `ShowDebugPanel`, `ShowModuleStates`, `ShowCounts`, `CompactHUD`, correlation preview, etc.

You likely only need one authoritative test target selector, one scope selector, one export selector family, and one HUD density selector.

**DESIGN RISK**
Pipeline toggles and testing toggles currently overlap semantically. That creates future repair risk because you will end up debugging the control system rather than the scanner. A user should not have to reason about both “run” and “test only” states for the same module family.

**WATCH**
The HUD is at risk of overloading in Dev Mode because it wants to show:

* phase
* step
* scope
* module states
* counts
* reject counts
* weak counts
* anomaly counts
* debug preview
* Top 3 preview

That can become unreadable faster than it becomes useful, especially on smaller charts.

**SIMPLIFY NOW**
HUD sections most likely to overload:

* module states
* reject/weak/anomaly count clusters
* debug preview mixed with Top 3 preview
* correlation preview in the same visual plane as trading shortlist

Dev HUD should prioritize “what step am I testing, what scope, what failed, where to inspect next.” Not everything at once.

**LIVE RISK**
Mode behavior likely to confuse a human operator:

* Trader Mode selected but invalid due to incomplete Phase 1
* Dev Mode active with stale prior debug files still present
* scope filters still active from last test, silently narrowing Trader Mode output
* selected-symbol test mode making production output look empty or weak
* bucket filter left on during live trading

Persistent filters are a real operator trap.

---

## 6. What must be simplified now

**SIMPLIFY NOW**
Reduce mode control to one visible mode selector and one explicit validity/status line. Do not make the operator infer mode truth from multiple booleans and gating flags.

**SIMPLIFY NOW**
Collapse pipeline/testing overlap. Keep one mechanism:

* full pipeline
* selected stage
* selected function hard-test
  Not two parallel families that can conflict.

**SIMPLIFY NOW**
Keep Phase 1 economics sanity narrow:

* obvious unusable / suspicious / weak detection
* visible raw/derived/validated disagreement logging
* no attempt at universal broker correctness yet

Trying to make Phase 1 economics “mostly right everywhere” is the fastest way to blow schedule.

**SIMPLIFY NOW**
Keep friction/activity scoring shallow and auditable. The scanner needs usable friction context, not a microstructure engine.

**SIMPLIFY NOW**
Reduce export options exposed in Phase 1. Too many file toggles create noise and support burden. A smaller set is safer:

* final output
* selected scope rows
* anomalies
* module summary
* classification review
  Everything else can be internal or deferred.

**SIMPLIFY NOW**
Do not let `ScanRecord` absorb every convenience field during build. Freeze only fields that are:

* required for downstream logic
* required for operator transparency
* required for future comparability

Temporary diagnostics belong outside the master contract.

---

## 7. What must be live-tested first

**TEST FIRST**
Classification normalization on real broker symbol sets:

* suffix/prefix FX
* metals
* indices
* crypto
* stock CFDs
* broker variants that look identical but are not operationally identical

This is the first thing to break trust system-wide.

**TEST FIRST**
Economics disagreement logging:

* raw symbol properties
* derived unit assumptions
* validated profit/margin checks
* trust grade outcome
* practicality status outcome

Do this before trusting ranking.

**TEST FIRST**
Session and freshness realism:

* off-session stocks
* sleeping CFDs
* weekend/rollover behavior
* quiet FX symbols
* crypto always-on behavior

A scanner that mistakes dead symbols for calm symbols is dangerous.

**TEST FIRST**
Spread regime sampling:

* active session
* rollover / illiquid window
* off-session visible quotes
* metals during event spikes
* index CFDs around session boundaries

Current spread alone is not enough.

**TEST FIRST**
Cross-broker same underlying comparison:

* canonical identity
* economics trust
* rank position
* friction metrics
* shortlist inclusion/exclusion

This is where false portability assumptions get exposed.

**TEST FIRST**
Shortlist correlation:

* obvious duplicates
* same underlying under different raw symbols
* same theme basket proxies
* misaligned session assets
* thin-history names

Correlation context can mislead if duplicate hygiene is weak.

---

## 8. What contracts must be frozen now

**DESIGN RISK**
Freeze the exact semantics of these `ScanRecord` statuses:

* `ClassificationStatus`
* `EconomicsTrust`
* `NormalizationStatus`
* `PracticalityStatus`
* `EligibilityState`

Each must have non-overlapping meaning.

**DESIGN RISK**
Freeze the rule for missing vs weak vs fail. Example:

* missing data
* inconsistent data
* weak-but-usable data
* invalid-for-ranking data
  These cannot blur, or reject/weak logic becomes unstable.

**DESIGN RISK**
Freeze reason-code behavior:

* deterministic order
* multi-code allowed or not
* whether first fatal code stops accumulation
* whether weak codes survive after fail
* whether codes are module-scoped or global-scoped

Without this, debugging history becomes incomparable over time.

**DESIGN RISK**
Freeze score semantics:

* bounded range
* directionality
* whether comparable across asset classes or only within bucket
* whether ranking weights assume standardized inputs
* whether total score is valid when some sub-scores are missing/weak

**DESIGN RISK**
Freeze canonical identity rules:

* when two raw symbols may share a canonical
* when they must remain separate due to contract-size or instrument-family differences
* whether canonical is identity of underlying or tradable instrument class

This is crucial for classification, duplicate control, and correlation.

**DESIGN RISK**
Freeze the wrapper-module authority boundary:

* wrapper orchestrates only
* modules compute only
* outputs report only
* no backdoor orchestration inside grouped modules

That boundary will save future maintenance.

---

## 9. What should be watched so growth stays additive

**WATCH**
Watch `MarketCore` growth. If future phases keep adding “just one more validation” there, it becomes a correctness black box that the rest of the system depends on but cannot reason about.

**WATCH**
Watch ranking inflation. Later phases will tempt you to add more relevance factors. If Phase 1 scoring semantics are not stable and interpretable, later growth will be score churn, not improvement.

**WATCH**
Watch mode/config combinatorics. Every new toggle multiplies states. Add capabilities through scoped selectors and stable enums, not Boolean sprawl.

**WATCH**
Watch classification map governance. The user-owned map is the truth, which is correct, but that also makes it a hidden operational dependency. Version it, diff it, and log which map version produced each output set.

**WATCH**
Watch output artifact creep. Debug convenience can quietly become a second product. Keep exports evidence-oriented, not exhaustive.

**WATCH**
Watch for semantic duplication between:

* practicality
* trust
* eligibility
* weak status
* anomaly status

If too many status systems describe the same failure from different angles, the scanner becomes hard to reason about.

**WATCH**
Watch persistent scope and test filters across sessions. This is one of the easiest ways for a sound system to produce misleadingly narrow outputs in live use.

**WATCH**
What should be logged/versioned/tested first to protect evolution:

* classification map version
* threshold set version
* server name normalization result
* reason-code distribution
* module timing summary
* raw/derived/validated disagreement counts
* final shortlist with supporting fields
* current active mode and active scope at run time

That gives you reproducibility when future changes alter results.

---

## 10. Final hardening recommendations

**BUILD RISK**
Treat Step 4 and Step 5 as the real foundation, not just early steps. If classification identity and economics sanity are only “good enough” in a vague way, every later module will look functional while compounding wrong assumptions.

**SIMPLIFY NOW**
Keep Phase 1 useful, not ambitious. The scanner only needs enough economics and friction realism to avoid obvious junk and rank plausible candidates. Do not try to solve universal broker correctness in Phase 1.

**DESIGN RISK**
Freeze `ScanRecord` semantics and reason-code contracts before expanding implementation. That is the single most important hardening action to prevent future repair work.

**LIVE RISK**
Assume broker raw fields are evidence, not truth. The blueprint is strongest where it keeps raw/derived/validated separate. That separation must remain visible in logs and reviews, especially for economics and freshness.

**SIMPLIFY NOW**
Unify mode behavior and reduce conflicting toggles. Human confusion is not a cosmetic issue here. A scanner with sticky filters, ambiguous mode state, or hidden invalid Trader Mode will cause live misuse.

**TEST FIRST**
Live-test early on the exact symbol families most likely to lie to you:

* JPY FX
* metals
* indices
* stock CFDs
* crypto
* odd suffix/prefix symbols
* off-session instruments

Do not let Phase 1 appear done based mostly on majors.

**WATCH**
Protect the grouped architecture by enforcing ownership:

* wrapper orchestrates
* Classification owns identity truth
* MarketCore owns raw/derived/validated economics mechanics
* HistoryFriction owns movement/freshness evidence
* Selection owns eligibility/ranking/correlation decisions
* OutputDebug reports, never decides

**DESIGN RISK**
The blueprint is viable without redesign. The real red-team conclusion is this: your danger is not the locked architecture. Your danger is semantic drift inside the architecture. If you hard-freeze contracts now and keep Phase 1 shallow where brokers are weird, the system can stay additive. If not, Phase 2 will become hidden repair work.
## 1. Overall red-team verdict

**DESIGN RISK**
The blueprint is **directionally sound and recoverable**, but Phase 1 is still carrying **too much broker-hardening load for something meant to be usable ASAP**. The architecture is not the main danger. The danger is that Phase 1 can look “complete” while still being **quietly wrong** on symbol economics, friction realism, and shortlist comparability across asset classes.

**BUILD RISK**
Phase 1 is **borderline too big**, not because of line count, but because it contains **three sinkhole domains at once**:

1. symbol identity normalization,
2. economics sanity across broker oddities,
3. friction/activity realism across session types.

That combination is where “usable scanner” projects lose months.

**LIVE RISK**
The scanner can produce **very believable but false rankings** if any of these are even slightly wrong:

* spread normalization vs ATR,
* tick freshness / liveliness on off-session symbols,
* contract/tick economics on CFDs/crypto/metals,
* deposit-currency effects,
* correlation based on stale or mismatched history.

**WATCH**
Your locked architecture is not what will break you.
What will break you is **false confidence from apparently clean outputs** produced from partially valid broker data.

---

## 2. Biggest Phase 1 risks

**BUILD RISK**
The biggest threat to the “usable ASAP” goal is **Step 5 + Step 7 together**:

* Step 5: Market/spec/economics core
* Step 7: Friction and activity

Both are deceptively small on paper and ugly in live reality.

**BUILD RISK**
The single biggest sinkhole is **economics sanity**. Not because margin/tick math is hard conceptually, but because MT5 symbol properties are often:

* asset-class dependent,
* broker-dependent,
* internally inconsistent,
* valid only in certain sessions,
* “raw-correct but practically misleading.”

A scanner does not need perfect execution math, but it does need **ranking-safe economics**. That distinction must be enforced or Step 5 balloons.

**BUILD RISK**
The most likely quiet sinkhole is **friction/activity**. Spread sampling, tick age, update count, liveliness, and freshness look compact, but this is where:

* off-session stock CFDs,
* sleeping indices,
* wide-market-open metals,
* 24/7 crypto,
* quiet FX crosses
  all behave differently enough to poison one universal metric.

**DESIGN RISK**
The Phase 1 step most likely to create future structural pain if done badly now is **ScanRecord handling of raw/derived/validated economics and friction confidence**.
If these are flattened too early into one “final usable value,” you will later need structural repair to explain:

* why a symbol ranked highly,
* whether a score came from raw data or validated behavior,
* whether a reject was due to data absence vs actual bad quality.

**SIMPLIFY NOW**
Minimum safe Phase 1 that still keeps the scanner useful:

* universe load,
* classification,
* coarse symbol usability,
* ATR context,
* **simple friction snapshot**,
* eligibility,
* **compact ranking within comparable buckets**,
* shortlist correlation,
* Top 3 per PrimaryBucket,
* clean Dev/Trader mode split.

What should be reduced in Phase 1:

* economics should be **coarse trust grading**, not ambitious cross-asset precision;
* friction should be **simple and explicit**, not pseudo-microstructure;
* ranking should stay **compact and explainable**, not elegant-but-fragile.

**SIMPLIFY NOW**
The part that must be simplified even if elegant is **friction/activity scoring**.
Do not let Phase 1 invent a sophisticated universal activity model.
Phase 1 only needs to answer:
“Is this symbol live enough, fresh enough, and cheap enough relative to movement to deserve attention?”

---

## 3. Biggest design risks

**DESIGN RISK**
The most overloaded future module is **AFS_MarketCore.mqh**.
It already owns:

* universe loading,
* raw spec reading,
* economics derivation,
* coarse validation,
* asset-class-aware handling,
* margin/tick/contract sanity.

That is too many kinds of truth in one place:

* identity truth,
* broker spec truth,
* derived economics truth,
* validation truth.

If left unchecked, MarketCore becomes the future monster.

**DESIGN RISK**
The most important contract to freeze now is the **ScanRecord field contract plus field provenance rules**:

* which fields are raw,
* which are derived,
* which are validated,
* which are temporary,
* which are ranking inputs,
* which are only diagnostic.

If this is not frozen now, every later phase will stuff new convenience values into ScanRecord until it becomes an ambiguous junk drawer.

**DESIGN RISK**
The second most important contract to freeze now is the **reason code contract**:

* deterministic,
* non-overlapping,
* severity-aware,
* machine-stable,
* human-readable.

If reject/weak/anomaly reasons drift over time, Dev Mode loses meaning and ranking explainability collapses.

**DESIGN RISK**
The biggest future entanglement risk is between:

* classification truth,
* eligibility logic,
* ranking logic,
* output presentation.

These must not start encoding each other’s policy.
Examples of bad future entanglement:

* classification starts carrying ranking hints,
* ranking compensates for missing eligibility rules,
* HUD wording becomes a hidden policy layer,
* output formatting depends on internal debug-only states.

**WATCH**
What should remain internal helper logic and not become separate modules:

* score component math,
* small normalization helpers,
* threshold comparators,
* string formatting helpers,
* sort/group utilities,
* light statistical helpers.

If these get promoted into “micro-modules,” the grouped architecture loses the exact benefit you locked in.

**WATCH**
What to watch so this does not become another monster:

* MarketCore gaining every broker exception,
* Selection gaining every future concept,
* OutputDebug becoming a second orchestration layer,
* menu flags becoming a shadow programming language.

---

## 4. Biggest live-runtime broker risks

**LIVE RISK**
The most dangerous calculations if wrong are:

1. **SpreadAtrRatio**
2. **TickAge / freshness**
3. **TickValueRaw-derived practicality assumptions**
4. **ContractSize / TickSize / Point interaction**
5. **cross-symbol comparability of scores**
6. **correlation built on misaligned histories**
7. **session-state interpretation**

Wrong lot math is dangerous in trading systems.
Wrong spread-vs-movement math is dangerous in scanners because it makes **bad symbols look good**.

**LIVE RISK**
What must be live-tested as early as possible:

* symbols that quote but barely update,
* symbols visible but not truly tradable,
* symbols with non-intuitive tick size/point relationships,
* symbols with broker suffix/prefix aliasing,
* symbols with valid history but dead live feed,
* symbols with off-session spreads that explode,
* symbols whose raw economics disagree with calc behavior.

**LIVE RISK**
Symbol types most likely to break assumptions:

* **JPY pairs**: point/pip mental shortcuts break,
* **metals**: size/value/spread conventions vary,
* **indices**: contract logic and session behavior vary wildly,
* **stock CFDs**: off-session and sparse updates poison liveliness,
* **crypto CFDs**: 24/7 behavior exposes stale-feed assumptions,
* **odd broker symbols**: micro contracts, cash indices, synthetic symbols, mini variants, suffix-heavy aliases.

**LIVE RISK**
Behavior that differs most across brokers:

* symbol naming and aliasing,
* contract size,
* tick value meaning,
* margin mode / margin responsiveness,
* quote update frequency,
* spread regime behavior,
* tradability/session handling,
* visible symbol universe defaults,
* history depth,
* stock CFD session coverage,
* whether raw properties are internally coherent.

**LIVE RISK**
Where false confidence happens even if code looks correct:

* raw symbol properties populate successfully, but imply the wrong economic reality;
* ATR is valid, but quotes are stale now;
* spread sample is low because the symbol is dead, not efficient;
* correlation is low because data windows are mismatched, not because symbols are unique;
* a symbol passes eligibility because the rejection logic is spec-based, while runtime tradability is degraded.

**LIVE RISK**
What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:

* classification resolution,
* visibility vs actual scanability,
* raw point/tick/ticksize consistency,
* spread unit interpretation,
* ATR scale sanity,
* session activity patterns,
* freshness under quiet vs dead conditions,
* reject/weak reason consistency,
* ranking stability under mixed asset universes,
* shortlist correlation sanity.

**LIVE RISK**
Where deposit-currency normalization is likely to go wrong:

* assuming tick value already reflects something usable for ranking across all asset classes,
* assuming profit currency and margin currency behave consistently across brokers,
* comparing movement efficiency across symbols without a clean common value basis,
* using partially normalized economics in rankings as if fully normalized.

For a scanner, the key risk is not just bad absolute normalization.
It is **ranking mixed symbols using fake comparability**.

**TEST FIRST**
Raw/derived/validated disagreements that should be explicitly logged:

* raw tick value vs behavior-implied economic sanity,
* point vs tick size assumptions,
* contract size vs expected movement value behavior,
* symbol visible vs symbol actually usable,
* history present vs live updates absent,
* tradable flag vs practical session bad,
* low spread vs low update count,
* strong ATR vs stale current feed,
* ranking score high while trust grade weak.

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK**
The current settings model is at real risk of becoming **too flag-heavy for human use**, especially because you have:

* Mode toggles,
* Pipeline toggles,
* Testing toggles,
* Output toggles,
* HUD toggles,
* Scope toggles.

That is enough to create contradictory states and operator confusion.

**DESIGN RISK**
The biggest usability hazard is the presence of both:

* `DevMode`
* `TraderMode`

as independent booleans.

That invites illegal or ambiguous states:

* both true,
* both false,
* TraderMode true while Phase 1 invalid,
* Dev pipeline toggles left active in TraderMode.

This is a classic future repair point. It should behave as one **exclusive mode state**, even if you keep the visible UX simple.

**BUILD RISK**
The settings most likely to become messy:

* Pipeline + Testing overlap,
* Output + Debug overlap,
* Scope + CustomSymbolList + SelectedSymbolsOnly overlap,
* DevMode/TraderMode + AllowTraderModeOnlyIfPhase1Complete overlap.

These are semantically overlapping controls.

**DESIGN RISK**
The HUD is at risk of becoming overloaded because Dev HUD wants to show:

* phase,
* step,
* scope,
* active module test,
* module states,
* counts,
* rejects,
* weaks,
* anomalies,
* debug preview,
* Top 3 preview.

That is too much for one always-visible panel unless aggressively prioritized.

**SIMPLIFY NOW**
Toggles/settings that should be merged or behaviorally constrained:

* `DevMode` + `TraderMode` → one effective mode state internally,
* `RunFullPipeline` should disable individual run toggles when active,
* `TestXOnly` flags should not coexist as multiple trues,
* `ScanVisibleOnly / ScanSelectedScope` should not overlap ambiguously,
* debug export flags should obey mode hard limits.

**WATCH**
Mode behavior likely to confuse a human operator:

* changing scope without realizing pipeline is partial,
* using Trader Mode with stale Dev thresholds,
* seeing missing symbols due to hidden classification quarantine,
* seeing “clean” Top 3 without noticing trust degradation,
* assuming “Top 3 per bucket” means all buckets were healthy enough to compete.

**WATCH**
For Trader Mode specifically, the biggest human confusion risk is **silent suppression**.
If symbols/buckets disappear because of quarantine, session badness, or scope filters, the HUD must make the reason obvious without becoming verbose.

---

## 6. What must be simplified now

**SIMPLIFY NOW**
Simplify Phase 1 economics to **ranking-safe practicality**, not broker-perfect valuation.
Phase 1 should answer:

* is the symbol economically sane enough,
* are its movement/cost signals comparable enough within the scanner,
* should it be trusted, weakened, or rejected.

It should not try to fully solve all broker correctness in Phase 1.

**SIMPLIFY NOW**
Simplify friction/activity to a small explicit core:

* current spread,
* median spread,
* tick age,
* update count,
* simple freshness/liveliness classification,
* spread/ATR.

Do not let Phase 1 build an elaborate “freshness bridge metric” unless it is extremely transparent.

**SIMPLIFY NOW**
Simplify ranking to a short list of score sources with obvious ownership:

* movement,
* cost,
* liveliness/freshness,
* trust.

No hidden penalties, no cross-module magic adjustments.

**SIMPLIFY NOW**
Simplify Dev controls.
You do not need both broad pipeline toggles and granular testing toggles to behave as fully independent systems in Phase 1. That is complexity without benefit.

**SIMPLIFY NOW**
Simplify correlation expectations.
Phase 1 correlation should remain:

* shortlist-only,
* same-window,
* clearly diagnostic,
* not a sophisticated portfolio model,
* not a major ranking engine.

---

## 7. What must be live-tested first

**TEST FIRST**
Test classification and normalization first on:

* suffix FX pairs,
* metals,
* index CFDs,
* stock CFDs,
* crypto CFDs,
* weird broker aliases.

If classification truth is unstable, everything downstream lies cleanly.

**TEST FIRST**
Test economics sanity first on:

* EURUSD,
* USDJPY,
* XAUUSD,
* a major index CFD,
* one stock CFD,
* one crypto CFD,
* one “odd” broker symbol.

Not for perfection. For **disagreement detection**.

**TEST FIRST**
Test friction/activity first under three conditions:

* active session,
* quiet session,
* off-session.

You need proof that the system can distinguish:

* cheap and live,
* cheap because dead,
* expensive but moving,
* stale but still visible.

**TEST FIRST**
Test ranking stability across mixed asset classes:

* run same scope repeatedly,
* verify top names do not swing wildly from tiny quote noise,
* verify dead/off-session symbols do not sneak upward,
* verify one asset class is not always structurally advantaged.

**TEST FIRST**
Test shortlist correlation on obvious cases:

* near-duplicate index symbols,
* two gold aliases if available,
* correlated FX majors,
* unrelated cross-asset names.

You want to catch bad history alignment and false-low correlation early.

**TEST FIRST**
Test output partitioning and server naming before anything else operationally.
If shared Common Files output gets messy, cross-terminal trust collapses fast.

---

## 8. What contracts must be frozen now

**DESIGN RISK**
Freeze **ScanRecord ownership and field semantics** now:

* stable field names,
* types,
* null/default policy,
* raw/derived/validated provenance,
* ranking input eligibility,
* export visibility rules.

**DESIGN RISK**
Freeze the **eligibility contract** now:

* what can reject,
* what can only weaken,
* whether weak symbols can rank,
* whether bucket output can include weak symbols,
* how missing data differs from failed data.

That policy must not drift later.

**DESIGN RISK**
Freeze the **reason code taxonomy** now:

* reject,
* weak,
* anomaly,
* trust grade.

These must not overlap loosely.

**DESIGN RISK**
Freeze the **module boundary contract** now:

* Classification owns symbol truth,
* MarketCore owns raw specs and coarse economics,
* HistoryFriction owns time-series sufficiency and live-state evidence,
* Selection owns eligibility/ranking/correlation,
* OutputDebug only renders/export/logs.

OutputDebug must not become policy logic.
Selection must not become data repair logic.
MarketCore must not own classification overrides.

**WATCH**
Freeze the **mode contract** now:

* what Trader Mode is allowed to run,
* what it can export,
* what it can display,
* what debug state is impossible in Trader Mode.

This is a hard boundary, not a preference.

---

## 9. What should be watched so growth stays additive

**WATCH**
Watch `AFS_MarketCore.mqh` for module obesity first.
This is the most likely future repair hotspot.

**WATCH**
Watch `AFS_Selection.mqh` for policy creep.
It will be tempting to keep adding:

* smarter ranking,
* smarter opportunity logic,
* smarter overlap rules,
* special-case suppressions.
  That is how selection turns into a hidden intelligence engine.

**WATCH**
Watch ScanRecord size and semantic drift.
Every new phase will want “just one more field.”
If new fields are not provenance-tagged and purpose-tagged, later debugging becomes impossible.

**WATCH**
Watch menu growth.
A scanner can survive dense internal logic.
It does not survive a human-unfriendly control surface.

**WATCH**
What should be logged/versioned/tested first to protect future evolution:

* classification map version and review status,
* threshold version,
* scoring weight version,
* reason code dictionary,
* ScanRecord schema version,
* server output path format,
* sample symbol hard-test packs by asset class,
* known broker anomaly registry.

**WATCH**
The best protection against future architecture repair is not more abstraction.
It is **stable contracts + reproducible hard-test cases + versioned thresholds/maps**.

---

## 10. Final hardening recommendations

**SIMPLIFY NOW**
Treat Phase 1 as a **useful coarse scanner**, not as a full broker-correctness engine.
Keep usefulness. Reduce false precision.

**BUILD RISK**
Do not let Step 5 and Step 7 grow “clever.”
They need to be:

* explicit,
* inspectable,
* trust-graded,
* easy to falsify.

**DESIGN RISK**
Enforce one internal mode enum, even if the menu still presents friendly mode choices.
Dual booleans for mode are a future bug factory.

**DESIGN RISK**
Make `ScanRecord` provenance visible by design.
A field should be obviously:

* raw,
* derived,
* validated,
* final selection metadata.
  Do not leave that to comments.

**LIVE RISK**
Never allow a high score to hide weak trust.
If trust is weak, the operator must see it in Trader Mode in a compact way.

**TEST FIRST**
Build a fixed live test basket immediately:

* one FX major,
* one JPY pair,
* one metal,
* one index CFD,
* one stock CFD,
* one crypto CFD,
* one odd alias symbol.
  Run this basket on every broker before trusting full-universe output.

**WATCH**
Keep shortlist correlation diagnostic in Phase 1.
Do not let it become an optimization rabbit hole.

**WATCH**
Keep classification map maintenance operationally separate and versioned from code changes.
That separation is one of the strongest parts of the blueprint. Protect it.

**DESIGN RISK**
The hardest architectural rule to preserve is this:
**selection logic must consume trusted evidence, not compensate for weak upstream truth.**
If ranking starts compensating for messy classification, messy economics, or messy friction, repair work becomes inevitable.

**OVERALL VERDICT**
This blueprint is **buildable without redesign**, but only if you harden against one specific failure mode:
a scanner that appears clean, fast, and structured while silently ranking on partially false broker reality.

That is the enemy.
Not file count. Not elegance. Not future phases.

The final hardening move is to make Phase 1:

* narrower in economic ambition,
* simpler in friction logic,
* stricter in mode legality,
* harder on provenance,
* louder about trust weakness,
* and brutally live-tested on mixed symbol types.
## 1. Overall red-team verdict

**DESIGN RISK**
The blueprint is directionally strong and much safer than a typical “scanner that wants to become everything,” but it is still carrying **one dangerous contradiction**: you call Phase 1 “complete usable scanner” while Phase 2 and Phase 3 still contain several things that materially affect whether Phase 1 outputs are trustworthy in live broker conditions. That is not fatal, but it is the main place future repair pressure will come from. If Phase 1 is treated as “usable for workflow, not yet broker-hardened truth,” the architecture survives. If Phase 1 is treated as already robust across brokers, you will get false confidence.

**BUILD RISK**
Phase 1 is still **large**. It is buildable, but only if “complete” means compact implementations, not polished implementations. If you try to make every Phase 1 sub-step production-grade across FX, metals, indices, stock CFDs, crypto, and odd symbols, Phase 1 will slip.

**LIVE RISK**
The biggest live danger is not code crash. It is **plausible-looking but wrong scanner context** caused by symbol-spec inconsistencies, stale feeds, off-session instruments, and weak deposit-currency/economics normalization. This system can look correct on screen while ranking the wrong things.

**WATCH**
Your current blueprint is most likely to fail by **becoming “quietly over-smart” too early**: too many trust grades, status layers, weak/reject reasons, friction variants, and HUD toggles before the raw broker edge cases are nailed.

---

## 2. Biggest Phase 1 risks

**BUILD RISK** — **Phase 1 is still too big**
Yes. Not because the module count is wrong, but because Phase 1 includes too many areas where “basic version” and “broker-safe version” are very different:

* classification normalization
* economics sanity
* friction/activity
* cross-asset ranking fairness
* shortlist correlation
* trader-mode usability

That is a lot for one “usable ASAP” milestone.

**BUILD RISK** — **Biggest risk to the “usable ASAP” goal**
The biggest risk is **Step 5 + Step 7 together**:

* Step 5: Market/spec/economics core
* Step 7: Friction and activity

Those two are where MT5 broker variability lives. Classification is tedious, but mostly deterministic. Economics and friction are where the scanner can become convincing-but-wrong.

**SIMPLIFY NOW** — **Minimum safe Phase 1 that still keeps the scanner useful**
Minimum safe Phase 1 should still include:

* universe load
* symbol normalization/classification
* hard quarantine for unresolved
* bars sufficiency
* ATR M15/H1
* current spread + a simple recent spread metric
* tick age / quote freshness
* binary eligibility + weak tagging
* compact ranking
* Top 3 per PrimaryBucket
* clean Trader Mode shell

But it should **degrade** rather than over-model:

* use **coarse economics sanity**, not deep economic correctness
* use **simple friction/activity**, not elaborate liveliness scoring
* use **shortlist-only correlation**, but with a small fixed shortlist and one stable method
* use **few score components**, not many tuned weights

That keeps the scanner useful without pretending Phase 2 robustness already exists.

**BUILD RISK** — **Most likely sinkhole**
Step 7, friction/activity.
Why:

* spread behavior differs by asset and session
* update count is feed-dependent, not just market-dependent
* tick age can mislead on off-session symbols
* sampled spread windows can produce unstable rankings
* “freshness bridge metric” is conceptually nice but dangerous in Phase 1 because it sounds precise before it is validated

This is the most likely place to burn time while still not being sure the numbers mean what you think.

**DESIGN RISK** — **Most likely to create future structural pain if done badly now**
Step 4, normalization/classification contract.
If canonical identity, asset class, and PrimaryBucket resolution are fuzzy now, everything later gets contaminated:

* economics comparisons
* ranking fairness
* bucket output
* duplicate symbol handling
* cross-broker continuity

Bad classification logic is survivable only if the contract is rigid. Badly defined classification ownership will force repair later.

**SIMPLIFY NOW** — **Part that must be simplified even if elegant**
“PASS / WEAK / FAIL trust” plus multiple grades/status families must be kept coarse in Phase 1.
You already have:

* ClassificationStatus
* EconomicsTrust
* NormalizationStatus
* PracticalityStatus
* EligibilityState
* RejectCodes
* WeakCodes
* TrustScore
* OutputFlags
* Notes

That is close to a state-system explosion. Elegant on paper, expensive in implementation, and easy to make inconsistent. In Phase 1, reduce the number of independently meaningful status axes.

---

## 3. Biggest design risks

**DESIGN RISK** — **ScanRecord is at risk of becoming a junk drawer**
Your warning is correct, but the current field list is already close to overloading. The danger is not field count alone; it is mixing:

* factual raw data
* computed metrics
* validation outcomes
* decision states
* output decoration

If ScanRecord becomes both master row and all-purpose debug container, every future phase will mutate it and nobody will know which fields are authoritative.

**DESIGN RISK** — **AFS_MarketCore is the most likely future overload module**
It currently owns:

* universe loading
* raw spec reading
* economics derivation
* coarse validation
* asset-class-aware handling
* margin/tick/contract sanity

That is too much long-term responsibility gravity. Even if file count stays fixed, this module is the most likely to become the “everything broker-weird lives here” sink.

**DESIGN RISK** — **Mode contract is slightly too dual-boolean**
Having both:

* DevMode
* TraderMode

creates invalid state combinations unless one is derived from the other. Two booleans for mutually exclusive behavior is a classic future repair source. The blueprint says “internally constrained,” which helps, but the contract should behave as one effective mode plus gating, not two independent truths.

**DESIGN RISK** — **Pipeline toggles and testing toggles overlap too much**
You have both:

* RunClassification / RunMarketCore / ...
* TestClassificationOnly / TestEconomicsOnly / ...

That is duplicate control surface. It will create ambiguous ownership:

* what happens if RunFullPipeline=true and TestRankingOnly=true?
* what if RunCorrelation=false but TestCorrelationOnly=true?

This is not a cosmetic problem. It is a future bug source.

**DESIGN RISK** — **Ranking before cross-asset comparability is defined**
You can do compact ranking in Phase 1, but the architecture must admit that ranking across:

* FX
* metals
* indices
* stock CFDs
* crypto

is only as good as your normalization assumptions. If ranking logic is treated as a stable universal scoring contract too early, later corrections will become structural repairs disguised as “weight tuning.”

**WATCH** — **Output partition by server name only**
Correct versus login, but still watch:

* server aliases changing between broker environments
* same firm exposing slightly different server strings
* characters needing path sanitization
* demo/live names creating near-duplicate folders that look related but are operationally different

This is not a reason to redesign. It is a reason to define a stable sanitization/versioning rule now.

---

## 4. Biggest live-runtime broker risks

**LIVE RISK** — **Most dangerous calculations if wrong**
Not just lot/margin:

1. **TickValueRaw interpretation**
2. **TickSize vs Point handling**
3. **ContractSize assumptions**
4. **Spread/ATR ratio comparability across symbol types**
5. **TickAge meaning for off-session or thin markets**
6. **Baseline movement comparability across asset classes**
7. **CurrentSpread reliability during market open/rollover spikes**
8. **OrderCalcProfit / OrderCalcMargin validation assumptions**
9. **ProfitCurrency / MarginCurrency / deposit currency normalization**
10. **Correlation on symbols with sparse or misaligned sessions**

Wrong here does not always crash. It produces believable garbage.

**TEST FIRST** — **What must be live-tested as early as possible**

* same canonical symbol across at least two brokers
* one JPY pair
* one metal
* one index CFD
* one stock CFD
* one crypto symbol
* one odd suffix/prefix broker alias
* one off-session instrument during closed hours
* one symbol with suspiciously stale quotes but visible market watch presence

**LIVE RISK** — **Symbol types most likely to break assumptions**

* stock CFDs with exchange sessions and stale last quotes
* cash indices vs futures-style CFDs
* broker-synthetic crypto symbols
* symbols with suffixes/prefixes that collide after normalization
* micro/mini contract variants
* metals with unusual tick sizes
* JPY pairs where point and pip intuition misleads
* broker-internal synthetic symbols that look tradable but are operationally odd

**LIVE RISK** — **Broker behavior that differs most**

* symbol naming conventions
* visible universe size and default visibility
* spread regime and update cadence
* contract size conventions
* tick value reliability
* session handling
* margin model behavior
* CFDs with different quoting precision
* whether stale symbols still look “available”
* whether hidden/inactive symbols still report enough properties to appear valid

**LIVE RISK** — **Where false confidence happens even if code looks correct**

* `SymbolInfo*` fields populate, but are economically misleading
* history exists, but current feed is stale
* spread sample window captures a calm pocket and misses regime shift
* ATR exists, but instrument is currently untradeable or off-session
* ranking looks stable because normalization errors are consistent
* correlation looks low because time series are session-misaligned, not truly diverse

**LIVE RISK** — **Deposit-currency normalization likely failure points**

* assuming `TickValueRaw` is already economically comparable
* mixing instruments where reported tick value semantics differ
* using derived cost metrics without validating profit currency conversion path
* relying on `OrderCalcProfit` for one scenario and generalizing it
* comparing cost efficiency across assets without a stable account-currency basis
* not separating “raw broker-reported economics” from “validated comparable economics”

**TEST FIRST** — **What should be tested across FX, JPY, metals, indices, stocks, crypto, odd symbols**
For each symbol class, test:

* normalization identity
* trade mode status
* digits / point / tick size agreement
* contract size
* current spread vs median spread behavior
* ATR population and sanity
* tick age behavior in active and inactive periods
* update count behavior
* weak/reject code accuracy
* whether ranking placement feels plausible relative to instrument reality

**TEST FIRST** — **Raw / derived / validated disagreements that should be explicitly logged**
Log disagreements for:

* Raw tick value vs validated economic estimate
* Point vs TickSize mismatch relevance
* CurrentSpread raw points vs normalized cost measure
* Tradable flag vs practical usability result
* History present vs freshness bad
* Classification confidence vs actual eligibility
* Raw symbol name vs canonical collision or ambiguity
* Margin/profit currency fields vs validated deposit-currency behavior
* ATR present vs baseline movement too small or economically irrelevant
* Correlation result vs overlapping canonical family/tag

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK** — **Settings block is at real risk of becoming messy**
The current menu is too wide for stable human use. It has:

* mode controls
* scope controls
* pipeline controls
* output controls
* HUD controls
* debug controls
* testing controls
* thresholds

That is fine architecturally, but the number of toggles is high enough that human misuse becomes likely. The danger is not ugliness. The danger is running the wrong test and trusting the wrong output.

**SIMPLIFY NOW** — **Toggles/settings that should be merged or simplified**

* `DevMode` and `TraderMode` should behave as one effective mode selector
* `RunX` and `TestXOnly` should collapse into one test-execution contract
* `ScanVisibleOnly` and `ScanSelectedScope` are too close unless one is purely derived
* `ExportRawDebug`, `ExportSelectedScopeRows`, `ExportModuleSummary`, `ExportAnomalies` can become export-chaos unless tied to a simple export profile concept internally
* `ShowDebugPanel`, `ShowModuleStates`, `ShowCounts`, `ShowCorrelationPreview` can overload HUD state combinations unless some are mode-default bundles

**DESIGN RISK** — **HUD can still become overloaded**
Dev HUD already wants to show:

* phase
* step
* scope
* test
* module states
* counts
* reject counts
* weak counts
* anomaly counts
* debug preview
* Top 3 preview

That is too much unless the display is aggressively prioritized. Dev HUD should help locate one problem, not display system autobiography.

**WATCH** — **Mode behavior that could confuse a human operator**

* both Dev and Trader toggles visible together
* TraderMode visible but “not valid yet”
* final output export available while partial pipeline is active
* debug exports enabled while user thinks they are in clean Trader Mode
* scope filters still active in Trader Mode, causing partial-market outputs that look global
* correlation shown in Trader Mode without making clear it is shortlist-relative, not universe-relative

**BUILD RISK** — **Selective testing may become harder than it looks**
The blueprint wants testing by:

* scope
* bucket
* asset class
* symbol list
* function/module

That is useful, but combinatorially messy. If not bounded, the testing surface will become harder to trust than the scanner itself.

---

## 6. What must be simplified now

**SIMPLIFY NOW** — **Keep economics sanity coarse in Phase 1**
Do not try to fully solve cross-broker economics correctness in Phase 1.
Phase 1 should do:

* raw capture
* simple derivation
* obvious anomaly detection
* coarse trust tagging
* clear logging of uncertainty

Anything beyond that belongs to Phase 2 hardening.

**SIMPLIFY NOW** — **Reduce score model width**
Phase 1 ranking should stay compact. The more score components you include now, the more hidden tuning debt you create. Keep only the components that are directly actionable and observable:

* movement capacity
* friction/cost efficiency
* freshness/activity
* trust penalty

**SIMPLIFY NOW** — **Reduce state-family sprawl**
Do not let every module invent its own status language. Freeze a small set of cross-system state conventions:

* hard reject
* weak but eligible
* eligible
* unknown/untrusted

Anything more nuanced can remain internal until proven necessary.

**SIMPLIFY NOW** — **Keep correlation narrow**
Only shortlisted eligible names. One method. One interpretation. One clear warning when data is thin or session-misaligned. Do not be elegant here.

**SIMPLIFY NOW** — **Treat “freshness bridge metric” as optional-internal**
This is exactly the kind of metric that sounds architecturally smart and becomes a calibration sinkhole. Keep it internal or crude in Phase 1, not central to human trust.

---

## 7. What must be live-tested first

**TEST FIRST** — **Step 4 normalization/classification**
Because one bad canonical mapping contaminates everything after it.

**TEST FIRST** — **Step 5 economics sanity**
This is the highest-value early live test because it creates the most dangerous false confidence if wrong.

**TEST FIRST** — **Step 7 friction/activity across sessions**
Specifically:

* active market
* quiet market
* off-session market
* rollover/open volatility regime

**TEST FIRST** — **Server/folder partitioning**
Not glamorous, but you do not want evidence mixed across environments. Test:

* sanitization
* live/demo distinction
* consistent path derivation
* artifact routing by mode

**TEST FIRST** — **Scope behavior**
Because a scanner that quietly runs on filtered scope while looking global is an operator trap.

**TEST FIRST** — **Reject/weak code determinism**
Same symbol, same conditions, same codes. If reason coding drifts, your debugging foundation is compromised.

---

## 8. What contracts must be frozen now

**DESIGN RISK** — **Freeze ScanRecord authority rules**
Not just fields. Freeze:

* which module owns each field
* whether field is raw / derived / validated / decision
* whether field may be overwritten later in pipeline
* whether missing is allowed and what it means

This is the single most important contract to freeze.

**DESIGN RISK** — **Freeze normalization/classification contract**
Define now:

* raw symbol normalization rules
* canonical identity uniqueness rules
* collision handling
* unresolved handling
* when a symbol is allowed to proceed
* whether map can be one-to-many or must be exactly one-to-one

This must not drift.

**DESIGN RISK** — **Freeze eligibility-before-ranking contract**
Make it impossible for FAIL records to score or appear in Top 3 through any future shortcut. This is a core structural safeguard.

**DESIGN RISK** — **Freeze mode behavior contract**
For each mode, define:

* what pipeline states are legal
* what HUD elements may appear
* what exports may occur
* whether partial-scope scans are visibly labeled
* whether Trader Mode can run with dev-only toggles still set

**DESIGN RISK** — **Freeze reason-code dictionary**
Readable, deterministic, versioned. Do not let codes become ad hoc strings across modules.

**DESIGN RISK** — **Freeze output schema**
At minimum for:

* `top3_by_bucket.csv`
* anomaly log categories
* selected debug export schema

You want later versions additive, not breaking.

---

## 9. What should be watched so growth stays additive

**WATCH** — **AFS_MarketCore overload**
If any module is going to become the future ISSX monster, it is this one. Watch for it becoming the dumping ground for:

* all broker quirks
* all economics repair logic
* all asset-class exceptions
* all practical tradability logic

Keep helpers internal, yes, but do not let this file become the system’s basement.

**WATCH** — **Selection module quietly absorbing strategy logic**
Selection should own:

* eligibility
* ranking
* shortlist correlation
* top-3 selection

But it must not become:

* pseudo-entry logic
* hidden momentum detector
* opportunity-state engine too early
* cross-phase logic blender

That is where “scanner” becomes “signal engine” by accident.

**WATCH** — **HUD turning into a dashboard platform**
Very likely failure mode. The moment new phases arrive, every new metric will want screen space. Resist that. Most future intelligence should remain in output/export/test views, not permanent HUD presence.

**WATCH** — **Classification map growing into governance debt**
You correctly made it separate. Now watch:

* review workflow drift
* inconsistent taxonomy
* overlapping buckets/themes
* canonical symbol duplication
* broker alias accumulation without cleanup

Separate ownership helps only if the map itself is disciplined.

**WATCH** — **Threshold sprawl**
Centralized thresholds are good, but too many exposed knobs create fake control and harder reproducibility. Expose only what you will actually tune.

**WATCH** — **Versioning and evidence discipline**
The first things that should be versioned/tested/logged to protect evolution are:

* classification map version
* output schema version
* reason code dictionary version
* ranking weight version
* server-path derivation version
* anomaly category definitions

That is what prevents future “growth” from meaning silent behavior drift.

---

## 10. Final hardening recommendations

**SIMPLIFY NOW**
Reframe Phase 1 internally as: **usable scanner with coarse broker sanity, not broker-complete truth**. That preserves the locked architecture while removing the biggest source of future disappointment.

**BUILD RISK**
Cut Phase 1 ambition at the implementation level, not at the architecture level:

* simple economics sanity
* simple friction/activity
* compact score
* narrow correlation
* fewer visible status families

**DESIGN RISK**
Freeze three contracts before more coding:

1. ScanRecord ownership and overwrite rules
2. normalization/classification uniqueness rules
3. mode legality and export legality rules

**LIVE RISK**
Treat economics and freshness as “suspicion zones,” not solved facts. Every place where broker reality can disagree with MT5 fields should have explicit anomaly evidence.

**SIMPLIFY NOW**
Collapse duplicated control surfaces:

* one effective mode contract
* one pipeline/test execution contract
* fewer HUD visibility combinations

**TEST FIRST**
Do cross-asset live tests before trusting ranking:

* FX major
* JPY pair
* metal
* index CFD
* stock CFD
* crypto
* odd alias symbol
* off-session instrument

**WATCH**
Guard against these three monster-growth patterns:

* MarketCore becoming broker-weirdness landfill
* Selection becoming stealth signal logic
* HUD becoming permanent dashboard sprawl

**DESIGN RISK**
The single most important hardening principle for this blueprint is:
**never let plausible output outrun validated trust**.
This system will not fail because it lacks features. It will fail if it looks clean, ranked, and actionable before the underlying broker interpretation is solid enough.

Overall: **keep the architecture, reduce Phase 1 cleverness, freeze contracts harder, and force early live evidence on economics/freshness/classification.** That is the path that makes this buildable without future structural repair.
## 1. Overall red-team verdict

**VERDICT:** The blueprint is structurally strong enough to build, but **Phase 1 is still carrying too much broker-correctness burden for a “usable ASAP” milestone**. The architecture itself is not the main problem; the danger is that several “small” Phase 1 steps are actually **live-broker truth problems disguised as scanner plumbing**.

**BUILD RISK**
Phase 1 is buildable, but not cheap. The main threat is not line count; it is the number of places where correctness depends on broker-specific behavior, session state, symbol type, quote freshness, and ambiguous MT5 metadata. That makes the implementation deceptively large.

**DESIGN RISK**
The design is mostly coherent, but the blueprint still risks one classic failure: **too much semantic ownership flowing into `ScanRecord` and `AFS_MarketCore` too early**. If those contracts get loose now, future phases will add “just one more field / one more status / one more score” until repair work is unavoidable.

**LIVE RISK**
The biggest live danger is **false confidence from plausible-looking numbers**. MT5 can provide internally consistent but practically misleading data across CFDs, crypto, off-session stocks, synthetic broker symbols, and deposit-currency conversions. A scanner is especially vulnerable because it does not place trades, so bad assumptions can survive longer without obvious failure.

---

## 2. Biggest Phase 1 risks

**BUILD RISK — Phase 1 is still slightly too big**
Not because of the number of modules, but because Phase 1 includes four different kinds of truth validation at once:

1. symbol identity truth
2. broker economics truth
3. market activity truth
4. ranking truth

That is a lot for a first usable release. The architecture says “Phase 1 is complete usable scanner,” but the implementation burden is really closer to **foundation + first hardening pass**, not just MVP scanner logic.

**BUILD RISK — biggest risk to “usable ASAP”**
The single biggest risk is **Step 5 + Step 7 together**:

* Step 5: market/spec/economics core
* Step 7: friction and activity

Why these two? Because they look bounded on paper, but in reality they are where cross-broker ambiguity lives. Classification can be manually corrected. Ranking can be tuned later. But if economics and activity are even slightly wrong, the whole shortlist becomes misleading while still looking professional.

**SIMPLIFY NOW — minimum safe Phase 1 that still keeps scanner useful**
The minimum safe Phase 1 is:

* universe load
* normalization
* user classification
* basic tradability sanity
* ATR on M15/H1
* simple spread context
* simple freshness/tick-age check
* eligibility
* compact ranking
* Top 3 per PrimaryBucket
* clean Trader Mode output

What should be kept but **narrowed** in Phase 1:

* economics sanity should remain **coarse**, not ambitious
* friction should remain **simple and session-aware**, not pseudo-precise
* shortlist correlation should remain **very small finalist-only context**, not a deeper intelligence layer

**BUILD RISK — step most likely to quietly become a sinkhole**
**Step 7: Friction and activity.**
Reason:

* sample-window design complexity
* session-state distortions
* stale quote ambiguity
* quiet-vs-dead discrimination
* asset-class differences
* stock CFD off-session behavior
* crypto 24/7 behavior
* spread spikes during rollovers/news

This step can absorb huge time because the output will always “look almost right,” which encourages endless patching.

**DESIGN RISK — step most likely to create future structural pain if done badly now**
**Step 5: Market/spec/economics core.**
If this is done with blurred ownership between raw fields, derived fields, validated fields, and “practical” fields, then every future broker-hardening phase becomes repair work. This is the most important place to avoid hidden shortcuts.

**SIMPLIFY NOW — Phase 1 step that must be simplified even if elegant now**
**Correlation.**
Keep it shortlist-only, small-N, and descriptive. Do not let it become a generalized similarity engine in Phase 1. It is not the most dangerous item technically, but it is the most likely elegant distraction.

---

## 3. Biggest design risks

**DESIGN RISK — `AFS_MarketCore.mqh` is the most likely overload module**
It currently owns:

* universe loading
* raw spec reading
* economics derivation
* coarse validation
* asset-class-aware handling
* margin / tick / contract sanity

That is already too much semantic gravity. This module can easily become the “everything broker-related” dumping ground. Future hardening phases will keep adding edge cases here unless you freeze internal boundaries now.

**DESIGN RISK — most important contract to freeze now**
The most important contract is the boundary between:

* `Classification`
* `MarketCore`
* `HistoryFriction`
* `Selection`

Specifically:

* `Classification` decides identity and labels only
* `MarketCore` decides tradability/economic trust only
* `HistoryFriction` decides activity/movement evidence only
* `Selection` consumes prior facts and decides eligibility/ranking only

If `Selection` starts recomputing economics/freshness logic, or `HistoryFriction` starts inferring classification behavior, the architecture will slowly tangle.

**DESIGN RISK — `ScanRecord` can become a hidden monolith**
You correctly say “only stable fields go in ScanRecord,” but the risk remains high. Once developers see it as the master row, they will be tempted to put:

* intermediate fields
* debug-only fields
* fallback fields
* alternate score variants
* helper caches

That will create versioning pain and unreadable ownership. `ScanRecord` must stay a final-state record, not a scratchpad.

**WATCH — future feature growth most likely to create entanglement**
The danger zones are:

* adding more score components
* adding more trust states
* adding more exception flags
* adding more “context” tags to support later phases
* adding mode-specific behavior inside core mechanics

Those all feel additive, but they silently create cross-module dependencies.

**WATCH — what should remain internal helper logic, not separate modules**
Do **not** split these into standalone modules unless they become independently maintained:

* symbol-name sanitation helpers
* score normalization helpers
* small per-asset conversion helpers
* CSV row formatters
* HUD formatting helpers
* shortlist sorting helpers

If you split these out early, you create file sprawl with no ownership gain.

**WATCH — ISSX-style monster risk**
The scanner becomes a monster if:

* `ScanRecord` keeps growing
* mode logic leaks into all modules
* every new phase adds more settings instead of stronger defaults
* ranking becomes a dumping ground for business logic
* HUD becomes a second analytics interface

---

## 4. Biggest live-runtime broker risks

**LIVE RISK — most dangerous calculations if wrong**
The most dangerous calculations are not just lot/margin. They are the ones that directly distort eligibility and ranking while looking believable:

1. `SpreadAtrRatio`
2. `TickAge`
3. `UpdateCount`
4. `FreshnessScore`
5. `MovementCapacityScore`
6. derived economics trust states
7. any deposit-currency-normalized cost metric
8. contract/tick interpretation for non-FX instruments

A wrong lot-size assumption is obvious eventually. A wrong freshness or spread/ATR interpretation is much more dangerous because it silently poisons ranking.

**TEST FIRST — what must be live-tested earliest**
Earliest live tests should hit:

* same canonical symbol on multiple brokers
* one FX major
* one JPY pair
* one metal
* one index CFD
* one stock CFD
* one crypto symbol
* one odd suffixed alias
* one off-session instrument
* one symbol with visible quotes but poor update quality

You need live evidence before trusting the formulas, especially for friction and freshness.

**LIVE RISK — symbol types most likely to break assumptions**

* JPY pairs
* metals with nonstandard tick behavior
* cash indices vs futures-like CFDs
* stock CFDs with sparse sessions
* crypto CFDs with weekend behavior
* broker-specific synthetic indices or themed symbols
* symbols with suffix/prefix aliases
* instruments with quotes present but trade mode restricted
* instruments whose visible spread is not practically executable

**LIVE RISK — behavior that differs most across brokers**

* contract size conventions
* tick value reliability
* point vs tick size interpretation
* deposit/profit/margin currency combinations
* minimum lot and actual executable lot
* session behavior and quote updates
* symbol visibility vs actual tradability
* CFD naming and alias conventions
* quote freshness behavior when market is technically closed or thin

**LIVE RISK — where false confidence happens even if code looks correct**

* `SymbolInfo*` fields return values, so the code “works”
* ATR computes correctly on stale or thin history
* spreads look low because symbol is inactive
* stock CFD looks calm because session is closed
* update count looks acceptable on brokers with odd tick batching
* margin/profit calculations pass simple tests but differ under real instrument conventions
* crypto appears highly active but cost context is distorted
* broker returns valid raw metadata that is operationally misleading

**LIVE RISK — deposit-currency normalization likely failure points**

* non-USD account with GBP/EUR/JPY quoted instruments
* profit currency differing from margin currency
* indirect conversion paths
* conversion symbol unavailable or hidden
* stale conversion quote
* symbol-specific contract conventions causing apparent normalization consistency while exposure is wrong
* using displayed point math instead of executable tick logic

**TEST FIRST — what should be tested across FX, JPY, metals, indices, stocks, crypto, odd symbols**
For each asset group test:

* canonical mapping
* digits/point/tick size consistency
* contract size
* tick value raw vs practical behavior
* session state
* bar sufficiency
* spread stability
* update cadence
* off-session handling
* eligibility outcome
* ranking reasonableness
* reject/weak code correctness

**TEST FIRST — raw/derived/validated disagreements that should be explicitly logged**
These disagreements should be first-class logs:

* `TickValueRaw` vs validated profit behavior
* `Point` vs `TickSize`
* derived pip-equivalent cost vs actual calc-based cost
* visible symbol vs not practically tradable
* quote present vs stale feed
* sufficient bars vs stale history
* low spread vs low update quality
* classified asset class vs economics pattern mismatch
* current spread vs median spread regime
* profit currency / margin currency / deposit currency mismatch chain
* raw tradability state vs eligibility result

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK — settings block is still too toggle-heavy**
The sectioning is good, but there are too many overlapping controls between:

* Mode
* Pipeline
* Debug
* Testing
* Output
* HUD

That will create ambiguous operator intent.

Example confusion:

* `RunClassification` vs `TestClassificationOnly`
* `RunFullPipeline` vs multiple `RunX`
* `DevMode` + `TraderMode` both boolean
* `ScanVisibleOnly` vs `ScanSelectedScope`
* `ExportRawDebug` vs `ExportSelectedScopeRows` vs `ExportModuleSummary`

This is not a cosmetic issue. It will create mis-runs and false bug reports.

**SIMPLIFY NOW — toggles/settings that should be merged or constrained**

* Replace `DevMode` and `TraderMode` dual booleans with one enum mode internally, even if wrapper UI still presents friendly choices.
* `RunX` and `TestXOnly` are too overlapping. One pipeline selector plus one “stop after stage” or “focus stage” concept is safer.
* `ScanVisibleOnly` and `ScanSelectedScope` should not coexist loosely.
* `ExportRawDebug` is too broad; it invites file spam and undefined payloads.

**WATCH — HUD overload risk**
The Dev HUD currently wants to show:

* phase
* step
* scope
* module states
* counts
* reject counts
* weak counts
* anomaly counts
* debug preview
* Top 3 preview

That is already close to overload. It will become unreadable once real live anomalies appear. The danger is not aesthetics; it is that the HUD stops being diagnostic because too many values compete for attention.

**DESIGN RISK — mode behavior likely to confuse a human operator**
Confusion points:

* both Dev and Trader represented as booleans
* Trader Mode “exists but not valid until Phase 1 complete”
* exports depending on both mode and export toggles
* HUD content depending on both mode and visibility flags
* test scope depending on both scope filters and testing toggles

That creates too many cross-products of behavior. A human user will not always know why they are seeing or not seeing something.

**WATCH — debug without drowning in noise**
The blueprint says selective debug, which is correct, but the menu still creates the possibility of enabling:

* verbose logs
* timings
* reject reasons
* weak reasons
* calculation sources
* trust grades
* selected scope rows
* anomalies
* summaries
* raw debug

That can still become a noise bomb if not aggressively constrained by mode/scope defaults.

---

## 6. What must be simplified now

**SIMPLIFY NOW — friction model in Phase 1**
Keep only:

* current spread
* median spread
* max spread
* tick age
* update count
* one conservative freshness classification

Do not let “liveliness score” and “freshness bridge metric” become pseudo-scientific in Phase 1. They are useful concepts, but they are high-risk soft metrics early.

**SIMPLIFY NOW — economics sanity scope**
Phase 1 economics should answer only:

* is this symbol structurally interpretable?
* is it practically tradable enough?
* are raw fields self-consistent enough to trust scanner use?

Do not overreach into rich broker-correctness logic in Phase 1.

**SIMPLIFY NOW — ranking model**
Compact ranking is correct, but freeze it as a small, explicit combination of a few components. Do not introduce too many weighted subtleties now. Every extra weight multiplies debugging ambiguity.

**SIMPLIFY NOW — menu intent model**
Reduce overlapping controls. Human usability will break before code architecture breaks.

**SIMPLIFY NOW — final output expectations**
Top 3 per PrimaryBucket is fine. Do not over-enrich Trader Mode rows with too many contextual columns in Phase 1. The more fields shown, the more pressure to stabilize every metric prematurely.

---

## 7. What must be live-tested first

**TEST FIRST — broker correctness matrix**
Run live tests first on:

* FX major
* JPY pair
* XAUUSD
* NAS100 or US100 CFD
* one EU index CFD
* one stock CFD
* BTCUSD or broker crypto CFD
* one odd suffixed symbol

For each, check:

* classification
* trade mode
* digits/point/tick size
* tick value raw
* contract size
* lot limits
* profit/margin/deposit currency relationship
* quote freshness
* spread regime
* bar sufficiency
* eligibility outcome
* final rank plausibility

**TEST FIRST — session/off-session behavior**
You need explicit live tests during:

* active session
* rollover/thin period
* off-session for stocks
* weekend for crypto-enabled brokers if applicable

This is crucial because activity/freshness logic often looks correct only during the easy hours.

**TEST FIRST — disagreement logging**
Before beautifying ranking, prove the disagreement logs work:

* raw vs derived
* derived vs validated
* visible vs tradable
* low spread vs stale feed
* classified vs unresolved
* sufficient bars vs stale last bar
* eligible vs weak vs reject reason determinism

**TEST FIRST — same symbol across brokers**
This is mandatory early. A scanner built for one terminal per server still needs **cross-broker truth comparison**, otherwise you will overfit the logic to the first broker.

---

## 8. What contracts must be frozen now

**DESIGN RISK — freeze `ScanRecord` field admission rules**
Define now:

* what counts as stable
* what is allowed as enum/status/code
* what is temporary and forbidden
* which module owns each field
* whether a field can be empty, weak, or validated

Without this, `ScanRecord` will bloat.

**DESIGN RISK — freeze ownership of eligibility**
`Selection` must be the only place that converts prior evidence into:

* PASS
* WEAK
* FAIL
* reject codes
* weak codes

Earlier modules may provide facts and trust grades, but they should not silently apply final selection semantics.

**DESIGN RISK — freeze raw/derived/validated separation**
This is one of the best ideas in the blueprint and one of the easiest to accidentally violate. Freeze naming, storage, and logging rules now.

**DESIGN RISK — freeze reason code taxonomy**
Reason codes must not become ad hoc strings or half-overlapping categories. They need stable semantics now, or historical comparison later will be unreliable.

**DESIGN RISK — freeze mode gating**
Define exactly:

* what Trader Mode suppresses
* what Trader Mode still logs minimally
* what exports are impossible in Trader Mode
* what settings are ignored or forced in Trader Mode

Do not let every module decide this locally.

**DESIGN RISK — freeze shortlist correlation scope**
Keep it:

* finalists only
* descriptive
* non-blocking unless clearly intended
* computationally bounded

If this boundary moves later without discipline, correlation will spread into ranking logic too early.

---

## 9. What should be watched so growth stays additive

**WATCH — `AFS_MarketCore` growth**
If every future broker quirk gets stuffed here, this becomes the repair nexus. Watch file size, branching by asset class, and the number of status flags produced.

**WATCH — score inflation**
Later phases will want:

* better movement relevance
* emergence
* state models
* overlap hygiene
* theme intelligence

Each of those will try to add more scores, tags, and trust modifiers. Watch for ranking inflation where every new feature adds another scalar instead of clean evidence.

**WATCH — settings inflation**
Every new phase must not add three more toggles. The system will remain usable only if later growth prefers:

* internal defaults
* mode-aware behavior
* narrow advanced settings
  over expanding the top-level menu endlessly.

**WATCH — HUD inflation**
Trader HUD especially must stay sparse. If later phases add more context, prefer summary tags rather than more numeric rows.

**WATCH — anomaly logging discipline**
Anomaly categories should grow carefully. If anomalies become a catch-all dump, nobody will trust them and future hardening loses one of its best safety tools.

**WATCH — classification map creep**
Keep the classification map as truth for identity/buckets, but do not let it become a dumping ground for runtime operational facts that belong in code or logs.

**WATCH — additive growth test protection**
The first things that should be versioned and regression-tested are:

* classification mapping behavior
* `ScanRecord` schema
* reason codes
* eligibility outcomes
* Trader Mode output schema
* raw/derived/validated disagreement logs

Those are the best protection against future accidental architecture drift.

---

## 10. Final hardening recommendations

**SIMPLIFY NOW**
Treat **Phase 1 as scanner usefulness with conservative broker trust**, not broker mastery. Keep economics and friction bounded and visibly conservative.

**BUILD RISK**
Do not underestimate Step 5 and Step 7. They are the true schedule risks, not the wrapper or ranking code.

**DESIGN RISK**
Freeze module ownership hard:

* Classification = identity truth
* MarketCore = tradability/economics truth
* HistoryFriction = movement/activity truth
* Selection = eligibility/ranking truth
* OutputDebug = presentation/export truth

No semantic leakage.

**LIVE RISK**
Assume broker metadata is often plausible but not trustworthy enough by itself. Design for disagreement visibility, not silent confidence.

**SIMPLIFY NOW**
Reduce settings overlap before implementation momentum makes it permanent. The current menu is organized, but still too combinatorial.

**TEST FIRST**
Prove live behavior on mixed asset classes before polishing scoring. A believable rank on wrong underlying facts is the most dangerous failure mode here.

**WATCH**
Guard `ScanRecord`, reason codes, and Trader Mode output like public APIs. Those are the parts most likely to create future repair work if allowed to drift.

**FINAL RED-TEAM JUDGMENT**
The blueprint does **not** need a redesign. It **does** need stricter hardening discipline around:

* Phase 1 scope control
* economics/freshness realism
* settings simplification
* contract freezing
* early live cross-broker testing

If you do that, this stays additive. If you do not, the most likely future repair work will come from **MarketCore ambiguity, ScanRecord bloat, and mode/settings sprawl**, not from the grouped-module architecture itself.
## 1. Overall red-team verdict

* **BUILD RISK (A):** Phase 1 is still at the outer edge of “too much for first usable release.” It is not fatally oversized, but it is only safe if you keep the implementations brutally compact. The danger is not the number of steps; it is that several steps hide broker-dependent complexity that behaves like infrastructure, not features.

* **DESIGN RISK (B):** The blueprint is directionally strong, but it has one structural tension: you call `ScanRecord` the stable master row while also expecting it to carry raw, derived, validated, eligibility, ranking, and correlation state across mixed asset classes and future phases. That can work, but only if contracts are frozen hard now. Otherwise `ScanRecord` becomes the junk drawer where every future uncertainty gets stuffed.

* **LIVE RISK (C):** The biggest real-world threat is false correctness. MT5 will happily give you values that look coherent enough to rank symbols while still being economically wrong, stale, session-broken, or asset-misaligned. This scanner is most vulnerable where code “works” and output looks clean, but the underlying tradability assumptions are wrong.

* **WATCH:** The blueprint is buildable without redesign, but only if you treat Phase 1 as a hostile-environment scanner, not a clean academic ranking engine. If you optimize elegance over survivability, repair work will come fast.

---

## 2. Biggest Phase 1 risks

* **BUILD RISK (A):** The single biggest threat to “usable ASAP” is **Step 5 + Step 7 together**: economics sanity plus friction/activity. Those are the first places where broker behavior, asset differences, live timing, and normalization errors compound. They are not “simple enrichments”; they are where naïve implementations become sinkholes.

* **BUILD RISK (A):** **Shortlist correlation in Phase 1** is acceptable only because you restricted it to shortlisted eligible names. Even then, it is still a time sink because data-window choices, symbol alignment, and sparse-history handling can consume far more effort than expected. It is not the largest risk, but it is the most likely “looks small, burns days” item after economics.

* **BUILD RISK (A):** The minimum safe Phase 1 that still remains useful is:

  * classification
  * economics sanity
  * ATR
  * friction/activity
  * eligibility
  * compact ranking
  * Top 3 per PrimaryBucket
    Correlation can stay in Phase 1 only if implemented as **thin context only**, not quality gating. The moment correlation starts behaving like a second eligibility layer, Phase 1 becomes slower and more fragile.

* **DESIGN RISK (B):** The most likely quiet sinkhole is **symbol normalization + classification edge handling**. Not because the logic is conceptually hard, but because every broker oddity creates pressure to keep patching normalization rules in code instead of preserving map-driven ownership. That is how classification modules rot.

* **DESIGN RISK (B):** The Phase 1 step most likely to create future structural pain if done badly now is **economics sanity**. If raw/derived/validated distinctions are not explicit from day one, Phase 2 will become a repair phase instead of a hardening phase.

* **SIMPLIFY NOW:** **Ranking must stay compact and dumb in Phase 1.** Elegant multi-factor ranking is seductive and dangerous here. If score composition becomes nuanced before broker correctness is proven, you will optimize on contaminated inputs.

* **SIMPLIFY NOW:** **Friction/activity must use a very small, deterministic model** in Phase 1. Median spread, max spread, tick age, update count, a simple freshness/liveliness score. Do not let it drift into microstructure theater.

---

## 3. Biggest design risks

* **DESIGN RISK (B):** `AFS_MarketCore.mqh` is the most likely future overload point. It already owns universe loading, raw spec reading, economics derivation, coarse validation, asset-aware handling, and margin/tick/contract sanity. That is a lot of ownership gravity. If anything new “kind of relates to specs,” it will get dumped there.

* **DESIGN RISK (B):** The most important contract to freeze now is the **boundary between `Classification`, `MarketCore`, and `Selection`**:

  * Classification decides identity and labels.
  * MarketCore decides what the broker says and what AFS can validate.
  * Selection consumes only normalized, explicit fields and statuses.
    If any of these modules start re-deciding each other’s truth, you get entanglement fast.

* **DESIGN RISK (B):** The blueprint still has a hidden ownership ambiguity around **“practicality status,” “economics trust,” “normalization status,” and “eligibility state.”** These sound similar but live at different layers. If those statuses are not strictly layered, later phases will keep reinterpreting them.

* **DESIGN RISK (B):** The wrapper owning menu, lifecycle, HUD, call order, and export decisions is correct. The risk is that it also becomes the place where special-case mode logic accumulates. That would slowly turn the wrapper into policy spaghetti.

* **DESIGN RISK (B):** `ScanRecord` is at risk of becoming both a transport struct and a diagnostic warehouse. Those are different jobs. If every phase adds permanent fields “just in case,” future repair work is guaranteed.

* **WATCH:** Internal helpers inside grouped modules should remain internal. In particular, do **not** split out standalone micro-modules for:

  * ATR helpers
  * spread stats helpers
  * reject-code formatting
  * scoring utilities
  * path helpers
    Those are classic “looks organized, creates fragmentation” traps.

* **WATCH:** The blueprint avoids an ISSX-style monster only if every new phase plugs into existing fields/statuses instead of inventing parallel truth systems. Parallel truth is how monsters breed.

---

## 4. Biggest live-runtime broker risks

* **LIVE RISK (C):** The most dangerous calculations if wrong are:

  1. **Tick value interpretation**
  2. **Deposit-currency normalization**
  3. **Contract size assumptions**
  4. **Spread-to-ATR ratio when spread units and ATR units are mismatched**
  5. **Tick age/freshness assumptions on off-session symbols**
  6. **Tradability assumptions based on visible symbols that are not actually usable now**

* **LIVE RISK (C):** What must be live-tested as early as possible:

  * `OrderCalcProfit` agreement with raw/derived economics
  * `OrderCalcMargin` agreement with practical assumptions
  * spread behavior during active vs quiet periods
  * symbols that remain quoted while functionally dead
  * session-closed stock CFDs that still look “present”
  * crypto symbols with 24/7 quotes but broker-specific contract weirdness

* **LIVE RISK (C):** The symbols most likely to break assumptions:

  * JPY FX pairs
  * metals with unusual contract/tick conventions
  * cash indices vs futures-style CFD indices
  * stock CFDs with session closures and thin updates
  * crypto pairs with suffix/prefix aliasing
  * broker-internal synthetic or custom symbols
  * micro contracts, mini contracts, and symbols with unusual lot steps

* **LIVE RISK (C):** Broker behavior that differs most across brokers:

  * tick value reliability
  * margin mode behavior
  * symbol naming conventions
  * contract size conventions
  * off-session quote persistence
  * spread stability and widenings
  * visibility/selection behavior in Market Watch
  * history depth and quality by asset class

* **LIVE RISK (C):** False confidence will happen where code looks correct but:

  * a symbol has enough bars, but most recent quote is stale
  * spread looks acceptable in points, but absurd in movement terms
  * economics validate for 1 lot but not practical min-step behavior
  * canonical mapping is right, but broker subtype materially changes usability
  * ranking prefers “moving” instruments that are just noisy or structurally expensive

* **LIVE RISK (C):** What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:

  * point/ticksize/digits consistency
  * ATR unit consistency
  * spread unit consistency
  * quote freshness vs session state
  * volume min/step/max realism
  * contract size reasonableness
  * margin/profit currency handling
  * validated profit/margin agreement
  * ranking stability under mixed asset classes
  * reject reasons being asset-appropriate, not FX-centric

* **LIVE RISK (C):** Deposit-currency normalization is likely to go wrong when:

  * profit currency differs from margin currency
  * cross-currency conversion path is absent or stale
  * broker reports plausible raw values that are not directly comparable
  * stock CFDs and indices use conventions unlike FX
  * you assume one validation path covers all asset classes

* **TEST FIRST:** Explicitly log raw/derived/validated disagreements for:

  * `TickValueRaw` vs derived tick economics
  * contract-size-based move value vs `OrderCalcProfit`
  * margin estimate vs `OrderCalcMargin`
  * current spread vs sampled spread stats
  * tick age vs update count vs session status
  * raw symbol vs canonical symbol vs classified asset class
  * visible symbol vs tradable symbol state
  * enough-bars status vs fresh-bars status

---

## 5. Menu/HUD/Mode usability risks

* **DESIGN RISK (B):** The menu is already close to too many toggles for a human operator. The structure is clean on paper, but the real risk is combinatorial confusion: Mode + Pipeline + Testing + Output + Debug creates too many ways to make the EA behave differently.

* **BUILD RISK (A):** Dual booleans for `DevMode` and `TraderMode` are a usability trap. Humans will create illegal combinations mentally even if code constrains them. This is not architecture-breaking, but it is a stupid source of avoidable confusion.

* **DESIGN RISK (B):** `Pipeline` and `Testing` sections appear partially overlapping. A user can reasonably ask: “What is the difference between RunClassification and TestClassificationOnly?” If those semantics are not razor-sharp, Dev Mode becomes annoying instead of surgical.

* **DESIGN RISK (B):** `Scope` can become messy fast because it mixes:

  * asset filters
  * bucket filters
  * sector filters
  * symbol filters
  * custom lists
  * visible/selected scope behavior
    That is too many selectors unless precedence rules are frozen.

* **DESIGN RISK (B):** The HUD is at risk of role confusion:

  * Dev HUD wants inspection
  * Trader HUD wants clarity
    If you reuse too many layout elements between them, Trader HUD will inherit debug posture and Dev HUD will become cramped.

* **LIVE RISK (C):** Mode behavior can confuse a real operator if Trader Mode silently suppresses evidence that a shortlist is weak, stale, or partially degraded. “Clean” must not mean “misleadingly calm.”

* **SIMPLIFY NOW:** Merge conceptual duplicates:

  * Replace dual booleans with one effective mode enum internally, even if UI keeps locked compatibility.
  * Collapse overlapping test/run semantics so one selector chooses pipeline scope, and one selector chooses symbol scope.
  * Make debug visibility independent from export behavior; those should not feel like the same switch.

* **SIMPLIFY NOW:** HUD should show fewer but stronger warnings. A wall of counts is not operator-friendly. What matters is whether the shortlist is trustworthy, degraded, or thin.

* **WATCH:** The settings most likely to become messy are:

  * scope selector precedence
  * mode gating
  * pipeline/test overlap
  * debug/export overlap
  * ranking weights exposure too early

---

## 6. What must be simplified now

* **SIMPLIFY NOW:** **Step 5 economics sanity** must stay coarse in Phase 1. Do not chase full broker correctness there. The goal is to catch obviously broken economics and flag uncertainty, not solve every conversion and contract pathology immediately.

* **SIMPLIFY NOW:** **Ranking weights** should be centralized but minimally exposed. Too much tunability too early will hide structural flaws behind parameter tweaking.

* **SIMPLIFY NOW:** **Correlation must remain descriptive, not decisive.** It should annotate shortlisted names, not become a complex de-duplication engine in Phase 1.

* **SIMPLIFY NOW:** **PrimaryBucket selection rules** must be simple:

  * eligible only
  * quality floor
  * top 3 or fewer
    Do not let bucket-specific exceptions proliferate.

* **SIMPLIFY NOW:** **Reason code taxonomy** should be small and stable now. Too many granular reject/weak codes in Phase 1 will create maintenance friction and muddy logs.

* **SIMPLIFY NOW:** **Freshness/liveliness scoring** should be straightforward and threshold-based before it becomes nuanced. Fancy freshness math is catnip for wasted time.

---

## 7. What must be live-tested first

* **TEST FIRST:** Raw/derived/validated economics agreement on:

  * EURUSD
  * USDJPY
  * XAUUSD
  * a major index CFD
  * one stock CFD
  * one crypto CFD/pair
  * one odd/suffixed broker symbol

* **TEST FIRST:** Session and freshness behavior on:

  * active FX during liquid hours
  * quiet cross
  * off-session stock CFD
  * weekend/near-weekend crypto
  * symbol with stale quotes but existing history

* **TEST FIRST:** Classification and normalization on:

  * alias variants
  * suffix/prefix variants
  * same canonical symbol across multiple brokers
  * unresolved symbols entering quarantine correctly

* **TEST FIRST:** Scope logic on:

  * all symbols
  * one asset class
  * one PrimaryBucket
  * one custom symbol list
    You need proof that selective testing actually isolates issues instead of creating accidental partial-state behavior.

* **TEST FIRST:** Mode/output behavior:

  * Dev Mode with one targeted export
  * Trader Mode with clean final output only
  * illegal mode combinations rejected deterministically
  * server-partitioned output path correctness

* **TEST FIRST:** Ranking sanity under mixed assets:

  * expensive-but-moving symbol should not beat tradable movers by accident
  * stale symbols should sink
  * weak-but-not-fail names should remain visibly weaker
  * thin buckets should return fewer than 3, not filler garbage

---

## 8. What contracts must be frozen now

* **DESIGN RISK (B):** Freeze the **`ScanRecord` contract**:

  * which fields are permanent
  * which are raw
  * which are derived
  * which are validated
  * which are status fields
  * which are output-only
    Do not let future phases mutate meanings silently.

* **DESIGN RISK (B):** Freeze **status semantics**:

  * `ClassificationStatus`
  * `NormalizationStatus`
  * `EconomicsTrust`
  * `PracticalityStatus`
  * `EligibilityState`
    These must not overlap conceptually.

* **DESIGN RISK (B):** Freeze **reason-code contract**:

  * deterministic
  * stable names
  * stable meaning
  * no module-specific reinterpretation

* **DESIGN RISK (B):** Freeze **module boundaries**:

  * Classification never makes tradability decisions
  * MarketCore never owns ranking
  * Selection never rewrites economics truth
  * OutputDebug never invents business logic

* **DESIGN RISK (B):** Freeze **scope precedence rules**. If multiple filters are active, the order of narrowing must be explicit and invariant.

* **DESIGN RISK (B):** Freeze **mode contract**:

  * what Dev Mode may show/export
  * what Trader Mode must suppress
  * what warnings Trader Mode must still show

* **WATCH:** Version the classification map schema and output schema early. Silent column drift is future pain disguised as flexibility.

---

## 9. What should be watched so growth stays additive

* **WATCH:** Watch `AFS_MarketCore.mqh` for overload. The second it starts absorbing Phase 2/3 exceptions without disciplined sub-ownership internally, growth stops being additive.

* **WATCH:** Watch `ScanRecord` field count and meaning drift. If new phases keep adding permanent columns instead of deriving transient internals inside modules, the master row becomes brittle.

* **WATCH:** Watch for “just one more trust score.” Multiple overlapping trust/quality/confidence concepts are how clean scanners become monsters.

* **WATCH:** Watch for asset-class-specific hacks leaking into global ranking. Asset awareness is necessary; scattered special cases are poison.

* **WATCH:** Watch for Trader Mode gradually inheriting Dev Mode options. Production mode should not become a debug cockpit with a haircut.

* **WATCH:** Watch output artifacts. Once logs and CSVs multiply without tight purpose, debugging gets slower, not better.

* **WATCH:** The first things to log/version/test to protect evolution are:

  * classification map version
  * output schema version
  * reason-code set
  * threshold set
  * score formula version
  * raw/derived/validated disagreement evidence on test symbols

* **WATCH:** Keep helper logic internal unless it becomes independently maintained data ownership. File explosion is not sophistication; it is future archaeology.

---

## 10. Final hardening recommendations

* **BUILD RISK (A):** Treat **economics sanity + friction/activity** as the true core of Phase 1 difficulty. Budget most implementation caution there, not in ranking polish.

* **DESIGN RISK (B):** Freeze the vocabulary of truth now:

  * identity truth
  * market/spec truth
  * validated economics truth
  * eligibility truth
  * ranking truth
    Those layers must never blur.

* **LIVE RISK (C):** Build Phase 1 to **surface uncertainty**, not hide it. A weak or low-trust shortlisted symbol is acceptable. A falsely confident symbol is dangerous.

* **SIMPLIFY NOW:** Keep ranking compact, correlation descriptive, freshness simple, and reason codes limited. Fancy logic here is how “usable now” becomes “repair later.”

* **TEST FIRST:** Hard-test one representative symbol from each hostile category before trusting any score output:

  * FX major
  * JPY pair
  * metal
  * index CFD
  * stock CFD
  * crypto
  * odd alias/suffix symbol

* **DESIGN RISK (B):** Do not allow MarketCore or Selection to quietly absorb classification exceptions. Preserve the user-owned map as the only identity truth, or Phase 7 becomes repair work.

* **WATCH:** The blueprint remains strong if later phases mostly improve confidence, freshness realism, and context richness without changing ownership. The moment a new phase needs contract reinterpretation, stop and refactor immediately.

* **Overall verdict:**
  **The architecture is viable, but only if Phase 1 is treated as a harshly constrained scanner-hardening build, not a feature-complete intelligence platform.**
  Your most likely future repair source is not the grouped-module design. It is hidden ambiguity in statuses, economics truth, and mode/scope semantics. Lock those now, keep Phase 1 coarse where reality is messy, and this stays additive instead of becoming another beast with seven heads and a CSV addiction.
1. Overall red-team verdict

**DESIGN RISK**
The blueprint is directionally strong and much safer than a typical “scanner that quietly becomes a platform,” but Phase 1 is still carrying too much broker-correctness burden for something meant to become usable fast. The architecture is not fatally wrong; the danger is that a few “small” Phase 1 items are actually disguised hard problems and can delay usable output or poison trust in the output.

**BUILD RISK**
Phase 1 is not too big because it has many steps. It is too big because several steps are coupled to broker-specific reality at the same time: classification, economics sanity, ATR/history sufficiency, friction sampling, eligibility, ranking, and shortlist correlation. That is a lot of interacting uncertainty before Trader Mode becomes valid.

**LIVE RISK**
The scanner can look correct in code while being wrong in practice on real brokers. The biggest false-confidence pattern is: clean ranking built on partially wrong economics, partially stale feeds, or mis-normalized symbols. That creates a scanner that “works” visually but teaches the wrong habits.

**WATCH**
The blueprint is most likely to need future repair if you fail to freeze contracts around: ScanRecord semantics, raw/derived/validated separation, reject/weak code determinism, and the exact ownership boundary between MarketCore, HistoryFriction, and Selection.

2. Biggest Phase 1 risks

**BUILD RISK**
The biggest risk to the “usable ASAP” goal is Step 5 plus Step 7 together: economics sanity and friction/activity. Those are deceptively hard because they are not just calculations; they are broker-behavior interpretation layers. They will consume debugging time far beyond their apparent size.

**BUILD RISK**
Phase 1 is still slightly too big for a first “trustworthy usable” release because it requires all of these to be simultaneously credible before Trader Mode is allowed: classification, economics sanity, ATR, friction, eligibility, ranking, and correlation. The dependency chain is long. A defect in any upstream layer contaminates all downstream layers.

**SIMPLIFY NOW**
Minimum safe Phase 1 that still remains useful:

* universe load
* normalization/classification
* coarse tradability/spec sanity
* ATR/history sufficiency
* very simple friction snapshot
* eligibility
* compact ranking
* Top 3 per PrimaryBucket
* Dev Mode + Trader Mode shell

That means correlation should remain present only if it is deliberately lightweight and non-blocking. If correlation becomes mathematically “nice” instead of operationally cheap, it stops being Phase 1-safe.

**BUILD RISK**
The step most likely to quietly become a sinkhole is Step 7, friction and activity. Median spread, max spread, spread/ATR, tick age, update count, liveliness score, and freshness bridge metric sounds tidy on paper, but live feed timing, off-session behavior, synthetic symbols, and quote sparsity will make this much harder than ATR or ranking.

**DESIGN RISK**
The step most likely to create future structural pain if done badly now is Step 5, Market/spec/economics core. If raw broker fields, derived economics, and validated economics are not kept explicitly separate with stable field names and trust rules, every later hardening phase will become repair work instead of additive growth.

**SIMPLIFY NOW**
The part of Phase 1 that must be simplified even if elegant is friction/activity scoring. In Phase 1, it should be a coarse gating and context layer, not a rich market microstructure model. If you make liveliness/freshness too expressive now, it will dominate debugging and distort ranking before the rest of the scanner is stable.

3. Biggest design risks

**DESIGN RISK**
AFS_MarketCore.mqh is the module most likely to become overloaded later. It already owns universe loading, raw spec reading, economics derivation, coarse validation, asset-class-aware handling, and margin/tick/contract sanity. That is not one responsibility family; it is the junction box of the whole scanner. If left unchecked, every future broker quirk gets dumped there.

**DESIGN RISK**
AFS_Selection.mqh is the second likely overload zone. Eligibility, ranking, shortlist correlation, and top-3 selection are adjacent but not identical responsibilities. The danger is not file count. The danger is policy entanglement: one module gradually becoming the place where every scoring rule, exception, and “one more override” lands.

**DESIGN RISK**
The most important contract to freeze now is the semantic meaning of ScanRecord fields, not just field names. Example: `TickValueRaw`, `EconomicsTrust`, `FreshnessScore`, `PracticalityStatus`, `TrustScore`, and `TotalScore` must each have one ownership source and one meaning. If their semantics drift over phases, old tests and old outputs become misleading.

**DESIGN RISK**
The wrapper owning menu, lifecycle, HUD, call order, mode, and export decisions is correct. The failure mode is letting it also own conditional business policy. If the wrapper starts deciding special-case scanning logic, broker-specific exceptions, or scoring shortcuts, the whole architecture will slowly turn into the thing you are trying to avoid.

**DESIGN RISK**
The biggest future entanglement risk is between scope control and pipeline control. If scope filters, test toggles, and module-run flags can combine arbitrarily, you will create invalid execution states: ranking without valid history, correlation without stable eligibility, Trader Mode with half-populated fields, or module outputs from stale prior passes.

**WATCH**
Internal helper logic that should not become separate modules yet:

* score normalization helpers
* symbol string cleanup helpers
* lightweight export formatting helpers
* tiny threshold lookup helpers
* simple HUD text assembly helpers

Splitting these early would create fake modularity and more contracts than value.

**WATCH**
What can turn this into another monster is not number of files. It is uncontrolled state combinations: mode x scope x pipeline x debug x thresholds x asset-class exceptions. That combinatorial surface is the real monster risk.

4. Biggest live-runtime broker risks

**LIVE RISK**
The most dangerous calculations if wrong are not ranking weights. They are:

* symbol identity normalization
* tick size / point interpretation
* tick value meaning
* contract size meaning
* current spread normalization
* spread/ATR ratio
* quote freshness
* history sufficiency assumptions
* asset-class-aware economics trust

If these are wrong, ranking becomes nonsense while still looking coherent.

**LIVE RISK**
What must be live-tested as early as possible:

* raw symbol specs versus observed behavior
* quote freshness versus apparent last price availability
* tick value raw versus OrderCalcProfit implications
* contract size assumptions across metals, indices, stock CFDs, and crypto
* spread statistics across active and off-session states
* visibility/tradability flags versus actual practical usability

**LIVE RISK**
Symbol types most likely to break assumptions:

* JPY FX pairs
* metals with non-FX contract conventions
* cash indices versus futures-like CFDs
* stock CFDs with limited sessions and sparse ticks
* crypto symbols with odd suffixes and weekend behavior
* broker-created synthetic indices or internal “theme” baskets
* symbols with suffix/prefix aliasing that partially matches a canonical name

**LIVE RISK**
Behavior that differs most across brokers:

* suffix/prefix symbol naming
* contract size conventions
* tick value denomination behavior
* margin model behavior
* volume step/min/max practicality
* session behavior and quote freshness
* whether “visible + tradable” actually means operationally usable
* how stale symbols still expose last quotes/specs

**LIVE RISK**
False confidence can happen where code looks correct but reality differs:

* `SYMBOL_TRADE_TICK_VALUE` exists but is not economically useful for your intended interpretation
* `SYMBOL_SPREAD` or current bid/ask exists while the symbol is effectively dead
* ATR populates from old bars, giving movement context to a currently inactive market
* stock CFD has enough historical bars but is outside session, so friction/current activity is misleading
* symbol passes coarse tradability but min volume / step / contract conventions make it practically poor for your workflow
* unresolved alias accidentally maps to a plausible but wrong canonical symbol

**LIVE RISK**
Across FX, JPY, metals, indices, stock CFDs, crypto, and odd symbols, you need to test:

* Digits / Point / TickSize consistency
* TickValueRaw versus profit-currency meaning
* ContractSize realism
* VolumeMin/Step/Max practicality
* spread units versus ATR units
* session openness versus quote freshness
* history density versus actual tradability now
* same canonical asset appearing with different economics across brokers
* alias normalization where the same raw pattern means different asset types on different brokers

**LIVE RISK**
Deposit-currency normalization is likely to go wrong where:

* profit currency differs from margin currency
* tick value is assumed directly usable without checking conversion chain
* synthetic CFDs inherit non-obvious conversion behavior
* account currency changes the apparent comparability of cost metrics across brokers
* OrderCalc-based validation succeeds for one volume assumption but not for normalized comparison purposes

**TEST FIRST**
Explicit raw / derived / validated disagreements that should be logged:

* RawSymbol vs CanonicalSymbol mismatch confidence
* TickSize vs Point mismatch relevance
* TickValueRaw vs derived pip/tick economics
* ContractSize raw vs expected asset-class template
* ProfitCurrency / MarginCurrency vs deposit-currency converted cost
* current spread snapshot vs median sampled spread
* current quote timestamp vs freshness score / tick age
* BarsM15/BarsH1 counts vs history sufficiency decision
* TradeMode/visibility flags vs actual eligibility outcome
* ATR presence vs stale-history condition
* eligibility FAIL/WEAK result vs rank attempt presence

5. Menu/HUD/Mode usability risks

**DESIGN RISK**
The mode model is conceptually clean, but the current settings layout can still become operator-hostile because it exposes both `DevMode` and `TraderMode` as booleans. That is a state-conflict trap. Two booleans create four states, but you only want two valid ones.

**SIMPLIFY NOW**
Mode should behave as one enum-like choice internally even if the input presentation remains simple. Otherwise human operators can produce:

* both off
* both on
* TraderMode on while Phase 1 invalid
* state carried over from a prior test run

**DESIGN RISK**
Pipeline toggles plus testing toggles are duplicative. `RunClassification` and `TestClassificationOnly` are dangerously similar. That creates ambiguity: does one mean execute as part of pipeline, and the other mean isolate execution, or do both partially overlap? Confused toggles create confused test evidence.

**SIMPLIFY NOW**
Merge mental models:

* one control set for execution scope
* one control for pipeline target
* one control for output verbosity

Right now the blueprint risks having three different ways to say “only test this piece,” which will confuse both you and any future handoff.

**WATCH**
The settings most likely to become messy:

* Scope
* Pipeline
* Debug
* Testing
* Thresholds

These are all valid sections, but Scope + Pipeline + Testing in particular can turn into a matrix of ambiguous combinations unless there is a clear precedence order.

**WATCH**
The HUD is most likely to become overloaded in Dev Mode, not Trader Mode. The listed Dev HUD content is already near the upper limit of what is readable on-chart:

* mode
* server
* phase
* step
* active scope
* active module test
* module states
* counts
* reject counts
* weak counts
* anomaly counts
* debug preview
* Top 3 preview

That is enough to become a wall of text, especially on lower-resolution layouts.

**SIMPLIFY NOW**
The HUD should never try to show detailed reject/weak/anomaly breakdowns and Top 3 detail simultaneously. One of those must become secondary. Otherwise the chart becomes a debug console, which breaks both human readability and Trader Mode discipline.

**DESIGN RISK**
Mode behavior that could confuse a human operator:

* Trader Mode appears selectable before it is actually valid
* outputs still reflect previous Dev runs
* filters persist between modes and silently constrain Trader Mode
* selected-symbol test scope remains active and the trader thinks the full universe is being scanned
* debug-only exports are still enabled but hidden from HUD visibility

**WATCH**
The single most dangerous usability issue is stale scope. A user can believe the scanner is live on the broker universe while it is still restricted to a bucket, list, or selected symbol set from prior testing.

6. What must be simplified now

**SIMPLIFY NOW**
Simplify mode control into one effective runtime mode. Keep the locked dual-mode concept, but do not let runtime logic depend on two independent booleans.

**SIMPLIFY NOW**
Simplify testing controls so there is one authoritative “run target” concept. Right now Pipeline and Testing overlap too much. That will create invalid combinations and noisy debugging.

**SIMPLIFY NOW**
Simplify friction/activity for Phase 1:

* keep current spread
* keep short-window median spread
* keep tick age
* keep update count
* derive one coarse liveliness/freshness status

Do not make freshness bridge metric and liveliness score too nuanced yet. They are Phase 3 hardening territory disguised as Phase 1.

**SIMPLIFY NOW**
Simplify economics sanity in Phase 1 to “coarse trust classification,” not “cross-broker correctness solved.” The blueprint already implies this, but you need to be ruthless about it in implementation. Phase 1 must detect obvious badness, not fully explain every broker quirk.

**SIMPLIFY NOW**
Simplify ranking so it remains compact and explainable. If score blending becomes difficult to explain from one row, it is too complex for Phase 1. The first ranking model should be auditable by inspection.

**SIMPLIFY NOW**
Simplify HUD density. Dev HUD should default to summary-first, not detail-first. Detailed panels should only appear when explicitly requested.

7. What must be live-tested first

**TEST FIRST**
Classification normalization on real broker universes:

* suffixes
* prefixes
* aliases
* ambiguous CFD names
* unresolved quarantine behavior

If this is wrong, everything downstream is contaminated.

**TEST FIRST**
MarketCore raw/derived/validated splits:

* FX major
* JPY pair
* gold
* index CFD
* stock CFD
* crypto
* one odd broker symbol

You need side-by-side evidence that the scanner is not silently fabricating sane economics from unsafe raw fields.

**TEST FIRST**
Friction/activity in active and inactive conditions:

* London/NY active FX
* quiet crossover period
* off-session stock CFD
* weekend crypto
* sleepy cross pair

This is where false “tradable enough” judgments will appear.

**TEST FIRST**
Scope persistence and mode switching:

* Dev restricted scope to Trader full scope
* selected symbol test to normal universe scan
* debug exports on/off
* final output cleanliness after prior Dev activity

This is a human-operator integrity test, not just a code test.

**TEST FIRST**
Eligibility-before-ranking enforcement:

* FAIL rows must never get scores that appear tradable
* WEAK rows must never look equivalent to PASS rows
* unresolved rows must not leak into bucket ranking through partial population

**TEST FIRST**
Correlation only on shortlisted eligible names:

* verify no full-universe accidental compute
* verify duplicate symbols / same-theme names behave predictably
* verify correlation remains contextual, not veto-like, in Phase 1

8. What contracts must be frozen now

**DESIGN RISK**
Freeze the ScanRecord contract at semantic level:

* who writes each field
* when it becomes valid
* whether it can be overwritten later
* whether “missing” is distinguishable from “zero”
* whether status fields are mutually exclusive or cumulative

**DESIGN RISK**
Freeze raw / derived / validated naming discipline. Never let a validated value replace a raw field or derived field implicitly. That separation is the backbone of future broker hardening.

**DESIGN RISK**
Freeze reject/weak code determinism:

* same cause must always produce same code
* codes must be stable enough for logs/tests
* one row can have multiple reasons, but reason ordering should be deterministic

Without that, dev exports become hard to diff and future testing becomes subjective.

**DESIGN RISK**
Freeze module ownership boundaries:

* Classification owns identity truth
* MarketCore owns raw specs and economics derivation
* HistoryFriction owns time-series sufficiency and feed-activity context
* Selection owns eligibility/ranking/correlation/selection policy
* OutputDebug owns rendering/export only

If a field can be “fixed anywhere,” growth will become repair work.

**DESIGN RISK**
Freeze execution ordering guarantees. It must be impossible for Selection to operate on partially valid records without knowing they are partial. Explicit per-step completeness flags are more important than clever implicit assumptions.

**WATCH**
Freeze output schema for `top3_by_bucket.csv` early. Trader-facing outputs must not churn field meaning every phase.

9. What should be watched so growth stays additive

**WATCH**
Watch AFS_MarketCore for scope creep. Every broker anomaly will try to land there. Resist turning it into a giant exception registry without explicit anomaly categorization.

**WATCH**
Watch Selection for policy bloat. Eligibility, ranking, and correlation must remain layered. Do not let ranking absorb eligibility exceptions or correlation absorb ranking repair.

**WATCH**
Watch config growth. Threshold centralization is correct, but a giant threshold block can become a pseudo-code layer. If thresholds start compensating for unresolved logic defects, the system is decaying.

**WATCH**
Watch mode growth. Dev Mode is allowed to be rich, but not to become a second product. The moment Dev Mode owns unique business logic unavailable in Trader Mode, you have split the system into two scanners.

**WATCH**
Watch for hidden reclassification logic outside Classification. Any later “just adjust bucket here during ranking” move is structural corrosion.

**WATCH**
Watch for asset-class special cases being copied into multiple modules. If metals logic appears in MarketCore, HistoryFriction, and Selection independently, future maintenance becomes repair-heavy.

**WATCH**
What should be logged/versioned/tested first to protect evolution:

* classification map version/hash
* output schema version
* reject/weak code catalog
* threshold set version
* server-name path resolution behavior
* ScanRecord field population completeness
* anomaly category counts by module

That gives you traceability when future phases change behavior.

10. Final hardening recommendations

**BUILD RISK**
Treat Step 5 and Step 7 as the true Phase 1 danger zone. Budget most hardening attention there, not in ranking polish.

**SIMPLIFY NOW**
Keep correlation in Phase 1 only as shortlist hygiene context. Do not let it become a mathematically ambitious subsystem yet.

**SIMPLIFY NOW**
Collapse mode ambiguity and testing ambiguity now. Two-mode architecture is fine; two-boolean mode state is not. Pipeline/test overlap is not.

**DESIGN RISK**
Freeze the ScanRecord, reject/weak code, and raw/derived/validated contracts before more code is built. Those are the parts most likely to force future repair if left soft.

**LIVE RISK**
Assume economics and friction are guilty until proven live-tested across asset classes. Do not trust apparent correctness from one broker, one session, or one symbol family.

**TEST FIRST**
Run earliest live tests on:

* one FX major
* one JPY pair
* XAUUSD
* one index CFD
* one stock CFD
* one crypto symbol
* one ugly odd-symbol alias

That basket will expose most false assumptions quickly.

**WATCH**
Protect against stale scope and stale mode state. Human-operator confusion is a real failure mode here, not a cosmetic one.

**DESIGN RISK**
Do not allow Trader Mode validity to mean “Phase 1 compiled.” It must mean “Phase 1 contracts are stable enough that the output is not quietly misleading.”

**WATCH**
The blueprint is close to hardenable without redesign. The main threat now is not architecture replacement. It is underestimating how much broker realism is hidden inside “coarse” economics and “simple” friction. If you keep those controlled, keep contracts frozen, and keep mode/test state unambiguous, the design stays additive instead of repair-driven.
1. **Overall red-team verdict**

* **DESIGN RISK**
  The blueprint is directionally strong and much safer than a typical MT5 monolith, but Phase 1 is still carrying too many correctness-sensitive responsibilities for a “usable ASAP” target. It is not fatally overdesigned, but it is one bad implementation away from needing repair in three places: `ScanRecord` contract discipline, raw/derived/validated economics handling, and Dev/Trader mode control logic.

* **BUILD RISK**
  Phase 1 is buildable, but only if “complete usable scanner” is interpreted narrowly and some metrics stay intentionally coarse. If you try to make economics, friction, and cross-asset ranking feel “smart” in Phase 1, it will slip from practical build into sinkhole build.

* **LIVE RISK**
  The scanner can look correct in code and still be wrong on live brokers because the most dangerous failures are not compile failures. They are believable-but-false values: bad tick economics, stale quotes masquerading as live context, off-session instruments appearing low-friction, and deposit-currency distortions making one asset class rank unfairly.

* **WATCH**
  This blueprint will stay healthy only if you treat Phase 1 as a controlled coarse scanner, not as a near-final broker correctness engine. The biggest threat is silent ambition creep inside already-approved modules.

---

2. **Biggest Phase 1 risks**

* **BUILD RISK**
  **Phase 1 is still slightly too big for “usable ASAP.”**
  The single biggest size risk is the combination of:

  * economics sanity across heterogeneous assets
  * friction/activity realism
  * cross-asset ranking comparability
  * shortlist correlation
    Any one of those is manageable. All four together in one first usable release is where Phase 1 becomes deceptively large.

* **BUILD RISK**
  **Biggest risk to the usable-ASAP goal: Step 5 + Step 7 together.**
  Step 5 (market/spec/economics core) and Step 7 (friction/activity) are the highest-risk pair. They are both full of broker-specific edge cases, and they poison later steps if wrong. A ranking system built on bad economics and fake liveness still produces a clean Top 3, which creates false confidence.

* **SIMPLIFY NOW**
  **Minimum safe Phase 1 that still remains useful:**
  Keep all locked steps, but simplify their ambition:

  * economics sanity = coarse PASS/WEAK/FAIL trust, not deep broker correctness
  * friction = current spread + median spread + tick age + update count only
  * ranking = bucket-relative, not universal “all assets equally comparable”
  * correlation = finalists only or top-N-per-bucket only
    That still keeps the scanner useful without pretending Phase 1 has solved full broker realism.

* **BUILD RISK**
  **Most likely sinkhole step: Step 7 friction and activity.**
  Why:

  * session dependence
  * broker quote behavior differences
  * off-session symbols
  * crypto vs FX vs stock CFD feed rhythms
  * spread sampling windows that look scientific but mean different things per asset
    This is the easiest place to burn time refining noisy metrics that still do not generalize.

* **DESIGN RISK**
  **Most likely future structural pain if done badly now: Step 5 economics contract.**
  If raw, derived, and validated economics are not cleanly separated now, you will later have to unwind hidden assumptions in:

  * eligibility
  * ranking
  * debug exports
  * anomaly logic
  * trust scoring
    That is exactly the kind of repair work your blueprint is trying to avoid.

* **SIMPLIFY NOW**
  **Phase 1 step that must be simplified even if elegant: ranking comparability across asset classes.**
  Do not let Phase 1 pretend that FX, metals, indices, stock CFDs, and crypto can be cleanly scored on one subtle shared scale. Use ranking that is explicitly:

  * eligibility-gated
  * trust-aware
  * friction-aware
  * but primarily bucket-relative / class-aware
    If you overreach here, the ranking layer becomes a permanent cleanup zone.

---

3. **Biggest design risks**

* **DESIGN RISK**
  **`ScanRecord` is the most important asset and the most likely future trap.**
  It is correctly declared as the master row, but the danger is predictable:

  * too many fields added “just for now”
  * temporary diagnostics leaking into permanent contract
  * mixed semantics between raw, normalized, and validated values
  * fields becoming both inputs and outputs for different modules
    Once that happens, every module starts depending on every other module’s interpretation.

* **DESIGN RISK**
  **AFS_MarketCore is the module most likely to become overloaded later.**
  It currently owns:

  * universe loading
  * spec reading
  * economics derivation
  * coarse validation
  * asset-aware handling
  * margin/tick/contract sanity
    That is already a broad responsibility family. It is the most likely future dumping ground for every weird broker fix. If not controlled, it becomes the hidden monolith inside the grouped architecture.

* **DESIGN RISK**
  **Mode ownership is good at wrapper level, but boolean mode design is fragile.**
  Having both:

  * `DevMode = true/false`
  * `TraderMode = true/false`
    creates invalid combinations unless one authoritative mode enum controls behavior. Otherwise you will have states like:
  * both false
  * both true
  * one true but pipeline/debug toggles inconsistent
    This is not a redesign issue; it is a contract-hardening issue.

* **DESIGN RISK**
  **Pipeline toggles + testing toggles create contract ambiguity.**
  You currently have both:

  * pipeline run toggles
  * testing-only toggles
    That invites contradictory states, such as:
  * `RunFullPipeline=true` and `TestClassificationOnly=true`
  * `RunRanking=true` while prerequisites are not run/refreshed
  * stale ScanRecord values surviving partial test runs
    This is a design risk because partial execution without explicit data validity rules leads to ghost bugs.

* **DESIGN RISK**
  **Server-name partitioning is correct, but naming/identity collision rules are underspecified.**
  Output partitioning by server name is better than login, but you still need a frozen rule for:

  * sanitization
  * maximum path-safe length
  * collision handling for similar server names
  * whether server rename changes path identity
    If this is fuzzy, file continuity breaks later.

* **WATCH**
  **Classification is correctly separate, but map ownership can become pseudo-code.**
  The danger is stuffing more and more runtime logic into classification metadata until the CSV becomes a second codebase. Keep it as identity/truth mapping, not a hidden strategy layer.

---

4. **Biggest live-runtime broker risks**

* **LIVE RISK**
  **Most dangerous calculations if wrong:**

  1. `TickValueRaw` interpretation
  2. deposit-currency normalization
  3. spread-to-ATR ratio across symbols with very different quote structures
  4. tick age / update count as proxies for “tradeability now”
  5. contract-size-derived economics for stock CFDs and indices
     These are dangerous because the scanner remains plausible even when they are wrong.

* **TEST FIRST**
  **What must be live-tested as early as possible:**

  * raw vs validated tick economics using `OrderCalcProfit`
  * margin sanity using `OrderCalcMargin`
  * quote freshness behavior during active and quiet periods
  * off-session symbol handling
  * spread sampling on symbols that gap, freeze, or widen irregularly
  * symbol alias normalization across brokers for same underlying
    These should be tested before ranking is trusted.

* **LIVE RISK**
  **Symbol types most likely to break assumptions:**

  * JPY pairs
  * metals with non-FX contract behavior
  * cash indices vs futures-style CFDs
  * stock CFDs with session gaps and thin quote updates
  * crypto symbols with suffixes and weird tick economics
  * odd symbols with custom contract sizes or misleading names
  * synthetic broker instruments
  * symbols visible in Market Watch but not genuinely tradable

* **LIVE RISK**
  **Behavior that differs most across brokers:**

  * contract size conventions
  * tick value reliability
  * profit and margin currency fields
  * allowed volume granularity
  * quote heartbeat during off-session
  * symbol visibility vs actual tradeability
  * suffix/prefix naming conventions
  * treatment of suspended/close-only instruments

* **LIVE RISK**
  **Where false confidence happens even when code looks correct:**

  * `SYMBOL_TRADE_TICK_VALUE` returns something nonzero, so code assumes economics are sane
  * current spread is tight, but symbol is effectively stale
  * history exists, but recent market behavior is dead/off-session
  * ATR is populated, but not meaningful for current session state
  * ranking produces stable-looking scores, but one asset class is systematically advantaged by normalization error
  * shortlisted symbols look diversified by bucket, but are actually same-theme risk

* **TEST FIRST**
  **What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:**

  * point vs tick size mismatch
  * tick value consistency under different hypothetical lot sizes
  * contract size sanity
  * profit currency and margin currency correctness
  * spread units vs ATR units alignment
  * stale quote detection
  * session-open vs off-session update rhythm
  * bars availability on M15/H1
  * alias normalization to canonical symbol
  * eligibility reason-code consistency across asset classes

* **LIVE RISK**
  **Where deposit-currency normalization is likely to go wrong:**

  * assuming `TickValueRaw` is already fully normalized
  * assuming account currency handling is uniform across brokers
  * using one conversion path for instruments whose profit currency differs from quote intuition
  * JPY and metals where pip-style human intuition leaks into formula logic
  * stock CFDs quoted in local currency while account is in something else
  * crypto crosses not directly mappable to account currency
  * fallback conversion using stale or missing bridge symbols

* **TEST FIRST**
  **Raw/derived/validated disagreements that should be explicitly logged:**

  * raw tick value vs validated per-lot profit delta
  * raw margin expectation vs `OrderCalcMargin`
  * raw trade mode vs actual practical tradability decision
  * current spread vs median spread vs max spread
  * tick age low but update count poor
  * ATR present but bars thin/stale
  * classification confidence high but economics trust low
  * symbol visible but rejected as non-practical
  * canonical mapping resolved but subtype/asset-class inconsistent with economics behavior

---

5. **Menu/HUD/Mode usability risks**

* **DESIGN RISK**
  **The settings block can still become messy because it mixes user intent, build state, and execution state.**
  Example problem groups:

  * phase tags mixed with real operator controls
  * mode booleans mixed with hard validity constraints
  * pipeline toggles mixed with testing toggles
  * output toggles mixed with debug verbosity
    The menu is readable now on paper, but real usability will collapse if these do not have clear precedence rules.

* **SIMPLIFY NOW**
  **Mode switching is conceptually fine, but operator confusion risk is high with dual booleans.**
  Human confusion points:

  * “Why is TraderMode true but not actually honored?”
  * “Why is DevMode off but debug still visible?”
  * “Why did partial pipeline settings persist when I switched modes?”
    This is an operator risk, not just a code risk.

* **BUILD RISK**
  **Selective testing one scope at a time is good, but the control surface is too broad for Phase 1 if not pruned.**
  Current risk:

  * asset class filter
  * bucket filter
  * sector filter
  * symbol filter
  * custom symbol list
  * selected symbols only
  * visible only
  * selected scope
    That is powerful, but too many overlapping ways to define scope create ambiguous test runs and user mistakes.

* **DESIGN RISK**
  **HUD overload risk is real in Dev Mode.**
  Your Dev HUD wants to show:

  * counts
  * rejects
  * weaks
  * anomalies
  * module states
  * output previews
  * Top 3 preview
    On MT5 chart real estate, that can quickly become unreadable, especially if scope-specific inspection is also active. The likely failure mode is the HUD becoming “technically rich but operationally ignored.”

* **SIMPLIFY NOW**
  **Toggles/settings that should be merged or precedence-constrained:**

  * `DevMode` and `TraderMode` should not behave as independent peer switches
  * pipeline step toggles and test-only toggles need one authority
  * scope selection methods need one precedence chain
  * output toggles should inherit from mode unless explicitly overridden in Dev
    Otherwise the system becomes configurable in too many contradictory ways.

* **WATCH**
  **Mode behavior most likely to confuse a human operator:**

  * Trader Mode invalid because Phase 1 not complete, but still selectable
  * “selected function test” using stale results from previous full run
  * hidden filters causing Top 3 to look incomplete
  * unresolved symbols excluded silently when user expects to see them
  * clean Trader HUD showing ranked outputs without surfacing a material trust warning

---

6. **What must be simplified now**

* **SIMPLIFY NOW**
  **Ranking must stay compact and bucket-relative in Phase 1.**
  Do not attempt refined universal cross-asset score calibration yet. Make ranking honest:

  * within eligible set
  * trust-aware
  * friction-aware
  * but not overpromising precision across all instrument types

* **SIMPLIFY NOW**
  **Friction/activity should use a short fixed metric set in Phase 1.**
  Keep:

  * current spread
  * median spread
  * max spread
  * tick age
  * update count
    Treat `LivelinessScore` and `FreshnessScore` as coarse outputs, not nuanced models. Anything more will become hand-tuning hell.

* **SIMPLIFY NOW**
  **Economics sanity must stay coarse in Phase 1.**
  It should answer:

  * obviously broken
  * suspicious
  * plausible
    It should not try to solve full broker correctness yet. That belongs to hardening phases.

* **SIMPLIFY NOW**
  **Scope control needs one dominant selection path.**
  Too many overlapping scope selectors in Phase 1 will cause test ambiguity. One dominant scope expression should be interpreted at a time, not many blended heuristics.

* **SIMPLIFY NOW**
  **Dev exports must stay evidence-driven, not “export because available.”**
  The moment every module can emit its own CSV by default, Dev Mode stops being selective and starts becoming noise.

---

7. **What must be live-tested first**

* **TEST FIRST**
  **Economics validation on representative symbols per asset class.**
  Minimum set:

  * EURUSD
  * USDJPY
  * XAUUSD
  * one major index CFD
  * one stock CFD
  * one crypto symbol
  * one odd/suffixed broker symbol
    Compare raw fields against validated MT5 behavior, not just internal formulas.

* **TEST FIRST**
  **Quote freshness and liveliness under three states:**

  * active session
  * quiet but live
  * off-session/stale
    The scanner must distinguish these, or Step 7 becomes misleading.

* **TEST FIRST**
  **Spread sampling realism across regime changes.**
  Check:

  * open
  * normal liquid period
  * illiquid period
  * off-session
    Median spread by itself can lie badly if the sample window is poorly timed.

* **TEST FIRST**
  **Classification normalization against real broker naming mess.**
  Test suffixes, prefixes, different crypto naming, stock CFD namespaces, and unresolved quarantine behavior.

* **TEST FIRST**
  **Eligibility-before-ranking enforcement under partial runs.**
  This must be verified in live use, not just compile logic. A stale or partially enriched `ScanRecord` must never sneak into ranking/output.

* **TEST FIRST**
  **Server output partitioning and path stability.**
  Test multiple terminals, same Common Files root, different servers, and sanitize edge cases. This is a quiet corruption risk, not a cosmetic one.

---

8. **What contracts must be frozen now**

* **DESIGN RISK**
  **Freeze `ScanRecord` field semantics now.**
  Not just names. Semantics. For each stable field, define:

  * owner module
  * whether it is raw/derived/validated/final
  * whether it may be absent
  * whether partial runs may leave it stale
  * whether downstream modules may reinterpret it
    This is the most important contract to freeze.

* **DESIGN RISK**
  **Freeze reason-code contract now.**
  Reject and weak codes must be:

  * stable
  * deterministic
  * non-overlapping in meaning
  * safe for logs, HUD, exports, and future analytics
    If reason codes drift, debugging history becomes useless.

* **DESIGN RISK**
  **Freeze mode precedence now.**
  You need one authoritative rule for:

  * current mode
  * whether Trader Mode is permitted
  * what settings are ignored in Trader Mode
  * what partial-test toggles are legal in each mode
    This must not be inferred ad hoc in wrapper logic.

* **DESIGN RISK**
  **Freeze scope resolution precedence now.**
  Which wins:

  * custom list
  * symbol filter
  * bucket filter
  * asset class filter
  * visible only
  * selected symbols only
    Without a fixed precedence chain, test reproducibility dies.

* **DESIGN RISK**
  **Freeze raw/derived/validated economics ownership now.**
  This contract matters more than the formulas themselves. Every future hardening phase depends on it.

* **DESIGN RISK**
  **Freeze final output eligibility contract now.**
  Top 3 rows must only come from records that are:

  * classified
  * eligible or explicitly weak-allowed
  * trust-qualified
  * correlated after shortlist stage
    Do not let future convenience shortcuts bypass this.

---

9. **What should be watched so growth stays additive**

* **WATCH**
  **Watch AFS_MarketCore for becoming the monster.**
  Every broker quirk will want to land there. Enforce a rule that MarketCore may derive and validate, but not quietly absorb ranking policy, anomaly policy, or classification overrides.

* **WATCH**
  **Watch AFS_Selection for hidden strategy creep.**
  Because the EA is not a signal engine, Selection must not start absorbing:

  * session tactics
  * entry-like logic
  * pattern semantics
  * opportunity state predictions in disguise
    That is how scanners become accidental signal bots.

* **WATCH**
  **Watch classification map growth so it does not become a rule engine.**
  Identity and bucket truth belong there. Dynamic scanner behavior does not.

* **WATCH**
  **Keep tiny helper logic internal; do not split prematurely.**
  In particular, these should remain internal helpers unless they become independently maintained:

  * symbol name cleanup helpers
  * score normalization helpers
  * simple anomaly-formatting helpers
  * HUD text formatting helpers
    Splitting these too early recreates file sprawl without architectural benefit.

* **WATCH**
  **Protect against ISSX-style monster growth by monitoring three symptoms:**

  * too many toggles to explain in one screen
  * too many fields added to ScanRecord without contract notes
  * modules reaching across boundaries “just for one extra check”
    Those are early warning signs of future repair work.

* **WATCH**
  **Log/version/test these first to protect future evolution:**

  * classification map version
  * threshold set version
  * output schema version
  * reason-code list version
  * ScanRecord contract version
  * mode behavior version / build label linkage
    Versioning these early makes later comparison and rollback possible.

---

10. **Final hardening recommendations**

* **BUILD RISK**
  Treat Phase 1 as a coarse trustworthy scanner, not an early-final correctness engine. The architecture supports that. Over-optimizing Phase 1 metrics is the main delivery risk.

* **SIMPLIFY NOW**
  Reduce ambition specifically in:

  * economics depth
  * liveliness sophistication
  * cross-asset score comparability
  * correlation breadth
    Keep the outputs useful, but keep the internals intentionally blunt where broker truth is not yet hardened.

* **DESIGN RISK**
  Lock down four contracts before more code grows:

  * ScanRecord semantics
  * mode precedence
  * scope precedence
  * raw/derived/validated economics ownership
    Those are the highest-value anti-repair controls.

* **LIVE RISK**
  Assume live brokers will invalidate elegant logic. Your scanner’s biggest enemy is plausible wrongness, not obvious failure. Log disagreements explicitly wherever a human might otherwise trust the output too easily.

* **TEST FIRST**
  Run early hard tests on representative symbols across asset classes and across active/quiet/off-session conditions before trusting ranking. Ranking should be the last thing you emotionally trust, not the first thing you make look polished.

* **WATCH**
  The blueprint remains safe only if growth stays additive at the contract level, not just at the file/module level. A grouped architecture can still become a monolith if contracts blur.

**Bottom line:**
This blueprint does not need redesign. It needs discipline. The weak points are not structure, but over-ambitious Phase 1 expectations, mode/control ambiguity, and hidden broker-correctness assumptions. If those are constrained now, the system is buildable and unlikely to require architecture repair later.
1. Overall red-team verdict

* DESIGN RISK: The blueprint is directionally strong and much safer than a typical “scanner that secretly wants to become a platform,” but Phase 1 is still carrying too many correctness-sensitive responsibilities at once. It is buildable, but only if “usable scanner” is interpreted as a narrow, disciplined first release rather than a broker-universal truth engine.
* BUILD RISK: The main danger is not code size alone. It is the number of places where Phase 1 can look finished while still being wrong in subtle ways: classification aliasing, economics sanity, spread/ATR comparability, freshness, and bucket output quality.
* LIVE RISK: The architecture will survive only if broker disagreement is treated as expected reality, not exception handling. MT5 symbol metadata often looks valid while being operationally misleading.
* WATCH: The blueprint is closest to failure where it tries to combine “usable ASAP” with “cross-asset broker hardening” inside the same first milestone. That tension is the real enemy.

2. Biggest Phase 1 risks

* BUILD RISK: Phase 1 is still too big for a truly low-risk first usable release because it includes five separate uncertainty domains at once: classification truth, economics sanity, history sufficiency, friction/activity realism, and shortlist correlation. Any one of those can consume the schedule.
* BUILD RISK: The biggest risk to the “usable ASAP” goal is Step 5 Market/spec/economics core. Not because it is the largest file, but because it touches the most broker-specific ambiguity and can quietly poison ranking if it is only half-correct.
* SIMPLIFY NOW: The minimum safe Phase 1 that still keeps the scanner useful is:

  * classification and quarantine
  * basic tradability/spec sanity
  * ATR/history sufficiency
  * simple friction snapshot plus short sample
  * deterministic eligibility
  * compact ranking
  * Top 3 per PrimaryBucket
  * Trader HUD/output
    Shortlist correlation can remain in Phase 1 only if it is strictly lightweight and shortlist-only exactly as defined. If correlation starts demanding broad statistical hygiene, it becomes Phase 2 material in practice.
* BUILD RISK: The most likely sinkhole is Step 7 Friction and activity. Spread sampling, tick age, update count, liveliness, and freshness bridge look compact on paper but become messy across off-session symbols, sparse feeds, synthetic symbols, and differing quote frequencies.
* DESIGN RISK: The Phase 1 step most likely to create future structural pain if done badly now is Step 4 normalization + classification. If canonical identity and bucket ownership are fuzzy, every later output becomes contaminated and you will end up building workaround logic in MarketCore, Selection, and Output.
* SIMPLIFY NOW: The part that most needs simplification even if elegant is “freshness bridge metric.” In Phase 1 it should stay a narrow, transparent score from a few observable inputs, not a sophisticated state concept. Otherwise it becomes an invisible ranking lever that is hard to trust or debug.

3. Biggest design risks

* DESIGN RISK: AFS_MarketCore is the module most likely to become overloaded later. It already owns universe loading, raw spec reading, economics derivation, coarse validation, asset-class-aware handling, and margin/tick/contract sanity. That is the natural dumping ground for every future broker quirk.
* DESIGN RISK: The most important contract to freeze now is the boundary between Classification truth and MarketCore truth. Classification decides identity and bucket lineage. MarketCore must not start “fixing” identity based on broker specs or ad hoc heuristics.
* DESIGN RISK: The second contract to freeze now is the semantic meaning of ScanRecord fields, especially PASS/WEAK/FAIL states, trust grades, and raw/derived/validated economics fields. If field meaning drifts, later phases will become retrofits instead of additive work.
* DESIGN RISK: Entanglement risk is highest between Selection and HistoryFriction. Once ranking starts depending on nuanced freshness, movement, friction confidence, and trust weighting, people will be tempted to push scoring rules backward into data collection modules. That must be resisted.
* WATCH: Do not let every diagnostic become a first-class ScanRecord field. Stable fields only. Otherwise ScanRecord becomes a junk drawer and future changes become schema surgery.
* WATCH: Tiny helper logic for symbol string cleanup, quote age formatting, threshold evaluation, score clipping, and CSV formatting should remain internal helpers, not new modules. Splitting those out early would create fake architecture and unnecessary contracts.
* WATCH: The thing most likely to recreate an ISSX-style monster is allowing “one more debug toggle” or “one more HUD line” for every edge case. Operational complexity will grow faster than feature value.

4. Biggest live-runtime broker risks

* LIVE RISK: The most dangerous calculations if wrong are:

  * tick value interpretation
  * deposit-currency normalization
  * spread/ATR comparability
  * tradability/session assumptions
  * contract-size-derived practicality
    These do not just make values noisy; they can invert ranking quality.
* LIVE RISK: What must be live-tested as early as possible is anything relying on symbol economics and live quote behavior, not just static metadata. A symbol can expose sane fields and still behave badly in quote freshness, spread regime, or session availability.
* LIVE RISK: Symbol types most likely to break assumptions:

  * JPY FX pairs due to point/pip intuition leaks
  * metals with unusual contract sizes or tick values
  * cash indices vs futures-style CFDs
  * stock CFDs with off-session quotes and sparse history
  * crypto symbols with weekend behavior and abnormal spread regimes
  * broker suffix/prefix aliases and synthetic “.pro/.m/.i/.cash/.mini/.ecn” variants
  * odd symbols with visible quotes but non-practical trading conditions
* LIVE RISK: Behavior that differs most across brokers:

  * symbol naming
  * contract size
  * tick value reliability
  * margin model
  * session openness exposure
  * available history depth
  * quote frequency
  * spread behavior outside active sessions
* LIVE RISK: False confidence can happen where code looks correct but assumptions are wrong:

  * SymbolInfo values populate but are economically misleading
  * ATR exists on stale or thin history
  * spread sample is taken during a dead regime and treated as normal
  * update count is high because of noise, not tradable activity
  * a symbol passes coarse validation but is unusable in real trading conditions
* TEST FIRST: Across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols, explicitly test:

  * raw Digits/Point/TickSize relationships
  * TickValueRaw vs validated profit behavior
  * ContractSize and lot step practicality
  * MarginCurrency and ProfitCurrency interactions
  * session-open behavior
  * quote age when market is closed vs merely quiet
  * ATR scale consistency
  * spread behavior during active and inactive periods
* LIVE RISK: Deposit-currency normalization is likely to go wrong when:

  * margin currency differs from profit currency
  * symbols are quoted in a third currency
  * broker provides incomplete conversion chains
  * TickValueRaw is present but not aligned to actual account currency
  * synthetic CFDs return values that look normalized but are not stable
* TEST FIRST: Raw/derived/validated disagreements that should be explicitly logged:

  * TickValueRaw vs OrderCalcProfit-implied tick value
  * theoretical point value vs validated P/L move
  * expected margin estimate vs OrderCalcMargin result
  * broker trade mode says tradable but order calculations fail
  * quote present but TickAge/update count indicates dead feed
  * classification says FX/metals/index/stock/crypto but spec behavior is inconsistent with that class
  * spread snapshot vs sample median/max regime disagreement
  * ATR present but bars/history recency below confidence threshold

5. Menu/HUD/Mode usability risks

* DESIGN RISK: The current settings layout is still too toggle-heavy. It is readable as a blueprint, but in the actual MT5 Inputs dialog it can become hostile quickly because booleans multiply into contradictory combinations.
* SIMPLIFY NOW: DevMode and TraderMode should not both be freely user-set booleans. That invites illegal state combinations. One mode enum is cleaner operationally even if the internal architecture still supports both personalities.
* DESIGN RISK: Pipeline toggles plus Testing toggles overlap conceptually. “RunClassification” and “TestClassificationOnly” are close enough to confuse the operator and create ambiguous execution rules.
* SIMPLIFY NOW: Merge pipeline/test behavior into one execution scope concept. One control should answer “how far through the pipeline do we run,” and one control should answer “what symbol scope do we run it on.” Separate duplicated toggles will create mistakes.
* DESIGN RISK: Scope filters can become messy because AssetClassFilter, PrimaryBucketFilter, SectorFilter, SymbolFilter, CustomSymbolList, ScanVisibleOnly, and ScanSelectedScope can interact in non-obvious ways. Without precedence rules, the user will not know what is actually being scanned.
* WATCH: The HUD is at risk of overload in Dev Mode. “module states, counts, reject counts, weak counts, anomaly counts, selected debug preview, Top 3 preview” is already near the edge of what remains readable on a chart.
* SIMPLIFY NOW: Show either diagnostics or shortlist preview by default in Dev HUD, not both at full density. Otherwise the HUD becomes a compressed audit page.
* DESIGN RISK: Trader Mode can still confuse the operator if Phase 1 completeness is internally enforced but not visibly explained. If TraderMode is unavailable, the HUD and logs must say exactly why, or the user will think the mode is broken.
* WATCH: BuildLabel / Version, CurrentPhaseTag, and CurrentStepTag are useful in Dev Mode but easily become noise in Trader Mode. Keep them out unless explicitly needed.
* WATCH: ShowDebugPanel, ShowCounts, ShowModuleStates, ShowCorrelationPreview, CompactHUD, and multiple debug flags can produce too many combinations to mentally model. The more combination states you support, the less predictable the UI becomes.

6. What must be simplified now

* SIMPLIFY NOW: Narrow economics sanity in Phase 1 to “enough to catch obvious broker lies and unusable symbols,” not “correct across all asset classes.” Anything beyond coarse validation plus logged disagreement becomes a Phase 2 hardening concern.
* SIMPLIFY NOW: Keep ranking compact and transparent. Do not let TotalScore become a dense weighted blend of partially trusted components. In Phase 1, fewer score inputs with obvious effects are safer than nuanced weighting.
* SIMPLIFY NOW: Freshness, liveliness, and update count must not become three overlapping pseudo-concepts. They need strict semantic separation:

  * TickAge = last update delay
  * UpdateCount = number of updates in window
  * Freshness/Liveliness score = derived interpretation
    If not, you will debug semantics instead of behavior.
* SIMPLIFY NOW: Correlation must remain finalist/shortlist-only and informational in Phase 1. If it starts affecting eligibility aggressively, you create hidden selection behavior too early.
* SIMPLIFY NOW: Scope logic needs an explicit precedence chain now. Example: CustomSymbolList > SymbolFilter > PrimaryBucket/Sector/AssetClass > visible universe. Without a frozen order, test results will be inconsistent and hard to reproduce.
* SIMPLIFY NOW: Reason code taxonomy should stay small in Phase 1. Too many reject/weak codes early will look precise but increase ambiguity and code branching.

7. What must be live-tested first

* TEST FIRST: Classification and normalization on mixed broker aliases. This is the first place silent corruption enters the pipeline.
* TEST FIRST: Raw vs validated economics on at least one representative symbol per asset family:

  * EURUSD
  * USDJPY
  * XAUUSD
  * one major index CFD
  * one stock CFD
  * one crypto CFD
  * one deliberately odd suffix/prefix symbol
* TEST FIRST: Quote freshness and friction during:

  * active session
  * quiet session
  * off-session
  * weekend for crypto vs non-crypto
* TEST FIRST: History sufficiency and ATR integrity on symbols with deep history and thin history. A symbol with bars available is not the same as a symbol with useful recent history.
* TEST FIRST: Eligibility boundary behavior. Verify that FAIL symbols never reach ranking, and WEAK symbols remain visible but appropriately penalized.
* TEST FIRST: Bucket output quality. The final Top 3 per PrimaryBucket should be inspected manually for “looks sensible” across at least two brokers. This is where many earlier flaws first become visible to a human.
* TEST FIRST: Server-based output partitioning with multiple accounts on same server and, separately, same broker brand across different server names. This can still surprise you operationally.

8. What contracts must be frozen now

* DESIGN RISK: Freeze ScanRecord field semantics now. Not just field names. Define whether each field is raw, derived, validated, final, optional, or confidence-scoped.
* DESIGN RISK: Freeze classification authority now:

  * classification map is sole identity truth
  * unresolved symbols never rank
  * MarketCore cannot silently override CanonicalSymbol or bucket lineage
* DESIGN RISK: Freeze eligibility contract now:

  * PASS/WEAK/FAIL meanings
  * fail-before-ranking rule
  * whether weak symbols can appear in Top 3
  * whether correlation can only weaken or can reject
* DESIGN RISK: Freeze mode contract now:

  * what output is permitted in Trader Mode
  * what debug artifacts are prohibited in Trader Mode
  * what happens when Trader Mode is requested before Phase 1 completion
* DESIGN RISK: Freeze scope-resolution contract now. Every run must be reproducible from settings alone.
* DESIGN RISK: Freeze raw/derived/validated logging contract now. If disagreement evidence is not standardized early, later broker hardening will become anecdotal rather than systematic.
* WATCH: Freeze folder/path naming and server sanitization rules now. Output conventions are painful to change after files start being consumed externally.

9. What should be watched so growth stays additive

* WATCH: Watch AFS_MarketCore for scope creep. If every broker anomaly, asset quirk, and validation heuristic lands there, it will become the real monolith even if the file count stays low.
* WATCH: Watch Selection for hidden policy growth. It should decide selection, not become a second data-cleaning layer or a backdoor classifier.
* WATCH: Watch HUD/settings growth. UI complexity is often how scanner projects become unmaintainable even when core computation is still clean.
* WATCH: Watch ScanRecord size. Additive growth should enrich via stable, meaningfully named fields, not append every experimental metric.
* WATCH: Watch threshold sprawl. Centralized thresholds are correct, but too many thresholds become a disguised programming language. The test for every new threshold should be: does it protect a stable concept, or patch a weak implementation?
* WATCH: Watch anomaly logging discipline. Log categories should support diagnosis and regression testing, not become a dumping ground for every surprising value.
* WATCH: Version first:

  * classification map format
  * reason code list
  * output CSV schema
  * threshold set
  * score formula version
    These are the things most likely to create invisible drift between builds.
* WATCH: Test first:

  * canonical mapping regressions
  * eligibility regressions
  * ranking order regressions on fixed test symbol sets
  * raw/validated disagreement regressions
    Protect these before adding cleverness.

10. Final hardening recommendations

* BUILD RISK: Treat Step 5 and Step 7 as the true gating steps for Phase 1, not correlation or final output polish. If economics sanity and friction/activity realism are weak, the scanner can be finished and still not be trustworthy.
* SIMPLIFY NOW: Reduce operator-state complexity in the menu. Collapse duplicated mode and test toggles into fewer, deterministic controls with clear precedence.
* DESIGN RISK: Freeze the classification boundary and ScanRecord semantics before more code is written. Those are the two contracts most expensive to repair later.
* LIVE RISK: Make disagreement logging first-class from day one. For any symbol that passes with low trust or conflicting evidence, preserve raw/derived/validated traces. That is the only reliable way to harden across brokers.
* TEST FIRST: Build a mandatory broker test pack of representative symbols across asset families and rerun it every time economics, friction, eligibility, or ranking changes.
* WATCH: Keep Phase 1 scoring explainable by inspection. If a human cannot quickly see why a symbol ranked above another, future hardening will turn into weight-chasing.
* SIMPLIFY NOW: Keep correlation informational unless there is overwhelming evidence to make it more powerful. Early aggressive overlap logic is more likely to hide scanner quality problems than solve them.
* WATCH: Do not let “health/anomaly evidence” become an always-on subsystem. Selective, reproducible evidence is good. Constant debug exhaust is not.
* DESIGN RISK: Decide now whether weak names are allowed into Top 3 when a bucket is thin. That policy must be explicit, because it affects both trader trust and later bucket-quality logic.
* FINAL VERDICT — WATCH: The blueprint does not need redesign. It needs disciplined narrowing of Phase 1 semantics, stronger contract freezing, and earlier live disagreement testing. If you do those three things, growth can stay additive. If you do not, the system will appear to evolve while actually accumulating deferred repair work.
## 1. Overall red-team verdict

**DESIGN RISK**
The blueprint is directionally strong, but Phase 1 is still carrying too much broker-correctness burden for something labeled “usable ASAP.” The architecture is not the main problem. The danger is that several Phase 1 items look compact on paper but are actually ambiguity traps in MT5: symbol normalization, economics sanity, friction/activity, and cross-asset ranking comparability. Those four can quietly consume most of the build.

**BUILD RISK**
Phase 1 is buildable, but only if “complete usable scanner” is interpreted narrowly and several calculations stay coarse, explicit, and conservative. If you try to make economics validation, friction realism, and ranking “smart” in Phase 1, it will stop being a practical first usable release and become a sinkhole.

**LIVE RISK**
The biggest real-world failure mode is false confidence: code compiles, outputs look clean, Top 3 appears sensible, but the scanner is wrong because broker symbol metadata, quote freshness, spread behavior, session state, or deposit-currency assumptions are misleading. This system is more vulnerable to “plausible wrongness” than outright crashes.

**WATCH**
Your locked architecture probably survives. The repair risk is not “wrong framework,” it is “too much inferred trust in weak broker data too early.”

---

## 2. Biggest Phase 1 risks

**BUILD RISK**
The biggest risk to the “usable ASAP” goal is **Step 5 + Step 7 + Step 9 together**, not any single step:

* Step 5 economics sanity across FX, JPY, metals, indices, stock CFDs, crypto, odd CFDs
* Step 7 friction/activity realism across active, quiet, off-session, and stale symbols
* Step 9 compact ranking across mixed asset classes

Individually they seem manageable. Together they create a normalization/comparability problem that can eat the phase.

**BUILD RISK**
**Phase 1 is still too big** if “economics sanity” means more than coarse gating and explicit trust grading. It is also too big if friction/activity tries to become a robust market microstructure model. Those are Phase 2/3 instincts trying to enter Phase 1.

**SIMPLIFY NOW**
The **minimum safe Phase 1 that still keeps the scanner useful** is:

* universe load
* symbol normalization + classification
* coarse spec/economics sanity
* ATR on M15/H1
* simple live friction snapshot
* eligibility with deterministic reject/weak reasons
* simple ranking inside explicit trust bounds
* shortlist-only correlation
* Top 3 per PrimaryBucket output
* clean Trader Mode

That means Phase 1 can still include all locked items, but with deliberately low ambition in:

* economics validation depth
* freshness/liveliness sophistication
* cross-asset score normalization

**BUILD RISK**
The step most likely to quietly become a **sinkhole** is **Step 7 friction and activity**. It looks small, but it is where session state, stale feed, quote cadence, instrument type, market hours, and “symbol exists but is not really tradable now” all collide.

**DESIGN RISK**
The step most likely to create future structural pain if done badly now is **Step 5 market/spec/economics core**. If raw, derived, and validated values are not separated cleanly now, later hardening will turn into repair work everywhere: eligibility, ranking, anomaly logging, and trust scoring.

**SIMPLIFY NOW**
The part that must be simplified even if architecturally elegant is **ranking comparability across asset classes**. In Phase 1, ranking should remain intentionally blunt and trust-gated. If you try to make one elegant universal score across FX, metals, indices, stock CFDs, and crypto now, you will either overfit or hide broken assumptions.

---

## 3. Biggest design risks

**DESIGN RISK**
The most important architectural risk is **ScanRecord becoming a dumping ground**. You say only stable fields go in it, which is correct, but the current field list is already close to “one row owns everything.” The danger is not too few fields. The danger is that temporary diagnostics, phase-specific convenience values, and half-validated interpretations start leaking into the master row. Once that happens, module boundaries rot without obvious breakage.

**DESIGN RISK**
The grouped module most likely to become overloaded later is **AFS_MarketCore.mqh**. It already owns:

* universe loading
* raw spec reading
* economics derivation
* coarse validation
* asset-class-aware handling
* margin/tick/contract sanity

That is a natural overload magnet because every broker quirk will want to land there. If you are not strict, it becomes “all ugly truths live here,” which then bleeds complexity into the whole system.

**DESIGN RISK**
The second likely overload point is **AFS_OutputDebug.mqh**. Output, health logs, anomaly logs, selective views, summaries, and mode-aware exports can easily turn into hidden orchestration. If output code starts deciding what is important, it is no longer just output.

**DESIGN RISK**
The contract most important to freeze now is **the boundary between classification truth, broker raw fields, and scanner interpretation**. Specifically:

* classification map is truth for identity/bucketing
* broker is truth for raw tradability/spec fields
* scanner derives scores/trust/eligibility from those, but never rewrites the raw truth

If that line blurs, later debugging becomes impossible.

**DESIGN RISK**
Future feature growth is most likely to create entanglement in **Selection**. Eligibility, ranking, correlation, quality floor, and later “opportunity emergence” are naturally adjacent. If Selection starts absorbing state models, overlap logic, and context interpretation without hard contracts, it becomes the new monolith.

**WATCH**
Internal helper logic that should **not** become separate modules yet:

* score math helpers
* threshold interpreters
* simple normalization helpers inside Classification
* simple diagnostic formatting helpers inside OutputDebug

Splitting those early would create fake modularity and more surface area without reducing complexity.

---

## 4. Biggest live-runtime broker risks

**LIVE RISK**
The most dangerous calculations if wrong are not just lot or margin items. The full danger list is:

* tick value interpretation
* tick size vs point confusion
* contract size assumptions
* profit/margin currency assumptions
* deposit-currency normalization
* current spread representation on symbols with odd digits/tick structure
* tick age on symbols that remain quoted but are not truly active
* ATR relevance on thin or session-bound instruments
* cross-symbol score comparability when price scales and trading schedules differ

Wrongness here does not always reject symbols. It often quietly misranks them.

**LIVE RISK**
What must be live-tested as early as possible:

* `SYMBOL_TRADE_TICK_VALUE`, `SYMBOL_TRADE_TICK_SIZE`, `SYMBOL_POINT`, `SYMBOL_DIGITS`, `SYMBOL_TRADE_CONTRACT_SIZE`
* `OrderCalcProfit` and `OrderCalcMargin` disagreements against derived expectations
* quote age and update count behavior during active, slow, and closed sessions
* spread sample stability across FX, metals, indices, stocks, crypto
* server-name partitioning on firms with multiple similar server names
* visibility/tradability states for symbols present in Market Watch but unusable

**LIVE RISK**
Symbol types most likely to break assumptions:

* JPY FX pairs
* metals with non-FX tick conventions
* cash indices vs futures-style index CFDs
* stock CFDs with market hours, auction phases, or stale quotes
* crypto symbols with broker-specific contract conventions
* synthetic or broker-branded symbols with suffixes/prefixes
* micro/mini variants sharing canonical roots but different economics
* symbols that remain selectable/visible but are not really tradeable now

**LIVE RISK**
Behavior that differs most across brokers:

* naming/alias conventions
* contract size and tick value treatment
* whether tick value is usable, approximate, zero, or context-dependent
* margin model and currency conversion behavior
* quote freshness during quiet sessions
* stock CFD session handling
* whether spreads collapse to misleading values when market is closed
* visibility universe size and presence of dead symbols

**LIVE RISK**
Where false confidence happens even if the code looks correct:

* a symbol passes economics sanity because raw fields are populated, but validated calculations disagree
* a stock CFD appears fresh because last quote exists, but market is closed and spread is meaningless
* crypto looks attractive because constant quoting inflates liveliness versus session-bound assets
* low spread/ATR ratio appears good because ATR is stale/thin rather than truly efficient
* top-ranked symbols are only “best among broken comparables”

**TEST FIRST**
What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:

* raw point/tick-size/tick-value consistency
* contract-size consistency
* spread representation in points, ticks, and money-normalized terms
* ATR stability relative to session structure
* stale quote detection
* update count behavior over same wall-clock window
* whether “tradable” differs from “visible and quoted”
* whether correlation behaves sensibly when price series have session gaps

**LIVE RISK**
Where deposit-currency normalization is likely to go wrong:

* symbols whose profit currency differs from deposit currency
* CFD contracts where broker internally converts using rates you do not directly see
* symbols with raw tick value already converted sometimes, but not consistently across instruments
* weekend/closed-session conversion behavior
* assuming `TickValueRaw` is comparable cross-asset without validation

**TEST FIRST**
Raw/derived/validated disagreements that should be explicitly logged:

* raw tick value vs implied tick value from contract/tick/price logic
* derived P/L expectation vs `OrderCalcProfit`
* derived margin expectation vs `OrderCalcMargin`
* raw spread vs sampled median/max spread disagreement
* quote timestamp freshness vs observed update cadence
* classification canonical symbol vs actual broker economics family mismatch
* asset class expectation vs calc mode / trade mode mismatch

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK**
The settings design is at risk of becoming internally contradictory because you currently expose both:

* `DevMode` true/false
* `TraderMode` true/false

That invites illegal combinations and operator confusion. The human model is one mode selector, not two booleans plus a gate.

**SIMPLIFY NOW**
Mode should behave like one state, even if implementation keeps internal flags. Exposed UI that allows both true, both false, or constrained overrides will confuse operation and testing.

**DESIGN RISK**
The next menu risk is overlap between:

* Scope
* Pipeline
* Testing
* Output
* Debug

These are sensible groups, but in practice they create combinatorial ambiguity. A user can accidentally set:

* selected scope
* one test-only toggle
* full pipeline
* multiple export toggles
* Trader Mode off but debug views hidden

That leads to “why did I get this output?” confusion.

**SIMPLIFY NOW**
The testing and pipeline toggles are too parallel. `RunClassification` and `TestClassificationOnly` are dangerously close in meaning. Same for the other step pairs. That is a future confusion factory.

**DESIGN RISK**
HUD overload risk is highest in Dev Mode. The current Dev HUD target includes:

* phase
* step
* scope
* active module test
* module states
* counts
* reject counts
* weak counts
* anomaly counts
* selected debug preview
* Top 3 preview

That is enough to become unreadable, especially on smaller MT5 chart spaces. A HUD that tries to explain everything during development often explains nothing.

**WATCH**
Mode behavior likely to confuse a human operator:

* Trader Mode “exists but is not valid yet”
* scope filters still active in Trader Mode from previous dev session
* debug output toggles left on while visually in a clean mode
* selected symbol testing accidentally surviving into full-run expectations
* `SnapshotMode` meaning not being obvious relative to timer behavior

**SIMPLIFY NOW**
Toggles/settings that should be merged or simplified:

* public mode choice into one selector
* `RunX` and `TestXOnly` into one execution selector model
* output toggles into fewer intent-based options rather than file-by-file micro-control
* HUD visibility toggles into fewer presets instead of many independent booleans

---

## 6. What must be simplified now

**SIMPLIFY NOW**
Simplify **economics sanity** in Phase 1 to coarse confidence bands, not deep correctness. The safe goal is:

* clearly broken -> reject
* ambiguous -> weak/trust-lowered
* sane enough -> pass

Do not try to fully solve broker economics in Phase 1.

**SIMPLIFY NOW**
Simplify **friction/activity** to a short-window observational layer with explicit confidence limits. Do not let liveliness, freshness, and spread behavior pretend to be robust on all asset classes in the first version.

**SIMPLIFY NOW**
Simplify **ranking** so that it is explicitly a shortlist aid, not a universal truth engine. Keep ranking dominated by:

* movement capacity
* friction efficiency
* freshness/activity
* trust

and avoid hidden adaptive logic, asset-specific score gymnastics, or many interacting weights.

**SIMPLIFY NOW**
Simplify **correlation** to an informational attachment on finalists, not a quality engine. Keep it clearly non-causal and late in the pipeline.

**SIMPLIFY NOW**
Simplify **menu intent** so a human can answer three questions quickly:

* what mode am I in
* what scope am I scanning
* what pipeline slice am I running

Any setting structure that obscures those answers is too complex.

---

## 7. What must be live-tested first

**TEST FIRST**
Live-test **classification + economics family alignment** first. A canonical mapping that points two broker variants to one identity is only safe if their economics family is actually compatible. Alias correctness is not just naming.

**TEST FIRST**
Live-test **raw vs validated economics** on a small symbol pack:

* one EURUSD-type major
* one JPY pair
* one metal
* one index CFD
* one stock CFD
* one crypto
* one odd/suffixed broker symbol

For each, compare raw fields, derived expectations, and MT5 validation calls.

**TEST FIRST**
Live-test **friction and freshness** during three conditions:

* active market
* slow/quiet period
* closed/off-session period

A lot of scanner credibility will fail here before it fails anywhere else.

**TEST FIRST**
Live-test **Trader Mode cleanliness** with dirty prior Dev settings. The real test is not “Trader Mode works from a clean start.” The real test is “Trader Mode cannot silently inherit dev clutter or restricted scope.”

**TEST FIRST**
Live-test **server partitioning** across multiple terminals/firms with similar server names, suffix variations, and sanitized path collisions. Server-name partitioning is correct conceptually, but path-sanitization collisions are an underappreciated edge.

**TEST FIRST**
Live-test **Top 3 per bucket usefulness** under incomplete buckets, weak buckets, and mixed asset classes. This is where the scanner proves it is actually usable rather than merely operational.

---

## 8. What contracts must be frozen now

**DESIGN RISK**
Freeze the **ScanRecord contract rules**, not just the field list:

* only stable row-level facts belong there
* no temporary diagnostics
* no module-private caches
* no phase-experiment values
* raw, derived, validated must remain distinguishable

That rule matters more than the current exact columns.

**DESIGN RISK**
Freeze the **classification contract**:

* raw symbol in
* canonical identity out
* asset class and bucket labels out
* unresolved stays unresolved
* no downstream module reclassifies identity

Downstream logic may annotate trust, but must not reinterpret identity.

**DESIGN RISK**
Freeze the **eligibility-before-ranking contract**:

* FAIL never enters score competition
* WEAK may rank, but with explicit weakness visibility
* ranking never decides core tradability

If that line blurs later, the scanner becomes impossible to reason about.

**DESIGN RISK**
Freeze the **raw/derived/validated evidence contract** for economics and friction:

* every important trust-affecting interpretation must be traceable back to raw source and validation result
* anomaly logging must identify which layer disagreed

**DESIGN RISK**
Freeze the **wrapper ownership contract**:

* wrapper decides lifecycle, mode, call order, and output policy
* modules return facts/results, not orchestration decisions

That one prevents hidden control flow from creeping into grouped modules.

**WATCH**
Freeze the **reason code vocabulary** early. Stable reject/weak codes will save enormous future pain in testing, HUD, exports, and cross-version comparison.

---

## 9. What should be watched so growth stays additive

**WATCH**
Watch **AFS_MarketCore** for overload. The warning sign is when every broker quirk, validation exception, and asset-specific branch lands there and then starts exporting semi-interpreted “helpful” states to everyone else.

**WATCH**
Watch **Selection** for silent scope creep. The danger sequence is:
eligibility -> ranking -> correlation -> opportunity state -> overlap hygiene -> contextual intelligence -> hidden signaling.
That is exactly how a scanner becomes an accidental decision engine.

**WATCH**
Watch **OutputDebug** for becoming a second controller. If output code starts choosing logic branches, suppressing evidence, or shaping run behavior, it is no longer just output.

**WATCH**
Watch **threshold sprawl**. You already centralize thresholds, which is good, but the real danger is multiplying threshold knobs faster than confidence in what they mean. Too many knobs will make dev mode look powerful while actually reducing trust.

**WATCH**
Watch **bucket semantics drift**. If PrimaryBucket remains central to output, then classification map versioning matters. If bucket meanings drift over time without version stamping, historical comparisons and review exports become misleading.

**WATCH**
Watch **cross-mode persistence**. Growth often breaks cleanliness when Dev selections, custom symbol lists, or test flags survive into Trader workflows.

**WATCH**
To prevent another ISSX-style monster, measure these first:

* module file size growth
* count of cross-module dependencies touching `ScanRecord`
* count of public config toggles
* count of exported artifact types
* count of trust/reason code categories
* ratio of helper functions that became externally referenced

That gives early warning before architecture “feels” broken.

**WATCH**
What should be logged/versioned/tested first to protect future evolution:

* classification map version/hash
* threshold set version
* reason code set version
* server-name/path resolution behavior
* representative symbol-pack test outputs
* raw/derived/validated anomaly snapshots

---

## 10. Final hardening recommendations

**BUILD RISK**
Treat Phase 1 as a **coarse-but-honest scanner**, not a correctness-complete scanner. Build speed and trust improve when ambiguous cases are downgraded instead of over-solved.

**DESIGN RISK**
Make **raw, derived, validated disagreement visibility** a first-class invariant. That is the single biggest anti-repair measure in the whole blueprint.

**SIMPLIFY NOW**
Collapse operator-facing mode and pipeline choices so a human cannot accidentally create contradictory run states. Most usability pain here is self-inflicted through too many near-duplicate toggles.

**TEST FIRST**
Create one fixed **broker hardening symbol pack** used repeatedly from the start:

* major FX
* JPY FX
* metal
* index CFD
* stock CFD
* crypto
* odd alias/suffix symbol

Run the same pack through every step and every phase change.

**LIVE RISK**
Assume **quote freshness and spread realism are lying** until proven otherwise per asset class and session state. That skepticism should shape eligibility and trust, not just debugging.

**DESIGN RISK**
Protect **ScanRecord discipline** ruthlessly. Most future repair work will come from contract pollution, not from wrong formulas.

**WATCH**
The system stays additive only if:

* Classification owns identity truth
* MarketCore owns broker fact interpretation
* Selection owns gating/ranking only
* OutputDebug never becomes logic control
* wrapper remains the sole orchestrator

That is the hard boundary set worth defending.

**Final red-team bottom line**
The blueprint does not need redesign. It needs restraint. The parts most likely to break the project are not the visible architecture choices; they are the seductive “just one more refinement” areas inside economics, friction, ranking, and mode controls. If you keep Phase 1 blunt, explicit, and evidence-driven, this can be both usable and hard to break.
## 1. Overall red-team verdict

* **DESIGN RISK**
  The blueprint is **strong enough to build**, but Phase 1 is still carrying **too much broker-correctness burden for something that is supposed to be usable ASAP**. The architecture is mostly sane; the danger is not “wrong framework,” it is **quiet overreach inside the locked framework**.

* **BUILD RISK**
  Phase 1 is not too big because of the number of modules. It is too big because it combines **classification truth, economics sanity, friction realism, ranking credibility, and shortlist correlation** in one “first usable” pass. That is a lot of failure surface for a scanner that must feel trustworthy fast.

* **LIVE RISK**
  The most dangerous outcome is not a crash. It is **false confidence**: the scanner runs, outputs clean Top 3 lists, and those lists are wrong because contract/tick/profit/freshness assumptions are quietly off on some symbol families.

* **WATCH**
  Your locked design is viable **if and only if** you treat Phase 1 as a scanner with **coarse safety gates**, not as a broker-universal truth engine. If you unconsciously push Phase 1 toward “correct on everything,” it will turn into a sinkhole.

---

## 2. Biggest Phase 1 risks

* **BUILD RISK**
  **Biggest risk to “usable ASAP”: Step 5 + Step 7 together.**
  Market/spec/economics core and friction/activity are the two places where Phase 1 stops being straightforward engineering and starts becoming broker-specific reality wrestling. Those two steps will eat time, test cycles, and confidence.

* **BUILD RISK**
  **Is Phase 1 still too big?**
  Barely yes. Not because of count, but because the blueprint defines Phase 1 as “complete usable scanner” while also requiring enough cross-asset correctness to avoid embarrassing output. That combination is heavy.

* **SIMPLIFY NOW**
  **Minimum safe Phase 1 that still keeps the scanner useful:**
  Keep:

  * universe load
  * normalization/classification
  * coarse economics sanity
  * M15/H1 history sufficiency
  * ATR
  * current spread + simple spread sanity
  * tick age
  * eligibility
  * compact ranking
  * Top 3 per PrimaryBucket
    Keep shortlist correlation only in a **strictly compact** form on a tiny finalist set. Do not let it grow into a “smart overlap engine” in Phase 1.

* **BUILD RISK**
  **Most likely sinkhole:** friction/activity.
  Why? Because “spread realism,” “liveliness,” “freshness bridge,” and “update count” sound compact on paper, but in live MT5 they are session-dependent, asset-dependent, and broker-dependent. This is the most likely step to consume time while producing shaky confidence.

* **DESIGN RISK**
  **Step most likely to create structural pain later if done badly now:** Step 5 economics normalization/trust model.
  If you blur raw broker fields, derived values, and validated behavior now, you will be repairing contracts for months. This is the one place where bad early shortcuts poison later growth.

* **SIMPLIFY NOW**
  **Part of Phase 1 that must be simplified even if elegant now:**
  Freshness/liveliness scoring. In Phase 1, make it coarse and explicit. Do not create a beautiful composite metric that hides why a symbol is “fresh enough.” Hidden composite logic here will create debugging hell.

* **WATCH**
  **Correlation in Phase 1 is acceptable only as context, not as optimizer logic.**
  The second correlation starts affecting selection mechanics beyond simple context attachment, you are drifting toward repair work.

---

## 3. Biggest design risks

* **DESIGN RISK**
  **AFS_MarketCore is the module most likely to become overloaded later.**
  It already owns:

  * universe loading
  * raw spec reading
  * economics derivation
  * coarse validation
  * asset-class-aware handling
  * margin/tick/contract sanity
    That is too much semantic weight in one family. It can still stay grouped, but you need a brutal internal boundary between:

  1. raw acquisition
  2. derivation
  3. validation outcome
     Otherwise that file becomes the future monster.

* **DESIGN RISK**
  **Most important contract to freeze now: ScanRecord economics semantics.**
  Freeze exact meaning of:

  * raw fields
  * derived fields
  * validated fields
  * trust grades
  * practicality status
  * normalization status
    If these meanings drift, every downstream step becomes ambiguous.

* **DESIGN RISK**
  **Weak ownership risk in mode logic.**
  You say wrapper owns mode, HUD, export decisions, and call order. Good. But right now there is still a hidden risk that modules start checking mode flags internally and altering calculation behavior. That is how “Dev vs Trader” turns into inconsistent math.
  Mode should affect:

  * scope
  * verbosity
  * exports
  * HUD
    Mode should **not** change calculation semantics unless explicitly declared.

* **DESIGN RISK**
  **Eligibility-before-ranking must be frozen as a hard contract, not a slogan.**
  If weak/fail states can still leak partial scores that later influence sorting or bucket selection, you will get silent contamination.

* **DESIGN RISK**
  **Classification module truth can become entangled with runtime heuristics.**
  Biggest long-term risk is “temporary broker alias rescue logic” slowly migrating out of the classification map and into code branches. That kills maintainability. User map must remain truth; code may normalize, but it must not silently invent classification truth.

* **WATCH**
  **What should remain helper logic and not become its own module:**

  * score aggregation helpers
  * reject/weak reason formatting
  * small HUD rendering helpers
  * path sanitization
  * threshold resolution helpers
    Splitting these out will buy nothing and start ISSX-style fragmentation.

* **WATCH**
  **What turns this into another monster:**
  letting every future concern become either:

  * a new score, or
  * a new toggle, or
  * a new status field
    That is how clean grouped architecture dies: not by big rewrites, but by uncontrolled additive knobs.

---

## 4. Biggest live-runtime broker risks

* **LIVE RISK**
  **Most dangerous calculations if wrong:**

  1. spread-to-ATR ratio
  2. tick value assumptions
  3. contract size interpretation
  4. deposit-currency normalized economics
  5. liveliness/freshness inference from tick timing
  6. “tradable enough” decisions on off-session or synthetic symbols

* **LIVE RISK**
  **Where false confidence happens even when code looks correct:**

  * symbol has valid specs but unusable real spread regime
  * symbol has recent quote timestamp but effectively dead feed
  * `TickValue` is populated but not economically trustworthy for the intended interpretation
  * stock CFD has valid properties but wrong movement/cost comparability versus FX/metals
  * crypto looks active 24/7 and dominates ranking because your freshness logic loves constant updates

* **TEST FIRST**
  **Must be live-tested as early as possible:**

  * OrderCalcProfit agreement versus derived tick economics
  * OrderCalcMargin agreement versus margin assumptions
  * quote freshness behavior across session boundaries
  * spread sampling quality on quiet vs active periods
  * same canonical symbol across two brokers with different raw specs
  * symbols that are selectable but not practically tradable

* **LIVE RISK**
  **Symbol families most likely to break assumptions:**

  * JPY FX pairs
  * metals
  * cash indices / index CFDs
  * stock CFDs
  * broker suffix/prefix crypto symbols
  * odd symbols with spaces, dots, suffixes, micro contracts, or synthetic naming

* **LIVE RISK**
  **Behavior that differs most across brokers:**

  * visible universe breadth
  * naming conventions
  * contract size conventions
  * tick value reliability
  * session availability
  * quote cadence
  * margin model interpretation
  * whether inactive symbols still show stale but plausible prices

* **LIVE RISK**
  **What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, odd symbols:**

  * digits/point/tick size relationship
  * current spread behavior in points vs price units
  * ATR comparability by asset class
  * baseline movement scaling
  * history sufficiency consistency
  * tick age behavior during dead periods
  * update count behavior during quiet but valid markets
  * whether ranking unfairly favors always-on asset classes

* **LIVE RISK**
  **Where deposit-currency normalization is likely to go wrong:**

  * cross-currency profit conversion assumptions
  * account currency differing from profit currency
  * non-FX CFDs with broker-specific profit logic
  * symbols where raw `TickValue` appears account-normalized on one broker and not on another
  * treating validated margin/profit as interchangeable with derived economics

* **TEST FIRST**
  **Raw / derived / validated disagreements that should be explicitly logged:**

  * raw tick value vs derived expected tick economics
  * raw point/tick size vs actual profit increment behavior
  * raw contract size vs OrderCalcProfit behavior
  * declared trade mode vs real usability in session
  * quote timestamp freshness vs update-count liveliness
  * raw spread snapshot vs sampled spread distribution
  * classification asset class vs observed economics pattern
    These disagreements are gold. Hide them and you will debug blind.

---

## 5. Menu/HUD/Mode usability risks

* **DESIGN RISK**
  The menu is readable in concept, but it is **still at high risk of becoming a flag cemetery**. You already have too many near-overlapping controls across:

  * Mode
  * Pipeline
  * Testing
  * Output
  * HUD
  * Debug

* **SIMPLIFY NOW**
  **Mode confusion risk:** having both `DevMode` and `TraderMode` as booleans is asking for contradictory state.
  You need one authoritative mode state, even if the visible UI still respects your locked design labels. Two booleans for mutually exclusive operation is needless ambiguity.

* **DESIGN RISK**
  `RunClassification`, `TestClassificationOnly`, and `ExportClassificationReview` can easily create user confusion because they represent three different axes:

  * execute
  * isolate
  * export
    That is fine architecturally, but human operators will absolutely mix them up unless the HUD shows the current run intent in plain language.

* **WATCH**
  **Settings most likely to become messy:**

  * Scope section, because filters can conflict
  * Pipeline vs Testing, because both imply selective execution
  * Output vs Debug, because exports and visibility are related but not identical
  * Thresholds, because rankings weights plus hard filters plus quality floors can get tangled fast

* **SIMPLIFY NOW**
  **Toggles that should be merged or heavily constrained in behavior:**

  * `ScanVisibleOnly` and `ScanSelectedScope`
  * `RunFullPipeline` versus individual run flags
  * `TestSelectedSymbolsOnly` versus `CustomSymbolList`
  * `ShowDebugPanel`, `ShowModuleStates`, `ShowCounts` if CompactHUD is on
    Not a redesign. Just enforce precedence and mutual exclusivity hard.

* **LIVE RISK**
  **Mode behavior that can confuse a human operator:**

  * Trader Mode showing symbols from a filtered development scope and looking “final”
  * Dev Mode still writing production-looking outputs
  * a prior custom scope remaining active when the user thinks they are scanning full universe
  * hidden phase gating preventing Trader Mode but not making the reason obvious

* **WATCH**
  **HUD overload risk:**
  Dev HUD can become unreadable fast if it tries to show:

  * counts
  * rejects
  * weaks
  * anomalies
  * module states
  * debug preview
  * Top 3 preview
    That is too much for one persistent panel unless it is aggressively prioritized. Dev HUD must show “what is blocking progress now,” not every metric simultaneously.

* **DESIGN RISK**
  **Debug without drowning in noise is not solved yet.**
  Selective exports are good. But selective on-screen visibility is still underdefined. If the HUD does not clearly state:

  * current mode
  * current scope
  * current pipeline slice
  * current active tests
    then you will misread results.

---

## 6. What must be simplified now

* **SIMPLIFY NOW**
  **Friction model:**
  Keep Phase 1 friction to:

  * current spread
  * median spread over small window
  * max spread over small window
  * spread/ATR
  * tick age
  * coarse update count
    Do not get cute with “freshness bridge metric” unless it is fully transparent and testable. That one phrase smells like hidden complexity.

* **SIMPLIFY NOW**
  **Liveliness/freshness scoring:**
  Use coarse bands and deterministic reason codes. Not an elegant blended score. You need inspectability more than sophistication.

* **SIMPLIFY NOW**
  **Economics trust grades:**
  PASS / WEAK / FAIL is enough for Phase 1, but only if each grade maps to very explicit triggers. Do not create a nuanced trust system yet. Nuance without field evidence becomes fiction.

* **SIMPLIFY NOW**
  **Ranking model:**
  Compact ranking is correct. Keep it compact for real. If you let ranking become a weighted dumping ground for every discomfort that did not make eligibility, Phase 1 will look functional while being conceptually rotten.

* **SIMPLIFY NOW**
  **Correlation:**
  Correlate only final eligible shortlist candidates with a strict cap. No “helpful pre-screen correlation,” no full-bucket pair matrices, no clever overlap heuristics in Phase 1.

* **SIMPLIFY NOW**
  **Mode controls:**
  Reduce operator choices at runtime. A scanner that requires six switches to answer “what am I scanning right now?” is already drifting off mission.

---

## 7. What must be live-tested first

* **TEST FIRST**
  **Step 5 before almost anything else.**
  Live-test economics sanity on:

  * EURUSD
  * USDJPY
  * XAUUSD
  * a major index CFD
  * a stock CFD
  * a crypto pair
  * one ugly odd symbol with suffix/prefix
    This is the first place the blueprint can lie to you with a straight face.

* **TEST FIRST**
  **Step 7 in live conditions, not just market replay or visual trust.**
  Test:

  * active session
  * quiet session
  * off-session stocks
  * weekend/near-weekend crypto
  * sleepy cross with valid quotes but poor updates

* **TEST FIRST**
  **Cross-broker same-symbol comparison.**
  The scanner is per terminal/server, good. But you still need to compare how the same canonical symbol behaves across brokers to expose hidden normalization problems.

* **TEST FIRST**
  **Explicit disagreement logging.**
  First hardening logs should include:

  * classification unresolved cases
  * economics trust downgrades
  * raw/derived/validated mismatches
  * stale-vs-active disagreements
  * rejected symbols that looked superficially good
  * high-ranked weak symbols and why they survived

* **TEST FIRST**
  **PrimaryBucket output quality.**
  Not just “did it output 3 names.” Test whether weak buckets correctly return fewer than 3 without pressure to fill with garbage.

---

## 8. What contracts must be frozen now

* **DESIGN RISK**
  **Freeze ScanRecord field meaning, not just field names.**
  Especially:

  * `EconomicsTrust`
  * `NormalizationStatus`
  * `PracticalityStatus`
  * `EligibilityState`
  * `RejectCodes`
  * `WeakCodes`
  * `TotalScore`
  * `BucketRank`
  * `CorrMax`
  * `CorrContextFlag`

* **DESIGN RISK**
  **Freeze the raw / derived / validated contract.**
  A downstream module must always know whether it is reading:

  * broker-declared fact
  * AFS-derived estimate
  * behavior-validated result
    If not frozen now, future debugging becomes theology.

* **DESIGN RISK**
  **Freeze reject/weak code determinism.**
  Same input state must produce same code set. No module-specific “best effort” wording. Reason codes are part of the architecture, not decoration.

* **DESIGN RISK**
  **Freeze bucket selection rules.**
  Define now whether bucket ranking is:

  * among all eligible names in bucket
  * among only names above quality floor
  * after or before weak penalties
    This sounds minor. It is not. If this drifts, output meaning drifts.

* **DESIGN RISK**
  **Freeze mode impact boundaries.**
  Dev vs Trader must not alter core calculations silently. Freeze that contract now.

* **WATCH**
  **Freeze versioning around map + thresholds + output schema first.**
  Those are the three things future-you will need to compare when results change unexpectedly:

  * classification map version
  * threshold set version
  * output schema/build label

---

## 9. What should be watched so growth stays additive

* **WATCH**
  **Watch AFS_MarketCore for semantic sprawl.**
  It is the most likely future sink for every weird broker exception. If that module becomes “where all odd things go,” your architecture will rot from the center.

* **WATCH**
  **Watch Selection for score inflation.**
  Every later phase will be tempted to add:

  * new score
  * new modifier
  * new penalty
  * new weight
    That is how ranking becomes unexplainable and untestable. Growth must add capability, not sludge.

* **WATCH**
  **Watch the classification map from becoming a junk drawer.**
  Keep truth there, yes. But do not stuff transient runtime observations into permanent mapping fields.

* **WATCH**
  **Watch HUD growth like a hawk.**
  Most systems don’t become monsters in compute first. They become monsters in operator cognition first. The moment the human cannot tell what mode, scope, and confidence state they are seeing, the tool is functionally damaged.

* **WATCH**
  **Watch threshold creep.**
  Centralized thresholds are good. Too many thresholds create fake control and fragile tuning. Each threshold added should have:

  * clear owner
  * clear failure it protects
  * clear evidence it is needed

* **WATCH**
  **What should be logged/versioned/tested first to protect future evolution:**

  * classification map revisions
  * threshold revisions
  * reason-code frequency by build
  * unresolved symbol count by server
  * economics trust downgrade count by asset class
  * symbols rejected for stale/freshness reasons by session
    These are early warning systems for architectural drift.

---

## 10. Final hardening recommendations

* **BUILD RISK**
  Treat Phase 1 as **usable with coarse trust**, not “correct everywhere.” That mindset is the difference between finishing and sinking.

* **SIMPLIFY NOW**
  Simplify three things immediately:

  1. friction/freshness logic
  2. mode/toggle interaction
  3. ranking inputs
     Those are the parts most likely to quietly explode complexity without obvious benefit.

* **TEST FIRST**
  Hard-test Step 5 and Step 7 live across asset classes before emotionally trusting any Top 3 output. Pretty rankings mean nothing if economics or liveliness is lying.

* **DESIGN RISK**
  Freeze four contracts now:

  1. raw/derived/validated semantics
  2. eligibility-before-ranking enforcement
  3. mode impact boundaries
  4. bucket selection meaning

* **WATCH**
  Do not let Phase 2+ hardening leak backward and silently mutate Phase 1 contracts. Add fields or explicit statuses if needed, but do not redefine existing meanings casually.

* **DESIGN RISK**
  The biggest long-term danger is **not** that the architecture is wrong. It is that you start “just patching broker quirks” in the wrong places:

  * classification hacks in runtime code
  * economics exceptions inside ranking
  * mode-dependent math
  * hidden composite freshness logic
    That is exactly how future repair work gets forced.

* **OVERALL VERDICT**
  This blueprint is **buildable and worth preserving**, but only if you stay ruthless about one thing:
  **Phase 1 must be operationally useful, not intellectually complete.**
  The killer risks are:

  * economics trust semantics
  * friction realism
  * toggle/state confusion
  * false confidence from clean-looking output
    Fix those hard, and the locked architecture can survive. Ignore them, and you will not need a redesign today—but you **will** need repair later.
Disclaimer: Not Financial Advice, Only for Research Purposes And May Sometimes Be Inaccurate.

## 1. Overall red-team verdict

* **DESIGN RISK**
  The blueprint is **coherent and buildable**, but **Phase 1 is still carrying too much broker-correctness burden for something that is supposed to become usable ASAP**. The architecture itself is not the main problem. The danger is that several “Phase 1 complete scanner” steps look compact on paper but are actually **broker-hardening sinkholes** once implemented against real MT5 symbol sets.

* **BUILD RISK**
  The system is at real risk of becoming **“almost usable for a long time”** rather than usable early, because Phase 1 combines:

  * classification truth management,
  * economics sanity,
  * ATR/history sufficiency,
  * friction/activity realism,
  * eligibility,
  * ranking,
  * shortlist correlation,
  * clean Trader Mode.
    That is a lot of coupled validation work before the scanner earns trust.

* **LIVE RISK**
  The biggest threat is **false confidence**: the scanner can compile, rank, and output Top 3 while being quietly wrong on symbol economics, freshness, spread meaning, or cross-asset normalization. That is worse than obvious failure because it produces believable garbage.

* **WATCH**
  The architecture is worth keeping. The hardening concern is not “wrong framework.” It is **where contracts are still too soft**, especially around economics, freshness, and ranking comparability across asset classes.

---

## 2. Biggest Phase 1 risks

* **BUILD RISK**
  **Yes, Phase 1 is still too big** for a “usable ASAP” target if “economics sanity,” “friction realism,” and “compact ranking across multiple asset classes” are all expected to be trustworthy from the start.

* **BUILD RISK**
  The **single biggest risk to usable ASAP** is **Step 5 + Step 7 + Step 9 as a chain**:

  * Step 5 Market/spec/economics core
  * Step 7 Friction and activity
  * Step 9 Compact ranking
    These three create the first believable output. If they are even slightly wrong, the scanner will look intelligent while ranking the wrong names.

* **BUILD RISK**
  The **minimum safe Phase 1 that still keeps the scanner useful** is:

  * universe load
  * normalization
  * user classification
  * coarse tradability/spec sanity
  * basic history sufficiency
  * ATR M15/H1
  * current spread + very simple spread context
  * tick age / update count
  * deterministic eligibility
  * simple ranking with very few components
  * Top 3 per PrimaryBucket
  * clean Dev/Trader split
    The part that should stay minimal is not classification. It is **economics depth, friction sophistication, and ranking richness**.

* **SIMPLIFY NOW**
  **Shortlist correlation** is acceptable in Phase 1 only because you already restricted it to shortlist-only. Good. But it must remain **lightweight context**, not a quality gate. If it starts influencing rank too early, Phase 1 becomes slower, harder to reason about, and harder to trust.

* **BUILD RISK**
  The **step most likely to quietly become a sinkhole** is **Step 7 Friction and activity**.
  Why:

  * “spread sampling” sounds simple but becomes session-dependent
  * “tick age” behaves differently by asset class
  * “update count” can reward noisy garbage feeds
  * quiet-but-tradable symbols can look dead
  * off-session stock CFDs can pollute logic
  * crypto behaves unlike almost everything else
    This is exactly the kind of step that keeps expanding because every broker exposes a new exception.

* **DESIGN RISK**
  The **step most likely to create future structural pain if done badly now** is **Step 5 Market/spec/economics core**.
  If raw, derived, and validated economics are not separated with hard ownership now, every later phase will inherit hidden ambiguity.

* **SIMPLIFY NOW**
  The **part that must be simplified even if elegant** is **ranking**.
  Phase 1 ranking should not try to be clever. A weighted score built from too many partially trustworthy sub-scores will create endless repair work. Ranking should be shallow until broker correctness is proven.

---

## 3. Biggest design risks

* **DESIGN RISK**
  The grouped module most likely to become overloaded later is **AFS_MarketCore.mqh**.
  It already owns:

  * universe loading
  * raw spec reading
  * economics derivation
  * coarse validation
  * asset-class-aware handling
  * margin/tick/contract sanity
    That is where future broker exceptions, normalization quirks, deposit-currency issues, calc-mode differences, and symbol-family special cases will accumulate. This is the most likely future “gravity well.”

* **DESIGN RISK**
  The most important contract to freeze now is the **ScanRecord semantic contract**, not just field names.
  Freeze for each field:

  * ownership module
  * whether it is raw / derived / validated
  * whether it is pre-eligibility or post-eligibility
  * whether missing is allowed
  * whether zero is valid
  * whether stale values are allowed
  * whether value is cross-asset comparable
    Without this, ScanRecord becomes a junk drawer with nice column names.

* **DESIGN RISK**
  The second most important contract to freeze is the **reason-code contract**.
  Reject and weak codes must be:

  * deterministic
  * ordered
  * non-overlapping in meaning
  * stable across future phases
    If reason codes drift semantically, testing becomes impossible and “why was this symbol excluded?” becomes untrustworthy.

* **DESIGN RISK**
  The place where future feature growth can create entanglement fastest is **Selection**.
  Eligibility, ranking, and correlation are already neighboring responsibilities. That is dangerous because future “just one more score” additions tend to leak:

  * friction logic into ranking
  * classification confidence into rank
  * correlation into eligibility
  * freshness into everything
    Selection must consume stable facts, not become the place where every unresolved nuance gets buried.

* **WATCH**
  What should remain internal helper logic and not become separate modules:

  * tiny score helpers
  * symbol-family formatting helpers
  * HUD formatting helpers
  * threshold retrieval helpers
  * CSV row writers
  * simple normalization utility fragments
    Splitting these out will create file sprawl without reducing complexity.

* **WATCH**
  What could turn this into another monster is not file count. It is **semantic creep**:

  * more statuses
  * more scores
  * more flags
  * more “temporary” exceptions
  * more mode-specific branches
  * more threshold overrides
    That is how readable grouped modules become unreadable anyway.

---

## 4. Biggest live-runtime broker risks

* **LIVE RISK**
  The **most dangerous calculations if wrong** are:

  1. anything used to decide whether a symbol is economically sane
  2. anything that normalizes cost against movement
  3. anything that treats quote recency as tradability
  4. anything that compares symbols across asset classes
     In practice, the biggest landmines are:

  * tick value interpretation
  * contract size interpretation
  * point vs tick size confusion
  * current spread vs real spread regime
  * ATR comparability across symbol types
  * deposit-currency normalization
  * session-aware freshness assumptions

* **LIVE RISK**
  What must be live-tested as early as possible:

  * symbol spec extraction versus actual MT5 behavior
  * OrderCalcProfit disagreement versus derived economics
  * OrderCalcMargin disagreement versus practical assumptions
  * spread sampling during active and quiet periods
  * tick age/update count on off-session symbols
  * same canonical symbol across brokers with different suffixes/specs

* **LIVE RISK**
  The symbol types most likely to break assumptions:

  * **JPY pairs**: point/pip mental shortcuts fail easily
  * **metals**: contract and tick interpretations vary
  * **indices**: synthetic contract conventions vary wildly
  * **stock CFDs**: sessions, stale quotes, and contract sizing differ
  * **crypto**: 24/7 feed behavior and spread regime differ
  * **odd broker symbols**: micro contracts, cash indices, exotic CFDs, synthetic symbols, broker-invented suffixes/prefixes

* **LIVE RISK**
  Behavior that differs most across brokers:

  * server symbol naming schemes
  * visible universe composition
  * whether hidden but tradable symbols appear
  * contract size conventions
  * margin model and calc mode
  * tick value reporting reliability
  * quote update rhythm
  * stock CFD session handling
  * crypto weekend behavior
  * spread widening patterns

* **LIVE RISK**
  Where false confidence happens even if code looks correct:

  * derived economics agree internally but disagree with OrderCalcProfit
  * spread/ATR ratio looks “cheap” because ATR is stale or too low
  * update count looks healthy because the feed is chatty, not tradable
  * current spread looks fine while median/max sampling window missed regime changes
  * stock CFD appears eligible outside active session due to stale last quote
  * canonical mapping is correct but practical tradability is not

* **LIVE RISK**
  What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:

  * Digits / Point / TickSize consistency
  * TickValueRaw plausibility
  * ContractSize plausibility
  * ProfitCurrency and MarginCurrency behavior
  * current spread unit meaning
  * ATR unit meaning
  * session-state visibility
  * stale quote behavior
  * bars availability and continuity
  * update rhythm under active and inactive sessions
  * whether ranking remains believable cross-asset

* **LIVE RISK**
  Where deposit-currency normalization is likely to go wrong:

  * assuming TickValueRaw is already trustworthy in deposit-currency terms
  * assuming ProfitCurrency conversion is direct or stable
  * symbols where MarginCurrency, ProfitCurrency, and deposit currency all differ
  * brokers that report economics inconsistently by calc mode
  * using derived normalized values without logging conversion path

* **TEST FIRST**
  Raw / derived / validated disagreements that should be explicitly logged:

  * raw TickValueRaw vs derived expected value path
  * raw ContractSize vs derived cost implications
  * derived profit-per-tick vs OrderCalcProfit result
  * derived margin expectation vs OrderCalcMargin result
  * current spread vs median spread vs max spread
  * tick age vs update count vs session expectation
  * BarsM15/BarsH1 sufficiency vs ATR populated state
  * classification confidence vs eligibility outcome
  * EconomicsTrust vs final rank participation

---

## 5. Menu/HUD/Mode usability risks

* **DESIGN RISK**
  The settings block is at high risk of becoming **internally contradictory**.
  Right now you have:

  * DevMode
  * TraderMode
  * AllowTraderModeOnlyIfPhase1Complete
  * RunFullPipeline
  * many RunX flags
  * many TestXOnly flags
    That is too many ways to say similar things. Humans will create impossible states.

* **SIMPLIFY NOW**
  The biggest settings mess is the overlap between:

  * **Pipeline**
  * **Testing**
  * **Scope**
  * **Output**
    The difference between “run only this module,” “test only this function,” “selected symbols only,” and “export selected scope rows” is easy for a developer to understand conceptually, but easy for an operator to misuse in practice.

* **DESIGN RISK**
  The most confusing mode behavior for a human operator will be:

  * DevMode=true and TraderMode=true at the same time
  * TraderMode true but pipeline flags partially disabled
  * TestClassificationOnly combined with RunRanking
  * selected scope filters causing Top 3 output that looks production-valid but is only a test slice
    You need harder internal constraints, not just readable names.

* **WATCH**
  The HUD is at risk of becoming overloaded in Dev Mode because it is trying to show:

  * mode
  * phase
  * step
  * scope
  * active module test
  * module states
  * counts
  * rejects
  * weaks
  * anomalies
  * output preview
  * Top 3 preview
    That is already too much for one on-chart layer unless the display hierarchy is brutally enforced.

* **SIMPLIFY NOW**
  Toggles/settings that should be merged or collapsed logically:

  * `DevMode` and `TraderMode` should behave like one mutually exclusive mode selector, even if implemented with booleans internally
  * `RunX` and `TestXOnly` should not both expose full parallel control surfaces
  * output controls should inherit from mode first, then only expose a small number of exceptions

* **WATCH**
  What parts of the HUD could still become messy:

  * showing both debug preview and Top 3 at once
  * showing full counts plus full reason categories
  * trying to show correlation previews for multiple buckets simultaneously
  * showing scope info that is not obvious enough to distinguish test mode from live use

* **LIVE RISK**
  Human-operator confusion risk:

  * trading from Trader Mode while scope filters are still narrowed
  * reading Top 3 without realizing the current view excludes asset classes/buckets
  * assuming “no anomalies shown” means “no anomalies exist,” when exports are disabled

---

## 6. What must be simplified now

* **SIMPLIFY NOW**
  **Ranking formula complexity** must be cut to the minimum set that is explainable and testable.
  Phase 1 should not try to solve opportunity quality deeply. It should only solve:

  * moving enough
  * not too costly
  * active/fresh enough
  * trustworthy enough
    Anything beyond that will create calibration churn.

* **SIMPLIFY NOW**
  **Economics sanity** should remain coarse in Phase 1.
  It should answer:

  * obviously broken?
  * probably usable?
  * uncertain and needs caution?
    It should not pretend to fully normalize every broker edge case in Phase 1.

* **SIMPLIFY NOW**
  **Friction/activity scoring** should be simplified from a “market microstructure realism layer” to a **bounded heuristic layer**.
  Use it to disqualify obvious garbage and downgrade weak contexts, not to model market quality elegantly.

* **SIMPLIFY NOW**
  **HUD ambition** should be reduced.
  In Dev Mode, prioritize:

  * current scope
  * current module/test
  * core counts
  * top anomaly summary
  * Top 3 preview
    Do not try to display deep diagnostic state on-chart.

* **SIMPLIFY NOW**
  **Threshold ownership UI** should stay centralized, but not every threshold needs to be operator-facing on-chart parameters during normal use. Too many exposed knobs create user error and false confidence.

---

## 7. What must be live-tested first

* **TEST FIRST**
  First live-test target: **economics sanity on a deliberately mixed symbol basket**:

  * EURUSD
  * USDJPY
  * XAUUSD
  * NAS100/US100 equivalent
  * one stock CFD
  * one crypto CFD
  * one odd/suffixed broker symbol
    That basket will expose most hidden assumptions fast.

* **TEST FIRST**
  Second live-test target: **freshness/friction realism across session states**:

  * active FX session
  * off-session stock CFD
  * weekend or low-liquidity crypto window
  * quiet metal period
    This will tell you whether tick age/update count/spread logic is useful or misleading.

* **TEST FIRST**
  Third live-test target: **same canonical symbol across two brokers**.
  Not because you need multi-broker portability immediately, but because it reveals whether your derived fields are actually broker-agnostic or just accidentally fitting one server.

* **TEST FIRST**
  Fourth live-test target: **scope/mode interaction**:

  * narrow scope in Dev Mode
  * switch to Trader Mode
  * verify output is clearly marked as full or filtered
  * verify no debug export leakage
  * verify no hidden filter persists unnoticed

* **TEST FIRST**
  Fifth live-test target: **raw / derived / validated disagreement logging**.
  If this is not visible early, you will spend later phases fixing ghosts.

---

## 8. What contracts must be frozen now

* **DESIGN RISK**
  **ScanRecord field semantics** must be frozen now.
  Especially:

  * `EconomicsTrust`
  * `NormalizationStatus`
  * `PracticalityStatus`
  * `FreshnessScore`
  * `LivelinessScore`
  * `CostEfficiencyScore`
  * `TrustScore`
  * `TotalScore`
  * `EligibilityState`
  * `RejectCodes`
  * `WeakCodes`
    These are not just columns. They are future architecture anchors.

* **DESIGN RISK**
  Freeze the **pipeline authority contract**:

  * which module can write which ScanRecord fields
  * whether later modules may overwrite earlier fields
  * whether scores can be recomputed conditionally
  * whether eligibility is terminal or revisitable

* **DESIGN RISK**
  Freeze the **eligibility-before-ranking contract** hard.
  Specifically:

  * FAIL records never enter rank math
  * WEAK records may rank but remain visibly weak
  * unresolved classification never leaks into ranking
  * correlation never rescues or excludes symbols in Phase 1

* **DESIGN RISK**
  Freeze the **mode/output contract**:

  * Trader Mode output must be impossible to confuse with test output
  * filtered runs must be visibly marked as filtered
  * Dev exports must never silently become production artifacts
  * output path and naming must preserve server partition without ambiguity

* **DESIGN RISK**
  Freeze the **classification map contract**:

  * required fields
  * acceptable missing values
  * alias precedence
  * review status meaning
  * active flag behavior
  * confidence meaning
    Otherwise classification maintenance becomes subjective and drifts over time.

---

## 9. What should be watched so growth stays additive

* **WATCH**
  Watch for **score proliferation**.
  Every new score must justify:

  * what decision it changes
  * whether it is raw, derived, or composite
  * whether it is comparable across asset classes
  * whether it belongs in ScanRecord or should remain internal

* **WATCH**
  Watch for **status proliferation**.
  Too many statuses are how systems become unreadable:

  * more trust grades
  * more anomaly tiers
  * more “practicality” states
  * more mode subtleties
    Prefer fewer stable categories with richer logging.

* **WATCH**
  Watch **AFS_MarketCore** and **AFS_Selection** file growth first.
  Those are the two modules most likely to become overloaded by future exceptions and “one more rule.”

* **WATCH**
  Watch that **classification remains truth ownership**, not a dumping ground for runtime exceptions.
  The map should own identity and taxonomy. It should not be abused to patch feed, economics, or session problems.

* **WATCH**
  Watch that **OutputDebug** does not become an implicit second orchestration layer.
  A common failure pattern is debug/export code starting to decide what matters, effectively stealing ownership from wrapper and modules.

* **WATCH**
  What should be logged/versioned/tested first to protect future evolution:

  * classification map versions
  * threshold set versions
  * reason-code definitions
  * ScanRecord schema version
  * server-name partition behavior
  * economics disagreement evidence
  * mode/scope state in every exported artifact header

---

## 10. Final hardening recommendations

* **BUILD RISK**
  Treat **Step 5 MarketCore**, **Step 7 Friction**, and **Step 9 Ranking** as the true Phase 1 risk center. Build them with the expectation that they will be wrong at first, so evidence logging must exist from the start.

* **SIMPLIFY NOW**
  Keep Phase 1 ranking intentionally blunt. A simple, explainable ranking that is slightly crude is safer than a rich scoring model built on half-trusted inputs.

* **TEST FIRST**
  Build a fixed **cross-asset hard-test basket** and use it every time you touch economics, friction, or ranking. Do not rely on ad hoc testing.

* **DESIGN RISK**
  Freeze **ScanRecord semantics**, **reason codes**, **field ownership**, and **mode/output constraints** before Phase 1 code gets large. That is what prevents later architecture repair.

* **SIMPLIFY NOW**
  Collapse mode logic into one human-readable operational state model, even if internal implementation remains boolean-based. The user must never be able to create ambiguous runtime intent.

* **LIVE RISK**
  Make raw/derived/validated disagreement evidence first-class. Not optional. If a symbol ranks well while economics validation disagrees, that must be visible immediately.

* **WATCH**
  Do not let Dev Mode become a second product. Its job is targeted inspection, not endless observability. Once Dev Mode starts trying to visualize everything, both Dev and Trader usability will degrade.

* **WATCH**
  Protect the system from becoming an ISSX-style monster by enforcing one question on every addition:
  **Does this add capability through an existing contract, or is it compensating for an undefined contract?**
  If it is compensation, fix the contract first.

* **FINAL VERDICT**
  The blueprint is **worth building as-is**, but it is only safe if you are ruthless about:

  * simplifying Phase 1 scoring,
  * freezing contracts now,
  * hard-testing economics and freshness early,
  * and preventing mode/config ambiguity.
    The architecture is not the part most likely to fail. **Silent semantic drift inside MarketCore, Selection, and mode behavior is.**
## 1. Overall red-team verdict

**BUILD RISK**
Phase 1 is still **borderline too large for a “usable ASAP” target** because it contains three different hard classes of work at once: broker normalization, market-quality estimation, and selection logic. Any one of those is manageable. All three together in one first usable release creates schedule risk and debugging ambiguity.

**DESIGN RISK**
The architecture is mostly sound and does **not** need redesign. The dangerous parts are not the grouped-module layout; they are the **contracts between steps**. If those contracts are loose now, future phases will not feel additive. They will become repair work hidden inside “small refinements.”

**LIVE RISK**
The scanner’s biggest real-world fragility is that it can look correct while being wrong on live broker data. The most dangerous false-confidence zone is:
classified symbol + populated specs + valid-looking ATR + valid-looking spread sample + incorrect economics interpretation.
That combination will produce believable rankings for the wrong reasons.

**WATCH**
Your strongest architectural choice is **eligibility before ranking**. Your most dangerous architectural liability is that **Phase 1 already mixes “can this symbol be trusted?” with “is this symbol attractive?”**. Those must remain visibly separate in data, logs, HUD language, and reason codes or the scanner will become hard to debug.

---

## 2. Biggest Phase 1 risks

**BUILD RISK**
Phase 1 is still too big because the following items are deceptively deep:

* symbol normalization + classification across broker aliases
* economics sanity across asset classes
* friction/activity logic across session types
* shortlist correlation that does not create misleading output

The biggest risk to the **usable ASAP** goal is **Step 5: Market/spec/economics core**.
Not because it is the largest code block, but because it is the first place where broker differences create silent wrongness that poisons everything downstream.

**BUILD RISK**
The minimum safe Phase 1 that still keeps the scanner useful is:

* universe load
* normalization/classification
* coarse tradability/spec sanity
* ATR on M15/H1
* basic spread + freshness + activity
* eligibility with deterministic reject/weak codes
* compact ranking
* Top 3 per PrimaryBucket
* clean Trader Mode output

What can stay thinner in minimum-safe Phase 1 without harming usefulness:

* correlation can be reduced to a **light shortlist duplicate warning**, not a sophisticated context layer
* economics validation should stay **coarse and conservative**, not clever
* freshness/liveliness should remain simple and explicit, not composite-heavy

**BUILD RISK**
The step most likely to quietly become a sinkhole is **Step 7: Friction and activity**.
Why:

* it sounds simple
* it depends on timer cadence, quote behavior, session state, and symbol type
* it creates scores that look reasonable even when based on poor observations
* it will invite endless tweaking because “this symbol feels wrong” is hard to falsify

**DESIGN RISK**
The step most likely to create future structural pain if done badly now is **Step 4 + Step 5 boundary**:

* classification/identity
* economics/spec normalization
* practicality/trust labeling

If identity, economics trust, and tradability are not separated cleanly, later hardening will force field renames, logic rewrites, and HUD/logging confusion.

**SIMPLIFY NOW**
The part that must be simplified even if elegant on paper is **shortlist correlation in Phase 1**.
Keep it as:

* shortlisted names only
* one method only
* one output meaning only
* one warning interpretation only

Do not let Phase 1 correlation carry nuanced “portfolio overlap intelligence.” That is Phase 8 territory.

---

## 3. Biggest design risks

**DESIGN RISK**
`ScanRecord` is the master row, which is correct, but it is in danger of becoming a **junk drawer**. The blueprint says only stable fields go in it, but the current field list is already close to the threshold where temporary implementation convenience will start leaking into the contract. Once fields enter the row, they are hard to remove.

**DESIGN RISK**
`AFS_MarketCore.mqh` is the grouped module most likely to become overloaded later. It currently owns:

* universe loading inputs
* raw spec reading
* economics derivation
* coarse validation
* asset-class handling
* margin/tick/contract sanity

That is already a mix of:

* data acquisition
* normalization
* interpretation
* broker hardening

If not policed, MarketCore becomes the place where every future broker quirk gets shoved. That is how monsters start.

**DESIGN RISK**
The most important contract to freeze now is the meaning of these states:

* `ClassificationStatus`
* `NormalizationStatus`
* `PracticalityStatus`
* `EconomicsTrust`
* `EligibilityState`

If those overlap semantically, later phases will create conflicting downgrade paths. Example failure:

* symbol classified correctly
* economics weak
* practical tradability bad
* eligibility weak
* total score still present

That only works if each state means one thing and only one thing.

**DESIGN RISK**
The strongest future entanglement risk is between:

* thresholds
* reason codes
* HUD summaries
* exported debug artifacts

If one threshold change silently changes:

* eligibility state
* score composition
* reason-code counts
* trader HUD warnings

then tuning becomes non-local and painful.

**WATCH**
What should remain internal helper logic and not become separate modules:

* score component helpers
* small asset-class conversion helpers
* simple reject/weak formatting helpers
* small correlation helper math
* HUD formatting utilities

Splitting those out early would create file sprawl without improving ownership.

**WATCH**
The ISSX-style monster risk will come from **adding secondary interpretations** everywhere:

* multiple trust layers
* multiple quality layers
* multiple freshness concepts
* multiple movement concepts
* multiple output variants

The architecture survives only if each pipeline stage owns **one primary judgment**.

---

## 4. Biggest live-runtime broker risks

**LIVE RISK**
The most dangerous calculations if wrong are not just lot-size-related. They are:

* tick value interpretation
* tick size vs point handling
* contract size meaning
* spread normalization across digits
* ATR comparability across asset classes
* spread/ATR ratio validity on low-price or discontinuous symbols
* quote freshness on off-session instruments
* update count interpretation on thin or session-bound symbols
* margin/profit/deposit currency interactions
* symbol tradability assumptions from visible universe alone

If wrong, these do not crash the EA. They create **plausible garbage**.

**TEST FIRST**
What must be live-tested as early as possible:

* FX majors and JPY pairs for digits/tick scaling
* metals for contract/tick quirks
* indices for broker-specific CFD conventions
* stock CFDs for session closure, stale quotes, sparse updates
* crypto for 24/7 behavior and abnormal spread regimes
* odd suffix/prefix symbols for normalization
* same canonical symbol across at least two brokers for disagreement mapping

**LIVE RISK**
Types of symbols most likely to break assumptions:

* JPY FX pairs
* metals quoted with nonstandard lot economics
* cash indices vs futures-like CFDs
* stock CFDs with long closed-session periods
* broker-created synthetic indices
* micro contracts
* crypto CFDs with huge spread variance
* symbols visible in Market Watch but practically non-tradable
* dormant symbols with historic bars but dead live feed

**LIVE RISK**
Behavior that differs most across brokers:

* `SYMBOL_TRADE_TICK_VALUE` reliability
* contract size conventions
* minimum/step/max volume
* quote freshness behavior
* visible-but-disabled instruments
* session metadata quality
* CFD economics consistency
* profit currency vs deposit currency conversion behavior
* margin mode interpretation
* naming alias complexity

**LIVE RISK**
Where false confidence happens even if code looks correct:

* `OrderCalcProfit` succeeds, but the test assumptions used are not representative
* ATR populates from stale history, making movement seem valid
* spread sample window catches only a calm slice of a usually hostile symbol
* update count looks healthy because of quote bursts, not sustained tradability
* symbol is classified properly but mapped to the wrong practical subtype
* raw fields agree internally but are economically useless in practice
* Top 3 looks sensible because ranking is relative within a weak bucket

**TEST FIRST**
What should be tested across FX, JPY pairs, metals, indices, stock CFDs, crypto, and odd symbols:

* digits / point / tick size relationships
* spread unit normalization
* ATR unit normalization
* stale quote detection
* session-open vs session-closed behavior
* visible vs tradable differences
* raw tick value vs validated profit behavior
* contract size realism
* update count realism
* friction metric stability under timer changes
* ranking comparability across asset classes
* rejection consistency for unclassified or half-broken symbols

**LIVE RISK**
Where deposit-currency normalization is likely to go wrong:

* profit currency not equal to quote currency
* CFDs whose profit behavior does not match naive FX conversion logic
* symbols whose tick value changes with price
* brokers that expose raw tick value inconsistently
* using one validation path and assuming all asset classes behave alike
* treating `OrderCalcProfit` as a universal truth without scenario controls

**TEST FIRST**
Raw / derived / validated disagreements that should be explicitly logged:

* raw tick value vs derived tick value vs validated profit-per-tick
* raw point/tick size vs effective price-step behavior
* contract size raw vs implied P/L behavior
* current spread raw points vs normalized spread in price units
* ATR raw price units vs normalized movement representation
* visible/tradable flag vs actual practical usability
* session metadata vs observed quote freshness
* classification subtype vs economics/practicality anomalies
* profit currency / margin currency / deposit currency disagreement cases
* score eligibility path vs reject/weak code path mismatch

---

## 5. Menu/HUD/Mode usability risks

**DESIGN RISK**
The menu is at high risk of becoming **internally redundant**. The current sectioning is good, but there are too many settings that represent the same decision from different angles.

Biggest examples:

* `DevMode` and `TraderMode` as two booleans instead of one authoritative mode state
* `RunFullPipeline` plus individual run toggles plus individual test toggles
* `ScanVisibleOnly` and `ScanSelectedScope` and multiple filters and custom list controls
* multiple output toggles that overlap in meaning for normal use

**SIMPLIFY NOW**
Mode selection should behave as a **single authoritative state**, even if represented in the wrapper however you prefer internally. Human-facing dual-boolean mode control is a confusion trap:

* both true
* both false
* TraderMode blocked but shown active
* Dev subfeatures still leaking while Trader Mode claims to be clean

**DESIGN RISK**
The Pipeline and Testing sections are dangerously close to duplicating each other.
Human operator confusion risk:

* “RunRanking” vs “TestRankingOnly”
* “RunCorrelation” vs “TestCorrelationOnly”
* “RunFullPipeline” while test-only flag is also active

That will create contradictory states and support pain.

**WATCH**
Settings likely to become messy:

* scope controls
* pipeline/test controls
* output controls
* debug verbosity controls
* threshold ownership if ranking weights become multi-component later

**WATCH**
HUD is at risk of overload in Dev Mode because it currently wants to show:

* module states
* counts
* reject counts
* weak counts
* anomaly counts
* selected debug previews
* Top 3 preview

That is too much for one always-readable on-chart surface unless aggressively prioritized.

**SIMPLIFY NOW**
The HUD should have one rule: **Dev HUD shows current investigation first, not maximum data density**.
If all panels are simultaneously allowed, Dev HUD becomes self-defeating.

**DESIGN RISK**
Mode behavior most likely to confuse a human operator:

* Trader Mode selected but internally blocked because Phase 1 incomplete
* Dev Mode selected with no test scope and too many exports on
* Top 3 shown while current scope is a filtered subset, leading to mistaken belief it is global
* bucket filter active while HUD still looks like full-universe output
* stale prior output file mistaken for current run because minimal logs hide refresh state

**WATCH**
To support “inspect one bucket / one asset class / one function” cleanly, the scanner must visibly show in HUD and output headers:

* active mode
* active scope
* active pipeline slice
* whether output is full universe or filtered subset

Without that, debug exports become misleading evidence.

---

## 6. What must be simplified now

**SIMPLIFY NOW**
Keep Phase 1 economics sanity **coarse, conservative, and explainable**.
Do not let it become a broker-correctness engine in Phase 1. It only needs to:

* catch obvious nonsense
* flag uncertainty
* prevent bad symbols from ranking confidently

**SIMPLIFY NOW**
Reduce shortlist correlation in Phase 1 to:

* one shortlist size
* one correlation metric
* one closest-symbol field
* one high-correlation flag

No tiered overlap language, no portfolio-style intelligence, no multi-horizon correlation.

**SIMPLIFY NOW**
Collapse the operator mental model of pipeline controls. Phase 1 should expose either:

* module run controls for development
  or
* test-only controls
  but not both as parallel command systems with overlapping semantics

**SIMPLIFY NOW**
Keep ranking compact.
The score should not become a hidden debate between:

* movement
* cost
* trust
* freshness
* activity
* bucket effects

It needs few components and visible reasons. If the score becomes “smart” too early, you will debug rankings forever.

**SIMPLIFY NOW**
Do not overbuild `PracticalityStatus` and `NormalizationStatus` in Phase 1.
If those become rich taxonomies now, you will spend too much time inventing states instead of hardening scanner behavior.

---

## 7. What must be live-tested first

**TEST FIRST**
Cross-broker symbol identity cases:

* same underlying symbol with different suffix/prefix
* same display name but different economics
* same canonical mapping but different practical subtype

**TEST FIRST**
Economics hard checks:

* raw tick value
* contract size
* point/tick relationship
* validated P/L behavior
* JPY scaling
* metals
* index CFDs
* stock CFDs
* crypto CFDs

**TEST FIRST**
Feed realism:

* tick age behavior during active market
* tick age during closed session
* update count on thin symbols
* spread sample quality on bursty symbols
* quiet-but-valid vs stale-and-dead distinction

**TEST FIRST**
Scope/output integrity:

* filtered-scope output clearly labeled
* Trader Mode output not polluted by Dev flags
* server-name partitioning stable and sanitized
* repeated runs do not leave ambiguous stale files

**TEST FIRST**
Eligibility/ranking integrity:

* FAIL never ranks
* WEAK ranks only if allowed by design
* quality floor works by bucket
* weak bucket does not produce polished junk output
* score fields never appear authoritative when trust is low

---

## 8. What contracts must be frozen now

**DESIGN RISK**
Freeze the exact semantic contract of every state field:

* `ClassificationStatus` = identity/classification resolution only
* `NormalizationStatus` = raw symbol/property normalization confidence only
* `EconomicsTrust` = economics reliability only
* `PracticalityStatus` = practical tradability/usefulness only
* `EligibilityState` = final gate result only

No overlap.

**DESIGN RISK**
Freeze the stage boundaries:

* Classification may enrich identity, not judge opportunity
* MarketCore may assess specs/economics, not rank
* HistoryFriction may measure movement/activity/friction, not decide final eligibility semantics beyond its own evidence
* Selection owns eligibility + ranking + shortlist choice

If evidence generation and decision ownership blur, later hardening becomes invasive.

**DESIGN RISK**
Freeze reject/weak code rules:

* deterministic
* stable names
* one code = one reason family
* codes attached before ranking
* codes never repurposed silently

These codes will become your debugging backbone.

**DESIGN RISK**
Freeze score contract:

* what each subscore means
* valid range
* when it is absent
* when total score is suppressed or downgraded
* whether low trust caps score authority

If this is not frozen now, future tweaks will silently break comparability.

**DESIGN RISK**
Freeze output contract:

* what `top3_by_bucket.csv` always contains
* whether it can contain filtered-scope runs
* how run timestamp/version/server/scope are represented
* whether weak/reject reasons are included or summarized

Output contract drift causes downstream confusion fast.

---

## 9. What should be watched so growth stays additive

**WATCH**
Watch `AFS_MarketCore.mqh` for overload. It should not become the dumping ground for:

* every broker quirk
* every derived field
* every validation path
* every cross-asset exception

**WATCH**
Watch `ScanRecord` growth.
Any new field should pass one question:
“Is this stable evidence or just implementation convenience?”
If it is convenience, keep it internal.

**WATCH**
Watch threshold proliferation.
A scanner like this becomes unmaintainable when every odd behavior gets:

* one new threshold
* one new weak code
* one new HUD warning
* one new export column

That creates tuning hell.

**WATCH**
Watch mode creep.
Dev Mode should not become a second product.
Trader Mode should not start accumulating hidden developer remnants.

**WATCH**
Watch bucket logic creep.
PrimaryBucket is a strong organizing principle. Do not let later phases create parallel bucket systems that undermine the meaning of Top 3 per bucket.

**WATCH**
What should be logged/versioned/tested first to protect future evolution:

* classification map version
* server name and build label
* threshold set version
* reason-code counts by run
* unresolved symbol list
* raw vs validated economics disagreements
* filtered scope markers
* mode used for the run

Those will give you regression evidence later.

---

## 10. Final hardening recommendations

**BUILD RISK**
Treat **Step 5 Market/spec/economics** as the critical path, not a middle step. It is the main blocker between “looks complete” and “is trustworthy enough to use.”

**SIMPLIFY NOW**
In Phase 1, keep these intentionally thin:

* economics validation
* shortlist correlation
* friction interpretation
* status taxonomies

Thin and honest beats rich and wrong.

**DESIGN RISK**
Do not allow ambiguous ownership between:

* evidence collection
* trust labeling
* eligibility gating
* ranking output

That boundary discipline matters more than any extra feature.

**LIVE RISK**
Assume broker fields are guilty until corroborated.
Anything related to:

* tick value
* contract size
* conversion behavior
* live feed quality
  must be treated as suspicious even when populated.

**TEST FIRST**
Your first live hardening matrix should be:

* FX major
* JPY pair
* metal
* index CFD
* stock CFD
* crypto CFD
* odd broker alias symbol

And for each, compare:

* raw fields
* derived fields
* validated behavior
* eligibility result
* final ranking presence/absence

**WATCH**
To avoid future architecture repair, protect these three things above all:

* the meaning of state fields
* the reason-code contract
* the evidence-vs-decision boundary

That is where this system will either stay additive or start rotting.

**Overall final verdict**
The blueprint is **architecturally viable**, but **Phase 1 is still carrying too much trust burden**. The system does not need redesign. It needs aggressive restraint in Phase 1, hard contract freezing now, and early live broker falsification of economics + feed assumptions. If you do that, growth can stay additive. If you do not, the repair work will start inside MarketCore, ScanRecord, and mode/debug behavior.
Below is a **true adversarial red-team review**. I am assuming the role of someone trying to **break the system later**, not someone trying to praise it.

I am **not redesigning the system**.
I am identifying **where it will fail, drift, or create future repair work**.

---

# 1. Overall Red-Team Verdict

**Verdict: Architecturally strong but Phase-1 overloaded.**

Your architecture is **structurally sound** in the following areas:

✅ Data contract clarity (ScanRecord)
✅ Eligibility-before-ranking rule
✅ Broker classification independence
✅ Dev vs Trader separation
✅ Grouped module architecture
✅ Memory-first runtime
✅ Server-scoped output

These are **excellent decisions**.

However:

⚠️ **Phase 1 currently contains 3 different problem classes:**

1. **Scanner functionality**
2. **Broker normalization**
3. **Market intelligence scoring**

Those are **different engineering problems**.

This creates two risks:

* **BUILD RISK**: Phase 1 implementation time explodes
* **LIVE RISK**: subtle broker errors poison ranking early
* **DESIGN RISK**: too many assumptions get frozen before real broker testing

Your blueprint is **close to the edge of Phase-1 bloat**, but **not yet broken**.

---

# 2. Biggest Phase-1 Risks

## 2.1 Economics Derivation

**Type:** BUILD RISK + LIVE RISK

The **MarketCore economics normalization** is the **largest sinkhole**.

Why:

MT5 broker economics are **not consistent across asset classes**.

Examples you will hit immediately:

| Asset   | TickValue Meaning           |
| ------- | --------------------------- |
| FX      | usually deposit currency    |
| Indices | sometimes USD               |
| Metals  | sometimes contract currency |
| Stocks  | sometimes quote currency    |
| Crypto  | sometimes coin              |

This means:

```
TickValueRaw
ContractSize
ProfitCurrency
DepositCurrency
```

can combine into **dozens of incorrect interpretations**.

Your architecture assumes you can produce:

```
EconomicsTrust
NormalizationStatus
PracticalityStatus
```

**in Phase 1**.

That is **ambitious and dangerous**.

### Failure Mode

Scanner ranks symbols based on **cost efficiency** using **incorrect economics**.

You will get:

```
cheap-looking symbols that are actually expensive
```

### Red-team conclusion

**Economics sanity should exist in Phase 1 but must remain shallow.**

Otherwise Phase 1 becomes a **broker research project**.

---

## 2.2 Friction Sampling

**Type:** BUILD RISK

Spread sampling with:

```
MedianSpread
MaxSpread
SpreadATRRatio
FrictionSampleCount
SampleWindowSec
```

sounds simple but hides issues:

MT5 problems:

* quotes freeze
* symbols go silent
* symbols become visible but inactive
* spreads spike randomly
* spreads report zero

### Real scenario

```
symbol visible
spread = 0
no ticks for 30 seconds
```

Your friction model must decide:

```
dead
quiet
broken
```

That logic can spiral quickly.

---

## 2.3 Freshness Bridge Metric

**Type:** DESIGN RISK

The concept:

```
FreshnessScore
FreshnessBridge
TickAge
UpdateCount
```

is good **conceptually**.

But **dangerous to define prematurely**.

If defined poorly now, **later phases will fight it**.

Freshness is **one of the hardest signals in market scanning**.

---

## 2.4 Correlation in Phase 1

**Type:** BUILD RISK

Correlation implementation risks:

* data alignment
* different trading sessions
* different volatility regimes
* missing bars

Even if limited to shortlist:

```
CorrMax
CorrClosestSymbol
```

You still need consistent data windows.

Correlation often becomes **a debugging nightmare**.

---

## 2.5 Ranking Model

**Type:** DESIGN RISK

Your Phase-1 ranking contains:

```
MovementCapacityScore
CostEfficiencyScore
LivelinessScore
TrustScore
FreshnessScore
TotalScore
```

This is already **6 scoring layers**.

For Phase 1.

That is **more complexity than necessary** for a usable scanner.

---

# 3. Biggest Design Risks

## 3.1 ScanRecord Expansion Risk

**Type:** DESIGN RISK

ScanRecord is currently excellent.

But there is danger.

You already have **~60 fields**.

Future phases will want to add:

```
phase signals
state flags
opportunity states
expansion metrics
efficiency metrics
bucket context
```

If uncontrolled, ScanRecord becomes:

```
120+ fields
```

Which becomes painful to maintain.

### Red-team rule

ScanRecord must remain:

```
identity
validated data
final outputs
```

Not:

```
temporary analytics warehouse
```

---

## 3.2 MarketCore Becoming a God Module

**Type:** DESIGN RISK

MarketCore currently owns:

```
universe loading
spec reading
economics
sanity checks
asset class logic
margin sanity
tick sanity
contract sanity
```

This will **balloon over time**.

MarketCore is the **most likely module to become overloaded**.

If it becomes:

```
1500+ lines
```

maintenance becomes difficult.

---

## 3.3 Threshold Centralization Contract

**Type:** DESIGN RISK

Your threshold block is a good idea.

But:

```
RankingWeights
CorrelationShortlistSize
FrictionSampleCount
SpreadAtr
MinUpdateCount
TickAge
```

will grow quickly.

Risk:

```
threshold tuning becomes opaque
```

This is a **future operational risk**.

---

## 3.4 Mode Ownership

**Type:** DESIGN RISK

You currently allow:

```
DevMode = true
TraderMode = true
```

with internal constraints.

This can create ambiguous states.

Better conceptual model:

```
Mode = DEV | TRADER
```

instead of two booleans.

Not architecture-breaking, but safer.

---

# 4. Biggest Live-Runtime Broker Risks

## 4.1 Symbol Visibility vs Tradability

**Type:** LIVE RISK

MT5 has symbols that are:

```
visible but not tradable
tradable but inactive
active but off-session
```

Example:

```
stocks overnight
```

Your system must detect:

```
SYMBOL_TRADE_MODE
SYMBOL_SESSION_DEALS
SYMBOL_SESSION_TRADE
```

or you'll rank **dead symbols**.

---

## 4.2 Quote Freshness False Positives

**Type:** LIVE RISK

Symbols can appear active because:

```
last quote recent
```

but:

```
no meaningful updates
```

Example:

```
crypto index
synthetic CFD
```

TickAge alone will lie.

---

## 4.3 Deposit Currency Normalization

**Type:** LIVE RISK

Very dangerous area.

Example broker configurations:

```
Account currency: EUR
Symbol profit currency: USD
Tick value: already converted
```

OR

```
Tick value: still USD
```

MT5 brokers are inconsistent.

If you assume consistency:

```
CostEfficiencyScore becomes wrong.
```

---

## 4.4 ATR Across Asset Classes

**Type:** LIVE RISK

ATR values across:

| Asset   | ATR Meaning  |
| ------- | ------------ |
| FX      | small        |
| Crypto  | huge         |
| Indices | moderate     |
| Stocks  | inconsistent |

Your ranking must not compare **raw ATR values across classes**.

Otherwise:

```
crypto always wins
```

---

## 4.5 Correlation Across Sessions

**Type:** LIVE RISK

Example:

```
US stock
European index
```

They may not trade simultaneously.

Correlation computed on mismatched sessions can become nonsense.

---

# 5. Menu / HUD / Mode Usability Risks

## 5.1 Menu Size

**Type:** WATCH

You currently have **9 menu sections**.

This is already borderline large.

MT5 input panels become painful with:

```
50+ inputs
```

You are approaching that.

---

## 5.2 Pipeline Toggles + Testing Toggles

**Type:** DESIGN RISK

You have both:

```
Pipeline:
RunClassification
RunMarketCore
RunHistory
RunFriction
RunEligibility
RunRanking
RunCorrelation
RunFullPipeline
```

AND

```
Testing:
TestClassificationOnly
TestEconomicsOnly
TestHistoryOnly
...
```

These **overlap conceptually**.

Operator confusion risk.

---

## 5.3 Dev HUD Overload

**Type:** WATCH

Dev HUD currently shows:

```
counts
reject counts
weak counts
module states
phase
step
scope
anomalies
Top3 preview
```

This can easily exceed **comfortable visual space**.

HUD overload is a real MT5 issue.

---

## 5.4 Trader HUD Drift

**Type:** WATCH

Trader HUD includes:

```
ATR
spread
liveliness
freshness
correlation
score
```

This is already **a lot of cognitive load**.

If future phases add:

```
state
efficiency
expansion
context
```

Trader HUD could become noisy.

---

# 6. What Must Be Simplified Now

### SIMPLIFY NOW 1 — Phase-1 Economics

Limit Phase 1 to:

```
basic spec sanity
tick size sanity
volume sanity
trade mode sanity
```

Avoid deep normalization until Phase 2.

---

### SIMPLIFY NOW 2 — Ranking

Reduce Phase-1 scoring to **3 factors only**:

```
movement
friction
activity
```

Everything else can be weak modifiers.

---

### SIMPLIFY NOW 3 — Freshness Model

Keep Phase 1 freshness minimal:

```
TickAge
UpdateCount
```

Avoid advanced bridge metrics yet.

---

### SIMPLIFY NOW 4 — Correlation Window

Use **fixed window** correlation in Phase 1.

Avoid dynamic window logic.

---

# 7. What Must Be Live-Tested First

**TEST FIRST**

These will expose the real broker problems.

### 1. Symbol economics

Across:

```
EURUSD
USDJPY
XAUUSD
US30
AAPL
BTCUSD
```

---

### 2. Spread sampling

Test during:

```
London open
New York open
dead hours
```

---

### 3. Tick freshness

Watch behavior of:

```
stocks off-session
crypto always-on
synthetic CFDs
```

---

### 4. Classification mapping

Test with:

```
BTCUSD.a
BTCUSD.m
BTCUSD
```

alias collisions.

---

### 5. ATR calculations

Verify across:

```
JPY pairs
metals
crypto
stocks
```

---

# 8. Contracts That Must Be Frozen Now

These contracts are **critical to freeze early**.

---

### CONTRACT 1 — ScanRecord Identity Fields

These must **never change names**.

```
RawSymbol
CanonicalSymbol
AssetClass
PrimaryBucket
ServerName
```

---

### CONTRACT 2 — Eligibility Pipeline

Must always be:

```
classification
economics
history
friction
eligibility
ranking
correlation
```

Changing order later will break assumptions.

---

### CONTRACT 3 — Reject / Weak Codes

These must remain stable.

They will become:

```
log keys
debug keys
analysis keys
```

---

### CONTRACT 4 — Output Structure

```
top3_by_bucket.csv
```

should never change columns.

External tooling will depend on it.

---

# 9. What Must Be Watched So Growth Stays Additive

**WATCH**

### 1. MarketCore module growth

Most likely future monster.

---

### 2. ScanRecord bloat

Keep it below ~80 fields.

---

### 3. Threshold explosion

Centralized config must remain readable.

---

### 4. HUD creep

Trader HUD must remain **decision-focused**.

---

### 5. Debug export creep

Dev Mode exports can multiply fast.

---

# 10. Final Hardening Recommendations

These are **surgical**, not redesigns.

---

### HARDENING 1

Treat **Phase 1 economics as sanity checks only**, not normalization.

---

### HARDENING 2

Limit Phase-1 ranking to **core movement + cost + activity**.

Avoid complex multi-factor models early.

---

### HARDENING 3

Correlation must remain **shortlist-only forever**.

Never expand to universe-level.

---

### HARDENING 4

Force **Mode = single enum internally**, even if menu keeps booleans.

Avoid dual-mode ambiguity.

---

### HARDENING 5

Add **explicit anomaly categories early**:

```
ANOMALY_ZERO_SPREAD
ANOMALY_STALE_QUOTES
ANOMALY_BAD_TICKVALUE
ANOMALY_NO_HISTORY
```

These will save debugging later.

---

### HARDENING 6

Add **asset-class normalization guard**:

Never compare raw ATR across asset classes.

---

### HARDENING 7

Lock **Top3 output schema early**.

This becomes the scanner’s external contract.

---

# Final Red-Team Summary

**The architecture is good.**

But three areas are **dangerous in Phase 1**:

1️⃣ **Economics normalization**
2️⃣ **Friction modelling**
3️⃣ **Freshness modelling**

Those are **deceptively hard real-world problems**.

If Phase 1 stays:

```
simple
robust
observable
```

the architecture will scale beautifully.

If Phase 1 tries to be **too smart too early**, you risk:

```
months of broker debugging
```

instead of shipping a usable scanner.

---

If you'd like, I can also show you something extremely valuable:

**The 5 places scanners almost always fail in production MT5 environments** (things that look fine in code but break after 2–3 weeks live).
## 1. Overall red-team verdict

**Verdict:** The blueprint is **directionally strong and mostly buildable**, but **Phase 1 is still carrying too much “correctness burden” for a first usable scanner**, and there are a few places where the architecture is clean on paper but vulnerable to hidden repair work later.

The good news: the locked decisions are mostly the right ones. The danger is not that the whole framework is wrong. The danger is that **a few contracts are still too soft**, and if they are implemented casually now, they will poison later phases without looking broken.

### Main verdict points

* **BUILD RISK** — Phase 1 is **not too big in module count**, but it is **too big in validation surface**. The issue is not the number of steps. The issue is that Step 5 + Step 7 + Step 9 together create a large “looks usable / may be wrong” zone.
* **DESIGN RISK** — The blueprint correctly says `ScanRecord` is the master row, but it does **not yet freeze strict field ownership, write timing, and immutability rules strongly enough**. That is the biggest future repair risk.
* **LIVE RISK** — The most dangerous failure mode is **false confidence from plausible-but-wrong economics, friction, or freshness values**. This scanner can look polished while being wrong on the symbols that matter most.
* **WATCH** — The grouped architecture is good, but `AFS_MarketCore` and `AFS_OutputDebug` are both at high risk of becoming dumping grounds.
* **SIMPLIFY NOW** — If one thing must be simplified for “usable ASAP,” it is **Phase 1 economics correctness ambition**. Keep coarse validation, but do not let Phase 1 try to feel smarter than it can safely prove.
* **TEST FIRST** — Same-symbol cross-broker behavior, off-session instruments, deposit-currency normalization, and stale/frozen quotes must be hit almost immediately.

---

## 2. Biggest Phase 1 risks

### 2.1 Phase 1 is not too big in breadth — it is too big in “silent wrongness”

* **BUILD RISK**
* Phase 1 is not overloaded because it has too many features.
* It is overloaded because several of its required features are **deceptively hard to make trustworthy**:

  * economics sanity
  * friction/activity
  * compact ranking
  * shortlist correlation across mixed assets

This means Phase 1 can compile, export, and look polished while still being unfit for real use.

### 2.2 Biggest threat to “usable ASAP”: Step 5 — Market/spec/economics core

* **BUILD RISK**
* This is the biggest risk to the ASAP goal.
* Why:

  * it touches raw broker metadata
  * it must support multiple asset classes
  * errors are subtle
  * downstream modules trust it
* This is the first step where “works on my broker” can produce false confidence.
* If Step 5 drags, the whole scanner drags.

### 2.3 Minimum safe Phase 1 that still stays useful

* **SIMPLIFY NOW**
* The minimum safe useful Phase 1 is:

  * universe load
  * classification
  * basic spec capture
  * coarse economics trust grading
  * ATR
  * spread/freshness/activity
  * eligibility
  * compact ranking
  * Top 3 per bucket
  * shortlist correlation only on finalists

What must be kept deliberately coarse in Phase 1:

* economics should produce **PASS / WEAK / FAIL with explicit evidence**, not pretend to fully normalize every broker quirk
* friction should focus on **session reality and cost visibility**, not microstructure sophistication
* ranking should remain **small and interpretable**, not “smart”

### 2.4 Most likely sinkhole: Step 7 — Friction and activity

* **BUILD RISK**
* This step looks small and will quietly eat time.
* Why it becomes a sinkhole:

  * spread behavior differs wildly by symbol and session
  * update count is feed-dependent, not just symbol-dependent
  * tick age can lie on off-session or badly streamed symbols
  * a short window can produce noise masquerading as data
* This is where teams start adding patches, exceptions, and special scoring logic.

### 2.5 Most likely source of future structural pain if done badly now: Step 4 — normalization + classification

* **DESIGN RISK**
* If symbol identity is sloppy now, everything downstream becomes brittle.
* Bad early choices here cause:

  * alias sprawl
  * one-off overrides
  * asset mis-bucketing
  * inconsistent canonical identity
  * irreproducible cross-broker comparisons
* This is the one place where “temporary workaround” becomes permanent architecture damage.

### 2.6 Part that must be simplified even if elegant: ranking inputs

* **SIMPLIFY NOW**
* Ranking must not become a quiet second eligibility engine.
* Phase 1 ranking should not try to elegantly blend too many semi-trustworthy fields.
* The more ranking depends on soft/fragile measures early, the more it hides bad inputs behind a nice score.

---

## 3. Biggest design risks

### 3.1 `ScanRecord` is the most important contract, and it is still under-specified

* **DESIGN RISK**
* You froze fields, which is good.
* But you did not freeze:

  * which module owns each field
  * whether fields are write-once or overwriteable
  * whether a later module may “correct” an earlier module
  * whether missing vs invalid vs not-applicable are distinct states
* Without this, `ScanRecord` becomes a shared mutable blob.

**Repair risk later:** huge.
This is where clean grouped architecture quietly turns monolithic.

### 3.2 `AFS_MarketCore.mqh` is the most likely overload module

* **DESIGN RISK**
* It currently owns:

  * universe loading
  * spec reading
  * economics derivation
  * coarse validation
  * asset-class-aware handling
  * margin/tick/contract sanity
* That is already multiple responsibility families.
* It is the likeliest place for future entanglement because everything “broker-specific and weird” will want to go there.

### 3.3 Wrapper ownership is correct, but it risks becoming orchestration plus policy

* **DESIGN RISK**
* The wrapper should own lifecycle, mode, HUD, call order.
* Good.
* But if settings logic starts including behavior policy, fallback policy, or special-case routing, the wrapper becomes a hidden strategy layer.
* That would force repair later.

### 3.4 OutputDebug can become a shadow system

* **DESIGN RISK**
* Debug/export layers often become the place where missing business logic gets “temporarily exposed.”
* Risk pattern:

  * module logic becomes hard to inspect internally
  * dev exports become the real diagnostic interface
  * then more meaning gets encoded in exports than in stable contracts
* Once that happens, debug artifacts become architecture dependencies.

### 3.5 Raw / Derived / Validated separation is good, but not enough by itself

* **DESIGN RISK**
* The rule is excellent.
* The missing piece is a frozen contract for **disagreement handling**:

  * when raw is present but derived is nonsense
  * when derived is plausible but validated disagrees
  * when validation is impossible
  * when validation succeeds only for some volume assumptions
* If this is not explicit now, each module will interpret disagreement differently.

### 3.6 Phase tags and step tags risk becoming decorative

* **WATCH**
* `CurrentPhaseTag` and `CurrentStepTag` are useful only if they gate behavior and output semantics.
* If they are merely labels, they become stale documentation inside the EA.

---

## 4. Biggest live-runtime broker risks

### 4.1 Most dangerous calculations if wrong

* **LIVE RISK**
* The most dangerous wrong calculations are:

  1. tick value interpretation
  2. spread normalization relative to movement
  3. deposit-currency normalization
  4. freshness/activity inference
  5. contract-size-based practicality interpretation
  6. margin/tradability inference
* Why these are most dangerous:

  * they directly affect eligibility and ranking
  * they can look numerically reasonable
  * they vary across asset classes and brokers

### 4.2 What must be live-tested as early as possible

* **TEST FIRST**
* Earliest live tests must hit:

  * same canonical symbol on different brokers
  * JPY FX pair vs non-JPY FX pair
  * XAUUSD / XAGUSD
  * a major index CFD
  * at least one stock CFD
  * at least one crypto symbol
  * one off-session symbol
  * one weird alias symbol
* You need proof that the scanner fails visibly, not silently.

### 4.3 Symbol types most likely to break assumptions

* **LIVE RISK**
* Highest-risk symbol classes:

  * stock CFDs
  * crypto CFDs
  * broker-suffixed synthetic-looking aliases
  * indices with unusual contract economics
  * metals with non-FX-like tick behavior
  * JPY pairs if pip/point assumptions leak anywhere
  * fractional-share or unusual stock-contract implementations
* Odd symbols break not because they are rare, but because they look normal until one field behaves differently.

### 4.4 Behavior that differs most across brokers

* **LIVE RISK**
* Biggest cross-broker divergences:

  * symbol names and alias conventions
  * contract size
  * tick value behavior
  * volume min/step/max
  * off-session quote behavior
  * trade mode / visibility behavior
  * spread regime on the same canonical symbol
  * margin currency / profit currency handling
* The same “XAUUSD” is not operationally the same instrument everywhere.

### 4.5 Where false confidence happens even when code looks correct

* **LIVE RISK**
* False confidence zones:

  * stale quotes that still look recent enough
  * spread samples taken during unrepresentative moments
  * symbols with valid specs but unusable live friction
  * valid ATR on dead/off-session instruments
  * cross-broker tick values that are consistent enough to look sane, but still wrong relative to deposit currency
  * ranking that rewards movement without real tradability
* This is the big one: **the code can be clean and still tell trader-mode lies**.

### 4.6 What must be tested across FX, JPY, metals, indices, stock CFDs, crypto, odd symbols

* **TEST FIRST**
* For each asset group, explicitly test:

  * symbol normalization result
  * canonical symbol mapping
  * digits / point / tick size relationship
  * tick value raw
  * contract size
  * profit currency
  * margin currency
  * volume min/step/max
  * ATR M15/H1 availability and plausibility
  * current spread / median spread / spread-ATR ratio
  * tick age / update count
  * eligibility state
  * total score position
  * final bucket inclusion or exclusion

### 4.7 Deposit-currency normalization likely failure points

* **LIVE RISK**
* Likely failure points:

  * assuming tick value is already in deposit currency when it is not reliably so
  * mixing profit-currency logic with margin-currency logic
  * validating at one hypothetical lot size that is impractical for the instrument
  * using `OrderCalcProfit`/`OrderCalcMargin` without controlling assumptions tightly
  * not distinguishing “unvalidated because unsupported” from “validated and failed”
* This is especially dangerous because numbers may look smoothly scaled while being wrong.

### 4.8 Raw / derived / validated disagreements that must be explicitly logged

* **TEST FIRST**
* You should explicitly log disagreements for:

  * `TickValueRaw` vs validated value behavior
  * `Point` vs `TickSize`
  * theoretical pip-like move vs actual calculated P/L move
  * `ContractSize` implications vs observed margin/profit behavior
  * `TradeMode` vs practical tradability
  * `CurrentSpread` vs sampled median/max behavior
  * `TickAge` vs `UpdateCount`
  * bars available vs current feed liveliness
  * classification asset class vs economics/profile behavior
* If these are not visible, Phase 2 will be guesswork.

---

## 5. Menu/HUD/Mode usability risks

### 5.1 Current settings structure is readable, but too many overlapping control surfaces exist

* **DESIGN RISK**
* You currently have overlap between:

  * Mode
  * Scope
  * Pipeline
  * Debug
  * Testing
* This is a human-confusion risk.
* Example:

  * `RunClassification`
  * `TestClassificationOnly`
  * `RunFullPipeline`
  * `DevMode`
  * `TraderMode`
    These can conflict conceptually even if implementation handles them.

### 5.2 DevMode and TraderMode dual-boolean design is risky

* **DESIGN RISK**
* `DevMode=true/false` and `TraderMode=true/false` is an avoidable confusion trap.
* Humans will ask:

  * what if both are true?
  * what if both are false?
  * which one wins?
* You can preserve the mode concept without preserving ambiguous toggle semantics.

### 5.3 HUD overload risk in Dev Mode

* **WATCH**
* Dev HUD currently wants to show:

  * phase
  * step
  * scope
  * active module test
  * module states
  * counts
  * reject counts
  * weak counts
  * anomaly counts
  * debug preview
  * Top 3 preview
* That is already too much for one stable on-chart interface.
* Result: either unreadable HUD or endless visibility toggles.

### 5.4 Trader HUD still risks becoming “lite debug”

* **WATCH**
* Trader HUD includes:

  * ATR
  * spread/cost
  * liveliness
  * freshness
  * total score
  * correlation context
* That is useful, but only if compactly normalized.
* Otherwise the trader sees a data slab, not actionable scanner context.

### 5.5 Settings likely to become messy

* **BUILD RISK**
* Messiest future settings areas:

  * scope filters
  * pipeline/testing toggles
  * output toggles
  * threshold ownership
  * visibility controls
* Why:

  * these all expand naturally over time
  * each new phase will try to add one more switch
* This is how “easy to use” dies.

### 5.6 Toggles/settings that should be merged or simplified

* **SIMPLIFY NOW**
* Biggest simplification targets:

  * `DevMode` + `TraderMode` → one authoritative mode selector behavior
  * `RunX` and `TestXOnly` overlap → one execution intent contract
  * `ScanVisibleOnly` / `ScanSelectedScope` / filters / custom list need one clear precedence chain
  * HUD visibility toggles should be coarse, not excessively granular in Phase 1

### 5.7 Mode behavior likely to confuse the operator

* **DESIGN RISK**
* Confusing cases:

  * TraderMode requested before Phase 1 completion
  * DevMode active with minimal HUD settings that mimic TraderMode
  * Full pipeline active but scope filters narrow to one test list
  * one module test active while full exports remain enabled
* The operator needs to know:

  1. what mode am I in
  2. what scope am I scanning
  3. what pipeline is actually running
  4. what outputs are being written

Anything less becomes ambiguity during trading.

---

## 6. What must be simplified now

### 6.1 Economics validation ambition

* **SIMPLIFY NOW**
* Phase 1 should not try to solve “broker correctness” broadly.
* It should:

  * capture raw
  * derive cautiously
  * validate where possible
  * grade trust clearly
  * reject obvious nonsense
* It should not pretend to have generalized broker truth yet.

### 6.2 Ranking formula

* **SIMPLIFY NOW**
* Keep ranking compact and interpretable.
* Too many score components this early will blur responsibility.
* If a symbol ranks high, you need to know *why* without reverse engineering the formula.

### 6.3 HUD density

* **SIMPLIFY NOW**
* Dev HUD should show only:

  * mode/state
  * scope
  * pipeline step
  * counts
  * active problem summary
  * Top 3 preview
* Detailed debug belongs in selected exports or on-demand views, not the main HUD.

### 6.4 Execution controls

* **SIMPLIFY NOW**
* Unify test execution semantics.
* Right now the blueprint risks having two competing models:

  * “run these pipeline stages”
  * “test only this function”
* That leads to brittle user expectations and brittle wrapper code.

### 6.5 Correlation interpretation

* **SIMPLIFY NOW**
* Keep Phase 1 correlation strictly as shortlist context.
* Do not let it become a hidden de-duplication policy engine yet.
* Context only. No cleverness.

---

## 7. What must be live-tested first

### 7.1 Classification correctness on ugly real symbols

* **TEST FIRST**
* Test:

  * suffixes
  * prefixes
  * broker-specific crypto names
  * stock CFD naming oddities
  * similar raw names mapping to different canonicals
* Goal: prove unresolved symbols quarantine correctly and never leak into ranking.

### 7.2 Economics trust grading

* **TEST FIRST**
* On live brokers, test whether symbols get:

  * PASS when genuinely sane
  * WEAK when ambiguous
  * FAIL when clearly broken
* The key is not perfection. The key is **not promoting ambiguity to confidence**.

### 7.3 Freshness / activity reality

* **TEST FIRST**
* Hit:

  * active London/NY FX
  * quiet cross
  * metal
  * off-session stock CFD
  * crypto weekend/live
* Goal: prove stale/dead/off-session behavior does not look tradable.

### 7.4 Spread regime realism

* **TEST FIRST**
* Sample spreads through changing conditions.
* Do not test only during ideal liquid periods.
* You need proof the friction layer behaves sensibly in:

  * quiet periods
  * open/close transitions
  * spread blowouts
  * sparse update windows

### 7.5 Same-canonical-symbol cross-broker comparison

* **TEST FIRST**
* This is foundational.
* Compare:

  * classification result
  * economics flags
  * trust status
  * friction ratios
  * final eligibility
* If the same symbol behaves differently, the disagreement must be explainable.

### 7.6 Output truthfulness

* **TEST FIRST**
* Before trusting Trader Mode, validate that the final Top 3 file contains only:

  * classified
  * eligible
  * actually current-enough
  * clearly interpretable symbols
* A clean output file that contains lies is worse than messy debug.

---

## 8. What contracts must be frozen now

### 8.1 `ScanRecord` field ownership and lifecycle

* **DESIGN RISK**
* Freeze:

  * which module writes each field
  * whether the field is write-once
  * whether later modules can only append, not reinterpret
  * null/not-applicable/fail/unknown semantics
* This is the most important contract to freeze now.

### 8.2 Eligibility-before-ranking enforcement contract

* **DESIGN RISK**
* Freeze hard:

  * FAIL symbols are never scored for selection
  * WEAK handling is deterministic
  * ranking never rescues failed symbols
* This must be untouchable.

### 8.3 Classification contract

* **DESIGN RISK**
* Freeze:

  * canonical identity rules
  * unresolved behavior
  * one raw symbol → one canonical mapping policy
  * confidence semantics
  * review-state semantics
* No fuzzy downstream reinterpretation.

### 8.4 Raw / Derived / Validated disagreement semantics

* **DESIGN RISK**
* Freeze:

  * what counts as disagreement
  * what gets logged
  * what causes WEAK
  * what causes FAIL
  * what remains informational only
* Without this, each developer phase will invent new meaning.

### 8.5 Mode execution contract

* **DESIGN RISK**
* Freeze:

  * exactly one effective operating mode at a time
  * what each mode is allowed to output
  * what each mode is allowed to show
  * how test-scope execution overrides normal pipeline flow
* This protects usability and prevents wrapper creep.

### 8.6 Output artifact contract

* **WATCH**
* Freeze:

  * final production file schema
  * anomaly log schema
  * selected-scope export schema
  * reason code representation
* This matters for Git diffing, regression checking, and future chats.

---

## 9. What should be watched so growth stays additive

### 9.1 Watch `AFS_MarketCore` for responsibility creep

* **WATCH**
* The moment it starts absorbing:

  * session logic
  * anomaly policy
  * asset-specific ranking hints
  * fallback normalization tricks
    it becomes the monster module.

### 9.2 Watch ranking so it does not become hidden policy

* **WATCH**
* Growth risk:

  * more scores
  * more modifiers
  * more soft penalties
  * more exceptions
* If ranking starts solving problems that eligibility, trust grading, or classification should solve, the architecture is decaying.

### 9.3 Watch output/debug so it does not become required for understanding

* **WATCH**
* The system should remain understandable from stable fields and reason codes.
* If you need custom debug exports to know why a symbol ranked, the core contract is too weak.

### 9.4 Watch thresholds for scatter and duplication

* **WATCH**
* Centralized thresholds are correct.
* But watch for:

  * same idea expressed with multiple thresholds
  * mode-specific hidden overrides
  * asset-specific values being snuck into logic without contract change
* Threshold sprawl is how systems become un-auditable.

### 9.5 Watch module splits

* **WATCH**
* Do not split helpers into separate modules just because code grows.
* Split only when:

  * maintenance ownership separates
  * contract hardens
  * feature life cycle diverges
* Otherwise file count rises while clarity falls.

### 9.6 What should remain internal helper logic

* **WATCH**
* These should remain internal until proven independent:

  * tiny score component helpers
  * symbol string sanitation helpers
  * basic field formatting utilities
  * one-off export formatting
  * small asset-class conditional helpers
* Premature modularization will recreate ISSX-style fragmentation.

### 9.7 What should be logged/versioned/tested first to protect growth

* **TEST FIRST**
* Protect future evolution by versioning and regression-testing:

  * classification map schema
  * `ScanRecord` schema
  * reason code enum set
  * final output schema
  * anomaly categories
  * threshold block
  * trust-grade rules
* These are the backbone contracts. Freeze and track them early.

---

## 10. Final hardening recommendations

### 10.1 Treat Phase 1 as usable scanner + visible uncertainty, not full correctness

* **SIMPLIFY NOW**
* Phase 1 should aim to be:

  * useful
  * readable
  * conservative
  * visibly uncertain where needed
* Not “broker hardened.”

### 10.2 Freeze `ScanRecord` ownership before writing more code

* **DESIGN RISK**
* This is the single highest-leverage hardening move.
* Define field ownership, mutation rules, and state semantics now.

### 10.3 Reduce mode ambiguity before implementation spreads

* **SIMPLIFY NOW**
* Preserve Dev/Trader concept, but remove any ambiguous dual-toggle semantics in behavior.
* One effective mode. One clear execution intent. One visible active scope.

### 10.4 Keep Phase 1 ranking brutally compact

* **SIMPLIFY NOW**
* Ranking should remain explainable in one glance.
* The moment it needs narrative interpretation, it is too complex for Phase 1.

### 10.5 Force disagreement visibility in economics and feed quality

* **TEST FIRST**
* Do not allow silent “best guess” blending.
* Explicitly surface raw / derived / validated disagreement and freshness/frequency disagreement.

### 10.6 Attack off-session and weird-symbol cases early, not later

* **TEST FIRST**
* Do not leave:

  * stock CFDs
  * crypto
  * metals
  * alias-heavy symbols
  * stale-feed cases
    for Phase 2 cleanup.
* Those are exactly the cases that break confidence.

### 10.7 Protect the grouped architecture from dump-zone behavior

* **WATCH**
* Especially:

  * `AFS_MarketCore`
  * `AFS_OutputDebug`
  * wrapper settings logic
* These are the most likely repair hotspots later.

### 10.8 Final harsh summary

* **BUILD RISK** — Phase 1 is buildable, but Step 5 and Step 7 are where schedule optimism dies.
* **DESIGN RISK** — The biggest architectural repair risk is not module count; it is **soft contracts around ScanRecord, mode semantics, and disagreement handling**.
* **LIVE RISK** — The biggest real-world danger is **plausible wrongness**: the scanner looking mature while misreading economics, feed quality, or tradability.
* **WATCH** — If MarketCore, ranking, or OutputDebug start absorbing exceptions and policy, you are on the road to another ISSX-style monster.
* **SIMPLIFY NOW** — Simplify economics ambition, mode semantics, ranking, and HUD density.
* **TEST FIRST** — Cross-broker same-symbol comparisons, off-session behavior, deposit-currency normalization, and stale/frozen quote behavior.

**Bottom line:**
You do **not** need redesign.
You **do** need harder contract freezing and narrower Phase 1 ambition in the places most likely to fake correctness.

This blueprint is close. But the remaining risk is exactly the dangerous kind: **not obvious breakage — elegant early wrongness.**
