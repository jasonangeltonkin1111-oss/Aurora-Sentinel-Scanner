# ASC Scheduler and Budgeting

## Scheduler philosophy

ASC needs a scheduler, not just a timer loop.

A timer loop says:
- “every N seconds, run this code”

A scheduler says:
- “each heartbeat, choose the best truthful work subset under current budgets”

The second one is what ASC requires.

## Minimum scheduler features

- due items
- priorities
- bounded work caps
- cursor/fairness
- retry policies
- stale/dirty tracking
- persistence of next-due state
- service-family budgeting

## Suggested service families

- `SERVICE_RUNTIME`
- `SERVICE_UNIVERSE`
- `SERVICE_MARKET_STATE`
- `SERVICE_SPECS`
- `SERVICE_MARKET_WATCH`
- `SERVICE_FILTER`
- `SERVICE_SELECTION`
- `SERVICE_DEEP_HISTORY`
- `SERVICE_DEEP_INDICATORS`
- `SERVICE_PUBLICATION`
- `SERVICE_HUD`

## Budget dimensions

### CPU/work budget
How many due items per heartbeat.

### Symbol-touch budget
How many distinct symbols may be processed this heartbeat.

### History budget
How many `CopyRates` / `CopyTicks` / indicator pulls may run.

### File budget
How many atomic promotions may happen.

### Reserved publication budget
Keep enough budget to save essential continuity even during busy cycles.

## Debt tracking

If a family keeps being deferred, record debt.
Debt helps avoid permanent starvation.

Suggested debt metrics:
- skipped count
- oldest deferred age
- average lateness
- last starvation warning
- last forced service time

## Persistence of scheduler state

The scheduler itself is continuity state.

Persist:
- next due time per symbol/task
- selected-set membership snapshot
- cursors
- last service run times
- debt counters (or summary)
- compatibility/schema version

Do not persist:
- giant transient queues if they can be reconstructed cheaply

## Warmup policy

During warmup:
- favor minimum truth coverage over deep richness
- ensure every symbol reaches explicit Layer 1 status
- then Layer 2 minimum snapshot
- then only proceed to higher layers

## Degraded mode policy

When budgets or environment are stressed:
- keep Layer 1 alive
- keep essential persistence alive
- reduce Layer 2 cadence
- defer Layer 3/4 recompute if necessary
- pause or slow Layer 5 first
- preserve visibility of degraded state

## Example heartbeat flow

1. update runtime clocks
2. ensure re-entry guard
3. universe sync if due
4. enqueue/refresh due families
5. dispatch high-priority runtime and market-state jobs
6. dispatch snapshot jobs within budget
7. dispatch layer jobs within remaining budget
8. commit essential publications
9. persist scheduler/runtime if due
10. release guard

## Example priorities

### Very high
- runtime state write
- scheduler state write
- market-state repair for symbols near open
- recovery critical tasks

### High
- due market-state checks
- open-symbol snapshot refreshes
- universe sync

### Medium
- filter/rank recompute
- selected set membership refresh
- dossier coalesced publication

### Lower
- deep enrichment
- operator HUD polish
- verbose diagnostics

## Example pseudocode

```text
OnTimer():
  if heartbeat_guard: record skip and return

  heartbeat_guard = true
  now = time_server_or_current()

  refresh_due_registry(now)
  refill_budgets()

  run_service_family(runtime_safety)
  run_service_family(market_state)
  run_service_family(snapshot)

  if warmup_complete:
      run_service_family(filter)
      run_service_family(selection)
      run_service_family(deep)

  run_service_family(publication)

  maybe_save_runtime_state()
  maybe_save_scheduler_state()

  heartbeat_guard = false
```

## Why Codex/GPT often gets this wrong

Common weak-codegen failure modes:
- one array of symbols, full scan every heartbeat
- no distinction between “dirty” and “due”
- no persistence of next-check timing
- no service-family caps
- no debt tracking
- no degradation strategy

ASC requires all of those concepts.
