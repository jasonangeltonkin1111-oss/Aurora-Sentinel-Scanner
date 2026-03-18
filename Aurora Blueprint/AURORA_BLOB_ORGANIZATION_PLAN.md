# AURORA BLOB ORGANIZATION PLAN

## PURPOSE

This file defines how Aurora Blueprint should organize many small extraction artifacts safely.

The goal is:
- no data loss
- no missing extraction residue from uploaded source sets
- easier future updates
- easier Codex consolidation later

This project is now allowed to create many small artifacts, as long as they are organized, logged, and recoverable.

---

# 1. ORGANIZATION PRINCIPLE

Aurora Blueprint should prefer:
- many small traceable artifacts
over
- a few giant mixed files

This is acceptable **only if** each artifact is:
- named clearly
- placed in the right folder
- linked to its source set
- linked to its destination module
- logged in a run file or registry

---

# 2. FOLDER MODEL

## Control layer
Use for continuity and handover truth:
- `Aurora Blueprint/`
- `Aurora Blueprint/runs/`

## Source-pass layer
Use for extraction artifacts by upload set or pass:
- `Aurora Blueprint/passes/`
- `Aurora Blueprint/passes/Q1/`
- later `Aurora Blueprint/passes/Q2/`, etc.

## Source-set registry layer
Use for mapping each uploaded batch to outputs:
- `Aurora Blueprint/source_sets/`

## Doctrine layer
Use for grounded module doctrine by wave:
- `Aurora Blueprint/doctrine/WAVE1/`
- later `Aurora Blueprint/doctrine/WAVE2/`, etc.

## Index / manifest layer
Use for registries and manifests:
- `Aurora Blueprint/indexes/`

---

# 3. REQUIRED ARTIFACT TYPES

For each meaningful uploaded source set, Aurora should ideally create:

## 3.1 Source-set manifest
Records:
- which books were uploaded
- what Aurora needed from them
- what was extracted now
- what was deferred later
- which output files were created from the set

## 3.2 Source-pass artifact
Records extracted doctrine in a reusable form.

## 3.3 Integration artifact(s)
Records which active doctrine files were grounded from the pass.

## 3.4 Run log
Records exactly what changed in the repo that run.

---

# 4. NAMING RULES

## Source-set manifests
Format:
- `SOURCE_SET_###_MANIFEST.md`

## Source passes
Format:
- `AURORA_Q#_SOURCE_PASS_###.md`

## Doctrine integrations
Format:
- `<MODULE_NAME>_Q#_INTEGRATED.md`

## Run logs
Format:
- `AURORA_RUN_###.md`

---

# 5. CURRENT JUDGMENT

The project now has enough complexity that strict blob organization is useful.

This plan allows:
- complete extraction residue preservation
- future Codex consolidation into larger canonical files
- easier tracking of what each upload set contributed
