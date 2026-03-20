# ASC Persistence and Atomic Write

## Persistence philosophy

ASC persistence exists to:
- preserve useful truth
- continue rolling work after restart
- avoid destructive rewrites
- distinguish fresh from stale continuity
- protect against partial-write corruption

It does not exist to:
- archive everything forever
- rewrite all files every cycle
- let weak current truth erase strong prior truth silently

## Persistence classes

### 1. Runtime continuity
Stores:
- runtime mode
- boot/recovery markers
- last heartbeat
- last service runs
- degrade flags
- warmup completion markers

### 2. Scheduler continuity
Stores:
- per-symbol next check
- task family next due
- pending/debt markers
- shortlist membership
- lightweight cursors

### 3. Symbol continuity
Stores:
- identity
- market state
- snapshot domains
- filter state
- promotion state
- deep blocks
- freshness
- write/publication state

### 4. Optional helper continuity
- temp stage files
- backups
- journals
- last-good files
- compatibility migration notes

## Restore-first process

On startup:

1. resolve storage root
2. verify/create folders
3. read runtime continuity if present
4. read scheduler continuity if present
5. discover symbol universe
6. reconcile restored symbol files with current universe
7. keep valid prior truth
8. mark stale or incompatible truth honestly
9. fill only what is missing or due

## Stronger-truth preservation

A weaker current observation must not casually destroy stronger earlier truth.

Examples:
- yesterday’s valid symbol identity should not vanish because one current read failed
- last known deep block may remain frozen rather than being blanked
- old good dossier can remain the last-good fallback while a new temp write is being validated

## Atomic write law

For any canonical file:
1. build payload separately
2. write temp file
3. validate temp write if possible
4. promote safely to final target
5. optionally preserve previous final as `.last-good`

Forbidden:
- writing directly into the final file progressively
- truncating the final file before temp succeeds
- silently leaving only a partial file

## Practical MT5-safe pattern

### Files
- `<name>.tmp`
- `<name>.last-good`
- `<name>.txt`

### Promotion flow
- write temp
- if final exists, move it to last-good
- move temp to final with rewrite flag
- if promotion fails, keep last-good intact and log error

## Dossier write coalescing

Do not rewrite a symbol file for every tiny in-memory change.
Instead:
- mark dossier dirty
- coalesce multiple changes
- publish on due cadence or important transitions

## Runtime and scheduler save cadence

The foundation code saves every heartbeat, but the long-term architecture should move toward:
- immediate save on critical transitions
- periodic save for continuity
- bounded save frequency to avoid excessive file churn

## Schema compatibility

All persisted files should include:
- schema version
- format family
- generated-at timestamp
- source/runtime mode
- validity or compatibility notes when relevant

Without versioning, restore logic becomes brittle.

## File/folder layout

Newest foundation law:

```text
AuroraSentinel/
  <Clean Server Name>/
    Symbol Universe/
    Dev/
    <Clean Server Name> Runtime State.txt
    <Clean Server Name> Scheduler State.txt
    <Clean Server Name> Summary Top 5 per Basket.txt
```

Rules:
- exactly one folder per server
- exactly two subfolders at that level: `Symbol Universe` and `Dev`
- avoid deep nested micro-folder sprawl

## Safe downgrade behavior

If current output is weak:
- mark stale
- mark pending
- mark degraded
- preserve last good where appropriate

Do not downgrade by silent deletion.

## Common persistence anti-patterns

- blind wipe on init
- direct writes to final path
- no schema version
- no last-good protection
- no restore validation
- using summary as the only stored truth
- collapsing stale and current into one unlabeled state
