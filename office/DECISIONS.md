# DECISIONS

## Locked Decisions
- root layout is `blueprint/`, `office/`, `mt5/`, `archives/`
- `archives/` is static reference only
- MT5 product code contains no dev/task/phase/worker wording
- MT5 deployment remains one flat EA folder
- output is broker-level, not account-level
- startup reads existing broker persistence first and fills gaps instead of blind rebuilding
- summary is top 5 per `PrimaryBucket` only
- symbol files have exactly 3 major sections:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`
- UI remains isolated from internal scanner logic
- only one build worker may run at a time
- Clerk and Debug are idle-only post-run workers
- Clerk and Debug must not run while a build worker is active

## First Scanner Milestone Locks
- summary is grouped by `PrimaryBucket` truth from Market classification
- ranking inside each bucket uses one balanced scanner score
- first milestone timeframe set is fixed to:
  - `M15`
  - `H1`
- first milestone minimum calculations are:
  - `spread_now_points`
  - `spread_now_price`
  - `avg_range_m15`
  - `atr_m15`
  - `atr_h1`
  - `atr_h1_percent_of_price`
  - `body_ratio_m15`
  - `freshness_seconds`
  - `balanced_score`
- first milestone cadence is:
  - `OnInit` full bounded pass after restore
  - `OnTimer` bounded refresh passes
  - `OnTick` no heavy scanner work
