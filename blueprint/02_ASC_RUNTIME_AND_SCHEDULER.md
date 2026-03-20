# ASC Runtime and Scheduler

## Purpose

ASC must behave like a rolling runtime with:
- time
- memory
- due work
- bounded updates
- restore continuity
- safe publication
- explicit degradation

## Global heartbeat

The global heartbeat runs every 1 second.
Its job is orchestration only.

It does not mean:
- every symbol updates every second
- every layer updates every second
- every field rewrites every second

It means:
- every second, ASC checks what work is due now

## Runtime mode spine

### Boot mode
Creates shell state, loads config, discovers current universe, and starts the timer.

### Restore mode
Restores persistence first and validates what can be trusted.

### Warmup mode
Fills minimum missing truths so every known symbol reaches explicit state instead of silent neglect.

### Steady-state mode
Rolls forward with due-based refreshes only.

### Degraded mode
Protects core truth when budget, broker, or file pressure rises.
Deep work yields first.

## Due item model

The scheduler should work with discrete due items.
Each due item owns one narrow job.

Canonical due-item fields:
- `due_id`
- `symbol`
- `layer`
- `task_kind`
- `field_group`
- `timeframe`
- `priority`
- `reason`
- `last_run_at`
- `next_due_at`
- `retry_count`
- `last_outcome`

## Good due-item examples

- one symbol open-state recheck
- one symbol market-watch 10-second snapshot refresh
- one symbol filter reevaluation
- one bucket ranking refresh
- one selected symbol ATR refresh for one timeframe
- one selected symbol OHLC boundary update for one timeframe
- one selected symbol tick-buffer flush

## Scheduler law

Each due item must do only its owned work.
It may mark downstream state dirty, but it may not silently run unrelated layers.

Bad example:
- asking for `Daily Change` triggers a full universe recollect

Good example:
- Layer 2 refresh updates stored snapshot
- Layer 3 notices the snapshot changed and becomes due later

## Canonical dispatch priority

1. runtime safety and continuity
2. Layer 1 open/closed truth
3. Layer 2 open-symbol snapshot
4. Layer 3 filter
5. Layer 4 top-list selection
6. publication commits that are safe and due
7. Layer 5 deep selective analysis
8. cosmetic presentation extras

## Dirty propagation

Use meaning-based downstream dirtiness.

Examples:
- Layer 2 snapshot changed -> mark Layer 3 dirty for that symbol
- Layer 3 outcome changed -> mark the relevant bucket dirty for Layer 4
- Layer 4 membership changed -> mark Layer 5 membership sync dirty

## Bounded work law

A single heartbeat must not attempt to finish all possible work if the due queue spikes.
The runtime should preserve stability first.

## Failure honesty

Services should return explicit outcomes such as:
- success
- skipped
- deferred
- not ready
- invalid data
- failed
- budget exceeded

No silent disappearance.

## Boot sequence

1. load config
2. discover Market Watch universe
3. restore persisted runtime and symbol state
4. ensure symbol files exist
5. ensure placeholder sections exist
6. collect reboot-only symbol specs
7. run initial open/closed checks
8. schedule initial due work
9. enter steady heartbeat control

## Scheduling note

This blueprint locks the scheduler as item-based.
The exact data structure may still be tweaked later, but the architecture must stay due-based and narrow-tasked.
