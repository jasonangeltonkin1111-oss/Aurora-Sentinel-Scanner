# WORKER RULES

## Worker Classes
There are two worker classes in this repository:

### 1. Build Workers
Build workers perform bounded implementation work inside assigned domains.

### 2. Post-Run Workers
Post-run workers do not build product code.
They run only after build work is complete and the system is idle.
These are:
- Clerk
- Debug

## Build Worker Must
- read relevant blueprint docs before building
- claim file locks before editing
- stay inside assigned module or project boundary
- write internal repo handoff when done
- stop when scope is complete instead of freelancing
- treat `archives/` as read-only reference material

## Build Worker Must Not
- redesign architecture casually
- rename shared meanings silently
- mix UI concerns into internal modules
- put dev/task/phase/worker wording into MT5 product code
- edit files already locked by another worker
- treat logical module names as permission to create nested MT5 deployment folders

## Post-Run Worker Constraints
Post-run workers:
- do not build MT5 product code
- run only when no build worker is active
- do not overlap with each other
- must respect `archives/` as static reference material
