# ASC GPT/Codex Codegen Playbook

## Purpose

This file tells a general coding model exactly how to behave when generating ASC code.

## Prime directive

Do not invent a simpler architecture than the docs describe.

## What the model must preserve

- timer-driven kernel
- restore-first persistence
- due-based scheduler
- bounded work
- server-only storage identity
- symbol-file-first publication
- human-readable dossier labels
- strict ownership separation
- honest unknown/stale/pending states
- deep analysis only for a bounded selected set

## What the model must not do

- move heavy logic into `OnTick()`
- rebuild all symbols every heartbeat
- compute ranking inside writers
- use account number/login for storage root
- invent fake zero placeholders
- collapse old and new blueprints into an incoherent hybrid
- treat summary as the only stored truth
- erase prior valid files on startup
- scatter MT5 API calls randomly across formatting code

## Implementation sequence the model should follow

1. create shared enums/types/status vocabulary
2. create paths/logging/atomic write helpers
3. create runtime state and scheduler shell
4. create universe discovery shell
5. create Layer 1 market-state service
6. create dossier writer and minimum dossier schema
7. create runtime/scheduler persistence
8. add Layer 2 snapshot stores and accessors
9. add Layer 3 filter
10. add Layer 4 selection
11. add Layer 5 deep analysis
12. expand summary only after earlier layers are real

## Prompt template for code generation

```text
You are implementing Aurora Sentinel Scanner for MT5.

Follow these laws:
1. Timer-driven runtime using OnInit + OnTimer + OnDeinit.
2. OnTick must not own heavy scanner work.
3. Restore first from FILE_COMMON paths scoped by cleaned broker server name.
4. Use a due-based scheduler with bounded work and next-check times.
5. Create one evolving dossier per symbol before relying on summary output.
6. Writers render prepared state only; no ranking/history retrieval inside writers.
7. Market-state truth uses tick evidence + quote usability + session reference.
8. Unknown/missing/stale/pending must remain explicit.
9. Filtering, ranking, and deep analysis must stay in separate modules/layers.
10. Summary is downstream and later.

Generate:
- file tree
- enums/structs
- function signatures
- MQL5 code with comments
- explicit TODOs only where blueprint intentionally blocks later stages
```

## Prompt template for debugging generated code

```text
Audit this MT5 ASC code against these architecture laws:
- restore-first
- timer-driven
- bounded scheduler
- server-only storage identity
- symbol-file-first publication
- no writer-side calculations
- no fake default values for unknown truth
- no heavy OnTick logic
- no full-universe deep calculations every heartbeat

Return:
1. architectural violations
2. runtime correctness bugs
3. persistence safety bugs
4. naming/surface leakage bugs
5. concrete code fixes
```

## Review checklist for generated code

- Does `OnInit()` set the timer?
- Is `OnTimer()` the main orchestration point?
- Are `FILE_COMMON` paths used?
- Is storage rooted by cleaned server name?
- Is atomic write present?
- Are next-check times persisted?
- Are unknown states explicit?
- Are dossiers created even before ranking exists?
- Are summary writes separated from state computation?
- Are layer boundaries visible in file/module names?
