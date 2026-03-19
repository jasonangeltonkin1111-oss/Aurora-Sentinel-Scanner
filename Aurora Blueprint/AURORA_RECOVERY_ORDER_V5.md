# AURORA RECOVERY ORDER V5

## PURPOSE

This file defines the exact read order a fresh chat must use to recover current Aurora Blueprint truth correctly after the first consolidation trio, merged ledger V2, and the deepening-pass protocol.

The goal is to prevent:
- restarting from a pre-consolidation picture
- missing ledger V2 truth
- missing the deepening-pass law
- entering Wave 2 consolidation with stale assumptions
- colliding with existing source-set or run IDs

---

# 1. MANDATORY RECOVERY ORDER

A fresh Aurora Blueprint chat must read in this exact order:

1. `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
2. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
3. `Aurora Blueprint/AURORA_RECOVERY_ORDER_V5.md`
4. `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`
5. latest file in `Aurora Blueprint/runs/`
6. `Aurora Blueprint/AURORA_DEEPENING_PASS_PROTOCOL_001.md`
7. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_COMPLETION_PROTOCOL.md`
8. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_LEDGER_V2.md`
9. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
10. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
11. `Aurora Blueprint/AURORA_EXTRACTION_QUEUE.md`
12. if working on Wave 1 doctrine, read the consolidated Wave 1 files
13. if working on Wave 2 doctrine, read:
   - `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`
   - `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`
   - relevant files in `Aurora Blueprint/strategy_families/`
   - relevant files in `Aurora Blueprint/patterns/`
   - relevant Wave 2 strengthening files
14. if working on Wave 3 doctrine, read `AURORA_RESEARCH_METHOD_WAVE3_CONSOLIDATED.md` first, then relevant strengthening files only if needed
15. if working on Wave 4 doctrine, read `AURORA_HOSTILE_ENVIRONMENT_WAVE4_CONSOLIDATED.md` first, then relevant strengthening files only if needed
16. if working on Wave 5 doctrine, read `AURORA_REVIEW_ADAPTATION_BEHAVIORAL_CONSOLIDATED.md` first, then relevant strengthening files only if needed
17. only then, the specific books or legacy/reference sources needed for the current task

---

# 2. WHY THIS ORDER EXISTS

## Step 1–8
Recover current control truth, tracker truth, deepening law, and merged ledger truth first.

## Step 9–11
Recover architecture, source universe, and queue logic.

## Step 12–16
Recover the active consolidated doctrine surface relevant to the current task.

## Step 17
Only then return to raw source books or legacy references.

This prevents:
- source-first drift
- stale-control drift
- stale-ledger drift
- pre-consolidation drift
- rebuilding layers that already exist in stronger canonical form

---

# 3. CURRENT JUDGMENT

Aurora Blueprint recovery must now be:
- repo-truth-first
- ledger-aware
- consolidated-surface-first
- deepening-aware

This file exists so future chats can recover the real active state directly from the repo.
