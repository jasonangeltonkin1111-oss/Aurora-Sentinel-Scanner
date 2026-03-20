# ASC Market State Truth Model

## Purpose

Market State Detection is the only active foundation capability today.
It must answer “is this symbol open enough now?” without faking certainty.

This is not trivial because:
- broker session metadata can exist while feed is stale
- a symbol can have old last-tick data while currently closed
- some brokers expose weak or partial session structures
- some symbols are quote-visible but not truly tradable
- fresh tick evidence is powerful but not universal

## Final truth model

The deepest archive doctrine and the active blueprint together imply a **multi-evidence market-state model**.

## Evidence families

### Evidence A — live tick evidence
Use `SymbolInfoTick()` and last tick time to detect whether recent market activity exists.

Strength:
- strongest evidence of current liveness

Weakness:
- absence of fresh tick is not always definitive proof of closure

### Evidence B — live quote usability
Use bid/ask and related live values only when structurally valid.

Strength:
- can confirm useful current surface

Weakness:
- quote presence alone can be misleading

### Evidence C — trade session reference
Use `SymbolInfoSessionTrade()` to know the broker-declared session windows and next expected open timing.

Strength:
- best for scheduling future checks

Weakness:
- should not dominate fresh real-time evidence when the two conflict

### Evidence D — trade mode / symbol permissions
Useful for detecting disabled or read-only market modes.

### Evidence E — continuity context
Previous known status, last good checks, and next scheduled open can support truthful degraded decisions.

## Recommended market-state outcomes

Do not reduce everything to only open/closed internally.
Use richer outcomes and map them to human labels later.

Suggested internal outcomes:
- `OPEN_CONFIRMED`
- `OPEN_WEAK`
- `CLOSED_SESSION`
- `CLOSED_NO_FEED`
- `QUOTE_ONLY`
- `TRADE_DISABLED`
- `STALE_FEED`
- `UNKNOWN`
- `UNSUPPORTED`
- `UNCERTAIN`

Public dossier wording can stay simpler:
- Open
- Closed
- Uncertain
- Unknown

## Decision policy

### Strong open
If:
- fresh tick exists within threshold
- quote data is structurally usable

Then:
- status = open confirmed
- schedule next check soon but not every second forever

### Weak open / uncertain
If:
- session window says currently open
- but tick freshness is weak or absent

Then:
- status = uncertain or weak open
- schedule faster retry
- do not automatically promote downstream as fully healthy

### Closed by schedule
If:
- current time is outside declared trade session
- next session open can be computed

Then:
- status = closed session
- schedule next check near future open window rather than constantly

### Stale feed
If:
- session may be open
- but last tick age is beyond freshness threshold
- and quotes are weak/missing

Then:
- status = stale feed or uncertain
- preserve forensic note
- retry according to policy

### Unknown
If:
- session data unavailable
- tick evidence unavailable
- quote usability unavailable

Then:
- status = unknown
- preserve reason code
- do not invent closure or openness

## Session scheduling model

A closed symbol should not be polled every second indefinitely.

Recommended behavior:
- compute next expected open from session tables if available
- schedule sparse checks while clearly closed
- inside the final minute before expected open, allow 1-second aggressive rechecks
- after reopen confirmation, return to ordinary cadence

## Tick freshness thresholds

Thresholds should be configuration values, not magic constants.
Examples:
- `fresh_tick_seconds_open_confirm`
- `stale_tick_seconds`
- `uncertain_burst_limit`
- `near_open_window_seconds`

## Output fields for minimum market-state dossier block

- `Current Status`
- `Status Note`
- `Evidence Confidence`
- `Has Tick`
- `Last Tick Seen`
- `Tick Age Seconds`
- `Quotes Usable`
- `Trade Sessions Available`
- `Within Trade Session`
- `Next Session Open`
- `Next Recheck`
- `Reason Code`

## Ownership boundary

Market State Detection owns:
- universe-linked per-symbol market-state truth
- tick presence and freshness
- session-aware recheck timing
- honest uncertain/unknown/degraded outcomes
- dossier-ready state for publication

It does not own:
- Open Symbol Snapshot
- Candidate Filtering
- Shortlist Selection
- Deep Selective Analysis
- execution readiness or strategy logic

## Important anti-patterns

Do not:
- declare closed only because bid/ask are zero once
- declare open only because session says so
- treat old last-tick time as current liveness
- hammer closed symbols every second forever
- destroy stronger earlier truth with weaker current evidence unless downgrade is explicit
