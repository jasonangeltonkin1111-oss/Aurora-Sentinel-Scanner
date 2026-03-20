# ASC Foundation Pass One

## Purpose

This document overrides broader blueprint drift for the current build pass.
It defines the first real working foundation only.

## Current scope

Build now:
- timer-driven runtime
- heartbeat
- due-based scheduler
- server-based storage root
- symbol universe dossier creation
- runtime state persistence
- scheduler state persistence
- summary scaffold file
- clean logging
- atomic writing
- boot and recovery continuity
- market open or closed truth per symbol
- dossier schema with reserved future sections only

Do not build yet:
- ranking
- filtering
- basket selection
- strategy logic
- trade logic
- account logic
- past-trade logic

## Server-only identity law

This system is server-based only.

Do not use:
- account number
- login
- balance
- equity
- positions
- orders
- trade history
- past trades

Storage identity is the cleaned broker server name only.
The EA name must not become the storage identity.

## Storage structure

Use MT5 Common Files under `AuroraSentinel`.

Inside it, use the cleaned broker server name as the main folder.

```text
AuroraSentinel/
  <Clean Server Name>/
    Symbol Universe/
    Dev/
    <Clean Server Name> Scheduler State.txt
    <Clean Server Name> Runtime State.txt
    <Clean Server Name> Summary Top 5 per Basket.txt
```

Rules:
- exactly one folder per server
- exactly two subfolders only: `Symbol Universe` and `Dev`
- `Symbol Universe` is the only folder allowed to become large
- `Dev` is for persistence support, debug, and logging
- no deep nesting
- no scattered micro-folder architecture

## Dossier naming law

Use real functional names only.
Do not expose architecture chatter such as step, phase, layer, packet, or wave in the dossiers.

Examples of dossier section names:
- `Symbol Identity`
- `Market Status`
- `Session State`
- `Runtime Health`
- `Heartbeat State`
- `Tick Activity`
- `Price History`
- `Scheduler State`

Top of dossier should stay compact, readable, and human-friendly.
Lower sections may be denser and more machine-friendly.

## Placeholder law

Do not fake completeness with `0`, `NONE`, or `DEFAULT` when the system does not yet know something.
If not yet populated:
- omit it, or
- mark it as `Reserved`, `Pending`, or `Not Yet Available`

## Boot and persistence law

Startup must continue from prior truth where possible.
Do not rebuild from zero blindly.

On boot:
- inspect existing state
- validate files and folders
- repair missing pieces
- fill gaps
- continue from last known good state
- recalculate missing or invalid data only

## Atomic persistence law

Persistent writes must use a safe rolling pattern.
Use temp-to-final promotion and protect against partial-write corruption.

## Scheduler and market-state law

The runtime is timer-driven, not tick-chaotic.

Per symbol:
- determine open or closed truth using sound MT5 evidence
- distinguish live tick presence from scheduled closed state where possible
- check open symbols more often
- avoid useless constant polling on clearly closed symbols
- allow short aggressive recheck bursts when state is uncertain

## Foundation module map

The first foundation build should remain modular and flat.
Expected responsibilities include:
- main EA orchestration
- runtime and heartbeat
- scheduler
- server path resolution
- logging
- atomic writing
- market-state detection
- dossier formatting
- runtime state persistence
- scheduler state persistence

## Flat runtime deployment law

The actual MT5 runtime files may stay in one flat folder for fast navigation.
That deployment choice does not weaken architectural responsibility separation.
