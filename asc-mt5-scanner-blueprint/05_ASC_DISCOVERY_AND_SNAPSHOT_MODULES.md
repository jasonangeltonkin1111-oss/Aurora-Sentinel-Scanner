# ASC Discovery and Snapshot Modules

## Principle

Discovery modules retrieve and store truth.
They do not rank, filter, score, or decide final selection.

Each retrieval module should have three roles:

- collector
- store
- accessor

This is one of the most important codegen constraints.

## Module 1 — SymbolSpecs

### Purpose
Capture broker-defined symbol properties for the known universe.

### Why it exists
ASC needs structural truth separate from live-market truth.

Examples:
- digits
- point
- tick size
- tick value
- contract size
- trade mode
- fill/order mode
- stops and freeze levels
- volume min/max/step
- base/profit/margin currencies
- sector/industry if exposed
- path/description/exchange
- session counts and summaries

### Design rules
- query raw broker properties honestly
- store unsupported/unavailable separately from zero
- refresh slowly, not on every heartbeat
- keep this module available for closed symbols too

### Suggested data groups
- identity
- pricing structure
- trading permissions
- volume rules
- margin/profit rules
- execution rules
- session summary
- optional metadata

## Module 2 — MarketWatchFeed

### Purpose
Capture current live observable values.

### Typical fields
- bid
- ask
- last
- volume
- daily high/low/open/close if available
- spread
- daily change
- last tick time
- capture timestamp
- staleness flags

### Design rules
- collect current snapshot
- detect no tick / stale tick
- do not fabricate missing fields
- treat feed quality separately from specs quality

## Module 3 — SessionReference

This can be implemented as part of market-state logic or as its own discovery helper.

### Purpose
Build reusable session/trading-window truth for:
- current within-session test
- next session open
- session availability status
- future check scheduling

## Module 4 — HistoryAccess

### Purpose
Provide timeseries access for later layers without coupling them directly to raw platform calls everywhere.

### Why it matters
A weak codegen model tends to call `CopyRates()` and indicator functions from random locations.
ASC should centralize this.

## Collector/store/accessor pattern

### Collector
Calls MT5 APIs and updates in-memory records.

### Store
Owns the latest internal record and freshness markers.

### Accessor
Returns requested field(s) without triggering a recollection.

Bad:
- `GetBid(symbol)` internally runs a full recollection
- `GetDigits(symbol)` calls `SymbolInfoDouble()` every time from every layer

Good:
- collectors refresh by schedule
- accessors read cached/store state
- scheduler decides recollection cadence

## Suggested store records

### `SymbolSpecsRecord`
- identity fields
- static/semi-static broker properties
- `collected_at`
- `validity_state`
- `missing_mask`
- `source_flags`

### `MarketWatchRecord`
- current observable values
- `last_tick_time`
- `captured_at`
- `staleness_state`
- `quote_usable`
- `tick_present`

### `SessionRecord`
- `has_trade_sessions`
- `within_trade_session`
- `next_open_at`
- `sessions_summary`
- `source_reliable`

## Refresh cadence model

### SymbolSpecs
- on init
- on universe change
- optional slow refresh

### MarketWatchFeed
- due-based
- higher cadence for open symbols
- lower cadence for clearly closed symbols
- in-memory update may be more frequent than file publication

### HistoryAccess
- only when requested by later layers and actually due

## Accessor discipline examples

Good accessors:
- `TryGetBid(symbol, out_bid)`
- `TryGetTradeMode(symbol, out_mode)`
- `GetSnapshotAgeSeconds(symbol)`
- `GetSessionNextOpen(symbol)`
- `HasFreshTick(symbol)`

Avoid:
- getters that silently recollect
- accessors that do ranking math
- accessors that convert unknown into default values
