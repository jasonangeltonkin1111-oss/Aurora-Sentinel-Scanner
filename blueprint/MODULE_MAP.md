# MODULE MAP

## Product Modules
Aurora Sentinel product code is divided into:
- Common
- Engine
- Market
- Conditions
- Surface
- Ranking
- Output
- Storage
- UI
- Diagnostics

## Responsibilities
### Common
Shared types, constants, statuses, and truth states.

### Engine
Runtime control, scheduling, orchestration, and guarded module call order.

### Market
Broker symbol discovery, canonical identity, asset/bucket mapping, alias handling, session state, and feed state.

### Conditions
Spread/spec/economics/tradability truth.

### Surface
ATR, movement, freshness, liveliness, friction, and surface-age truth.

### Ranking
Eligibility, score composition, shortlist authority, and top-5-per-bucket selection.

### Output
Summary and symbol snapshot formatting only.

### Storage
Common-folder paths, broker naming, persistence read/merge, stale detection, and atomic writes.

### UI
HUD, menu, chart display, and presentation only.

### Diagnostics
Logs, runtime trace, timing, warnings, and degraded-state notes.
