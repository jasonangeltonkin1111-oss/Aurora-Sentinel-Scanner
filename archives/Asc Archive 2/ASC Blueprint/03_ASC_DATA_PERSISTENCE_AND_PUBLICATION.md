# 03 ASC Data Persistence and Publication

## 1. Persistence philosophy

ASC persistence exists to preserve useful truth and continue rolling work safely.
It does not exist to:

- archive everything forever
- create giant monolithic blobs
- masquerade stale continuity as fresh truth
- erase prior good state because one read failed
- let partial current results destroy stronger older truth silently

## 2. Persistence classes

### 2.1 Universe continuity
Applies to all symbols.
Stores:
- identity
- lifecycle
- market truth
- broker snapshot
- recheck timing
- surface freshness metadata
- continuity origin
- publish eligibility markers

### 2.2 Deep continuity
Applies to promoted or previously promoted symbols.
Stores:
- tick window state
- OHLC rings
- ATR families
- indicator families
- regime/environment
- deep freshness
- last good deep refresh
- frozen reason when demoted

### 2.3 Runtime continuity
Stores:
- scheduler state
- mode state
- service last-run times
- cursors
- budget and coverage debt
- publish headline
- warmup completeness markers

## 3. Canonical file model

### 3.1 Published root files
- `UNIVERSE_DUMP.txt`
- `SUMMARY_TOP5_BY_BUCKET.txt`
- `RUNTIME_STATE.txt`
- `ASC_LOG_*.txt`

### 3.2 Published symbol files
- `SYMBOLS/<symbol>.txt`

### 3.3 Internal helper files
Allowed where useful:
- temp stage files
- backups
- write journal
- service journal
- compact deep fragments
- lock/guard files

Internal helpers never replace canonical published files.

## 4. Canonical naming and structure

### 4.1 One-symbol-one-file law
Each symbol owns one canonical symbol file.
This file may contain multiple blocks, but it remains one canonical document.

### 4.2 Why this law exists
- simple recoverability
- easier atomic replacement
- natural fit for symbol-specific truth and fallback
- aligns with old continuity lessons
- avoids giant monolithic symbol-state blobs

## 5. Symbol file contract

Suggested block order:
1. identity
2. lifecycle and continuity
3. market truth
4. broker snapshot
5. surface
6. promotion
7. deep
8. freshness
9. publication
10. pending/degraded reasons

### 5.1 Pending-safe rule
A symbol file may exist while some domains are pending, as long as pending state is explicit.

### 5.2 Stronger-truth rule
A current weak domain may not erase older stronger truth unless the downgrade is explicit.
Examples:
- failed quote read must not erase prior valid specs
- temporary history outage must not erase prior OHLC rings
- failed deep refresh must not destroy last good deep block

### 5.3 Frozen deep rule
If a symbol is demoted, the deep block is retained as frozen context until retention policy says otherwise.

## 6. Universe dump contract

The universe dump is the broad truth baseline.
For each symbol it should include:
- identity
- lifecycle
- market truth headline
- broker snapshot essentials
- surface score if available
- promotion status
- continuity origin
- freshness ages
- pending/degraded reasons
- next recheck

The universe dump contains all known symbols, not just leaders.

## 7. Summary contract

The summary is the trader/operator shortlist surface.
It must include:
- scanner mode and freshness headline
- last summary commit time
- top leaders per bucket
- bucket counts and quality floor notes
- score family highlights
- penalties/caveats per leader
- pointer to symbol files
- deep freshness age for promoted leaders

The summary routes attention. It does not replace symbol files.

## 8. Runtime state contract

The runtime state file is the read-model source for HUD/menu.
It should include:
- mode
- last kernel heartbeat
- last successful runs per service family
- current cursors
- budget and coverage debt
- degraded status
- warmup completeness markers
- publish headline
- pending clusters

## 9. Logging contract

### 9.1 Log must answer
- did the function run?
- what did it try to do?
- which symbols were touched?
- what outcome occurred?
- what got deferred and why?
- what got published?
- what failed and why?

### 9.2 Log event classes
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
- budget/coverage
- degraded event

### 9.3 Minimum event shape
- timestamp
- cycle number
- service family
- symbol if applicable
- outcome
- reason code
- budget context where relevant

## 10. Rolling data stores

### 10.1 Tick window
Policy:
- keep last hour only
- update every 10 seconds when due
- compact representation
- promoted symbols by default
- near-promoted candidates only if budget allows

### 10.2 OHLC windows
Each timeframe owns its own bounded ring.
Rules:
- append only when new bar closes
- do not rewrite unchanged bars
- drop oldest when capacity is reached
- commit atomically to the symbol domain

### 10.3 ATR and indicator families
Refresh only when the underlying timeframe domain updates.
No relevant new bar means no recalculation.

## 11. Freshness model

### 11.1 Separate clocks
Track freshness separately for:
- market truth
- broker snapshot
- surface
- tick window
- M1 OHLC
- M5 OHLC
- M15 OHLC
- H1 OHLC
- H4 OHLC
- D1 OHLC
- ATR families
- indicator families
- regime
- symbol publication
- summary publication
- runtime state
- HUD snapshot

### 11.2 Stale meaning
Stale means:
- still useful as retained context
- not acceptable as fresh current truth without downgrade

### 11.3 Freeze vs downgrade vs discard
- **Freeze** when older truth is still useful but no longer current promoted truth
- **Downgrade** when a domain remains readable but too old for fresh use
- **Discard** only when corruption or incompatibility makes the domain unsafe to trust at all

## 12. Schema versioning and compatibility

### 12.1 Every canonical file must carry
- schema version
- writer version or build id
- creation/update timestamps
- continuity origin

### 12.2 Restore compatibility checks
Validate:
- schema version
- file readability
- required block presence
- identity compatibility
- broker fingerprint compatibility where needed
- freshness limits

### 12.3 Migration policy
When schema changes:
- preserve old last-good files until migration succeeds
- migrate block-by-block where feasible
- do not silently reinterpret incompatible fields
- record migration outcome visibly

## 13. Atomic commit classes

### 13.1 Class A strict canonical
Use full atomic commit for:
- symbol files
- universe dump
- summary
- runtime state

### 13.2 Class B bounded append/roll
Use bounded roll-safe semantics for:
- logs
- event rings
- telemetry traces

## 14. Canonical atomic commit flow

1. build payload in memory
2. validate structure and required fields
3. write temp file
4. flush temp file
5. close temp file
6. optionally re-read staged content
7. preserve prior good file when policy requires
8. promote temp to final atomically
9. stamp commit success
10. clean temp safely

No canonical file may appear half-written.

## 15. Write journal and crash recovery

For Class A writes, a small journal should record:
- file target
- temp target
- intended commit sequence
- commit start time
- commit finish outcome

If a crash occurs mid-commit, startup uses the journal to:
- detect incomplete transactions
- ignore orphan temps when safe
- restore last-good final file
- log the event honestly

## 16. Write gating

### 16.1 May always be written
- logs
- runtime state
- pending symbol files
- degraded state files
- internal journals

### 16.2 Require validation
- summary
- publish-ready symbol files
- universe dump
- promoted deep blocks

### 16.3 Never overwrite with weaker truth unless explicit
A fresh partial result must not overwrite an older stronger result unless the downgrade is intentional, marked, and safer than pretending freshness.

## 17. Publication order

### 17.1 Canonical order
1. runtime state as needed
2. symbol files
3. universe dump
4. summary last

### 17.2 Why summary is last
The summary must only point to already-committed symbol files.
This translates the old dossier-first / summary-last lesson into ASC.

## 18. Last-good preservation

### 18.1 Promotion refresh fails
- preserve prior good deep state
- mark current deep refresh failed/deferred

### 18.2 Summary commit fails
- preserve prior good summary
- do not publish half-new partial summary

### 18.3 Universe dump fails
- keep prior good dump
- log the failed attempt

## 19. Corruption handling

### 19.1 Corrupt file policy
If a file is corrupt:
- do not pretend restore success
- fall back to backup or clean rebuild of that domain
- record the reason visibly
- preserve safety over convenience

### 19.2 Backup policy
Keep bounded last-good backups for Class A files where useful.
At minimum, recent previous versions of symbol files, universe dump, and summary should be available during instability.

## 20. Cleanup and retention

### 20.1 May be cleaned
- stale temp files
- superseded backups beyond retention count
- obsolete symbol files only when the symbol has truly left the broker universe and retention permits removal

### 20.2 Must not be casually auto-deleted
- last good promoted symbol files
- frozen retained deep state still within retention
- recent summary backups during instability
- evidence needed for recent failure analysis

## 21. Failure points and countermeasures

### 21.1 File churn too high
Countermeasure:
- delta-first writes
- domain due checks
- bar-boundary updates only for OHLC families

### 21.2 Tick store too expensive
Countermeasure:
- promote-first persistence
- bounded one-hour window
- compact representation

### 21.3 Summary freshness lies
Countermeasure:
- include summary freshness and leader freshness ages
- never hide degraded domains

### 21.4 Pending forever
Countermeasure:
- pending records must carry reason, retry, and eventual expiry/escalation path
