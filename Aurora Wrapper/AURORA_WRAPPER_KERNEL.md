# AURORA WRAPPER KERNEL

## Identity

`Aurora Wrapper/` is the compiled wrapper-facing Aurora canon.
It is derived from `Aurora Blueprint/`, which remains the active research, doctrine, lineage, and source-truth workspace.
This folder exists so a GPT wrapper can ingest Aurora through a small, replaceable, clearly routed file set instead of reading scattered source files directly.

## Scope Boundary

Use this folder for wrapper operation, wrapper assembly, and file-by-file wrapper replacement.
Do not treat it as permission to rewrite, move, or collapse `Aurora Blueprint/`.
Do not treat wrapper packs as higher authority than the source workspace.
When source truth and wrapper compilation diverge, source truth wins and this folder must be refreshed.

## Hot-Path Reading Order

Default wrapper read order:
1. `AURORA_WRAPPER_KERNEL.md`
2. `AURORA_WRAPPER_SETTINGS.md`
3. `AURORA_WRAPPER_FILE_MAP.md`
4. `AURORA_WRAPPER_CONTROL_PACK.md`
5. `AURORA_WRAPPER_EXECUTION_PACK.md`
6. `AURORA_WRAPPER_FAMILY_VAULT.md`
7. `AURORA_WRAPPER_PATTERN_VAULT.md`
8. `AURORA_WRAPPER_BRIDGE_PACK.md`

Load `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` when you need concrete packet shapes, review structure, or worked interpretation anchors.
Load `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` only for update/recompile work.

## Active File Roles

- `AURORA_WRAPPER_SETTINGS.md` = active mode, hot-path list, replacement model, cold-path boundaries.
- `AURORA_WRAPPER_FILE_MAP.md` = routing table from task type to wrapper pack and source roots.
- `AURORA_WRAPPER_CONTROL_PACK.md` = identity, control law, active-vs-historical law, wrapper non-goals, and doctrine posture.
- `AURORA_WRAPPER_EXECUTION_PACK.md` = stage chain, object chain, enums, statuses, deployability, geometry, cards, packets, and safe-output boundaries.
- `AURORA_WRAPPER_FAMILY_VAULT.md` = family-first canon, competition logic, and compiled family doctrine for the current core family set.
- `AURORA_WRAPPER_PATTERN_VAULT.md` = pattern-competition canon and compiled current pattern set.
- `AURORA_WRAPPER_PACKET_EXAMPLE_VAULT.md` = representative packet schemas and worked examples.
- `AURORA_WRAPPER_BRIDGE_PACK.md` = ASC→Aurora contract and bridge discipline.
- `AURORA_WRAPPER_MAINTENANCE_GUIDE.md` = how to refresh this wrapper safely from source truth.

## Routing Law

Route by task, not by convenience.
- If the task is “what is Aurora and what must it not do?”, read control first.
- If the task is “how does Aurora transform context into opportunity/card output?”, read execution first.
- If the task is “which family or pattern is alive?”, read family vault before pattern vault.
- If the task is “what input can ASC provide and what happens when fields are missing?”, read bridge pack.
- If the task is “show concrete object/packet/example shapes”, read the packet/example vault after the execution pack.

Aurora is family-first and pattern-second.
A wrapper must not skip directly from ASC context to geometry, trade plan, or symbol-bound advice.

## Hot-Path Usage Rules

- Keep the operational kernel small; delegate doctrine to the packs.
- Prefer the compiled wrapper packs over source scattering during live wrapper use.
- Preserve missingness, degraded states, and unresolved competition instead of forcing clean answers.
- Read only the packs needed for the current task; do not load cold-path lineage by default.
- Replace a whole pack when a source area changes materially instead of patching many small fragments.

## Active-vs-Historical Rule

Inside wrapper operation, only this folder’s packs plus the still-active source contracts they compile should be treated as wrapper canon.
`Aurora Blueprint/office/`, active control files, active doctrine files, active bridge files, and the latest run remain source-truth control surfaces.
Runs, work logs, SHA ledgers, extraction queues, supplements, strengthening files, and older generations remain lineage or maintenance inputs, not wrapper hot-path doctrine.

## Bridge Rule

ASC owns measured context truth.
Aurora owns interpretation, family/pattern competition, deployability, opportunity posture, and strategy-card generation.
This wrapper pass does not widen the ASC contract.
Current bridge outcome remains `NO_BRIDGE_CHANGE_NEEDED`.

## Anti-Drift / Non-Goals

Never turn Aurora into:
- a generic trading framework
- symbol-bound doctrine
- hidden-score ranking logic
- shallow strategy tips
- a monolithic one-file brain dump
- an archive cleanup excuse

Never erase:
- family competition before pattern competition
- deployability before geometry
- machine-safe versus human-only separation
- active versus historical separation
- source-truth ownership inside `Aurora Blueprint/`
