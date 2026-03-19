# L1.2 CONDITIONS ECONOMICS RECOVERY HANDOFF

## Purpose
This handoff is the bounded recovery reference for finishing the current Layer 1.2 Conditions economics contract without reopening legacy schema sprawl.

It translates what the live `mt5/ASC_Conditions.mqh` already reads, what AFS still has that ASC has not fully carried over, and what the smallest safe next packet should include.

---

## 1. Current `ASC_Conditions.mqh` reads that are purely raw broker reads
The current file already performs a broad MT5 broker-spec sweep, but most fields are still simple broker evidence reads rather than validated truth.

### Integer/raw mode reads
These are read directly through `SymbolInfoInteger(...)` and copied into `ASC_ConditionsTruth` with readability flags:
- `SYMBOL_DIGITS`
- `SYMBOL_SPREAD`
- `SYMBOL_SPREAD_FLOAT`
- `SYMBOL_TRADE_STOPS_LEVEL`
- `SYMBOL_TRADE_FREEZE_LEVEL`
- `SYMBOL_TRADE_CALC_MODE`
- `SYMBOL_CHART_MODE`
- `SYMBOL_TRADE_MODE`
- `SYMBOL_TRADE_EXEMODE`
- `SYMBOL_ORDER_GTC_MODE`
- `SYMBOL_FILLING_MODE`
- `SYMBOL_EXPIRATION_MODE`
- `SYMBOL_ORDER_MODE`
- `SYMBOL_SWAP_MODE`

### Double/raw broker reads
These are read directly through `SymbolInfoDouble(...)` and copied into `ASC_ConditionsTruth` before any higher-level trust decision:
- `SYMBOL_POINT`
- `SYMBOL_TRADE_TICK_SIZE`
- `SYMBOL_TRADE_TICK_VALUE`
- `SYMBOL_TRADE_TICK_VALUE_PROFIT`
- `SYMBOL_TRADE_TICK_VALUE_LOSS`
- `SYMBOL_TRADE_CONTRACT_SIZE`
- `SYMBOL_VOLUME_MIN`
- `SYMBOL_VOLUME_MAX`
- `SYMBOL_VOLUME_STEP`
- `SYMBOL_VOLUME_LIMIT`
- `SYMBOL_SWAP_LONG`
- `SYMBOL_SWAP_SHORT`
- `SYMBOL_SWAP_SUNDAY`
- `SYMBOL_SWAP_MONDAY`
- `SYMBOL_SWAP_TUESDAY`
- `SYMBOL_SWAP_WEDNESDAY`
- `SYMBOL_SWAP_THURSDAY`
- `SYMBOL_SWAP_FRIDAY`
- `SYMBOL_SWAP_SATURDAY`
- `SYMBOL_MARGIN_INITIAL`
- `SYMBOL_MARGIN_MAINTENANCE`
- `SYMBOL_MARGIN_HEDGED`

### String/raw broker reads
These are read directly through `SymbolInfoString(...)`:
- `SYMBOL_CURRENCY_MARGIN`
- `SYMBOL_CURRENCY_PROFIT`
- `SYMBOL_CURRENCY_BASE`

### Raw broker API reads that are not `SymbolInfo*`, but still remain raw broker evidence
These are still broker-supplied reads rather than validated economics outputs:
- `SymbolInfoMarginRate(..., ORDER_TYPE_BUY, ...)`
- `SymbolInfoMarginRate(..., ORDER_TYPE_SELL, ...)`
- `SymbolInfoTick(...)` when preparing tick-value validation inputs

### Important distinction
In the current implementation, almost everything above remains raw broker evidence even when it feeds later trust grading. The main exceptions are:
- `TickValueDerived`, which is a local derivation from profit/loss tick values.
- `TickValueValidated`, which is empirically estimated through `OrderCalcProfit(...)`.
- `SpecIntegrityStatus`, `EconomicsTrust`, `TruthCoverageStatus`, and mismatch flags, which are interpretation layers built on top of the raw broker reads.

---

## 2. AFS validations and semantics still missing or only partially carried into ASC
AFS already had a tighter economics contract than the current ASC Layer 1.2 implementation. The missing pieces below are the ones that matter for bounded recovery.

### A. `OrderCalcProfit` tick-value validation is present, but still too thin
Current ASC already calls `OrderCalcProfit(...)`, but the validation is still shallow compared with the contract implied by the legacy recovery notes:
- it validates only a single-tick move using `VolumeMin`
- it accepts the first successful BUY or SELL path
- it does not preserve richer evidence about which scenario succeeded
- it does not expose validation assumptions as a first-class sub-contract
- it does not separate “validation unavailable” from “validation disagrees but raw/derived remain usable” with enough detail for later hardening

So the gap is not “no validation exists”; the gap is that the validation contract is still too coarse and under-explained.

### B. Raw / derived / validated split is only partially frozen
ASC now stores:
- `TickValueRaw`
- `TickValueDerived`
- `TickValueValidated`

But the surrounding contract is still incomplete versus AFS expectations:
- only tick-value fields are explicitly split this way
- disagreement evidence is collapsed into one flat `EconomicsMismatchFlags` string
- there is no bounded semantics note saying which field is broker evidence, which is local derivation, and which is empirical validation truth
- there is no small structured “economics provenance” sub-contract to keep later packets from drifting field meaning

### C. Commission metadata is still missing from current ASC Conditions truth
AFS carried optional commission context:
- commission value
- commission mode/type
- commission currency
- commission readability/status

Current ASC Conditions truth does not read or store any commission metadata. That means Layer 1.2 still cannot distinguish:
- no commission exposed by broker
- broker/build does not support the commission property
- commission exists but was unreadable
- commission is visible and should be preserved as cost context only

### D. Carry-forward semantics exist, but the bounded contract is still under-specified
Current ASC already preserves stronger prior economics in `ShouldPreservePrior(...)`, and marks preserved results with `EconomicsPreservedFromPrior` plus `CARRY_FORWARD`.

What is still missing is the narrower AFS-style contract language for when carry-forward is allowed:
- same-symbol only
- preserve only when prior truth is stronger and still internally acceptable
- never fabricate a fresh pass from stale broker silence
- never let carry-forward silently overwrite new contradictory evidence without exposing why
- keep carry-forward as continuity protection, not as a hidden replacement for current reads

The code is directionally there; the recoverable office contract is not yet explicit enough.

---

## 3. Minimal bounded subset that should be ported into current Layer 1.2
The next Conditions recovery packet should stay intentionally small. The goal is to harden economics provenance, not to import the full AFS record layout.

### Port now: bounded additions that fit current ASC shape
1. **Freeze a tiny economics provenance contract inside Layer 1.2 Conditions.**
   - Keep existing ASC fields.
   - Explicitly define broker raw, local derived, and empirical validated roles in code comments / handoff / shared contract wording.
   - Do not add a giant legacy sub-struct.

2. **Tighten tick-value validation semantics without widening scope.**
   - Preserve current `OrderCalcProfit(...)` validation path.
   - Add bounded result reasoning for BUY/SELL success, validation absence, or disagreement.
   - Keep it limited to tick-value economics only.

3. **Add optional commission metadata only as passive context.**
   - Add minimal fields for commission value, commission mode, commission currency, and commission status/readability.
   - Do not add fee engines, ranking penalties, or execution-cost models.
   - Treat commission as observational metadata for Layer 1.2 dossier/storage truth.

4. **Freeze carry-forward decision law.**
   - Carry-forward remains same-symbol continuity only.
   - It preserves stronger prior economics when the incoming read is thinner.
   - It must always surface preservation via explicit flags/status.
   - It must not invent new tradability or ranking truth.

5. **Keep trust grading coarse.**
   - Retain the current bounded statuses rather than importing AFS practicality/ranking/deep friction interactions.
   - The packet should improve evidence quality, not widen downstream behavior.

### Explicitly do **not** port now
- legacy giant record/schema growth
- practicality scoring sprawl
- ranking or shortlist consequences
- execution-cost formulas
- commission engines or commission heuristics
- broader AFS market-core status taxonomies beyond what current ASC already uses
- later-layer diagnostics/UI/reporting expansion beyond the minimum snapshot/output fields required for continuity

---

## 4. READY NOW vs BLOCKED UNTIL SHARED CONTRACT UPDATE

### READY NOW
These items can be implemented in the next bounded Conditions packet without reopening architecture:
- document the current raw broker reads as broker evidence, not final truth
- tighten the meaning of `TickValueRaw`, `TickValueDerived`, and `TickValueValidated`
- add bounded validation-result reasoning around the existing `OrderCalcProfit(...)` path
- add minimal optional commission metadata fields/status in current Conditions/storage/output contracts
- codify the carry-forward decision law already implied by `ShouldPreservePrior(...)`
- keep all of this inside Layer 1.2 Conditions/storage/output scope only

### BLOCKED UNTIL SHARED CONTRACT UPDATE
These items should wait until HQ opens a shared-contract update because they affect multiple modules and semantic ownership boundaries:
- any rename or widening of `ASC_ConditionsTruth` semantics that changes existing storage/output schema expectations
- any new shared struct grouping for economics provenance beyond the minimal existing field pattern
- any trust-grade expansion that changes how Engine, Storage, Output, or later layers interpret economics states
- any attempt to let commission fields influence selection, ranking, or activation behavior
- any broader “economics package” that couples Conditions with future friction/history/selection logic
- any schema change that would pull in legacy AFS field sprawl just because the archive had it

---

## 5. Recommended implementation packet boundary
Use this handoff to issue a future Conditions worker packet with the following exact boundary:
- touch current shared contract only as much as needed to add minimal commission metadata and bounded validation/carry-forward semantics
- update current Layer 1.2 storage/output persistence only for those minimal additions
- do not reopen Market, Ranking, Activation Gate, Surface, UI, or execution logic
- keep archive usage limited to AFS economics provenance patterns, not full record translation

That is the smallest recovery slice that materially improves Layer 1.2 economics truth while avoiding legacy schema sprawl.
