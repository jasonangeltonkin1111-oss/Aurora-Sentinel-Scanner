AFS FUTURE UPGRADE NOTE
Trader HUD – Trust Indicators (Deferred)

Purpose
-------
Improve trader confidence in the scanner by exposing a small set of
high-signal health indicators directly in the Trader Mode HUD.

These indicators should help a trader immediately answer:

1. Is the scanner fully warmed up?
2. Is the shortlist trustworthy yet?
3. Are the dossiers current?
4. Are correlations resolved enough to review setups?

This must remain downstream-only display logic and must never alter
scanner truth, selection logic, or correlation behavior.

Proposed Indicators
-------------------

1. PIPELINE MATURITY
   Shows readiness of upstream scanner stages.

   Example:
   Surface Ready        1200 / 1200
   Spec Ready           1180 / 1200
   History Ready        1175 / 1200
   Tradability Ready    1200 / 1200

   Status states:
   - WARMING
   - PARTIAL
   - READY

2. SHORTLIST STABILITY
   Indicates whether the finalist set is still shifting heavily.

   Possible metrics:
   - finalist count change over last N passes
   - PASS / WEAK churn

   Display example:
   Shortlist Stability: STABILIZING

3. CORRELATION RESOLUTION
   Helps determine if clusters are fully resolved.

   Example:
   Correlation Resolved   92 / 146
   Pending Clusters       54

4. DOSSIER FRESHNESS
   Ensures trader package is not stale.

   Example:
   Dossiers Published     146
   Last Summary Update    17:12:44
   Refresh Status         ACTIVE

5. SCANNER CONFIDENCE
   Simple synthesized indicator derived only from existing state.

   Possible states:
   - WARMING
   - STABILIZING
   - READY

   Example:
   Scanner Confidence: STABILIZING

Constraints
-----------
These indicators must:

- read existing trusted runtime state only
- never recompute scanner truth
- never affect Step 8 / 9 / 10 logic
- remain HUD-only presentation
- remain optional and bounded

Implementation Phase
--------------------

This work should be implemented only after:

Phase 1 Step 3 or later

Reason:
Current focus remains on:
- writer framework safety
- active publication lifecycle
- canonical trader package stability

Only after those are hardened should Trader HUD trust indicators be added.

End of Note





Aegis Forge Scanner – Enhancement Notes
Version Target: Phase 2 System Improvements
Purpose: Improve trade quality, reduce correlation risk, and optimize volatility efficiency.

------------------------------------------------
1. CORRELATION CLUSTER FILTER
------------------------------------------------

Goal:
Prevent multiple trades from the same correlated market cluster.

Rule:
If correlation between two instruments >= 0.85,
only allow ONE active trade from that cluster.

Implementation Logic:

for each symbol_A:
    for each symbol_B:
        if correlation(symbol_A, symbol_B) >= 0.85:
            assign same cluster_id

Trade Selection:

if cluster_id already has active_trade:
    reject new trade
else
    allow trade

Example Cluster:
US_INDEX_CLUSTER
- SPCUSD
- DJCUSD
- NACUSD
- RUSS2000

Allowed:
1 trade only from cluster.

------------------------------------------------
2. ATR EFFICIENCY SCORE
------------------------------------------------

Goal:
Prioritize markets where volatility is large relative to spread.

Formula:

ATR_Efficiency = ATR_M15 / SpreadNow

Example:

ATR_M15 = 60
SpreadNow = 150

ATR_Efficiency = 0.40

Interpretation:

>= 0.40   Excellent
0.25–0.40 Good
0.15–0.25 Weak
< 0.15    Avoid

Implementation:

symbol.atr_efficiency = ATR_M15 / SpreadNow

Ranking:

sort symbols by atr_efficiency DESC

------------------------------------------------
3. TRADE CANDIDATE GENERATION
------------------------------------------------

Goal:
Output a shortlist of best tradeable markets.

Filter Criteria:

Status == PASS
Quote == FRESH
Session == ACTIVE
SprATR <= 0.20
ATR_M15 > minimum_volatility_threshold

Candidate Score Formula:

TradeScore =
    (ATR_Efficiency * 0.40)
  + (Activity.Live * 0.20)
  + (Freshness * 0.15)
  + (Score * 0.25)

Sort by TradeScore.

Output Top 3–5 instruments.

Example Output:

TRADE_CANDIDATES

1.
Symbol: NACUSD
ATR_M15: 59.23
ATR_H1: 76.31
Spread: 150
ATR_Efficiency: 0.39
Cluster: US_INDEX
TradeScore: 0.87

2.
Symbol: XAUUSD
ATR_M15: 13.96
ATR_H1: 25.17
Spread: 52
ATR_Efficiency: 0.27
Cluster: METALS
TradeScore: 0.82

3.
Symbol: TSLA
ATR_M15: 2.30
ATR_H1: 3.85
Spread: 12
ATR_Efficiency: 0.19
Cluster: US_STOCKS
TradeScore: 0.79

------------------------------------------------
4. SPREAD TO VOLATILITY FILTER
------------------------------------------------

Goal:
Reject instruments where spread consumes too much movement.

Metric:

SprATR = SpreadNow / ATR_M15

Interpretation:

<= 0.10 Excellent
0.10–0.20 Acceptable
0.20–0.30 Risky
> 0.30 Reject

Implementation:

if SprATR > 0.30:
    Status = WEAK
    Reason = FRICTION_UNUSABLE

------------------------------------------------
5. SESSION QUALITY FILTER
------------------------------------------------

Goal:
Avoid trading inactive or thin liquidity periods.

Rules:

Reject if:

Quote == STALE
TickAge > 10
Session == QUIET
Session == UNKNOWN

Prefer:

Session == ACTIVE
Quote == FRESH

------------------------------------------------
6. MAX TRADE PER ASSET CLASS
------------------------------------------------

Goal:
Reduce hidden correlation across asset types.

Limits:

MAX_TRADES_PER_CLASS

INDEX   = 2
CRYPTO  = 2
STOCK   = 3
FX      = 2
METALS  = 1
ENERGY  = 1

Example:

if open_trades[asset_class] >= limit:
    reject_trade()

------------------------------------------------
7. POSITION RISK MODEL
------------------------------------------------

Goal:
Maintain consistent small risk per trade.

Rule:

Max RR allowed = 1.30

Risk Model:

StopLoss = ATR_M15 * SL_MULTIPLIER

Example:

SL_MULTIPLIER = 0.8
TP_MULTIPLIER = 1.04

Ensures:

RR ≈ 1.30

------------------------------------------------
8. FINAL TRADE PIPELINE
------------------------------------------------

Full System Flow:

SCAN_MARKETS
    ↓
FILTER_BAD_MARKETS
    ↓
CALCULATE_ATR_EFFICIENCY
    ↓
REMOVE_HIGH_FRICTION_SYMBOLS
    ↓
CORRELATION_CLUSTER_FILTER
    ↓
SESSION_LIQUIDITY_FILTER
    ↓
TRADE_SCORE_RANKING
    ↓
OUTPUT_TOP_CANDIDATES
    ↓
AI_TRADE_ANALYSIS
    ↓
EA_EXECUTION

------------------------------------------------
END NOTES
------------------------------------------------

System Philosophy:

High-frequency
Low correlation
Moderate RR
Consistent small edge

Target Profile:

Trades per day: 8–15
RR: ≤ 1.3
Winrate target: 55–65%
Risk per trade: small
Equity curve: smooth upward trend