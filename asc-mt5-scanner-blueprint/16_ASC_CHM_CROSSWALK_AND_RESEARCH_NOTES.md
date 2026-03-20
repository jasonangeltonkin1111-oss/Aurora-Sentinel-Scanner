# ASC CHM Crosswalk and Research Notes

## What was available in the zip

The uploaded archive included these compiled help manuals:

- `mql5.chm`
- `mql5book.chm`
- `neuronetworksbook.chm`

## Environment limitation

This environment cannot directly unpack CHM files, so the practical method was:

1. inspect the archive and active blueprint directly
2. inspect the current MT5 foundation code
3. cross-map the required MQL5 topics to the official online reference
4. infer which CHM families matter for ASC

## Relevant CHM knowledge families for ASC

### `mql5.chm`
Most relevant for:
- event model
- timers
- symbol information APIs
- session APIs
- timeseries access
- file APIs
- runtime behavior
- structures/enums

### `mql5book.chm`
Most relevant for:
- practical MQL5 programming idioms
- program structure
- event handling patterns
- file/state handling examples
- robustness and style concepts

### `neuronetworksbook.chm`
Not central for current ASC foundation.
It is mostly out of scope unless ASC later adds ML research modules, which the blueprint does not currently authorize.

## Deep practical crosswalk for ASC

### Event runtime topics
A normal coding model needs:
- `OnInit`
- `OnTimer`
- `OnDeinit`
- `EventSetTimer`
- event queue behavior
- re-entry and bounded handler thinking

### Market/symbol topics
A normal coding model needs:
- `SymbolsTotal`
- `SymbolName`
- `SymbolInfoTick`
- `SymbolInfoInteger/Double/String`
- `SymbolInfoSessionTrade`
- trade mode and symbol permission properties

### History topics
A normal coding model needs:
- `CopyRates`
- `CopyBuffer`
- `CopyTicks`
- indicator handles
- timeframe boundaries
- bars/indicator readiness

### File/persistence topics
A normal coding model needs:
- `FILE_COMMON`
- `FolderCreate`
- `FileOpen`
- `FileWriteString`
- `FileReadString`
- `FileMove`
- `FileDelete`
- whole-payload write patterns

## CHM-informed guidance likely to matter most

1. MT5 is event-driven and serialized, but that does not remove the need for scheduler discipline.
2. `SymbolInfoTick()` is the cleanest current-tick snapshot API for live evidence.
3. session-time APIs return times as seconds-from-midnight style values and require careful interpretation.
4. common-file paths are the correct shared terminal storage location for broker/server-scoped continuity.
5. history and indicator access should be centralized, bounded, and not called blindly from UI/writer code.

## Why this note exists

Without it, a later GPT might wrongly assume the CHM manuals were parsed directly and rely on details that were never actually read from them in this environment.
This pack instead uses:
- direct archive evidence
- current foundation code
- official online MQL5 reference alignment
