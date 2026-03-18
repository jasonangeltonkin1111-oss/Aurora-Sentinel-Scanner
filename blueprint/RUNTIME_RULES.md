# RUNTIME RULES

## Runtime Philosophy
Run cheaply across the full broker universe, deepen only where justified, and persist broker truth between reloads.

## Required Runtime Behavior
- one EA only
- scheduler must preserve layer boundaries
- startup must restore broker state before scanning aggressively
- deep work remains scarce
- demotion should prefer freeze over forgetting when safe

## First Working Slice
The first working implementation target is:
1. Common
2. Engine
3. Market
4. Conditions
5. Storage
6. Output

That slice must reach:
- clean EA startup
- broker symbol discovery
- broker-level persistence restore
- safe write path to Common Files
- truthful summary output without crashes

## Build Order Intent
1. Common
2. Engine
3. Market
4. Conditions
5. Storage
6. Output
7. Surface
8. Ranking
9. Diagnostics
10. UI
