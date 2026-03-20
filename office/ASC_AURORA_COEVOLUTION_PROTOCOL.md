# ASC and Aurora Co-Evolution Protocol

## Purpose

ASC and Aurora now evolve together.

They do not collapse into one system.
They do not drift as isolated systems.
They evolve hand in hand while keeping clear role boundaries.

## Role boundary

### ASC
ASC is the scanner foundation.
It senses, schedules, preserves, restores, and publishes market-state truth.

### Aurora
Aurora is the execution-side intelligence layer.
It consumes upstream truth, applies execution intelligence, and evolves at its own pace.

## Co-evolution law

From this point onward, any meaningful update to ASC or Aurora must check the other system's current progress and update the bridge understanding accordingly.

This does not mean both must always be edited together.
It means every meaningful change must be evaluated for bridge impact.

## Required check on every meaningful update

When ASC changes, check:
- what Aurora currently expects upstream
- whether ASC output contracts still support Aurora cleanly
- whether dossier, runtime, scheduler, and publication truth remain useful downstream
- whether any new ASC capability or constraint should be reflected in bridge docs or office control

When Aurora changes, check:
- whether ASC must provide additional upstream guarantees
- whether ASC timing, continuity, freshness, or schema contracts should tighten
- whether bridge assumptions are now outdated
- whether ASC remains cleanly separated from execution logic

## Bridge update rule

Every meaningful change must classify bridge impact as one of:
- no bridge impact
- bridge clarification needed
- bridge contract change needed
- upstream ASC requirement change needed
- downstream Aurora requirement change noted

## Anti-pollution rule

Aurora requirements may influence ASC foundation requirements.
Aurora may not pollute ASC with execution logic.

ASC must remain:
- foundation
- scanner
- scheduler
- persistence and publication system

Aurora must remain the execution-side intelligence layer.

## Practical workflow rule

For future workers, every substantial update should include:
1. what changed in the local system
2. what was checked in the sister system
3. whether the bridge changed
4. what docs/contracts were updated as a result

## Preferred surfaces to keep aligned

### ASC-side
- `blueprint/`
- `asc-mt5-scanner-blueprint/`
- `mt5_runtime_flat/`
- `office/`

### Aurora-side read surfaces
- `Aurora Blueprint/`

Aurora Blueprint remains readable reference when working on ASC.
ASC blueprint/runtime remains readable reference when assessing Aurora-facing scanner requirements.

## Final rule

ASC and Aurora now grow together deliberately.
They evolve at different speeds, but never blindly or in isolation.
