# 03 ASC Data Persistence and Publication

## 1. Persistence philosophy

ASC persistence exists to preserve useful truth and continue rolling work safely.

It does not exist to:
- archive everything forever
- create giant monolithic blobs
- masquerade stale continuity as live truth
- erase prior good state because one read failed

## 2. Persistence classes

### 2.1 Universe continuity
Applies to all symbols.

Stores:
- identity
- market truth
- broker snapshot
- lifecycle state
- recheck timing
- surface freshness metadata
- summary eligibility markers
- continuity origin

### 2.2 Deep continuity
Applies only to promoted or previously promoted symbols.

Stores:
- rolling OHLC windows
- bounded tick window
- ATR families
- indicator families
- regime/environment state
- deep freshness state
- last good deep refresh

### 2.3 Runtime continuity
Stores:
- kernel cursors
- scheduler state
- mode state
- service last-run times
- budget debt
- last publish state

## 3. File model

### 3.1 Canonical root files
- `UNIVERSE_DUMP`
- `SUMMARY_TOP5_BY_BUCKET`
- `RUNTIME_STATE`
- `ASC_LOG`

### 3.2 Symbol files
- `SYMBOLS/<symbol>`

### 3.3 Optional internal files
- temp stage files
- backup files
- lock/guard files
- runtime service journal
- deep ring-buffer fragments if needed

## 4. One-symbol-one-file law

Each symbol must have one canonical symbol file.

Reasons:
- simple recoverability
- easier atomic replacement
- no giant monolithic per-universe symbol truth blob
- aligns with old per-symbol continuity logic
- easier selective refresh and fallback

The symbol file may contain multiple logical sections, but it remains one canonical symbol document.

## 5. Symbol file structure

Suggested block order:

1. identity block
2. lifecycle / continuity block
3. market truth block
4. broker snapshot block
5. surface block
6. promotion block
7. deep block
8. freshness block
9. publication block
10. pending/degraded reasons block

### 5.1 Pending-safe rule
A symbol file may exist even when some domains are pending, as long as pending state is explicit.

This solves the need to:
- preserve all symbols
- retain partial truth
- avoid fake completeness

### 5.2 Summary-safe rule
The top-level summary may only include symbols whose surface result is current enough and whose symbol file has been safely committed.

## 6. Universe dump structure

The universe dump is the broad truth baseline.

It should include, per symbol:
- identity
- market truth
- broker snapshot essentials
- surface score if available
- promotion status
- continuity origin
- freshness ages
- pending reasons
- next recheck

It must contain all known symbols in the canonical universe, not only leaders.

## 7. Summary file structure

The summary is the trader/operator shortlist surface.

It should contain:
- scanner mode and freshness headline
- last summary commit time
- top 5 per bucket
- bucket counts
- symbol score breakdown headline
- caveats and penalties per leader
- pointers to symbol files
- quality floor notes when a bucket has fewer than five leaders

The summary is a routing surface, not a hidden analytics engine.

## 8. Rolling data stores

### 8.1 Tick window
Store only the last hour of tick-derived rolling state.

Suggested policy:
- refresh every 10 seconds
- bounded size
- compact representation
- primarily for promoted symbols
- optionally for near-promoted active candidates if budget allows

### 8.2 OHLC windows
Each timeframe maintains its own bounded ring.

Rules:
- append only when a new bar closes
- do not rewrite unchanged bars
- drop oldest when capacity is reached
- commit atomically for the symbol domain

### 8.3 ATR and indicators
Derived metrics refresh only when their underlying timeframe domain updates.

Do not recompute ATR/indicators when no new relevant bar exists.

## 9. Freshness and staleness

### 9.1 Separate freshness clocks
Track freshness separately for:
- market truth
- snapshot
- surface
- ticks
- M1 OHLC
- M5 OHLC
- M15 OHLC
- H1 OHLC
- H4 OHLC
- D1 OHLC
- ATR families
- indicator families
- regime
- publication
- HUD state

### 9.2 Stale meaning
Stale means:
- still useful as retained context
- not trustworthy as current truth without downgrade

### 9.3 Stale handling
- stale current domains are downgraded explicitly
- stale deep domains may remain frozen
- stale continuity may be discarded on restore if beyond policy windows
- stale does not imply deletion

## 10. Atomic commit classes

### 10.1 Class A strict canonical files
Use full atomic commit for:
- universe dump
- summary
- symbol files
- runtime state

### 10.2 Class B bounded append/roll files
Use bounded roll-safe semantics for:
- log files
- event ring files
- telemetry traces

## 11. Canonical atomic commit flow

1. build payload in memory
2. validate required structure
3. write temp file
4. flush temp file
5. close temp file
6. optionally re-read/verify staged content
7. preserve prior good file when policy requires
8. promote temp to final atomically
9. stamp commit success
10. clean temp safely

No canonical file may appear half-written.

## 12. Write gating

### 12.1 What may always be written
- logs
- runtime state
- pending symbol files
- degraded state files
- internal event journals

### 12.2 What may only be written after validation
- summary
- publish-ready symbol files
- universe dump if structural requirements fail

### 12.3 Never overwrite with weaker truth
A fresh partial result must not overwrite an older stronger result unless the downgrade is explicit and intentional.

Examples:
- a failed quote read cannot erase prior broker specs
- a temporary history outage cannot erase prior OHLC arrays
- a weak current pass cannot destroy last good deep block

## 13. Last-good preservation

### 13.1 Symbol demotion
If a symbol leaves the promoted set:
- stop active deep refresh
- retain the last good deep block as frozen context
- mark it non-current

### 13.2 Failed promotion refresh
If new deep refresh fails:
- preserve prior good deep state
- mark current deep refresh as failed/deferred

### 13.3 Summary routing
Summary must only point to symbol files already safely committed.

This preserves the old “dossiers first, summary last” lesson, translated into ASC symbol files.

## 14. Continuity compatibility checks

On restore, validate:
- schema version
- file readability
- required block presence
- identity compatibility
- broker fingerprint compatibility where needed
- content freshness
- optional hash compatibility for sensitive domains

Reject or downgrade cleanly when incompatible.

## 15. Corruption handling

### 15.1 Corrupt file policy
If a file is corrupt:
- do not pretend restore success
- move to reject/degraded path if policy allows
- fall back to backup or clean rebuild of that domain
- record the reason visibly

### 15.2 Backup policy
Keep bounded backups for Class A files where useful:
- previous symbol file
- previous summary
- previous universe dump

## 16. Cleanup policy

### 16.1 What may be cleaned
- stale temp files
- superseded backups beyond retention count
- obsolete symbol files only after strong proof the symbol truly left the broker universe and retention rules allow it

### 16.2 What may not be auto-deleted casually
- last good promoted symbol files
- frozen retained deep state
- summary backups during instability
- runtime evidence needed for debugging recent failures

## 17. Logging contract

### 17.1 The log must answer
- did the function run?
- what did it try to do?
- what symbols did it touch?
- what conclusion did it reach?
- what got deferred?
- what got published?
- what failed and why?

### 17.2 Log event classes
- startup
- restore
- compatibility
- market truth
- snapshot
- surface
- promotion
- deep refresh
- atomic commit
- cleanup
- mode transition
- budget event
- degraded event

### 17.3 Log shape
Each event should include:
- timestamp
- cycle number
- service name
- symbol if applicable
- outcome
- reason code
- budget/cadence context if relevant

## 18. Runtime state file contract

The runtime state file should include:
- mode
- last kernel heartbeat
- last successful Layer 1/1.2/2/3 runs
- current cursors
- backlog counts
- budget debt
- degraded status
- publish headline
- warmup completeness markers

It is the UI read-model foundation.

## 19. Failure points and countermeasures

### 19.1 File churn too high
Fix:
- delta-first writes
- per-domain due checks
- bar-boundary updates only for OHLC families

### 19.2 Large tick store cost
Fix:
- promote-only tick persistence by default
- bounded last-hour window
- compact representations

### 19.3 Universe dump too heavy
Fix:
- keep one broad file, but allow compact render shape
- separate internal runtime state from trader summary

### 19.4 Summary lies about freshness
Fix:
- include summary freshness and source freshness fields
- never hide downgraded domains

### 19.5 Pending forever
Fix:
- pending files must carry reason, retry, and expiry logic
