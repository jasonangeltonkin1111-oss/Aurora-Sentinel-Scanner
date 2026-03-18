# MARKET WAVE 1 HANDOFF

## Files Changed
- `mt5/ASC_Market.mqh`
- `office/HANDOFF_MARKET_WAVE1.md`

## Archive Use Note
- Used `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` as the translation source for server-aware canonical symbol mapping, alias/suffix normalization, and upstream `AssetClass` / `PrimaryBucket` truth.
- Used legacy session-loading patterns from archived market-core references to preserve quote/trade session separation and broker-symbol-specific recheck timing without importing legacy execution or ranking scope.

## What Was Implemented
- Raw broker symbol discovery through `ASC_Market_DiscoverSymbols`.
- Canonical identity resolution and unresolved-state preservation through `ASC_Market_BuildIdentityAndTruth`.
- Population of `CanonicalSymbol`, `AssetClass`, `PrimaryBucket`, `Sector`, `Industry`, `Theme`, `ClassificationResolved`, and `ClassificationReason`.
- Layer 1 truth population for existence, selection, visibility, quote/trade windows, trade permission, session status, eligibility, last quote time, recheck timing, and explicit ineligible reason.

## Session Truth Handling
- Quote and trade sessions are read separately from broker session APIs.
- Session truth distinguishes `OPEN_TRADABLE`, `CLOSED_SESSION`, `QUOTE_ONLY`, `TRADE_DISABLED`, `NO_QUOTE`, `STALE_FEED`, and `UNKNOWN`.
- Recheck timing is symbol-specific and uses deterministic jitter, with next-open preference for closed sessions.

## Classification Handling
- Classification resolves by server-aware archive-map matching first.
- Known broker suffixes and punctuation are normalized using translated archive logic.
- If no trusted map match exists, classification stays unresolved explicitly and `PrimaryBucket` is set to `UNKNOWN`.

## What Was Intentionally Not Implemented
- No ranking, promotion scoring, ATR, spread scoring, or output formatting.
- No storage, persistence, dossier, or writer logic.
- No archive imports beyond translated identity/session-reference logic.

## Risks / Dependencies
- The repository currently does not include the shared ASC type definitions, so this implementation assumes the shared `ASC_RuntimeConfig` and `ASC_SymbolRecord` contracts will supply the fields named in the task packet.
- If shared config later exposes freshness/recheck constants, this file should consume those values instead of relying on bounded internal defaults.
