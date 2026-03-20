# ASC Field Cadence and Refresh Policy

## Purpose

Not all fields should refresh at the same speed.
ASC must support selective cadence by:
- layer
- field family
- timeframe
- symbol state

## Cadence classes

### Reboot-only
Used for fields that are effectively static at startup.

Examples:
- symbol specs
- file scaffold and placeholders
- stable broker metadata

### Slow refresh
Used for semi-static fields that may change but should not be hammered.

Examples:
- selected broker-spec rechecks
- session structure refresh if justified

### Scheduled 10-second
Used for frequently changing but bounded-refresh fields.

Examples:
- Layer 2 Market Watch snapshot writes
- Layer 3 filter reevaluation
- ATR refreshes where current design targets 10 seconds

### Near-open aggressive 1-second
Used only around expected session-open windows.

Examples:
- Layer 1 open-state rechecks for a symbol expected to reopen soon

### Timeframe-boundary
Used for timeframe-owned OHLC and close-dependent calculations.

Examples:
- M5 close rollover every 5 minutes
- H1 close rollover every 1 hour

### Continuous memory
Used for data that must stay live in memory but not hit disk every event.

Examples:
- selected-symbol tick buffer for the last minute

### Scheduled flush
Used for persistence writes from an in-memory rolling structure.

Examples:
- tick-buffer flush to disk
- selected deep-analysis publication flush

## Cadence law

A field family must be assigned to the cheapest truthful cadence that preserves usefulness.
Faster is not automatically better.

## Examples

### Symbol specs
- reboot-only by default
- slow refresh only when justified

### Market Watch live fields
- scheduled 10-second write target for publication
- in-memory refresh may be more frequent if runtime needs it

### Open/closed checks
- due-based
- slower while clearly closed
- faster near expected reopen window

### OHLC
- forming bar may refresh more frequently
- official bar completion must obey timeframe boundary

### ATR and indicators
- owned by Layer 5
- selective by timeframe
- never universal just because one selected symbol needs an update

## Write minimization law

If a field group did not change materially and does not require a new commit, ASC should skip unnecessary rewrites.

## Publication law

Cadence rules apply to state refresh and file publication separately.
Something may refresh in memory more often than it is written to disk.
