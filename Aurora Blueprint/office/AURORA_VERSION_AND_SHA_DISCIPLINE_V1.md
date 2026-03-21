# AURORA VERSION AND SHA DISCIPLINE V1

## PURPOSE

This file formalizes the minimum continuity discipline for meaningful Aurora updates.

It exists because Aurora now has:
- active office control
- active canonical doctrine surfaces
- active wrapper compilation
- an active SHA ledger
- append-only run continuity

That means future work can no longer rely on implicit update hygiene.
The discipline must be explicit.

---

## ROOT LAW

A meaningful Aurora update is not complete unless continuity remains honest.

That means future GPT, Codex, and operator passes must treat:
- file content
- version posture
- run continuity
- SHA continuity
- control-surface freshness

as one connected system.

---

## 1. WHEN THIS DISCIPLINE APPLIES

Apply this discipline whenever an Aurora pass materially changes any of the following:
- active office/control truth
- active canonical doctrine or protocol truth
- active wrapper canon
- run-continuity posture
- active recovery / tracker / task posture

Small typo fixes do not always require the full package.
Meaningful architectural, doctrinal, control, wrapper, or workflow changes do.

---

## 2. VERSION-AWARE UPDATE LAW

When a meaningful Aurora pass lands, the pass should update version posture honestly.

Use one or more of these mechanisms depending on file type:
- bump the file generation/version when the file is versioned that way
- refresh internal status/version metadata when the file uses internal version fields
- create the next append-only run file when continuity meaningfully changed
- refresh wrapper status when wrapper compilation posture changed materially
- refresh task-map or control-map version references when those surfaces changed materially

Do not materially change active truth while leaving version posture misleadingly static.

---

## 3. SHA-AWARE UPDATE LAW

If a meaningful pass changes any active file already covered by `Aurora Blueprint/office/SHA_LEDGER.md`, the SHA ledger must be refreshed in the same pass.

If a new file becomes active control truth or active canonical truth, decide explicitly whether it now belongs in SHA coverage.
Do not let the ledger drift by omission.

The ledger is not decorative.
It is a checkpoint surface.

---

## 4. MINIMUM CONTINUITY PACKAGE

At minimum, a meaningful Aurora pass should update:
1. the actual target file or files
2. the next run file if the pass is continuity-meaningful
3. the SHA ledger when covered files changed materially
4. the office/control surfaces when the active repo picture changed materially

Typical office/control surfaces to review:
- `Aurora Blueprint/office/TASK_BOARD.md`
- `Aurora Blueprint/office/DECISIONS.md`
- `Aurora Blueprint/office/WORK_LOG.md`
- `Aurora Blueprint/AURORA_CONTROL_INDEX_V5.md`
- `Aurora Blueprint/AURORA_PROGRESS_TRACKER_V6.md`

---

## 5. NO FAKE FRESHNESS LAW

Aurora must not claim:
- task truth is current
- tracker truth is current
- SHA truth is current
- wrapper truth is current

if the underlying active repo state changed materially and the linked continuity surfaces were not refreshed.

A stale control surface is better called stale than treated as current by habit.

---

## 6. RECURRING FAULT-FINDING LAW

Each major Aurora pass should include a brief contradiction sweep across:
- office files
- control files
- tracker
- latest run
- SHA ledger
- wrapper packs
- stale legacy extraction-control files

The purpose is to detect:
- silent drift
- over-summary
- stale queueing
- control claims that no longer match repo truth
- wrapper claims that no longer match Blueprint truth

---

## 7. CURRENT JUDGMENT

Aurora now requires explicit version-aware and SHA-aware update discipline.

From this point forward, speed is still allowed.
But speed must remain continuity-safe.
