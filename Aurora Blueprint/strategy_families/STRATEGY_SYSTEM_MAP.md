# STRATEGY SYSTEM MAP

## PURPOSE

This file is the top-level system map for the Aurora strategy layer.

It exists to make the whole strategy path clear from end to end:
- doctrine
- data surfaces
- family selection
- family competition
- future wrapper logic
- future EA routing

This is the file a future HQ chat, GPT wrapper designer, or EA planner should read when asking:
- how does Aurora go from raw information to strategy-family choice?

---

# 1. HIGH-LEVEL FLOW

Aurora strategy logic should ultimately flow in this order:

1. **Doctrine layer**
   - market-state doctrine
   - execution-context doctrine
   - cross-link logic

2. **Data-surface layer**
   - chart / structure
   - ASC scanner outputs
   - live execution / microstructure
   - macro / regime
   - cross-asset / relative
   - calendar / session / timebox

3. **Family layer**
   - identify plausible family candidates
   - reject anti-habitat families
   - separate core vs conditional vs preserved families

4. **Competition layer**
   - compare the most plausible families
   - identify dominant interpretation
   - identify rejected interpretations

5. **Pattern / child-logic layer**
   - call the relevant pattern or subfamily structures only after family choice becomes credible

6. **Testing / execution layer later**
   - test the family
   - later route into wrapper / EA implementation logic

---

# 2. STRATEGY FAMILY ENTRY STACK

## First doctrinal gate
The first family gate is not a tactic gate.
It is a doctrine gate:
- what state is the market in?
- what surface trust does that state currently deserve?

These answers come from:
- consolidated Wave 1 market-state doctrine
- consolidated Wave 1 execution-context doctrine

## Second gate
After state and surface are clear:
- which family is native here?
- which competing family is most likely to be confused with it?
- which families should be rejected immediately?

These answers come from:
- strategy family files
- family matrix
- starter build pack

## Third gate
Only after family plausibility is established:
- what pattern layer is needed?
- what extra data surface is missing?
- is this family ready for chart-only use or does it need richer surfaces?

---

# 3. FAMILY SELECTION STACK

A future Aurora wrapper or EA should reason in this order:

## Step 1 — detect current state
Examples:
- balance
- directional discovery
- failed break / trap
- transition / instability

## Step 2 — detect current surface trust
Examples:
- discovery-with-trust
- structurally valid but low-trust
- nonconviction / stay-out
- excess / exhaustion

## Step 3 — generate candidate families
Examples:
- Trend Continuation
- Pullback Continuation
- Breakout / Compression Release
- Failed Break / Trap Reversal
- Balance Rotation / Range Mean-Reversion

## Step 4 — reject anti-habitat families
Suppress families that do not belong in the current state/surface combination.

## Step 5 — request supporting surfaces if needed
Ask whether:
- ASC symbol-ranking data would improve filtering
- live execution/microstructure data would improve trust
- macro/regime context would suppress or weight the family differently
- session/calendar context would materially change the family read

## Step 6 — call deeper child logic
Only then call:
- family cards
- pattern modules
- testing modules
- later execution logic

---

# 4. FAMILY CLASSES IN THE SYSTEM

## CORE families
These are the first build pack and the first routing targets.

## CONDITIONAL families
These are real but require stronger supporting surfaces or doctrine before they become clean primary routing targets.

## PRESERVED families
These remain in system memory so the future architecture does not forget them, but they are not immediate first-pack routing targets.

---

# 5. ROLE OF ASC IN THE SYSTEM

ASC is not outside Aurora.
It is one of Aurora’s future high-value data surfaces.

Likely future uses of ASC outputs in the family layer:
- pre-select symbols before deeper family analysis
- rank candidates across symbols
- suppress weak-quality symbols before family logic is called
- provide internal feature context that makes family competition smarter

ASC therefore belongs mostly to:
- S2 — ASC Scanner / Internal Feature Surface

It should later become one of the major bridges between broad market scanning and deeper family selection.

---

# 6. ROLE OF LIVE DATA IN THE SYSTEM

Live execution or microstructure data is not mandatory for every family, but it is one of the major future trust-improving surfaces.

Likely future uses:
- spread / liquidity / slippage awareness
- live deployability refinement
- execution-aware rejection of weak opportunities
- support for non-chart-native microstructure tactics later

Live data therefore belongs mostly to:
- S3 — Live Execution / Microstructure Surface

---

# 7. ROLE OF MACRO / REGIME DATA IN THE SYSTEM

Macro or regime data is not part of the first chart-first Wave 1 family pack, but it is a real future family-weighting or suppression surface.

Likely future uses:
- suppress families in hostile regime conditions
- change weighting of trend vs mean-reversion vs breakout families
- support calendar and macro-conditioned families later

Macro/regime therefore belongs mostly to:
- S4 — Macro / Regime Surface

---

# 8. ROLE OF CROSS-ASSET DATA IN THE SYSTEM

Cross-asset and relational data should later support:
- cross-sectional momentum
- pairs / spread logic
- relative-value or confirmation layers
- symbol-group competition and selection

This belongs mostly to:
- S5 — Cross-Asset / Relative Surface

---

# 9. ROLE OF SESSION / CALENDAR DATA IN THE SYSTEM

Session/timebox data should later support:
- ORB families
- intraday momentum families
- post-open reversal families
- time-conditioned suppressions or upgrades

This belongs mostly to:
- S6 — Calendar / Session / Timebox Surface

---

# 10. WHAT THIS PREVENTS

This system map is designed to prevent five bad outcomes:

1. treating Aurora as chart-only forever
2. treating strategy selection as direct pattern-picking without family logic
3. letting ASC remain disconnected from Aurora family intelligence
4. confusing preserved families with first-pack build-ready families
5. building a wrapper or EA that has to infer the strategy architecture from scattered files

---

# 11. CURRENT JUDGMENT

Aurora now has enough strategy structure that the family layer can be viewed as a true system:
- doctrine drives family plausibility
- data surfaces refine family trust
- families route deeper pattern/testing work
- future wrappers and EAs can be built on top of an explicit map rather than on scattered notes
