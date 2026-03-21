# AURORA WRAPPER PACKAGE ARCHITECTURE V1

## PURPOSE

This file locks the intended long-run package shape for `Aurora Wrapper/`.
Its job is to keep the wrapper rich enough for standalone operation without drifting into file sprawl, duplicated doctrine, or a giant monolithic prompt dump.

## ROOT DESIGN LAW

The wrapper should be:
- standalone-capable
- source-truth-faithful
- grouped by function
- rich in doctrine
- low in file count
- easy to refresh by owning pack

The architecture should prefer richer owning packs over parallel pack-plus-manual duplication.

## CURRENT PACKAGE JUDGMENT

The wrapper has now completed the expected consolidation move:
- control manual merged into control pack
- execution manual merged into execution pack
- family routing manual merged into family vault
- pattern routing manual merged into pattern vault
- bridge operating manual merged into bridge pack
- packet/review operating manual merged into packet/example vault

That returns the package to the intended stable architecture instead of a transitional 19-file split.

## TARGET PACKAGE SIZE

### Hard ceiling
19 files maximum.

### Preferred final range
12–14 files.

### Best-current target
13 files.

## TARGET FILE CLASSES

### 1. Router / metadata class
1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`

### 2. Core doctrine hot path
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`

### 3. Support hot path
9. `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### 4. Package-governance / maintenance class
10. `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
11. `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`
12. `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`
13. `AURORA_WRAPPER_STANDALONE_AUDIT_V1.md`

## TARGET FINAL FILE SET

The final operating package should consist of the 13 files listed above.
No parallel operating-manual companions should remain unless a future pass proves one truly earns permanent separation.

## READING FLOW

### Flow A — fast standalone operator flow
`KERNEL → SETTINGS → FILE_MAP → one doctrine pack`

### Flow B — higher-certainty reasoning flow
`KERNEL → SETTINGS → FILE_MAP → doctrine pack → support pack if needed`

### Flow C — wrapper-only standalone recovery flow
`KERNEL → SETTINGS → FILE_MAP → CONTROL_PACK → task owner pack → PACKET_EXAMPLE as needed`

### Flow D — maintenance / refresh flow
`KERNEL → SETTINGS → FILE_MAP → MAINTENANCE_GUIDE → governance files → Blueprint roots → latest run / SHA`

## FILE BOUNDARY LAW

### Kernel
Small router and boundary file only.

### Settings
Status, file-count target, run ref, and operating modes.

### File map
Task routing and source-root map.

### Control pack
Identity, authority, build/scope locks, refusal, and anti-drift law.

### Execution pack
Stage chain, objects, enums, opportunity/deployability/geometry/card law, and packet/review consequences.

### Family vault
Family competition and current core family ecology.

### Pattern vault
Pattern competition and current pattern ecology.

### Bridge pack
ASC ownership, missingness, downgrade/refusal, and joint-evolution posture.

### Packet/example vault
Concrete schema anchors, worked-example anchors, and review law.

### Maintenance/governance files
Refresh workflow, standalone bar, architecture lock, and audit findings.

## RULE FOR ADDING A NEW WRAPPER FILE

A new file must materially improve:
- grouping
- ambiguity reduction
- standalone usefulness
- refresh safety

and must not simply duplicate owning-pack doctrine.
If the knowledge fits cleanly into an existing owner, enrich the owner instead.

## CURRENT DESIGN DECISION

The owning-pack model is now locked as the preferred wrapper architecture.
Future temporary densification files may be created only as scaffolds and should be merged back out once the owning pack is strong enough.
