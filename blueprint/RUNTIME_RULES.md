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

## Locked Refresh Cadence for First Milestone
The first scanner milestone uses a simple bounded cadence:

### OnInit
- identify broker
- restore existing broker state from Common Files
- detect missing, invalid, or stale broker symbol files and summary state
- perform one full bounded scanner pass
- publish refreshed broker outputs

### OnTimer
- run periodic bounded refresh passes
- re-read current broker state first when needed
- refresh only symbols that are missing, invalid, or stale
- rebuild summary after the symbol pass completes

### OnTick
- no heavy scanner work
- no universe-wide work
- no summary rebuilds

## Timer Rule
The exact timer interval may be implemented in code, but the blueprint intent is fixed:
- frequent enough to keep the scanner useful
- slow enough to avoid turning the EA into a heavy tick-driven loop

The first milestone prefers timer-driven orchestration over tick-driven orchestration.

## First Milestone Runtime Scope
The first milestone runtime includes:
- symbol universe intake
- broker spec intake
- bounded M15 and H1 history intake
- minimum calculation preparation
- symbol file writes
- summary rebuild
- diagnostics

It does not include:
- signal generation
- trade direction logic
- execution logic
- deep telemetry systems
- strategy extraction

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
