# STRATEGY DATA SURFACES

## PURPOSE

This file defines the main data surfaces Aurora strategy families may eventually use.

It exists to prevent a false narrowing where all strategy families are treated as chart-only simply because the first Wave 1 doctrine stack began from chart-visible auction structure.

Aurora is broader than chart-only logic.
It may later use:
- chart structure
- ASC scanner outputs
- live execution or order-flow data
- macro / regime context
- cross-asset and relative-strength context
- event and calendar context

This file keeps that future design space explicit.

---

# 1. DATA SURFACE CLASSES

## S1 — CHART / STRUCTURE SURFACE
Examples:
- state
- surface trust
- balance
- breakout
- trap
- continuation
- compression

Use:
- first-wave core family hosting

## S2 — ASC SCANNER / INTERNAL FEATURE SURFACE
Examples:
- symbol ranking outputs
- bucket comparisons
- broker specs
- OHLC persistence
- internal calculation layers
- future Aurora-compatible scanner features

Use:
- cross-symbol ranking
- family filtering
- pre-selection before deeper family evaluation

## S3 — LIVE EXECUTION / MICROSTRUCTURE SURFACE
Examples:
- spreads
- liquidity
- order-book or queue information
- live execution conditions
- live transaction cost / slippage context

Use:
- live deployability refinement
- advanced execution-aware families
- microstructure-native overlays

## S4 — MACRO / REGIME SURFACE
Examples:
- macro state
- debt / rate / policy context
- broad regime instability
- high-impact event regime shifts

Use:
- contextual risk overlays
- family suppression or weighting logic later
- macro-conditioned families

## S5 — CROSS-ASSET / RELATIVE SURFACE
Examples:
- cross-sectional momentum
- relative strength / weakness
- spread relationships
- intermarket confirmation or divergence

Use:
- multi-instrument families
- statistical or relational families

## S6 — CALENDAR / SESSION / TIMEBOX SURFACE
Examples:
- ORB definitions
- session-specific behavior
- time-of-day families
- seasonal or calendar tendencies

Use:
- session-conditioned families
- intraday momentum families
- calendar-effect families

---

# 2. WHY THIS MATTERS

A future GPT wrapper or EA should not assume every family only consumes one candle chart.

Instead, every family should later be mappable by:
- native structural habitat
- required data surfaces
- optional supporting data surfaces

That allows Aurora to stay modular while expanding beyond chart-only logic.

---

# 3. CURRENT JUDGMENT

Wave 1 core doctrine is chart-first.
Aurora as a larger system is not chart-only.

This file exists so the strategy-family folder can remain compatible with ASC outputs, live data, macro context, and future multi-surface families.
