# AURORA WRAPPER SETTINGS

- wrapper_status: `ACTIVE_COMPILATION_V3`
- compiled_on: `2026-03-21`
- source_truth_root: `Aurora Blueprint/`
- wrapper_root: `Aurora Wrapper/`
- active_run_ref: `Aurora Blueprint/runs/AURORA_RUN_065.md`
- default_mode: `WRAPPER_OPERATOR_MODE`
- alternate_mode: `WRAPPER_MAINTENANCE_MODE`
- bridge_status: `NO_BRIDGE_CHANGE_NEEDED`
- kernel_target: `<= ~5k chars`
- file_count_target: `10`
- file_count_soft_range: `8-12`
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

## Conditional support files

- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when object shapes, review behavior, example anchoring, or packet-field recall is required.
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` when auditing, recompiling, replacing packs, or checking control/SHA/run continuity.

## Prompt-versus-pack separation

- keep the kernel and any future system prompt small, routing-first, and boundary-first
- keep doctrine, examples, and schema detail in replaceable wrapper packs rather than the kernel
- prefer loading one or two relevant packs over pasting the whole wrapper canon into one monolithic prompt
- preserve long-lived doctrine in files and reserve prompt text for task framing, read order, and refusal/boundary behavior

## Pack replacement model

- replace `AURORA_WRAPPER_CONTROL_PACK.md` when office/control/build-phase/scope law changes materially
- replace `AURORA_WRAPPER_EXECUTION_PACK.md` when workflow, object, enum, deployability, geometry, strategy-card, opportunity, packet, or EA-boundary law changes materially
- replace `AURORA_WRAPPER_FAMILY_VAULT.md` when family competition law, family registry posture, or current core family doctrine changes materially
- replace `AURORA_WRAPPER_PATTERN_VAULT.md` when pattern competition law, atlas posture, or current pattern doctrine changes materially
- replace `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when packet schemas, worked examples, review doctrine, or canonical intake anchors change materially
- replace `AURORA_WRAPPER_BRIDGE_PACK.md` only when ASC⇄Aurora ownership or minimum context requirements change materially
- refresh `AURORA_WRAPPER_KERNEL.md`, `AURORA_WRAPPER_FILE_MAP.md`, and this file only when routing, file roles, or package structure changes materially

## Document-structure law

- prefer stable section boundaries, compact headings, and explicit law/exclusion/replacement sections
- prefer fewer medium-sized packs over many tiny fragments
- avoid giant blended summaries that mix identity, doctrine, examples, and maintenance into one file
- keep hot-path packs readable top-to-bottom without requiring Blueprint traversal for every answer

## Cold-path surfaces intentionally excluded from default reads

- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/runs/`
- extraction ledgers, supplements, queueing, and archive mirrors
- deep source doctrine and strengthening residue already compiled into the active packs
