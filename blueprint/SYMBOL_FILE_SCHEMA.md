# SYMBOL FILE SCHEMA

## Symbol File Goal
Each symbol file is the deeper source of truth for one shortlisted symbol.

## Major Sections
Exactly 3 major sections:
1. `[BROKER_SPEC]`
2. `[OHLC_HISTORY]`
3. `[CALCULATIONS]`

## Section Meaning
### `[BROKER_SPEC]`
Spread/spec/economics/tradability facts.

### `[OHLC_HISTORY]`
Persisted history slices needed for deeper inspection.

### `[CALCULATIONS]`
Prepared deeper calculations and trader-facing metrics.

## Locked Timeframe Set
For the first scanner milestone, the runtime uses a fixed two-timeframe set only:
- `M15`
- `H1`

Purpose:
- `M15` gives short-horizon movement and spread-context usefulness
- `H1` gives broader surface context

No additional timeframes are part of the first milestone contract.

## Locked Minimum Calculation Set
The first scanner milestone must prepare these minimum calculations per valid symbol:
- `spread_now_points`
- `spread_now_price`
- `avg_range_m15`
- `atr_m15`
- `atr_h1`
- `atr_h1_percent_of_price`
- `body_ratio_m15`
- `freshness_seconds`
- `balanced_score`

These calculations are scanner-surface measurements only.
They are not signals or strategy decisions.

## `[OHLC_HISTORY]` Contract for First Milestone
The symbol file must persist bounded recent OHLC slices for:
- `M15`
- `H1`

The exact storage format may be implementation-friendly, but it must remain readable and truthful.
It must not dump unbounded history.

## Rules
- no extra major sections
- include timestamps and truth-state where relevant
- preserve last trusted state where appropriate
- do not fake unavailable values
- do not add trend labels or directional signals in the first milestone
