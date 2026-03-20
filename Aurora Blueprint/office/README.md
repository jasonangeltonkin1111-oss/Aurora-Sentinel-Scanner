# Aurora Office

This folder is the compact active control layer for the Aurora Blueprint side of the repo.

It borrows the useful control discipline of ASC office without turning Aurora into office sprawl.

## Purpose

Aurora already has rich doctrine, bridge, ledger, source-set, and run-history surfaces.
The office layer exists to control those active surfaces tightly so future workers can tell:
- what is active control truth now
- what is active doctrine truth now
- what is historical lineage only
- what must be updated when a meaningful Aurora pass lands
- what should be hashed for material-change checkpoints

## Active office files

- `AURORA_OFFICE_CANON.md`
- `TASK_BOARD.md`
- `DECISIONS.md`
- `WORK_LOG.md`
- `SHA_LEDGER.md`

## What this folder owns

- Aurora active control law
- active versus historical interpretation
- task status for the active Aurora side
- locked Aurora control decisions
- append-only office work logging
- compact SHA checkpoints for active canonical surfaces

## What this folder does not own

- doctrine extraction itself
- source-set manifests
- run history itself
- raw archive or backup storage
- wrapper prompt content itself
- ASC implementation control

## Archive and backup interpretation

If an operator-created archive mirror of `Aurora Blueprint/` exists under `archives/`, treat it as reference only.
Do not modify it.
Do not move active knowledge into it as a cleanup shortcut.

Aurora active truth must stay usable from the active tree.

## Small-file rule

Do not grow this office folder casually.
A new office file is allowed only when an existing file cannot absorb the truth without losing clarity.
