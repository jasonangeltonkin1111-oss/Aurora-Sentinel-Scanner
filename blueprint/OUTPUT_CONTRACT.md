# OUTPUT CONTRACT

## Canonical Trader-Facing Outputs
Aurora Sentinel exposes only two canonical trader-facing outputs.

### 1. `<Broker>.Summary.txt`
Purpose:
- show which symbols deserve attention now

Rules:
- top 5 symbols per bucket only
- compact but decision-useful
- no raw OHLC dump
- no writer-side calculations
- no fake zero placeholders

### 2. `<Broker>.Symbols/<Symbol>.txt`
Purpose:
- show deeper intelligence for one shortlisted symbol

Rules:
- exactly 3 major sections:
  1. `[BROKER_SPEC]`
  2. `[OHLC_HISTORY]`
  3. `[CALCULATIONS]`

## Writer Purity
Output formats and renders already-prepared snapshot data. It does not fetch, calculate, rank, normalize, or repair values.
