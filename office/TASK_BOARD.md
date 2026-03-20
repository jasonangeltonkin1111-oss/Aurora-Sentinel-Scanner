# Task Board

## Current repo posture

- blueprint exists
- first flat MT5 foundation exists
- office normalization is now active
- compile-hardening and recovery-hardening are next
- ranking, basket logic, and trading logic remain blocked

## Active streams

| STREAM | STATUS | PURPOSE | NEXT ACTION |
|---|---|---|---|
| Office normalization | DONE | replace office sprawl with a small control layer | keep this office updated in place |
| Blueprint correction | ACTIVE | keep active blueprint aligned with current foundation scope | fold later contradictions into canonical blueprint over time |
| Foundation runtime | ACTIVE | timer, heartbeat, server storage, dossiers, runtime and scheduler persistence | compile-hardening pass |
| Market-state truth | ACTIVE | open / closed / uncertain symbol truth | edge-case hardening for stale and sessionless symbols |
| Persistence and atomic writing | ACTIVE | runtime state, scheduler state, summary scaffold, dossier writes | restart and temp-failure hardening |
| Deep intelligence | BLOCKED | later ranking, shortlist, and enrichment work | do not open before foundation is stable |
| Trade / account logic | BLOCKED | execution and account-driven features | not part of ASC foundation |

## Immediate next tasks

1. compile-hardening pass for `mt5_runtime_flat/`
2. recovery-load pass so runtime state and scheduler state are read back, not only written
3. dossier schema refinement for readability and editability
4. scheduler pacing review for large universes and long closed sessions
5. active blueprint cleanup where current scope still conflicts with older broader wording

## Blocking rules

Do not open:
- ranking
- basket selection
- strategy logic
- trading logic
- account logic
- past-trade logic

until the flat foundation is compile-clean and restart-safe.

## Office maintenance rule

Do not create task packets for each tiny step.
Update this board instead.
