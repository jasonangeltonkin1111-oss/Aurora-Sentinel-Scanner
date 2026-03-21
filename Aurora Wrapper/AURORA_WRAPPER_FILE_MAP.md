# AURORA WRAPPER FILE MAP

## Purpose

This file routes wrapper tasks to the smallest correct pack and records which source areas were compiled into each pack.

## Wrapper task router

| Task | Read first | Then read | Source roots compiled |
|---|---|---|---|
| Aurora identity, control law, active-vs-historical boundary | `AURORA_WRAPPER_CONTROL_PACK.md` | `AURORA_WRAPPER_BRIDGE_PACK.md` if ASC boundary matters | office files, control index, operator protocol, recovery order, tracker, active doctrine posture |
| End-to-end execution flow | `AURORA_WRAPPER_EXECUTION_PACK.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` | workflow packet, object model, enums, status alignment, deployability, geometry, card, packet, review, opportunity, EA-safe spec |
| Family selection | `AURORA_WRAPPER_FAMILY_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for examples | family registry, family system map, core family files, family cards, family competition protocol/schema/example |
| Pattern selection | `AURORA_WRAPPER_PATTERN_VAULT.md` | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` for examples | pattern atlas, pattern cards, pattern competition protocol/schema/example |
| ASC context intake / missingness handling | `AURORA_WRAPPER_BRIDGE_PACK.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | ASC contract, joint evolution protocol, real ASC intake example |
| Packet shape / review / worked example anchoring | `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` | `AURORA_WRAPPER_EXECUTION_PACK.md` | packet schema, group context schema, review packet schema, family lane packet, worked example packet, review packet, object example |
| Wrapper package maintenance | `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` | source files named there | latest run, office canon, source doctrine roots |

## Pack boundaries

### Hot path
- `AURORA_WRAPPER_CONTROL_PACK.md`
- `AURORA_WRAPPER_EXECUTION_PACK.md`
- `AURORA_WRAPPER_FAMILY_VAULT.md`
- `AURORA_WRAPPER_PATTERN_VAULT.md`
- `AURORA_WRAPPER_BRIDGE_PACK.md`

### Conditional hot-path support
- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### Maintenance only
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
- `AURORA_WRAPPER_FILE_MAP.md`
- `AURORA_WRAPPER_SETTINGS.md`

## Source-truth-only classes

Keep these in `Aurora Blueprint/` and out of wrapper hot path except for maintenance refresh:
- office logs and SHA checkpointing
- append-only runs
- extraction ledgers and supplements
- extraction queue and pass scheduling
- strengthening residue already compiled into consolidated doctrine
- archival mirrors and superseded generations
