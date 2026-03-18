# CONDITIONS WAVE 1 HANDOFF

## Files Changed
- `mt5/ASC_Conditions.mqh`
- `office/HANDOFF_CONDITIONS_WAVE1.md`

## What Was Implemented
- Implemented `ASC_Conditions_Load(const string symbol, ASC_SymbolRecord &record)`.
- Added broker spec intake for digits, spread, spread-float mode, point, tick size, tick value, contract size, and volume min/max/step.
- Added explicit initialization of `ASC_ConditionsTruth` before reading broker data.
- Added integrity checks that keep Conditions truth separate from Market classification truth.

## Spec Integrity Handling
- `SpecsReadable` is set true only when every required broker field is readable and passes basic non-guess integrity checks.
- Broker values are preserved exactly as read when the read succeeds.
- Read failures and integrity failures accumulate into `SpecsReason` instead of being hidden.
- The function returns the same truth as `record.ConditionsTruth.SpecsReadable`.

## Missing/Unreadable Field Handling
- Unreadable fields are kept explicit by leaving sentinel invalid values in the record initialization state.
- The loader does not invent fallback values for missing broker specs.
- `SpecsReason` lists which required fields were unreadable or invalid.
- Missing or invalid spec truth does not get converted into apparently valid `0.00` completeness.

## What Was Intentionally Not Implemented
- No ranking logic.
- No ATR or history retrieval.
- No output formatting.
- No file persistence.
- No classification logic.
- No downstream activation or promotion logic.

## Risks / Dependencies
- This file depends on the shared `ASC_Common.mqh` contract being provided exactly as locked by HQ.
- Full compile validation depends on the remaining flat MT5 product files being created in their locked locations.
- Some brokers may expose readable fields with zero-like values; those remain preserved but are treated as spec-integrity failures for `SpecsReadable`.
