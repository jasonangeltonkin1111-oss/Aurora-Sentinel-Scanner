# ASC Deep Markdown Build Pack

This pack is a **code-generation oriented reconstruction manual** for the newest Aurora Sentinel Scanner (ASC) blueprint found in the uploaded archive.

It is designed for:
- GPT/Codex style code generation
- human implementation review
- architecture-preserving MT5 rebuild work
- preventing archive drift, scope creep, and naming corruption

## What this pack does

This pack translates four source layers into one practical build canon:

1. **Active `blueprint/`** — the current working canon for the new build.
2. **`mt5_runtime_flat/`** — the current foundation implementation surface.
3. **`archives/Asc Archive 2/ASC Blueprint/`** — the deepest runtime and persistence doctrine.
4. **older archive and lineage systems** — design evidence, migration clues, anti-patterns, and reusable primitives.

## What this pack does not do

It does not:
- treat old archive files as active truth when they conflict with the new blueprint
- pretend the current foundation already implements the full scanner
- confuse scanner selection with trade advice
- confuse trader-facing language with internal runtime labels

## Important interpretation

The user asked for deep use of the “3 cfm files”. In the uploaded zip those appear to be the three compiled help manuals:

- `mql5.chm`
- `mql5book.chm`
- `neuronetworksbook.chm`

This environment cannot directly unpack CHM files, so this pack cross-walks their relevant MQL5 runtime/API subject matter against the official online MQL5 documentation and the archive’s own code/blueprint material.

## Read order

1. `01_ASC_MASTER_CANON.md`
2. `02_ASC_ARCHIVE_RESOLUTION.md`
3. `03_ASC_RUNTIME_KERNEL_AND_EVENT_MODEL.md`
4. `04_ASC_MARKET_STATE_TRUTH_MODEL.md`
5. `05_ASC_DISCOVERY_AND_SNAPSHOT_MODULES.md`
6. `06_ASC_LAYER_MODEL_DEEP_SPEC.md`
7. `07_ASC_SCHEDULER_AND_BUDGETING.md`
8. `08_ASC_PERSISTENCE_AND_ATOMIC_WRITE.md`
9. `09_ASC_SYMBOL_DOSSIER_CONTRACT.md`
10. `10_ASC_SUMMARY_AND_PUBLICATION_CONTRACT.md`
11. `11_ASC_MT5_API_CROSSWALK.md`
12. `12_ASC_CODE_SHAPE_AND_FILE_LAYOUT.md`
13. `13_ASC_PSEUDOCODE_AND_IMPLEMENTATION_SKELETONS.md`
14. `14_ASC_ACCEPTANCE_TEST_MATRIX.md`
15. `15_ASC_GPT_CODEGEN_PLAYBOOK.md`
16. `16_ASC_CHM_CROSSWALK_AND_RESEARCH_NOTES.md`
17. `17_ASC_SOURCE_EVIDENCE_MAP.md`

## Output intent

A normal GPT or Codex agent should be able to use this pack to generate:
- the correct MT5 folder/file shape
- the correct runtime/event model
- restore-first persistence
- honest market-state determination
- per-symbol dossier evolution
- later layer growth without architecture drift
