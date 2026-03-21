# AURORA WRAPPER PACKAGE ARCHITECTURE V1

## PURPOSE

This file defines the intended final package architecture for `Aurora Wrapper/` as a standalone compiled canon.

Its job is to prevent wrapper growth from becoming accidental.

The wrapper should not merely stay under a ceiling.
It should stay:
- low-count
- standalone-capable
- clearly routed
- replaceable by pack
- strong enough for GPT-only usage when `Aurora Blueprint/` is unavailable in the session

---

## ROOT DESIGN LAW

The wrapper must be designed as a standalone compiled operating package, not as a neat summary set.

That means:
- each file must have a clean job
- file boundaries must follow reasoning flow, not accidental topic clustering
- the package must stay below the hard ceiling of `20` files
- the preferred operating range remains `8–12` files
- if the wrapper grows beyond `12`, that growth must be justified by clear standalone benefit

---

## CURRENT PACKAGE JUDGMENT

Current wrapper shape is already good enough to preserve.
The correct move is not to redesign from zero.
The correct move is to lock a final package model and deepen toward it carefully.

Current strengths:
- tiny kernel discipline
- clear file map
- clean hot-path routing
- good major-pack separation
- maintenance path kept separate

Current risk:
- standalone hardening could create random support files unless the target package architecture is explicit first

---

## TARGET PACKAGE SIZE

### Hard ceiling
- absolute maximum: `19` files

### Preferred final range
- preferred final operating range: `10–14` files

### Best-current target
- target end-state: `12` files

Why `12` is the best current target:
- enough room for standalone sufficiency
- enough room for proper packet/example and maintenance separation
- still compact enough for GPT upload/use
- still disciplined enough to avoid wrapper sprawl

---

## TARGET FILE CLASSES

The wrapper should be organized into five classes only.

### 1. Router / metadata class
Purpose:
- identify package status
- define read order
- define package boundaries

Files:
1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`

### 2. Core doctrine hot path
Purpose:
- carry the main standalone operational doctrine

Files:
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`

### 3. Support hot path
Purpose:
- carry examples, packets, reviews, and edge-case anchors without bloating the central doctrine packs

Files:
9. `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`

### 4. Package-governance / maintenance class
Purpose:
- support refresh, recompilation, replacement, and drift prevention

Files:
10. `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
11. `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`

### 5. Package-architecture lock class
Purpose:
- define the intended wrapper package shape and file-budget law so future growth remains disciplined

Files:
12. `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`

---

## TARGET FINAL FILE SET

The current best-designed end-state is therefore:

1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`
9. `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md`
10. `AURORA_WRAPPER_MAINTENANCE_GUIDE.md`
11. `AURORA_WRAPPER_STANDALONE_REQUIREMENTS_V1.md`
12. `AURORA_WRAPPER_PACKAGE_ARCHITECTURE_V1.md`

This is the current preferred wrapper package target.

---

## READING FLOW

The wrapper should support four clean reading flows.

### Flow A — fast standalone operator flow
`KERNEL → SETTINGS → FILE_MAP → one primary doctrine pack`

Use when:
- normal GPT wrapper session
- user asks one bounded Aurora question
- low-cost retrieval is preferred

### Flow B — higher-certainty reasoning flow
`KERNEL → SETTINGS → FILE_MAP → primary doctrine pack → one support pack`

Use when:
- packet/example certainty is needed
- family-pattern interaction is contested
- bridge or review law matters

### Flow C — wrapper-only standalone recovery flow
`KERNEL → SETTINGS → FILE_MAP → CONTROL_PACK → EXECUTION_PACK → relevant doctrine vault`

Use when:
- Blueprint is unavailable in the session
- wrapper must stand on its own
- GPT must recover system posture from wrapper files alone

### Flow D — maintenance / refresh flow
`KERNEL → SETTINGS → FILE_MAP → MAINTENANCE_GUIDE → STANDALONE_REQUIREMENTS → PACKAGE_ARCHITECTURE`

Use when:
- recompiling wrapper packs
- checking drift
- deciding whether a new wrapper file is justified

---

## FILE BOUNDARY LAW

### Kernel
Must remain tiny.
It should route, not explain the whole system.

### Settings
Must remain compact metadata and package law.
It should not become doctrine-heavy.

### File map
Must remain a routing surface.
It should not duplicate pack content.

### Control pack
Carries identity, authority, phase honesty, and wrapper operating boundaries.
It must stay small enough to orient quickly.

### Execution pack
This is the wrapper gravity center.
It carries the main chain and therefore has the highest bloat risk.
It should be the richest single pack, but still bounded.

### Family vault
Carries family-first ontology and current core family canon.
It must not collapse into generic directional commentary.

### Pattern vault
Carries pattern-second doctrine and pattern competition rules.
It must remain downstream of family truth.

### Bridge pack
Carries missingness and ownership law.
It must remain strict and refusal-capable.

### Packet/example vault
Carries worked anchors, schema expectations, and review logic.
It should absorb more examples rather than forcing examples into every doctrine pack.

### Maintenance guide
Carries replacement and refresh rules.
It must stay off the default hot path.

### Standalone requirements
Carries the standalone sufficiency target.
It prevents hidden Blueprint dependence.

### Package architecture file
Carries the package shape lock.
It prevents random file-count drift.

---

## RULE FOR ADDING A NEW WRAPPER FILE

A new wrapper file is allowed only if all of the following are true:
1. the current pack structure cannot absorb the material cleanly
2. adding the material to an existing pack would make routing worse
3. the new file improves standalone sufficiency materially
4. the new file keeps total wrapper count below `20`
5. the new file does not duplicate Blueprint source truth lazily

If these are not all true, deepen an existing pack instead.

---

## CURRENT DESIGN DECISION

At this stage, the wrapper should be designed toward a `12-file` final architecture.

That is:
- compact enough for upload and GPT use
- rich enough for standalone compiled canon behavior
- organized enough to preserve proper flow
- strict enough to avoid future sprawl

This should now govern future wrapper hardening passes.
