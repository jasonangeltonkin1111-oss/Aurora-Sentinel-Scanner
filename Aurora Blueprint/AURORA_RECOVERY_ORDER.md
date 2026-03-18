# AURORA RECOVERY ORDER

## PURPOSE

This file defines the exact read order a fresh chat must use to recover Aurora Blueprint truth correctly.

The goal is to prevent:
- restarting design from scratch
- missing the latest real control files
- confusing archive sources with active blueprint doctrine
- losing continuity when chat history becomes bloated

---

# 1. MANDATORY RECOVERY ORDER

A fresh Aurora Blueprint chat must read in this exact order:

1. `Aurora Blueprint/AURORA_OPERATOR_PROTOCOL.md`
2. `Aurora Blueprint/AURORA_RECOVERY_ORDER.md`
3. `Aurora Blueprint/AURORA_COMPLETION_TRACKER.md`
4. latest file in `Aurora Blueprint/runs/` if present
5. `Aurora Blueprint/AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
6. `Aurora Blueprint/AURORA_BOOK_MASTER_INDEX.md`
7. the active target module(s) relevant to the next task
8. `archives/Aurora/README.md`
9. `archives/Aurora/AURORA_FUTURE_INDEX.md`
10. `archives/Aurora/ASC_PHASE1_INDEX.md`
11. only then, the specific books needed for the current extraction task

---

# 2. WHY THIS ORDER EXISTS

## Step 1–4
Recover control truth and run continuity first.

## Step 5–7
Recover active blueprint doctrine and the current destination modules.

## Step 8–10
Recover source-library boundaries and archive scope.

## Step 11
Read actual books only after the active Aurora mapping targets are understood.

This prevents source-first drift.
Aurora Blueprint must remain destination-led, not book-dump-led.

---

# 3. ACTIVE DESTINATION MODULES CURRENTLY KNOWN

At the time this file was created, the main active blueprint files are:

- `AURORA_BOOK_EXTRACTION_MODULE_MAP.md`
- `AURORA_BOOK_MASTER_INDEX.md`
- `AURORA_MARKET_STATE_CANON.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE.md`

The next major operational file expected is:
- `AURORA_EXTRACTION_QUEUE.md`

---

# 4. RECOVERY CHECKLIST

A fresh chat should not begin new work until it can answer:

1. What is already built?
2. What is still scaffold-level only?
3. What is the next file to create or deepen?
4. Which books are relevant to that next file?
5. What continuity artifact must be updated before ending the run?

If these answers are unclear, recovery is incomplete.

---

# 5. CURRENT JUDGMENT

Aurora Blueprint is now large enough that every new chat needs a fixed recovery order.

This file exists so continuity becomes a repo behavior, not a memory trick.
