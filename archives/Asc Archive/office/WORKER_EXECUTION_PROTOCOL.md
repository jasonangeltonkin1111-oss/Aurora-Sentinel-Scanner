# WORKER EXECUTION PROTOCOL

## Purpose
This file defines how all workers must operate inside ASC.

Workers do not redesign the system.
Workers do not expand scope.
Workers do not self-assign follow-up stages.

Workers implement one bounded task under HQ direction.

---

## Authority Order
Workers must obey authority in this order:
1. `README.md`
2. `INDEX.md`
3. `office/HQ_OPERATOR_MANUAL.md`
4. active `blueprint/`
5. explicit HQ task packet
6. active `office/` rules
7. active `mt5/`
8. `archives/` as translation/reference source only

If conflicts exist, escalate to HQ.
Do not resolve architectural conflicts privately.

---

## Worker Laws
- Work one task only.
- Touch only in-scope files.
- Do not improve unrelated systems "while here".
- Do not import legacy systems blindly.
- Do not expand into later layers.
- Do not make strategy or execution logic appear inside scanner layers.
- Do not guess missing truth.
- Do not hide invalidity behind placeholder values.

---

## Required Task Packet Format
Every HQ task packet must define:
- objective
- exact scope
- out-of-scope items
- source blueprint files to obey
- required archive references
- deliverables
- completion checks
- handoff note format

If a task packet lacks these, worker must request HQ clarification before implementation.

---

## Required Worker Start Routine
Before editing anything, worker must:
1. read required active blueprint files
2. read required office files
3. consult required archive references
4. classify archive use as:
   - TRANSLATE
   - REFERENCE ONLY
   - DO NOT USE
5. restate scope internally and remain inside it

---

## Required Worker Handoff Format
Every worker handoff must include:

### 1. CHANGED FILES
List all changed files.

### 2. SCOPE CHECK
State whether any out-of-scope area was touched.
If yes, explain why.

### 3. ARCHIVE USE NOTE
- archive files consulted
- classification for each file
- truth extracted
- legacy scope rejected

### 4. COMPLETION CHECK
State how deliverables satisfy the task packet.

### 5. OPEN RISKS
List unresolved risks without inventing fixes outside scope.

---

## Forbidden Worker Behavior
- redesigning ASC
- adding future-layer features early
- parallelizing hidden tasks
- changing contracts without HQ
- inventing bucket rules downstream
- letting writers compute
- converting unknown to valid by assumption

---

## Review Chain
No worker output becomes trusted by default.
After worker completion:
1. Clerk checks structure/boundaries
2. Debug checks logic/truth/integrity
3. HQ decides next step
