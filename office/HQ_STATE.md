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
- Foundation status: materially locked and implementation-ready
- Current implementation wave: Wave 1 Fix
- Current stage family: first-slice implementation
- Current focus: Layer 1 / Layer 1.2 / storage-output foundation alignment

---

## Current Worker State

### HQ
- Status: ACTIVE
- Role: orchestration, contradiction resolution, next packet control

### Engine Worker
- Status: FIX PACKET ISSUED
- Scope: include wiring, shared contract ownership discipline, runtime shell correction

### Market Worker
- Status: FIX PACKET ISSUED
- Scope: enum alignment, shared contract alignment, classification/session truth correction

### Conditions Worker
- Status: BLOCKED IN ONE CHECKOUT / REQUIRES REPO SYNC
- Scope: struct alignment and handoff correction only
- Blocker: worker reported required files/review docs missing in its checkout view

### Storage + Output Worker
- Status: FIX PACKET ISSUED
- Scope: serialization/recovery/output-language correction

### Clerk
- Status: COMPLETED WAVE 1 REVIEW
- Verdict: FAIL

### Debug
- Status: COMPLETED WAVE 1 REVIEW
- Verdict: FAIL

---

## Current Blocking Findings

### Clerk blocking findings
- MT5 flat-layout compliance issue was reported
- shared-contract ownership issue around `ASC_Common.mqh` was reported
- handoff format violations were reported

### Debug blocking findings
- compile/integration risk remains
- shared contract mismatch was reported
- session status enum vs string drift was reported
- additional logic/safety corrections were required before progression

### Conditions-specific sync blocker
A Conditions fix worker reported that required owned files/review files were not visible in its checkout state.
HQ must treat this as a repo-state synchronization problem, not as permission to freestyle outside worker ownership.

---

## Current HQ Decision
The system is in:
- FIX phase
- not progression phase
- not feature expansion phase

Current decision:
1. keep the 4 build workers on Wave 1 Fix only
2. require repo-state precheck/synchronization before fix execution
3. rerun Clerk after fix wave
4. rerun Debug after fix wave
5. do not advance to new features until post-fix reviews pass

---

## Required Next Action
Before any worker continues:
1. confirm latest repository state is visible in the worker checkout
2. confirm these files are present where required:
   - `mt5/AuroraSentinel.mq5`
   - `mt5/ASC_Common.mqh`
   - `mt5/ASC_Engine.mqh`
   - `mt5/ASC_Market.mqh`
   - `mt5/ASC_Conditions.mqh`
   - `mt5/ASC_Storage.mqh`
   - `mt5/ASC_Output.mqh`
   - `office/CLERK_REVIEW_WAVE1.md`
   - `office/DEBUG_REVIEW_WAVE1.md`
   - all 4 worker handoff files
3. rerun the 4 Wave 1 Fix packets
4. rerun Clerk
5. rerun Debug
6. only then decide whether Wave 1 passes or requires another correction pass

---

## Allowed Next
- worker fix packets inside owned files only
- repo sync / precheck enforcement
- Clerk and Debug reruns after fixes
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
Wave 1 foundation build ran in parallel, Clerk and Debug both failed correctly, Wave 1 Fix was issued, and the immediate next step is synchronized rerun of the 4 fix workers followed by Clerk and Debug reruns before any progression.