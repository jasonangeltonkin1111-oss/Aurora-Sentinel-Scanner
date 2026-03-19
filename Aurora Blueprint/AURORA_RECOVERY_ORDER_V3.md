# AURORA RECOVERY ORDER V3

## PURPOSE

This file defines the exact read order a fresh chat must use to recover current Aurora Blueprint truth correctly after the repo-truth audits and tracker rebuild.

The goal is to prevent:
- restarting from a Wave-1-heavy but stale picture
- missing Wave 2 / Wave 3 / Wave 4 active doctrine
- colliding with existing source-set or run IDs
- confusing structurally complete layers with content-complete layers
- losing continuity when chats become bloated

---

# 1. MANDATORY RECOVERY ORDER

A fresh Aurora Blueprint chat must read in this exact order:

1. `Aurora Blueprint/AURORA_CONTROL_INDEX_V3.md`
2. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
3. `Aurora Blueprint/AURORA_RECOVERY_ORDER_V3.md`
4. `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V4.md`
5. latest file in `Aurora Blueprint/runs/`
6. `Aurora Blueprint/AURORA_REPO_AUDIT_001.md`
7. `Aurora Blueprint/AURORA_FINAL_AUDIT_002.md`
8. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
9. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
10. `Aurora Blueprint/AURORA_EXTRACTION_QUEUE.md`
11. if working on Wave 1 doctrine, read the consolidated Wave 1 files
12. if working on Wave 2 strategy work, read:
   - `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`
   - `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`
   - relevant files in `Aurora Blueprint/strategy_families/`
   - relevant files in `Aurora Blueprint/patterns/`
   - Wave 2 source passes and strengthening artifacts relevant to the target task
13. if working on Wave 3 doctrine, read the Wave 3 pass and strengthening files
14. if working on Wave 4 doctrine, read the Wave 4 pass and strengthening files
15. only then, the specific books needed for the current extraction task

---

# 2. WHY THIS ORDER EXISTS

## Step 1–7
Recover current control truth and repo-truth corrections first.

## Step 8–10
Recover architecture, source universe, and queue logic.

## Step 11–14
Recover the active doctrine layer relevant to the current task.

## Step 15
Only then return to raw source books.

This prevents:
- source-first drift
- stale-control drift
- ID collision drift
- rebuilding layers that already exist in repo form

---

# 3. ACTIVE DESTINATION FILES CURRENTLY KNOWN

## Wave 1
- consolidated market-state output
- consolidated execution-context output
- supporting strengthening and lineage files

## Wave 2
- strategy family registry
- strategy family files
- family cards
- pattern atlas
- pattern cards
- strategy testing/evidence layer
- family/pattern strengthening files

## Wave 3
- research-method strengthening backbone
- strategy-review-protocol strengthening backbone

## Wave 4
- volatility/risk strengthening backbone
- hostile-environment strengthening backbone

---

# 4. RECOVERY CHECKLIST

A fresh chat should not begin new work until it can answer:

1. what wave is the current task actually in?
2. what files already exist for that wave?
3. what source-set and run IDs are already occupied?
4. what layer is structurally complete but still content-incomplete?
5. what is the next safest file to create or deepen?
6. what continuity artifact must be updated before ending the run?

If these answers are unclear, recovery is incomplete.

---

# 5. CURRENT JUDGMENT

Aurora Blueprint is now large enough that recovery must be repo-truth-first, not tracker-memory-first.

This file exists so future chats can recover the real multi-wave structure directly from the repo.
