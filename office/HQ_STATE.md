# HQ STATE

## Purpose
This file is the live HQ continuity snapshot.

It exists so a fresh HQ chat can recover:
- current system phase
- current worker state
- current blockers
- what is allowed next
- what is forbidden next

This file should be updated in place.
Do not create endless new HQ state files per wave.

---

## Current System Status
- Foundation status: blueprint hardened and Wave 1 fix commits merged, but post-fix review normalization is still in progress
- Current implementation wave: Wave 1 Post-Fix Review
- Current stage family: first-slice implementation correction review
- Current focus: control-layer truth normalization plus fresh Debug verification against the merged Wave 1 fix state

---

## Current Worker State

### HQ
- Status: ACTIVE
- Role: orchestration, contradiction resolution, next packet control

### Engine Worker
- Status: FIX COMMIT MERGED
- Scope delivered in repo: include wiring, restore continuity, bounded upsert preservation, runtime shell correction

### Market Worker
- Status: FIX COMMIT MERGED
- Scope delivered in repo: classification translation wiring plus market/session truth alignment

### Conditions Worker
- Status: FIX COMMIT MERGED
- Scope delivered in repo: partial conditions truth preservation and unreadable vs invalid handling

### Storage + Output Worker
- Status: PARTIALLY MERGED VIA ENGINE/STORAGE FIX
- Scope delivered in repo: snapshot shrink guard and temp-file cleanup; Output handoff/log state still needs normalization

### Clerk
- Status: ACTIVE POST-FIX REVIEW
- Verdict: pending current review writeback

### Debug
- Status: RERUN REQUIRED
- Verdict: last completed review was FAIL against pre-fix state

---

## Current Blocking Findings

### Control-layer findings now active
- `HQ_STATE.md` must reflect that the Wave 1 fix commits are merged and that HQ is in post-fix review, not pre-fix issuance
- Wave 1 handoff files still lag the merged fix state and still miss the required handoff heading format
- the earlier Clerk flat-layout failure is no longer truthful under the active navigation law

### Debug-state findings now active
- `office/DEBUG_REVIEW_WAVE1.md` is now historically important but stale against the current merged MT5 state
- a fresh Debug rerun is required before HQ interprets any pre-fix Debug blocker as still active

---

## Current HQ Decision
The system is in:
- FIX phase
- not progression phase
- not feature expansion phase

Current decision:
1. treat the merged Wave 1 fix commits as landed repo state
2. normalize control-layer truth so handoffs and live HQ state match the merged code
3. rerun Debug against the current merged repo state
4. do not advance to new features until post-fix Clerk and Debug review truth is current
5. keep progression blocked if control docs or Debug truth still lag the repo

---

## Required Next Action
1. write back the post-fix Clerk review and normalize live control docs
2. refresh or normalize the four active Wave 1 handoff files so they truthfully describe the merged fix state
3. rerun Debug against the merged MT5 files
4. only then decide whether Wave 1 passes or requires another correction pass

---

## Allowed Next
- control-doc normalization by Clerk where truthful
- handoff normalization under HQ/worker ownership
- blueprint-law enforcement from `office/BLUEPRINT_INTEGRITY_AUDIT.md`
- fresh Debug rerun after merged fixes
- HQ correction-wave orchestration

---

## Forbidden Next
- Layer 2 expansion
- ranking expansion
- deep dossier work
- Layer 4 work
- new worker-role expansion
- bypassing Clerk or Debug
- creating many new root review files instead of updating the active ones or later archiving them deliberately

---

## File Hygiene Rule
For HQ continuity and review hygiene:
- `HQ_STATE.md` is updated in place
- `HQ_TASK_FLOW.md` is stable process law
- `HQ_HANDOVER_PROMPT.md` is stable handover entrypoint
- `HQ_DECISION_LOG.md` is append-only decision memory
- active review files may remain wave-specific while the wave is live
- older review files should later be archived deliberately instead of multiplying across the office root forever

---

## Short HQ Resume Sentence
Wave 1 fix commits are merged, Clerk is normalizing the control record, and the immediate next step is a fresh Debug rerun against the merged repo before any progression decision.
