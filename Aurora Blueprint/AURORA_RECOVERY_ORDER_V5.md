# AURORA RECOVERY ORDER V5

## PURPOSE

This file defines the exact read order a fresh chat must use to recover current Aurora Blueprint truth correctly after the office-layer hardening pass, merged ledger V2, and the deepening-pass protocol.

The goal is to prevent:
- stale-control drift
- missing office law
- missing ledger V2 plus latest supplement truth
- entering Wave 2 consolidation with pre-office assumptions
- colliding with existing source-set or run IDs

---

# 1. MANDATORY RECOVERY ORDER

A fresh Aurora Blueprint chat must read in this exact order:

1. `Aurora Blueprint/office/README.md`
2. `Aurora Blueprint/office/AURORA_OFFICE_CANON.md`
3. `Aurora Blueprint/office/TASK_BOARD.md`
4. `Aurora Blueprint/office/DECISIONS.md`
5. `Aurora Blueprint/office/WORK_LOG.md`
6. `Aurora Blueprint/office/SHA_LEDGER.md`
7. `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
8. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
9. `Aurora Blueprint/AURORA_RECOVERY_ORDER_V5.md`
10. `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`
11. latest file in `Aurora Blueprint/runs/`
12. `Aurora Blueprint/AURORA_DEEPENING_PASS_PROTOCOL_001.md`
13. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_COMPLETION_PROTOCOL.md`
14. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_LEDGER_V2.md`
15. latest ledger supplement not yet merged into Ledger V2
16. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
17. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
18. `Aurora Blueprint/AURORA_EXTRACTION_QUEUE.md`
19. if working on bridge/wrapper/machine surfaces, read the relevant bridge and object/protocol files before editing
20. if working on Wave 1 doctrine, read the consolidated Wave 1 files first
21. if working on Wave 2 doctrine, read:
   - `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`
   - `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`
   - relevant files in `Aurora Blueprint/strategy_families/`
   - relevant files in `Aurora Blueprint/patterns/`
   - relevant Wave 2 strengthening files only after the target consolidated lane is understood
22. if working on Wave 3 doctrine, read `AURORA_RESEARCH_METHOD_WAVE3_CONSOLIDATED.md` first, then relevant strengthening files only if needed
23. if working on Wave 4 doctrine, read `AURORA_HOSTILE_ENVIRONMENT_WAVE4_CONSOLIDATED.md` first, then relevant strengthening files only if needed
24. if working on Wave 5 doctrine, read `AURORA_REVIEW_ADAPTATION_BEHAVIORAL_CONSOLIDATED.md` first, then relevant strengthening files only if needed
25. only then, the specific books or legacy/reference sources needed for the current task

---

# 2. WHY THIS ORDER EXISTS

## Steps 1–15
Recover office law, control truth, tracker truth, run continuity, deepening law, and merged-ledger-plus-delta truth first.

## Steps 16–19
Recover architecture, source universe, queue logic, and the active bridge/wrapper protocols needed for precise work.

## Steps 20–24
Recover the active consolidated doctrine surface relevant to the task.

## Step 25
Only then return to raw source books or legacy references.

This prevents:
- source-first drift
- stale-control drift
- stale-ledger drift
- pre-office drift
- rebuilding layers that already exist in stronger canonical form

---

# 3. CURRENT JUDGMENT

Aurora recovery must now be:
- office-aware
- repo-truth-first
- ledger-aware
- consolidated-surface-first
- deepening-aware
- bridge-aware when wrapper or machine work is touched

This file exists so future chats can recover the real active state directly from the repo.
