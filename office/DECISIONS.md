# DECISIONS

## Locked Decisions
- root layout is `blueprint/`, `office/`, `mt5/`, `archives/`
- `archives/` is static reference only
- MT5 product code contains no dev/task/phase/worker wording
- MT5 deployment remains one flat EA folder
- output is broker-level, not account-level
- startup reads existing broker persistence first and fills gaps instead of blind rebuilding
- summary is top 5 per bucket only
- symbol files have exactly 3 major sections:
  - `[BROKER_SPEC]`
  - `[OHLC_HISTORY]`
  - `[CALCULATIONS]`
- UI remains isolated from internal scanner logic
- only one build worker may run at a time
- Clerk and Debug are idle-only post-run workers
- Clerk and Debug must not run while a build worker is active
