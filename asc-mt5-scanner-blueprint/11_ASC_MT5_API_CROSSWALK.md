# ASC MT5 API Crosswalk

## Purpose

This file maps ASC architecture needs to the MT5/MQL5 runtime APIs that a coding model must use correctly.

## Event model APIs

### `OnInit()`
Use for:
- startup
- restore bootstrap
- timer creation

### `OnTimer()`
Use for:
- heartbeat orchestration
- due scheduler
- bounded refresh work

### `OnDeinit()`
Use for:
- timer cleanup
- final save/log

### `EventSetTimer(int seconds)`
Use 1-second cadence for the main heartbeat.
A timer must be set before `OnTimer()` events occur.

### `EventKillTimer()`
Stop timer on shutdown.

### Optional: `EventSetMillisecondTimer(int milliseconds)`
Possible for sub-second precision, but the active blueprint does not require it and it can increase load complexity.

## Time APIs

### `TimeTradeServer()`
Preferred for trade/session logic and server-time interpretation.

### `TimeCurrent()`
Useful current terminal/server-related time source; may be used as fallback.

### `TimeLocal()`
Use only for local diagnostics when needed.

### `TimeToStruct()`
Useful for computing current day-of-week and seconds-in-day for session logic.

## Universe and symbol APIs

### `SymbolsTotal(bool selected)`
Use carefully.
- `true` = Market Watch only
- `false` = all symbols known to the server

The current foundation code uses `SymbolsTotal(false)` and `SymbolName(i,false)`, which means full server universe, not Market Watch only.

### `SymbolName(int pos, bool selected)`
Enumerate universe symbols.

### `SymbolSelect(symbol, true/false)`
Use only when a deliberate Market Watch selection policy exists.
Do not casually mutate user Market Watch state unless architecture explicitly requires it.

## Market-info APIs

### `SymbolInfoTick(symbol, tick)`
Best single-call access for current last-tick snapshot.
Use for bid/ask/last/time/volume bundle and live tick evidence.

### `SymbolInfoInteger`
Use for:
- booleans, enums, datetime/integer properties
- trade mode
- session counters
- visible/select state
- spread_float and many symbol flags

### `SymbolInfoDouble`
Use for:
- point
- tick size
- tick value
- contract size
- bid/ask/high/low where appropriate
- margin values
- volume constraints

### `SymbolInfoString`
Use for:
- description
- path
- currencies
- exchange
- sector/industry string-like metadata

### `SymbolInfoSessionTrade`
Use for:
- session begin/end times by day of week
- computing within-session and next-open windows

### `SymbolInfoSessionQuote`
Useful if you later distinguish quote sessions from trade sessions explicitly.

## Timeseries/history APIs

### `CopyRates`
Use for OHLC/timeframe history retrieval.
Centralize through history access services, not random calls from everywhere.

### `CopySeries`
Useful if synchronized retrieval of multiple series arrays is desired.

### `CopyBuffer`
Use to retrieve values from indicator handles.
Create indicator handles centrally; do not recreate every cycle.

### `CopyTicks`
Use for recent tick history / tick buffers.
Important for selected-set deep analysis only.

### `CopyTicksRange`
Useful when exact time-window extraction matters.

## Indicator APIs

### Built-in handles
Examples:
- `iATR`
- `iMA`
- `iRSI`
- `iMACD`

Create handles once when practical, store them, and copy data via `CopyBuffer()`.

### `BarsCalculated(handle)`
Use before trusting indicator buffers.

### `IndicatorRelease(handle)`
Release handles when no longer needed.

## File APIs

### `FolderCreate(relative_path, FILE_COMMON)`
Create directories in shared common files area.

### `FileOpen(path, flags | FILE_COMMON)`
Open shared files under common storage root.

### `FileWriteString`
Write text payloads.

### `FileReadString`
Read text payloads.

### `FileIsExist`
Check file existence.

### `FileDelete`
Delete or clear old helper files when safe.

### `FileMove`
Use for temp-to-final promotion and last-good preservation.

### `FileFlush`
Optional when streaming, though ASC generally prefers whole-payload write then close.

## Recommended API-to-domain mapping

### Runtime
- `OnInit`
- `OnTimer`
- `OnDeinit`
- `EventSetTimer`
- `EventKillTimer`
- `TimeTradeServer`
- `TimeCurrent`

### Discovery
- `SymbolsTotal`
- `SymbolName`
- `SymbolInfoInteger/Double/String`
- `SymbolInfoTick`
- `SymbolInfoSessionTrade`

### Deep analysis
- `CopyRates`
- `CopyBuffer`
- `CopyTicks`

### Persistence
- `FolderCreate`
- `FileOpen`
- `FileWriteString`
- `FileReadString`
- `FileMove`
- `FileDelete`
- `FileIsExist`

## Codegen rules around APIs

- prefer `SymbolInfoTick()` over piecemeal last-tick pulls for live tick snapshots
- treat missing symbol properties as unsupported/unknown, not as zero
- centralize history access
- keep file writes atomic
- use `FILE_COMMON` for broker/server shared storage roots
