# AURORA WRAPPER FILE MAP

## Purpose

This file routes wrapper tasks to the smallest correct pack, names the Blueprint roots compiled into each pack, and keeps hot-path versus maintenance-path boundaries explicit.
It also reflects the post-consolidation 13-file wrapper shape, where owning packs absorbed the temporary operating manuals.

## Router law

- start with kernel/settings/file-map, then branch by task
- do not default to loading every wrapper pack for every task
- prefer one hot-path doctrine pack plus one support pack when needed
- use maintenance/governance surfaces only for refresh, audit, or package-shape work

## Task router

| Task | Read first | Then read | Primary Blueprint roots compiled |
|---|---|---|---|
| Aurora identity, authority, build-phase honesty, refusal law | `AURORA_WRAPPER_CONTROL_PACK.md` | `AURORA_WRAPPER_BRIDGE_PACK.md` if ownership boundary matters | office files, control index, operator protocol, recovery order, progress tracker, build/scope locks |
| End-to-end execution flow, object chain, opportunity/deployability/geometry/card law | `AURORA_WRAPPER_EXECUTION_PACK.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` if schema/example certainty is needed | workflow packet, wrapper object model, status alignment, enum registry, deployability, geometry, card, packet, review, opportunity, abundance/stage law, EA-boundary specs |
| Family routing, family competition, family ecology, core family comparison | `AURORA_WRAPPER_FAMILY_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for worked anchors | family registry, family system map, family schema, core family files, family cards, family competition protocol/schema/example, Wave 2 family doctrine |
| Pattern routing, pattern competition, family-to-pattern mapping, local anti-confusions | `AURORA_WRAPPER_PATTERN_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for worked anchors | pattern atlas, pattern competition protocol/schema/example, active pattern cards, Wave 2 pattern doctrine |
| ASC context intake, missingness, refusal, bridge sufficiency | `AURORA_WRAPPER_BRIDGE_PACK.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | ASC contract, joint evolution protocol, real ASC intake example |
| Packet shape, review behavior, lane examples, illustrative vs real anchors | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | packet schema, group-context schema/example, review packet schema/example, family lane packet, worked example packet, real ASC intake example |
| Wrapper package audit, standalone sufficiency, consolidation, or refresh | `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` | standalone requirements / package architecture / standalone audit | latest run, office canon, current doctrine roots, consolidation plan |

## File classes

### Router / metadata
- `AURORA_WRAPPER_KERNEL.md`
- `AURORA_WRAPPER_SETTINGS.md`
- `AURORA_WRAPPER_FILE_MAP.md`

### Default hot path
- `AURORA_WRAPPER_CONTROL_PACK.md`
- `AURORA_WRAPPER_EXECUTION_PACK.md`
- `AURORA_WRAPPER_FAMILY_VAULT.md`
- `AURORA_WRAPPER_PATTERN_VAULT.md`
- `AURORA_WRAPPER_BRIDGE_PACK.md`

### Conditional hot-path support
- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### Maintenance / governance
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
- `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`
- `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`
- `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md`

## Reading patterns by job type

### Fast operator read
`KERNEL → SETTINGS → FILE_MAP → one primary doctrine pack`

### Higher-certainty reasoning read
`KERNEL → SETTINGS → FILE_MAP → primary doctrine pack → secondary doctrine/support pack`

### Wrapper-only standalone recovery read
`KERNEL → SETTINGS → FILE_MAP → CONTROL_PACK → task pack → PACKET_EXAMPLE if needed`

### Refresh / replacement read
`KERNEL → SETTINGS → FILE_MAP → MAINTENANCE_GUIDE → governance files → Blueprint source roots → latest run / SHA surfaces`

## Source-truth-only classes

Keep these out of wrapper doctrine hot path except when refreshing the compilation:
- office logs, checkpointing, and append-only runs
- extraction ledgers, supplements, and queueing artifacts
- archive mirrors and superseded generations
- raw doctrine residue already represented by active consolidated files and wrapper packs
