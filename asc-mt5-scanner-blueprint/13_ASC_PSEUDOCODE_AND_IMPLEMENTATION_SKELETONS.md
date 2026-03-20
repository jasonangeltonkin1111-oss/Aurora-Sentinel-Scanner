# ASC Pseudocode and Implementation Skeletons

## Goal

This file gives GPT/Codex implementation skeletons that preserve architecture shape.

## Root EA skeleton

```cpp
int OnInit()
{
   if(!ASC_ResolveServerPaths(g_paths))
      return(INIT_FAILED);

   ASC_LogConfigure(g_paths.log_file);

   ASC_RuntimeInit(g_runtime, g_paths);
   ASC_RestoreBootstrap(g_runtime, g_scheduler, g_state_store);

   ASC_UniverseSync(g_universe, g_runtime);

   if(!EventSetTimer(1))
      return(INIT_FAILED);

   return(INIT_SUCCEEDED);
}

void OnTimer()
{
   ASC_RunHeartbeat(g_runtime, g_scheduler, g_stores, g_publication);
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   ASC_FinalSave(reason, g_runtime, g_scheduler, g_publication);
}
```

## Heartbeat skeleton

```text
ASC_RunHeartbeat():
  if reentry_guard_active:
      record skipped heartbeat
      return

  mark guard active
  now = get_server_time_with_fallback()

  runtime.last_heartbeat_at = now
  scheduler.refresh_due_registry(now)

  if universe_sync_due():
      sync_universe()

  dispatch_runtime_safety()
  dispatch_market_state_due_items()
  dispatch_snapshot_due_items()

  if warmup_minimum_complete():
      dispatch_filter_due_items()
      dispatch_selection_due_items()
      dispatch_deep_due_items()

  publish_due_dossiers()
  publish_due_summary()
  maybe_save_runtime()
  maybe_save_scheduler()

  clear guard
```

## Universe sync skeleton

```text
ASC_UniverseSync():
  total = SymbolsTotal(false)
  enumerate symbols
  reconcile additions/removals
  ensure dossier path mapping exists
  preserve prior continuity for known symbols
  mark new symbols as pending minimum truth
```

## Market-state assessment skeleton

```text
ASC_AssessMarketState(symbol):
  now = TimeTradeServer() or TimeCurrent()
  tick_ok, tick = SymbolInfoTick(symbol)

  quote_usable = derive from tick fields and/or live symbol properties
  has_sessions, within_session, next_open_at = inspect SymbolInfoSessionTrade()

  if tick_ok and tick_is_fresh and quote_usable:
      return OPEN_CONFIRMED, next_check = now + open_refresh_seconds

  if within_session and !tick_is_fresh:
      return UNCERTAIN, next_check = now + uncertain_retry_seconds

  if has_sessions and !within_session:
      next_check = schedule_near_next_open(next_open_at)
      return CLOSED_SESSION

  if !tick_ok and !has_sessions:
      return UNKNOWN, next_check = now + unknown_retry_seconds

  return STALE_FEED or UNCERTAIN
```

## Dossier write skeleton

```text
ASC_PublishDossier(symbol):
  build dossier DTO from prepared stores only
  render text payload
  atomic_write(temp -> last-good -> final)
  update publication state
```

## Runtime persistence skeleton

```text
ASC_SaveRuntime():
  serialize schema version
  serialize mode/timestamps/counters
  atomic_write(runtime_state_file)
```

## Scheduler persistence skeleton

```text
ASC_SaveScheduler():
  serialize per-symbol next checks
  serialize debt summary
  serialize service last-run times
  atomic_write(scheduler_state_file)
```

## Filter skeleton

```text
ASC_RunFilter(symbol):
  read layer1 + layer2 state only
  evaluate cheap gates
  assign eligibility and penalties
  mark bucket dirty if result changed
```

## Selection skeleton

```text
ASC_RunSelection(bucket):
  gather eligible symbols for bucket
  compute bounded promotion score
  apply anti-churn policy
  choose top N (usually 5 for summary visibility, larger bounded working set for deep budget if desired)
  mark deep-membership sync dirty
```

## Deep analysis skeleton

```text
ASC_RunDeepForSelected(symbol):
  maintain tick ring or recent tick buffer
  refresh OHLC windows by timeframe
  refresh ATR/indicator handles only when due
  write/update deep DTO blocks
```

## Important implementation notes

- keep text building separate from state collection
- keep API calls inside domain services, not scattered everywhere
- preserve restore-first behavior on every restart
- coalesce writes
- never let one symbol’s failure collapse the whole heartbeat
