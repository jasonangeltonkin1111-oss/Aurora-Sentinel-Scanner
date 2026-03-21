# AURORA WRAPPER MAINTENANCE GUIDE

## What this folder is

`Aurora Wrapper/` is a compiled wrapper-facing canon built from active source truth in `Aurora Blueprint/`.
It is designed for low file count, clear routing, and file-by-file replacement.
It is not the source workspace and must not absorb source-truth ownership away from `Aurora Blueprint/`.

## How to update it safely

1. recover current source truth from active office/control files, latest run, active bridge files, active execution-side protocols, current family/pattern doctrine, and active example packets
2. decide whether the change belongs in control, execution, family, pattern, packet/example, or bridge scope
3. replace the smallest correct wrapper pack instead of sprinkling edits across many packs
4. update `AURORA_WRAPPER_FILE_MAP.md` and `AURORA_WRAPPER_SETTINGS.md` only if routing/file roles changed
5. create a new append-only run in `Aurora Blueprint/runs/`
6. refresh office truth only when the pass materially changed active canonical surfaces

## Replace-vs-edit law

Prefer replacing an entire wrapper pack when its source area changed materially.
Edit in place only for:
- typo-level corrections
- clarified routing text that does not change canon boundaries
- metadata refreshes such as run id, date, or file count

## Source roots for future refreshes

### Control roots
- `Aurora Blueprint/office/README.md`
- `Aurora Blueprint/office/AURORA_OFFICE_CANON.md`
- `Aurora Blueprint/office/TASK_BOARD.md`
- `Aurora Blueprint/office/DECISIONS.md`
- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
- `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
- `Aurora Blueprint/AURORA_RECOVERY_ORDER_V5.md`
- `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`
- latest `Aurora Blueprint/runs/`

### Execution roots
- workflow/object/enum/status/deployability/geometry/card/packet/review/opportunity/EA-boundary files under `Aurora Blueprint/`

### Family roots
- family registry
- family system map
- core family files
- family cards
- family competition protocol/schema/example
- current consolidated family doctrine under `Aurora Blueprint/doctrine/WAVE2/`

### Pattern roots
- pattern atlas
- pattern cards
- pattern competition protocol/schema/example
- current consolidated pattern doctrine under `Aurora Blueprint/doctrine/WAVE2/`

### Bridge roots
- `Aurora Blueprint/ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `Aurora Blueprint/ASC_AURORA_JOINT_EVOLUTION_PROTOCOL.md`
- real ASC intake examples

## What stays out of wrapper hot path

- raw work logs
- SHA checkpointing
- full run history
- extraction ledgers and supplements
- extraction queueing
- strengthening residue already compiled into consolidated doctrine
- archive mirrors

## Current package audit

- intended role: first serious wrapper-compilation foundation
- intended update style: file replacement by pack
- expected next pass: deepen family/pattern vaults with more canonical examples and possibly compile current prompt templates into a dedicated wrapper-tooling pack only if it improves wrapper build quality without inflating hot-path file count
