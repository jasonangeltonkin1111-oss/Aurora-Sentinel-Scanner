# AURORA WRAPPER MAINTENANCE GUIDE

## Purpose

`Aurora Wrapper/` is a compiled wrapper-facing canon built from active source truth in `Aurora Blueprint/`.
It is designed for low file count, clear routing, tiny-kernel discipline, and pack-by-pack replacement.
It must stay separate from Blueprint, which remains the source-truth workspace.

## Safe refresh workflow

1. recover active source truth from office/control files, latest run, active bridge files, active execution-side protocols, current family/pattern doctrine, and active packet/example anchors
2. audit the existing wrapper pack against those sources before editing anything
3. decide whether the change belongs in control, execution, family, pattern, packet/example, or bridge scope
4. replace the smallest correct pack instead of sprinkling partial edits across many packs
5. update `AURORA_WRAPPER_FILE_MAP.md` and `AURORA_WRAPPER_SETTINGS.md` only if routing, file roles, or package structure changed
6. create the next append-only run file under `Aurora Blueprint/runs/`
7. refresh office truth (`WORK_LOG.md`, `TASK_BOARD.md`, `SHA_LEDGER.md`, control/progress files) only when active canonical surfaces changed materially
8. record the bridge-check outcome every meaningful pass, even if it remains `NO_BRIDGE_CHANGE_NEEDED`

## Replace-vs-edit law

Prefer replacing an entire wrapper pack when its source area changed materially.
Edit in place only for:
- typo-level fixes
- metadata refreshes such as run id or file count
- routing clarifications that do not alter pack boundaries

## Pack-by-pack source roots

### Control pack
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
- latest run file

### Execution pack
- `Aurora Blueprint/AURORA_BUILD_PHASE_LOCK.md`
- `Aurora Blueprint/AURORA_EXECUTION_SIDE_SCOPE_LOCK.md`
- `Aurora Blueprint/AURORA_WRAPPER_OBJECT_MODEL.md`
- `Aurora Blueprint/AURORA_WRAPPER_WORKFLOW_PACKET_002.md`
- `Aurora Blueprint/AURORA_STATUS_AND_ENUM_ALIGNMENT_SPEC_001.md`
- `Aurora Blueprint/AURORA_ENUM_REGISTRY_001.md`
- `Aurora Blueprint/AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `Aurora Blueprint/AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`
- `Aurora Blueprint/AURORA_GENERATED_STRATEGY_CARD_PROTOCOL.md`
- `Aurora Blueprint/AURORA_STRATEGY_CARD_FIELD_SCHEMA.md`
- `Aurora Blueprint/AURORA_PACKET_SCHEMA_001.md`
- `Aurora Blueprint/AURORA_GROUP_CONTEXT_OBJECT_SCHEMA.md`
- `Aurora Blueprint/AURORA_REVIEW_PACKET_SCHEMA_001.md`
- `Aurora Blueprint/AURORA_OPPORTUNITY_INVENTORY_AND_RANKING_PROTOCOL.md`
- `Aurora Blueprint/AURORA_EA_SAFE_OUTPUT_BOUNDARY_SPEC.md`

### Family vault
- `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`
- `Aurora Blueprint/strategy_families/AURORA_FAMILY_SYSTEM_MAP.md`
- `Aurora Blueprint/strategy_families/FAMILY_FILE_SCHEMA.md`
- `Aurora Blueprint/strategy_families/CORE/CORE_FAMILY_INDEX.md`
- current core family files
- current family cards
- `Aurora Blueprint/AURORA_FAMILY_COMPETITION_ENGINE_PROTOCOL.md`
- `Aurora Blueprint/AURORA_FAMILY_COMPETITION_OBJECT_SCHEMA.md`
- `Aurora Blueprint/AURORA_FAMILY_COMPETITION_WORKED_EXAMPLE_001.md`

### Pattern vault
- `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`
- current pattern cards
- `Aurora Blueprint/AURORA_PATTERN_COMPETITION_ENGINE_PROTOCOL.md`
- `Aurora Blueprint/AURORA_PATTERN_COMPETITION_OBJECT_SCHEMA.md`
- `Aurora Blueprint/AURORA_PATTERN_COMPETITION_WORKED_EXAMPLE_001.md`

### Packet/example vault
- `Aurora Blueprint/AURORA_PACKET_SCHEMA_001.md`
- `Aurora Blueprint/AURORA_GROUP_CONTEXT_OBJECT_SCHEMA.md`
- `Aurora Blueprint/AURORA_REVIEW_PACKET_SCHEMA_001.md`
- `Aurora Blueprint/AURORA_GROUP_CONTEXT_OBJECT_EXAMPLE_001_C04_G4.md`
- `Aurora Blueprint/AURORA_FAMILY_LANE_PACKET_002_C04_G4.md`
- `Aurora Blueprint/AURORA_WORKED_EXAMPLE_PACKET_002_C04_G4_FILLED.md`
- `Aurora Blueprint/AURORA_REVIEW_PACKET_001_C04_G4.md`
- `Aurora Blueprint/AURORA_REAL_ASC_CONTEXT_INTAKE_EXAMPLE_001_3_XHKG.md`

### Bridge pack
- `Aurora Blueprint/ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `Aurora Blueprint/ASC_AURORA_JOINT_EVOLUTION_PROTOCOL.md`
- real ASC intake examples when bridge behavior needs re-verification

## What stays outside wrapper hot path

- raw work logs and SHA entries
- full append-only run history
- extraction ledgers, supplements, and queueing artifacts
- archive mirrors and superseded generations
- unconsolidated doctrine residue not needed for current wrapper fidelity

## Audit checklist for future passes

- Is the kernel still a router rather than a doctrine vault?
- Does the file map still describe hot path, support path, and maintenance path correctly?
- Does each major pack state what it compiles, excludes, and how to replace it?
- Has family-first then pattern-second law been preserved?
- Are strategy-card and EA-safe boundaries still explicit?
- Are review/diagnosis anchors still faithful to the active schemas/examples?
- Has the bridge check been recorded?
- Have SHA/control/run surfaces been refreshed when active canonical files changed?

## Current package posture after Wave 2 audit

- wrapper file count target preserved: `10`
- kernel posture: still tiny router, tightened rather than expanded into doctrine storage
- bridge posture: `NO_BRIDGE_CHANGE_NEEDED`
- next likely wrapper-focused pass: deepen optional wrapper-tooling/prompt support only if it can remain off the default hot path
