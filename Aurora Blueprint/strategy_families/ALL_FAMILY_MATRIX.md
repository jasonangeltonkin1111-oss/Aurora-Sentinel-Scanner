# ALL FAMILY MATRIX

## PURPOSE

This file is the compact matrix view of the full Aurora strategy-family layer.

It exists so future HQ, GPT wrappers, and EA design layers can quickly see:
- what families exist
- which class each belongs to
- which habitats they target
- which data surfaces they naturally use
- whether they are first-pack core, conditional, or preserved

This file complements the deeper family files.
It does not replace them.

---

# 1. FAMILY MATRIX

| Family | Class | Primary habitat | Native readiness | Primary data surfaces | Notes |
|---|---|---|---|---|---|
| Trend Continuation | CORE | Directional discovery / expansion | First-pack core | S1; later S2/S3 | continuation after structure is already established |
| Trend Pullback / Pullback Continuation | CORE | directional retracement within intact trend | First-pack core | S1; later S2/S3 | continuation via temporary retracement |
| Breakout / Compression Release | CORE | balance/compression -> expansion transition | First-pack core | S1; later S2/S3/S6 | release must survive beyond cheap excursion |
| Failed Break / Trap Reversal | CORE | failed state / reclaim / trap | First-pack core | S1; later S2/S3/S6 | reversal after failed directional hold |
| Balance Rotation / Range Mean-Reversion | CORE | stable balance / range rotation | First-pack core | S1; later S2/S3/S6 | return-to-value / opposite-boundary logic |
| Intraday Momentum | CONDITIONAL | session-specific directional expansion | Conditional | S1/S3/S6 | requires explicit session/timebox doctrine |
| Opening Range Breakout variants | CONDITIONAL | post-open directional resolution | Conditional | S1/S3/S6 | needs opening-range and session definitions |
| Cross-Sectional Momentum | CONDITIONAL | relative strength across instruments | Conditional | S2/S5 | requires ranking/grouping logic |
| Calendar / Seasonal Effects | CONDITIONAL | time-window or calendar-conditioned behavior | Conditional | S4/S6 | requires strong anti-overfitting controls |
| Pairs / Statistical Arbitrage | PRESERVED | spread / relative-value distortion | Preserved | S2/S5 | not single-chart-native |
| Order-Book / Microstructure Tactics | PRESERVED | live queue / flow / microstructure dynamics | Preserved | S3 | requires live microstructure surfaces |
| Options Overlay / Volatility Harvest | PRESERVED | derivatives / vol-premium / options overlays | Preserved | derivatives extensions; later S4 | outside current chart-first core |
| HFT / Latency / Ultra-Short-Horizon | PRESERVED | ultra-short-lived execution asymmetry | Preserved | S3 + specialized infra | architecturally separate from current Aurora core |

---

# 2. READING RULE

Use this matrix to answer three questions quickly:

1. Is this family part of the first core build pack?
2. Which market habitat does it naturally belong to?
3. Which data surfaces are needed before it becomes cleanly buildable?

---

# 3. CURRENT JUDGMENT

Aurora now has a strategy-family layer that can be seen both as:
- a detailed family-file system
- a compact matrix for future routing, wrapper design, and EA planning
