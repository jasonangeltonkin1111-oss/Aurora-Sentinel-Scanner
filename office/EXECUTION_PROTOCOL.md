# EXECUTION PROTOCOL

## Core Law
Only one active build worker may run at a time.

No parallel product work is allowed.
No overlapping worker execution is allowed.

## Execution Cycle
1. Master assigns one bounded project.
2. Assigned worker claims locks and performs the scoped run.
3. Worker stops when scope is complete.
4. Clerk may be invoked manually after worker completion.
5. Debug may be invoked manually after worker completion.
6. System returns to idle before the next project begins.

## Worker Exclusivity
- only one build worker may be active at once
- a build worker must not start while another build worker is active
- file locks must be claimed before edits
- no two workers may modify the same file concurrently

## Clerk Run Window
Clerk is post-run only.
Clerk may run only when:
- no build worker is active
- no task is mid-execution
- the master explicitly invokes Clerk

## Debug Run Window
Debug is idle-state only.
Debug may run only when:
- no build worker is active
- Clerk is not currently running
- the master explicitly invokes Debug

## Clerk Authority
Clerk may:
- update logs
- update ledgers
- normalize repo state records
- summarize completed changes

Clerk must not:
- build product code
- redesign architecture
- silently change blueprint meaning

## Debug Authority
Debug may:
- inspect blueprint, office, and mt5
- detect drift, violations, and contradictions
- report exact failures and affected files

Debug must not:
- build product code
- silently fix issues
- redefine system rules

## Master Authority
The master:
- decides when a build worker starts
- decides when Clerk runs
- decides when Debug runs
- must preserve idle-only access for Clerk and Debug
