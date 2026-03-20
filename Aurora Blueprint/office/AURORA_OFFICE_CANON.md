# Aurora Office Canon

## Purpose

This file is the active Aurora control constitution.
It exists to keep the Aurora Blueprint side compact, explicit, and low-drift while preserving doctrine richness, extraction lineage, and run lineage.

## Active office model

Aurora active control is intentionally small:
- one office canon
- one task board
- one decisions log
- one append-only work log
- one SHA ledger

That control layer governs active Aurora surfaces, but it does not replace doctrine, ledgers, runs, manifests, or bridge files.

## Aurora active-truth classes

### 1. Active control surfaces
These control the current Aurora operating picture and must stay mutually consistent.

- `Aurora Blueprint/office/AURORA_OFFICE_CANON.md`
- `Aurora Blueprint/office/TASK_BOARD.md`
- `Aurora Blueprint/office/DECISIONS.md`
- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
- `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
- `Aurora Blueprint/AURORA_RECOVERY_ORDER_V5.md`
- `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`

### 2. Active canonical doctrine and protocol surfaces
These are active doctrine or bridge truths that current wrapper/machine work should read before touching older generations.

- `Aurora Blueprint/AURORA_BOOK_EXTRACTION_COMPLETION_PROTOCOL.md`
- `Aurora Blueprint/AURORA_BOOK_EXTRACTION_LEDGER_V2.md` plus the latest supplements not yet merged
- `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
- `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
- `Aurora Blueprint/AURORA_DEEPENING_PASS_PROTOCOL_001.md`
- `Aurora Blueprint/ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `Aurora Blueprint/ASC_AURORA_JOINT_EVOLUTION_PROTOCOL.md`
- `Aurora Blueprint/AURORA_WRAPPER_OBJECT_MODEL.md`
- `Aurora Blueprint/AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `Aurora Blueprint/AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`
- `Aurora Blueprint/AURORA_GENERATED_STRATEGY_CARD_PROTOCOL.md`
- `Aurora Blueprint/AURORA_OPPORTUNITY_INVENTORY_AND_RANKING_PROTOCOL.md`
- `Aurora Blueprint/AURORA_EA_SAFE_OUTPUT_BOUNDARY_SPEC.md`
- active wrapper prompt templates and active operator scaffolds
- active consolidated doctrine surfaces by wave

### 3. Historical lineage surfaces
These preserve prior generations or earlier canonical states and must not be deleted casually.

Examples:
- older control index generations
- older recovery order generations
- older progress tracker generations
- earlier ledger generations after supersession
- strengthening files whose truth has been partially consolidated but still carries lineage value
- older audit and consolidation-planning files

Historical does not mean disposable.
It means reference, lineage, and proof — not first-read active truth.

### 4. Run-history surfaces
- `Aurora Blueprint/runs/AURORA_RUN_XXX.md`

Run files are append-only continuity records.
They preserve how the repo evolved.
They are not replaced by the office work log.

### 5. Source and pass lineage surfaces
- `Aurora Blueprint/source_sets/`
- `Aurora Blueprint/passes/`

These preserve extraction truth and book-to-doctrine lineage.
They are never to be collapsed into vague summaries.

### 6. Backup/archive mirrors if present
Any operator-made archive copy under `archives/` is reference only.
It is a safety mirror, not active control truth.

## Update law

Any meaningful Aurora-side change should update the smallest valid set of control files.

### Update `TASK_BOARD.md` when
- current Aurora priorities change
- a stream becomes active, blocked, or historical
- immediate next actions change materially

### Update `DECISIONS.md` when
- a control rule is locked or explicitly revised
- an active/historical classification rule changes
- a bridge or machine-boundary rule becomes fixed enough to govern future work

### Update `WORK_LOG.md` when
- a meaningful Aurora pass changes repo state
- a consolidation, hardening, or bridge check happened
- a pass intentionally chose cross-reference over risky merge

### Update `SHA_LEDGER.md` when
- active control surfaces changed materially
- active canonical protocol/doctrine surfaces changed materially
- a checkpoint is needed so later workers can answer “what changed materially?” safely

## Consolidation law

Aurora may consolidate only when the result is clearly lossless.

If two files overlap but both still carry distinct truth:
- keep both
- strengthen the active file’s cross-links
- classify one as historical or lineage if needed

Do not flatten doctrine, source truth, run history, or bridge truth into generic summaries.

## Wrapper and machine-precision law

Active Aurora files should prefer:
- explicit objects
- explicit field names
- explicit ownership
- explicit missing-surface handling
- explicit machine-safe versus human-only boundaries

Do not force automation prematurely.
Do not invent generic trading logic to look “systematic.”

## ASC bridge law

Aurora office governs Aurora only.
It must not redesign ASC office.
But any meaningful Aurora-side architectural pass must state one of:
- `NO_BRIDGE_CHANGE_NEEDED`
- `ASC_NEEDS_UPDATE`
- `AURORA_NEEDS_UPDATE`
- `BOTH_NEED_UPDATE`

That outcome belongs in the relevant work log or run record.
