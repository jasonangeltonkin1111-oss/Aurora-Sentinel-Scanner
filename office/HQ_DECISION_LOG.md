# HQ DECISION LOG

## Purpose
This file is append-only HQ memory for major decisions.

Use it to preserve:
- why a wave advanced
- why a wave failed
- why a correction wave was opened
- why scope was blocked
- why a HOLD was issued

This is not a full diary.
Only record load-bearing decisions that matter for future HQ recovery.

---

## Entries

### 2026-03-18 — Control-layer harmonization locked
- Decision: harmonize the office/control layer before implementation
- Why: worker model, module ownership, and summary grouping still had contradictory wording
- Result: locked 7-role control model, clarified `PrimaryBucket` truth, and strengthened HQ handoff behavior

### 2026-03-18 — Archive surgical mapping completed
- Decision: perform deep archive review before further implementation planning
- Why: needed exact separation of TRANSLATE vs REFERENCE ONLY vs DO NOT USE legacy truth
- Result: first-slice and later-slice archive truth became clearer, and remaining blueprint gaps were identified explicitly

### 2026-03-18 — Foundation gap closure completed
- Decision: close remaining first-slice blueprint/control gaps before product implementation
- Why: Layer 1 sub-states, Layer 1.2 minimum snapshot shape, and persistence fallback/corruption behavior were still too weak for precise worker packets
- Result: foundation became materially implementation-ready

### 2026-03-18 — Parallel Wave 1 build approved
- Decision: run the 4 build workers in parallel
- Why: the 7-role worker model and ownership boundaries were now strong enough for a bounded parallel build wave
- Result: Engine, Market, Conditions, and Storage + Output foundation code was produced in parallel

### 2026-03-18 — Clerk and Debug both failed Wave 1
- Decision: do not advance; open Wave 1 Fix
- Why: Clerk found structural/compliance problems and Debug found integration/contract/logic problems, including compile-risk and shared-contract drift
- Result: progression blocked pending targeted fix packets

### 2026-03-18 — Worker-checkout sync issue recognized
- Decision: treat missing required files in one fix worker checkout as synchronization/state failure, not as worker permission to improvise
- Why: a Conditions fix worker correctly reported missing owned files/review files and refused to freestyle outside scope
- Result: repo-state precheck and sync discipline became an explicit HQ concern before future worker execution

### 2026-03-18 — Blueprint integrity hardening run completed
- Decision: strengthen blueprint law before another debug cycle
- Why: live Wave 1 failures exposed remaining ambiguity around unresolved classification handling, partial snapshot overwrite risk, tie-handling determinism, and front-door recovery references
- Result: active blueprint law and front-door navigation were tightened, and HQ now has an explicit integrity audit to enforce before rerunning Debug

### 2026-03-18 — Wave 1 fix merges require post-fix review normalization
- Decision: treat the merged Engine/Storage, Market, and Conditions fix commits as the new live repo baseline and shift HQ into post-fix review mode
- Why: the fix wave has landed in product code, but `HQ_STATE.md`, worker handoffs, and the last Debug review no longer fully describe the current repo truth
- Result: Clerk must normalize control docs, Debug must rerun against the merged MT5 state, and HQ must keep progression blocked until those records are current

### 2026-03-19 — Post-fix review loop completed and normalized
- Decision: treat blueprint hardening, merged Wave 1 fix commits, post-fix Clerk review, and post-fix Debug review as the new live repo baseline
- Why: the product layer no longer reflects the earlier Wave 1 blocker state, and the remaining lag was in office/control continuity rather than unresolved core MT5 blockers
- Result: Clerk recorded `PASS WITH CLERK CORRECTIONS`, Debug recorded `PASS WITH NON-BLOCKING FIXES`, control-layer normalization became the final active office task, and HQ may now prepare to advance beyond the current fix loop without rewriting later layers as complete

### 2026-03-19 — Canonical non-Aurora system/archive map added
- Decision: add `office/MASTER_SYSTEM_ARCHIVE_MAP.md` as the canonical office reference for current ASC lineage, non-Aurora legacy systems, and archive-to-ASC translation guidance
- Why: the repository had front-door archive maps and surgical references, but it did not yet have one deep office document joining current ASC truth, office/blueprint law, and the full non-Aurora archive landscape into a single recoverable spine
- Result: future HQ and workers now have a durable lineage map that distinguishes high-value translation sources, historical-only sources, dangerous legacy patterns, and the main gaps ASC still has relative to legacy systems

### 2026-03-19 — Canonical legacy recovery execution plan added
- Decision: add `office/LEGACY_RECOVERY_EXECUTION_PLAN.md` as the operational bridge between the master archive map and future archive-to-ASC recovery packets
- Why: the repository now had strong lineage and code-translation intelligence, but future HQ still needed one canonical document that converts that intelligence into bounded module-specific recovery order, readiness states, and worker-packet requirements
- Result: future HQ can now issue surgical recovery prompts with explicit ready-now vs blocked vs future-layer distinctions without re-deriving archive sequencing from scratch
