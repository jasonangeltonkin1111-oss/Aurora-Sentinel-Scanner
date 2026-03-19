# AURORA RECOVERY ORDER V2

## PURPOSE

This file defines the exact read order a fresh chat must use to recover current Aurora Blueprint truth correctly after Source Set 002, tracker V3, and the Wave 1 consolidation guide.

The goal is to prevent:
- restarting from a thinner pre-strengthening picture
- missing the strengthening stack
- confusing grounded files with later strengthening files
- skipping the consolidation instruction layer
- losing continuity when chats become bloated

---

# 1. MANDATORY RECOVERY ORDER

A fresh Aurora Blueprint chat must read in this exact order:

1. `Aurora Blueprint/AURORA_CONTROL_INDEX_V2.md`
2. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
3. `Aurora Blueprint/AURORA_RECOVERY_ORDER_V2.md`
4. `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V3.md`
5. latest file in `Aurora Blueprint/runs/` if present
6. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
7. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
8. `Aurora Blueprint/AURORA_EXTRACTION_QUEUE.md`
9. if working on Wave 1 grounding or hardening, read:
   - `Aurora Blueprint/passes/AURORA_Q1_SOURCE_PASS_001.md`
   - `Aurora Blueprint/AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md`
   - `Aurora Blueprint/AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md`
   - `Aurora Blueprint/AURORA_WAVE1_CROSSLINK_MAP.md`
10. if working on Wave 1 strengthening or consolidation, then also read:
   - `Aurora Blueprint/source_sets/SOURCE_SET_002_MANIFEST.md`
   - `Aurora Blueprint/passes/Q1/AURORA_Q1_SOURCE_PASS_002.md`
   - `Aurora Blueprint/doctrine/WAVE1/MARKET_STATE/AURORA_MARKET_STATE_Q1_STRENGTHENING_002.md`
   - `Aurora Blueprint/doctrine/WAVE1/EXECUTION_CONTEXT/AURORA_EXECUTION_CONTEXT_Q1_STRENGTHENING_002.md`
   - `Aurora Blueprint/doctrine/WAVE1/AURORA_WAVE1_CONSOLIDATION_GUIDE.md`
11. `archives/Aurora/README.md`
12. `archives/Aurora/AURORA_FUTURE_INDEX.md`
13. `archives/Aurora/ASC_PHASE1_INDEX.md`
14. only then, the specific books needed for the current extraction task

---

# 2. WHY THIS ORDER EXISTS

## Step 1–5
Recover current control truth and continuity first.

## Step 6–8
Recover architecture, source universe, and queue logic.

## Step 9
Recover the grounded Wave 1 base stack.

## Step 10
Recover the strengthening and consolidation layer only after the grounded base is understood.

## Step 11–14
Recover archive boundaries and then source books.

This prevents:
- source-first drift
- strengthening-first drift without base understanding
- accidental loss of state-vs-surface boundaries

---

# 3. ACTIVE DESTINATION FILES CURRENTLY KNOWN

## Wave 1 grounded files
- `AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md`
- `AURORA_WAVE1_CROSSLINK_MAP.md`

## Wave 1 strengthening files
- `AURORA_MARKET_STATE_Q1_STRENGTHENING_002.md`
- `AURORA_EXECUTION_CONTEXT_Q1_STRENGTHENING_002.md`

## Wave 1 consolidation instruction
- `AURORA_WAVE1_CONSOLIDATION_GUIDE.md`

## Next likely doctrine outputs
- `AURORA_MARKET_STATE_CANON_WAVE1_CONSOLIDATED.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE_WAVE1_CONSOLIDATED.md`

---

# 4. RECOVERY CHECKLIST

A fresh chat should not begin new work until it can answer:

1. what is already grounded?
2. what is only strengthening and not yet consolidated?
3. what remains scaffold-only?
4. what is the next file to create or deepen?
5. which books are relevant to that next file?
6. what continuity artifact must be updated before ending the run?

If these answers are unclear, recovery is incomplete.

---

# 5. CURRENT JUDGMENT

Aurora Blueprint is now large enough that recovery must be layered:
- control truth
- grounded base truth
- strengthening truth
- consolidation instruction
- archive boundary
- source materials

This file exists so future chats can recover that structure directly from the repo rather than guessing from older partial control files.
