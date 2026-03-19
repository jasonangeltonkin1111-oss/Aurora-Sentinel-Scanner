# HQ TASK FLOW

## Purpose
This file defines how HQ must think and act.

It is the stable decision-flow law for the repository.
A fresh HQ must use this file to avoid improvising the wrong next action.

---

## Core Principle
HQ does not build product code directly.
HQ:
- reads state
- decides phase
- assigns bounded work
- blocks drift
- requires review
- advances only on evidence

---

## HQ Operating Flow

### Step 1 — Recover state
Read in order:
1. `office/HQ_OPERATOR_MANUAL.md`
2. `README.md`
3. `INDEX.md`
4. `office/HQ_STATE.md`
5. `office/MODULE_OWNERSHIP.md`
6. `office/TASK_BOARD.md`
7. `office/WORKER_RULES.md`
8. `office/LAYERED_BUILD_ORDER.md`
9. `office/TEST_AND_VERIFICATION_PLAN.md`

Then read any active review/handoff files relevant to the current wave.

Do not assign new work before state is recovered.

---

### Step 2 — Identify current phase
HQ must classify the system into exactly one of these modes:
- FOUNDATION
- BUILD WAVE
- REVIEW WAVE
- FIX WAVE
- HOLD
- ADVANCE

Interpretation:
- FOUNDATION = docs/control layer still not sufficiently locked
- BUILD WAVE = bounded implementation work is currently being produced
- REVIEW WAVE = Clerk and/or Debug are actively reviewing the last build/fix outputs
- FIX WAVE = corrections are required before progression
- HOLD = system truth is unclear or repo state is inconsistent; stop and clarify first
- ADVANCE = prior wave passed gates and the next bounded packet may be issued

---

### Step 3 — Enforce repo-state precheck
Before any worker packet in a build or fix wave, HQ must ensure workers are told to:
1. list relevant files in `mt5/` and `office/`
2. confirm required owned files and required review/handoff files are visible
3. stop if required files are missing

If worker checkouts are inconsistent:
- do not treat that as worker failure
- classify it as a synchronization/state problem
- HOLD until the repo state is trustworthy again

---

### Step 4 — Issue bounded worker packets
Every worker packet must specify:
- exact owned files
- exact files forbidden to edit
- exact objective
- exact required reads
- exact non-goals
- exact success condition
- exact handoff update target

Do not issue vague prompts.
Do not let workers improvise adjacent modules.

---

### Step 5 — Run post-run reviews
After build/fix workers complete:
1. run Clerk
2. run Debug

Clerk and Debug may run in parallel only if both are review-only and both write only their own review files.

Neither Clerk nor Debug may silently patch product code unless HQ explicitly opens a correction task.

---

### Step 6 — Evaluate verdicts
Possible outcomes:
- PASS / PASS -> ADVANCE
- PASS WITH CORRECTIONS / PASS WITH CORRECTIONS -> FIX WAVE
- FAIL / PASS WITH CORRECTIONS -> FIX WAVE
- PASS WITH CORRECTIONS / FAIL -> FIX WAVE
- FAIL / FAIL -> FIX WAVE

If the reviews disagree materially:
- HQ must read both reports directly
- classify structural vs logical failures separately
- issue targeted fixes only

---

### Step 7 — Fix wave discipline
In FIX WAVE:
- do not add features
- do not broaden scope
- do not leap to later layers
- fix only what reviews flagged
- rerun Clerk and Debug after the fixes

---

### Step 8 — Advancement discipline
HQ may advance only when:
- current wave has passed the required reviews
- no load-bearing contradiction remains
- repo state is synchronized and trustworthy
- the next layer/domain is unblocked by build order law

---

## Non-Negotiable HQ Rules
- Never skip Clerk.
- Never skip Debug.
- Never mix build and fix casually.
- Never treat missing worker files as permission to improvise.
- Never allow later-slice work to leak into first-slice packets.
- Never let Output steal classification or ranking authority.
- Never let product-facing naming absorb dev/task/phase wording.

---

## Decision Shortcuts

### If the system is unclear
-> HOLD

### If the current wave has unreviewed product changes
-> REVIEW WAVE

### If reviews found load-bearing failures
-> FIX WAVE

### If reviews passed and build order allows progression
-> ADVANCE

### If the foundation/control layer becomes contradictory again
-> FOUNDATION

---

## Review File Hygiene Rule
While a wave is active:
- keep one active Clerk review file for that wave
- keep one active Debug review file for that wave
- keep one active handoff file per worker/domain for that wave

Do not create endless small review files in the office root.
Later archive old review artifacts deliberately if needed.
