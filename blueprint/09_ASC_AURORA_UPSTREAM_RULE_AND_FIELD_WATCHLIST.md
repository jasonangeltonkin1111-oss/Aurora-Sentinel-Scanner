# ASC Aurora Upstream Rule and Field Watchlist

## Purpose

This file makes one thing explicit:

ASC is the foundation.
Aurora aligns downstream to ASC.

ASC chooses the battlefield by defining, sensing, preserving, and publishing the market truth surfaces that exist.
Aurora executes downstream intelligence using that upstream truth.

Aurora may pressure ASC to grow.
Aurora may not reverse the direction of dependence.

## Upstream rule

### ASC
ASC is the upstream scanner foundation.
It owns:
- sensing
- scheduler truth
- market-status truth
- continuity truth
- dossier truth
- publication truth
- machine-readable state surfaces

### Aurora
Aurora is the downstream execution-side intelligence layer.
It consumes upstream truth, interprets opportunity and execution context, and evolves in alignment with ASC.

## Practical meaning

When ASC changes:
- Aurora should review what new truth became available
- Aurora should align to the new upstream surface

When Aurora changes:
- ASC should review what additional upstream fields or guarantees may be needed later
- those needs should be recorded on the ASC side as scanner-expansion pressure
- ASC should remain foundation-first and should not absorb execution logic

## Anti-reversal rule

Aurora does not define the battlefield.
ASC defines the battlefield.

Aurora may reveal missing upstream requirements.
ASC decides how those requirements become scanner-side fields, contracts, or publication surfaces.

## ASC field watchlist

This watchlist exists so ASC can see where Aurora is likely to keep applying pressure.
These are not all required immediately.
They are the current expansion watchlist for future ASC growth.

### 1. Market-status certainty and freshness
ASC should continue strengthening fields such as:
- current market status
- last tick seen
- tick age seconds
- next check due
- next session open
- freshness confidence / certainty markers later if needed

Why Aurora cares:
- execution-side intelligence must know whether truth is fresh, stale, uncertain, or degraded before trusting it

### 2. Session and timebox truth
ASC should continue expanding:
- session availability
- within-session truth
- upcoming session change timing
- session edge proximity
- timebox metadata later if needed

Why Aurora cares:
- timing, deployability, and execution geometry depend on session truth

### 3. Continuity and recovery truth
ASC should continue exposing:
- schema version
- generated-at / saved-at style metadata
- restore source / last-good recovery markers later if needed
- degraded state truth
- bounded-work pressure truth

Why Aurora cares:
- downstream consumers must know whether scanner state is steady, recovering, degraded, or partially repaired

### 4. Publication metadata
ASC should continue expanding machine-readable publication safety fields such as:
- format family
- schema version
- generated at
- heartbeat time
- dossier completeness markers later if needed
- missing section markers later if needed

Why Aurora cares:
- downstream consumers need stable contracts, not brittle text guessing

### 5. Symbol identity and classification pressure
ASC should later expand toward stronger symbol-side fields such as:
- cleaner identity metadata
- asset / market classification later
- venue / broker-specific traits later
- symbol normalisation guidance later if needed

Why Aurora cares:
- execution-side reasoning becomes stronger when symbol context is explicit and machine-safe

### 6. Snapshot truth pressure
ASC Layer 2 and later should eventually expose clean snapshot fields such as:
- bid / ask
- spread
- high / low
- open / close
- daily change
- stale / missing snapshot flags

Why Aurora cares:
- downstream opportunity logic needs stable current-state surfaces

### 7. History depth and timeframe controls
ASC Layer 5 and later should eventually expose controllable history surfaces such as:
- OHLC availability by timeframe
- bars retained per timeframe
- indicator update timing by timeframe
- history completeness markers later if needed

Why Aurora cares:
- downstream intelligence must know what timeframe truth exists and how deep that truth is

### 8. Friction and deployability pressure
ASC should later consider scanner-side truth surfaces around:
- spread condition
- execution-mode constraints
- stop / freeze constraints
- fill-mode constraints
- other broker-side deployability facts already available from specs

Why Aurora cares:
- Aurora execution reasoning needs upstream friction truth, but ASC should publish it as scanner truth rather than execution logic

## Rule for future workers

When Aurora reveals a missing need, ask:
- is this truly an upstream scanner field?
- if yes, note it here or in the active ASC bridge docs
- if not, keep it on the Aurora side

Do not let Aurora-side logic leak backward into ASC as execution clutter.

## Final rule

ASC remains the upstream foundation.
Aurora aligns downstream.
ASC should keep a visible watchlist of upstream field pressure so the scanner grows deliberately rather than reactively.
