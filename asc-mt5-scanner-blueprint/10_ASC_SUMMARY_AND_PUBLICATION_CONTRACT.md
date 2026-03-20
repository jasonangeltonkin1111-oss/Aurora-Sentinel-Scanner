# ASC Summary and Publication Contract

## Summary purpose

The summary is a publication artifact for quick operator/trader scanning.

It is not:
- the universe
- the persistence source of truth
- permission to skip per-symbol dossiers
- the place where writer-side calculations happen

## Publication order

1. symbol dossiers exist
2. layer-owned sections fill truthfully
3. shortlist/promotion state exists
4. summary is composed from already prepared state

## Foundation-era summary

While ranking is still blocked, the summary may be a scaffold:
- runtime mode
- symbol counts by market state
- recent heartbeat info
- maybe a small market-state rollup

Do not fake “Top 5 per Basket” before the ranking layer exists.

## Future ranked summary

When Shortlist Selection exists, the summary should provide:
- grouped results by `Primary Bucket`
- top 5 only per bucket
- truthful smaller counts where fewer qualify
- compact readable scoring/support context
- no raw deep dump

## Suggested summary sections

- header
- runtime health
- universe coverage
- market-state counts
- bucket summary blocks
- degraded/pending notes
- publication timestamp

## Example future bucket block

```text
FX Majors
----------------------------------------
1. EURUSD
   Rank Score: 82.4
   Market Status: Open
   Daily Change: +0.48%
   Spread: 1.2 pts
   Snapshot Freshness: 4 sec
```

## Publication rules

- use readable labels
- no internal enum leakage
- no architecture chatter like `Shortlist Selection` or numeric layer names in trader-facing text
- no fake zero placeholders
- do not pad to 5 when fewer are valid
- preserve source timestamps where helpful

## Coalescing and atomicity

Summary writes should be:
- bounded
- due-based
- atomic
- skipped when no material change and no forced publication due

## Human-surface mapping

Internal fields may be:
- `market_status`
- `snapshot_freshness_seconds`
- `selection_score`

Trader/public summary labels should be:
- `Market Status`
- `Snapshot Freshness`
- `Selection Score`

## Common summary anti-patterns

- summary built before dossiers
- summary as only persisted truth
- full-universe dump masquerading as summary
- direct raw-object reads from writers
- writer-side ranking math
- leaking internal shortlist-selection identifiers into the UI

## Summary bridge note

The summary is not the canonical symbol store.
Aurora should later treat it as a quick publication surface only.

Canonical downstream ingestion should prefer dossiers and continuity files first, with the summary used as a convenience layer for operator review or coarse scanner posture.
