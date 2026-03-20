# Office Canon

## Purpose

This file is the active office constitution for the repo.

It replaces office sprawl with one compact control system.

## Active office model

The active office layer is:

- one canon
- one task board
- one decision log
- one work log
- one SHA ledger

That is enough.

## What was preserved from the archive

The archive office showed that the following are useful and should remain:

- a canonical control file
- a current task board
- a locked decision record
- an append-only work log
- a SHA ledger for repo-state checkpoints
- stage-gated implementation discipline
- separation between blueprint, office, MT5 code, and archives

## What was adapted

The archive office used many additional files for:
- HQ state
- operator manuals
- handoff prompts
- worker rules
- wave packets
- review packets
- many narrow project notes

Those truths are adapted into fewer heavy files here.

## What was rejected

The following are rejected as active office shape:

- dozens of narrow office files at the root
- handoff packets as the main planning system
- one file per tiny state change
- rebuilds of the same truth in many overlapping docs
- clutter that slows execution

## Folder law

### `blueprint/`
Runtime design truth.

### `office/`
Implementation control truth.

### `mt5_runtime_flat/`
Active flat MT5 runtime build surface.

### `archives/`
Reference and lineage only.

## Update law

Any meaningful repo change should touch office in a bounded way:

- `TASK_BOARD.md` if task state changes
- `DECISIONS.md` if a lock changes
- `WORK_LOG.md` for the actual work performed
- `SHA_LEDGER.md` for a checkpointed file-hash snapshot when needed

Do not create a new office file when an existing canonical file can absorb the truth.

## Current office target

The current active target is:

- server-only ASC foundation
- flat MT5 runtime
- restart-safe persistence
- market-state truth
- dossier continuity
- compile-hardening next

## Small-file rule

Do not grow this folder by default.

A new office file is allowed only if it carries a truly distinct long-lived role that does not fit inside the existing canon.
