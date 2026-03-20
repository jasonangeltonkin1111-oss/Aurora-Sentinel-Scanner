# ASC Acceptance Test Matrix

## Purpose

A GPT/Codex-generated rebuild is not acceptable just because it compiles.
It must prove runtime behavior.

## Stage A — Foundation shell

### Must prove
- EA initializes
- timer starts
- paths resolve
- common folders create successfully
- logger writes
- runtime state saves
- scheduler state saves
- summary scaffold saves
- dossier files appear

### Fail examples
- `OnTimer()` never fires
- paths are account-dependent
- files write outside `FILE_COMMON`
- no temp-to-final pattern


## Stage A.5 — Menu wiring and staged testability

### Must prove
- MT5 inputs are grouped cleanly
- active controls load into one settings surface
- reserved controls are marked Reserved or Pending
- init logs one concise settings summary

### Fail examples
- random loose inputs with no grouping
- future controls missing entirely
- pending controls pretending to be active
- noisy init logs that dump every placeholder every second

## Stage B — Restore continuity

### Must prove
- restart does not wipe files
- existing runtime state is read first
- scheduler continuity influences next checks
- last-good logic survives failed write

### Fail examples
- every restart behaves as zero state
- restore is ignored even when files exist
- malformed file causes blind deletion without logging

## Stage C — Market-state truth

### Must prove
- open symbols become open by fresh evidence
- closed symbols do not get hammered forever
- next session open is scheduled when possible
- uncertain state exists when evidence conflicts

### Fail examples
- everything becomes open if any quote exists
- everything becomes closed when no fresh tick
- no distinction between unknown and closed

## Stage D — Snapshot truth

### Must prove
- live snapshot fields refresh on due cadence
- static/semi-static specs are not hammered constantly
- missing values remain marked missing

### Fail examples
- getters recollect everything
- unsupported values become zeros
- layer ownership mixed

## Stage E — Filter and selection

### Must prove
- cheap gates happen before deep analysis
- bucket grouping remains stable
- fewer than 5 eligible symbols does not get padded
- selection changes mark deep membership dirty

### Fail examples
- ranking occurs before minimum truth exists
- selection implies trade signal
- summary pads empty leaders

## Stage F — Deep selective analysis

### Must prove
- only selected symbols receive heavy work
- `CopyRates`/`CopyTicks` calls are bounded
- indicator handles are reused, not recreated every cycle

### Fail examples
- full-universe ATR updates every heartbeat
- no bounded budget
- no demotion/freeze state

## Stage G — Publication

### Must prove
- dossiers evolve by owned sections
- summary is downstream
- writers do not compute analytics
- writes are coalesced and atomic

### Fail examples
- writer calls `CopyRates`
- summary created before dossiers
- partial files appear after failed writes

## Operational test scenarios

### 1. Empty first startup
Expect:
- folders created
- runtime scaffold
- symbol dossiers begin appearing
- no crash on missing prior state

### 2. Warm restart with intact files
Expect:
- recovery_used = true
- continuity preserved
- no full blind rebuild

### 3. Corrupt runtime state file
Expect:
- error logged
- best-effort fallback
- symbol dossiers and scheduler continuity survive if valid

### 4. Weekend / closed market
Expect:
- most symbols closed/uncertain as appropriate
- next open times planned
- no every-second hammering of all symbols forever

### 5. Live market open
Expect:
- open symbols refreshed more often
- fresh tick evidence drives open truth
- bounded number of symbols processed per heartbeat

### 6. Large broker universe
Expect:
- whole universe retained
- bounded work per cycle
- no catastrophic timer collapse

## Acceptance standard

The generated system must show:
- compile correctness
- runtime correctness
- continuity correctness
- publication correctness
- architecture correctness
