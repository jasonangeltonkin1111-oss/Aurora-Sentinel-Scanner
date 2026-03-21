# AURORA WRAPPER SETTINGS

- wrapper_status: `ACTIVE_COMPILATION_V4_CONSOLIDATED_STANDALONE`
- compiled_on: `2026-03-21`
- source_truth_root: `Aurora Blueprint/`
- wrapper_root: `Aurora Wrapper/`
- active_run_ref: `Aurora Blueprint/runs/AURORA_RUN_067.md`
- default_mode: `WRAPPER_OPERATOR_MODE`
- alternate_mode: `WRAPPER_MAINTENANCE_MODE`
- bridge_status: `NO_BRIDGE_CHANGE_NEEDED`
- kernel_target: `<= ~5k chars`
- file_count_target: `13`
- file_count_soft_range: `12-14`
- file_count_hard_ceiling: `19`

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
- `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`, `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`, and `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md` when validating package shape and standalone sufficiency rather than doing normal operation.

## Prompt-versus-pack separation

- keep the kernel and any future system prompt small, routing-first, and boundary-first
- keep doctrine, examples, and schema detail in replaceable wrapper packs rather than the kernel
- prefer loading one or two relevant packs over pasting the whole wrapper canon into one monolithic prompt
- preserve long-lived doctrine in files and reserve prompt text for task framing, read order, and refusal/boundary behavior

## Pack replacement model

- replace `AURORA_WRAPPER_CONTROL_PACK.md` when office/control/build-phase/scope law changes materially
- replace `AURORA_WRAPPER_EXECUTION_PACK.md` when workflow, object, enum, opportunity, deployability, geometry, strategy-card, packet, review, or EA-boundary law changes materially
- replace `AURORA_WRAPPER_FAMILY_VAULT.md` when family competition law, family registry posture, or current core family doctrine changes materially
- replace `AURORA_WRAPPER_PATTERN_VAULT.md` when pattern competition law, atlas posture, or current pattern doctrine changes materially
- replace `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when packet schemas, worked examples, review doctrine, or canonical intake anchors change materially
- replace `AURORA_WRAPPER_BRIDGE_PACK.md` only when ASC⇄Aurora ownership or minimum context requirements change materially
- refresh router/governance files when routing, package shape, file count, or maintenance law changes materially

## Document-structure law

- prefer stable section boundaries, compact headings, and explicit law/exclusion/replacement sections
- prefer richer owning packs over parallel pack-plus-manual duplication
- avoid giant blended summaries that mix identity, doctrine, examples, and maintenance into one file
- keep hot-path packs readable top-to-bottom without requiring Blueprint traversal for normal operation

## Cold-path surfaces intentionally excluded from default reads

- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/runs/`
- extraction ledgers, supplements, queueing, and archive mirrors
- raw doctrine residue already compiled into the active packs
