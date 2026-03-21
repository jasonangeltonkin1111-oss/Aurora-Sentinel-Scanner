# AURORA WRAPPER SETTINGS

- wrapper_status: `ACTIVE_COMPILATION_V1`
- compiled_on: `2026-03-21`
- source_truth_root: `Aurora Blueprint/`
- wrapper_root: `Aurora Wrapper/`
- active_run_ref: `Aurora Blueprint/runs/AURORA_RUN_063.md`
- default_mode: `WRAPPER_OPERATOR_MODE`
- alternate_mode: `WRAPPER_MAINTENANCE_MODE`
- bridge_status: `NO_BRIDGE_CHANGE_NEEDED`
- kernel_target: `~8k chars max`
- file_count_target: `8-15`
- file_count_hard_ceiling: `20`

## Default hot-path files

1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`

## Conditional files

- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when object, packet, review, or worked-example anchoring is required.
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` when updating the wrapper package.

## Replacement model

- replace `AURORA_WRAPPER_CONTROL_PACK.md` when active control law changes materially
- replace `AURORA_WRAPPER_EXECUTION_PACK.md` when workflow/object/protocol/schema layers change materially
- replace `AURORA_WRAPPER_FAMILY_VAULT.md` when family doctrine or family competition law changes materially
- replace `AURORA_WRAPPER_PATTERN_VAULT.md` when pattern doctrine or pattern competition law changes materially
- replace `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when new packet schemas or better examples become canonical
- replace `AURORA_WRAPPER_BRIDGE_PACK.md` only when ASC⇄Aurora contract truth changes materially
- refresh `AURORA_WRAPPER_FILE_MAP.md`, `AURORA_WRAPPER_SETTINGS.md`, and `AURORA_WRAPPER_KERNEL.md` only when routing or package structure changes materially

## Cold-path areas kept off default wrapper reads

- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/runs/`
- `Aurora Blueprint/AURORA_BOOK_EXTRACTION_LEDGER_V2.md`
- `Aurora Blueprint/AURORA_BOOK_EXTRACTION_LEDGER_SUPPLEMENT_*.md`
- `Aurora Blueprint/AURORA_EXTRACTION_QUEUE.md`
- strengthening residue under `Aurora Blueprint/doctrine/**`
- archives and mirrors under `archives/`
