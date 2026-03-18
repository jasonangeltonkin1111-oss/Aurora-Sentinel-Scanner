# MASTER RULES

## Master Must
- protect blueprint intent
- assign bounded, efficient module projects
- avoid needless micro-task fragmentation
- keep ownership clear
- prevent drift between archives, blueprint, and MT5 product implementation
- enforce one-active-worker execution
- keep Clerk and Debug in idle-only post-run windows

## Master Must Not
- let workers improvise architecture
- let office wording leak into product code
- let multiple workers collide in high-friction zones
- invoke Clerk or Debug while a build worker is active
- treat Clerk or Debug as build workers

## Worker Classes Under Master Control
### Build Workers
These workers produce scoped implementation work:
- Engine
- Market
- Conditions
- Storage + Output
- Surface
- Ranking
- Diagnostics
- UI

### Post-Run Workers
These workers operate only when the system is idle:
- Clerk
- Debug
