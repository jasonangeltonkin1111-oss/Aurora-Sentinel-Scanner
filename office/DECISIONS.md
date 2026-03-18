# DECISIONS

## Locked Decisions
- root layout is `blueprint/`, `office/`, `mt5/`, `archives/`
- MT5 product code contains no dev/task wording
- output is broker-level, not account-level
- startup reads existing broker persistence first and fills gaps instead of blind rebuilding
- summary is top 5 per bucket only
- symbol files have exactly 3 major sections
- UI remains isolated from internal scanner logic
