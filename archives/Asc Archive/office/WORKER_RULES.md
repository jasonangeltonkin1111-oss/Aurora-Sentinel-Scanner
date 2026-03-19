# WORKER RULES

## Purpose
This file locks worker behavior for the ASC control layer.
The worker roster is intentionally small.
Workers must preserve system truth, not improvise organizational growth.

---

## Locked Worker Classes
There are only two worker classes in this repository:

### 1. Build Workers
The active build-worker roster is:
- Engine Worker
- Market Worker
- Conditions Worker
- Storage + Output Worker

Build workers perform bounded implementation work inside assigned domain packets.
A product domain may exist without having its own dedicated worker role.

### 2. Post-Run Workers
Post-run workers do not build MT5 product code.
They run only after build work is complete and the system is idle.
These are:
- Clerk
- Debug

HQ coordinates all assignments and approvals, but HQ is not a build worker.

---

## Worker Model Clarifications
- The repository control layer is a locked 7-role system: HQ plus 4 build workers plus 2 post-run workers.
- Surface, Ranking, Diagnostics, and UI are product domains, not automatic worker roles.
- Clerk and Debug are never implementation substitutes for missing build work.
- Diagnostics the product domain is distinct from Debug the office reviewer.

---

## Build Worker Must
- read relevant blueprint docs before building
- read the active office control docs relevant to the assignment
- claim file locks before editing
- stay inside assigned domain or task boundary
- preserve `PrimaryBucket` as Market-owned upstream truth
- keep writer logic computation-free
- treat `archives/` as read-only reference material
- write an internal handoff when done
- stop when scope is complete instead of freelancing

---

## Build Worker Must Not
- redesign architecture casually
- invent new worker classes because more modules exist
- rename shared meanings silently
- move classification ownership out of Market
- move ranking authority into Output or Storage
- mix UI concerns into internal modules early
- put dev/task/phase/worker wording into MT5 product code or output surfaces
- edit files already locked by another worker
- treat logical module names as permission to create nested MT5 deployment folders
- grant Layer 3 continuation rights to non-ACTIVE symbols
- import archive systems wholesale

---

## Post-Run Worker Constraints
Post-run workers:
- do not build MT5 product code
- run only when no build worker is active
- do not overlap with each other
- must respect `archives/` as static reference material
- may report contradictions, but may not silently rewrite architecture law

### Clerk focus
- structure
- naming
- document/file placement
- boundary adherence
- handoff completeness

### Debug focus
- logic integrity
- fail-fast behavior
- truth handling
- activation safety
- persistence safety

---

## Escalation Rule
A worker must stop and escalate to HQ if it encounters:
- contradictory blueprint vs office truth
- unclear ownership across major domains
- missing authority for a contract change
- a task packet that leaks later-slice work into first-slice scope

Workers must not resolve load-bearing architectural conflicts privately.
