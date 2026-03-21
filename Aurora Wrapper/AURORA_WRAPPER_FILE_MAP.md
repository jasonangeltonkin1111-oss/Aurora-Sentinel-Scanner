# AURORA WRAPPER FILE MAP

## Purpose

This file routes wrapper tasks to the smallest correct pack, names the Blueprint roots compiled into each pack, and keeps hot-path versus maintenance-path boundaries explicit.
It also keeps the read order retrieval-friendly: small router first, then only the lowest-cost doctrine pack that actually answers the question.

## Router law

- start with kernel/settings/file-map, then branch by task
- do not default to loading every wrapper pack for every task
- prefer one hot-path doctrine pack plus one support pack when needed
- use maintenance surfaces only for refresh/audit/control continuity work

## Task router

| Task | Read first | Then read | Primary Blueprint roots compiled |
|---|---|---|---|
| Aurora identity, authority, active-vs-historical law | `AURORA_WRAPPER_CONTROL_PACK.md` | `AURORA_WRAPPER_BRIDGE_PACK.md` if ownership boundary matters | office files, control index, operator protocol, recovery order, progress tracker, build/scope locks |
| End-to-end execution flow or object-chain questions | `AURORA_WRAPPER_EXECUTION_PACK.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` if schema/example certainty is needed | workflow packet, wrapper object model, enum registry, status alignment, abundance law, stage taxonomy, deployability, geometry, card, packet, review, opportunity, EA-boundary specs |
| Family routing or family competition | `AURORA_WRAPPER_FAMILY_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for worked anchors | family registry, family system map, core family files, family cards, family competition protocol/schema/example |
| Pattern routing or pattern competition | `AURORA_WRAPPER_PATTERN_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for worked anchors | pattern atlas, pattern cards, pattern competition protocol/schema/example |
| ASC context intake, missingness, or bridge ownership | `AURORA_WRAPPER_BRIDGE_PACK.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | ASC contract, joint evolution protocol, real ASC intake example |
| Packet shape, review behavior, family-lane path, or worked examples | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | packet schema, group-context schema, review packet schema, family lane packet, worked example packet, review packet, object example |
| Wrapper package audit or replacement | `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` | source files listed there | latest run, office canon, current doctrine/protocol roots |

## File classes

### Default hot path
- `AURORA_WRAPPER_CONTROL_PACK.md`
- `AURORA_WRAPPER_EXECUTION_PACK.md`
- `AURORA_WRAPPER_FAMILY_VAULT.md`
- `AURORA_WRAPPER_PATTERN_VAULT.md`
- `AURORA_WRAPPER_BRIDGE_PACK.md`

### Conditional hot-path support
- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### Router / metadata surfaces
- `AURORA_WRAPPER_KERNEL.md`
- `AURORA_WRAPPER_SETTINGS.md`
- `AURORA_WRAPPER_FILE_MAP.md`

### Maintenance-only
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/office/SHA_LEDGER.md`
- `Aurora Blueprint/runs/`

## Reading patterns by job type

### Fast operator read
`KERNEL → SETTINGS → FILE_MAP → one primary doctrine pack`

### Higher-certainty reasoning read
`KERNEL → SETTINGS → FILE_MAP → primary doctrine pack → secondary doctrine/support pack`

### Refresh / replacement read
`KERNEL → SETTINGS → FILE_MAP → MAINTENANCE_GUIDE → Blueprint source roots → latest run / SHA surfaces`

## Source-truth-only classes

Keep these out of wrapper doctrine hot path except when refreshing the compilation:
- office logs, checkpointing, and append-only runs
- extraction ledgers, supplements, and queueing artifacts
- archive mirrors and superseded generations
- raw doctrine residue that is already represented by active consolidated family, pattern, bridge, and execution files
