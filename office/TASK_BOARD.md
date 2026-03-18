# TASK BOARD

## Rule
The master assigns bounded projects by module or product concern.
Product naming must stay domain-based, not task-number-based.

## Current State
- root layout locked
- archive remains static reference only
- blueprint baseline is coherent
- MT5 flat deployment rule is locked
- execution protocol is locked
- Clerk and Debug are added as idle-only post-run workers
- first scanner milestone specifics are now locked
- next active build slice is:
  - Engine
  - Market
  - Conditions
  - Storage + Output

## Current Objective
Reach the first working EA slice that:
- starts cleanly
- discovers broker symbols
- reads broker conditions
- restores broker state first
- writes truthful broker-level outputs

## First Milestone Locked Shape
- summary grouped by asset-class buckets only
- top 5 per bucket only
- first milestone timeframe set:
  - `M15`
  - `H1`
- first milestone cadence:
  - `OnInit` full bounded pass after restore
  - `OnTimer` bounded refresh passes
  - `OnTick` no heavy scanner work

## Post-Run Sequence
After each completed worker run, the master may invoke in order:
1. Clerk
2. Debug
