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

## Rules
- no extra major sections
- include timestamps and truth-state where relevant
- preserve last trusted state where appropriate
- do not fake unavailable values
