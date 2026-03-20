# ASC Aurora Bridge Contract

## Purpose

This file translates Aurora-side downstream needs into ASC-side scanner requirements without granting Aurora authority over ASC foundation architecture.

Authority remains:
1. root `blueprint/`
2. this implementation pack
3. active runtime
4. office
5. archive lineage
6. Aurora Blueprint as downstream requirement evidence only

## Why this file exists

Aurora doctrine makes clear that a downstream system will eventually need:
- stable scanner truth surfaces
- freshness and continuity markers
- honest degraded-state reporting
- broad symbol coverage before selective narrowing
- scanner outputs that remain readable to humans and parseable to machines

ASC must satisfy those needs as a foundation capability stack while staying out of strategy and execution logic.

## Scanner-to-Aurora boundary

### ASC responsibilities
- maintain server-scoped symbol universe continuity
- maintain market open / closed / uncertain truth
- preserve canonical dossier publication
- persist runtime and scheduler continuity
- expose freshness, pending, degraded, and recovery state
- keep outputs restart-safe and path-stable

### Aurora responsibilities later
- interpret the scanner outputs
- combine scanner truth with chart, execution-context, and strategy-family logic
- decide scenario quality, deployability, and execution suitability
- own any account, exposure, or execution-state reasoning outside pure scanner continuity

## Downstream constraints inferred from Aurora materials

Aurora references repeatedly imply that its downstream reasoning will need scanner surfaces that are:
- broad across many symbols
- current enough to trust present-tense state
- explicit about uncertainty
- explicit about degraded or low-trust conditions
- serializable without narrative dependence

That means ASC should preserve these bridge properties.

## Required scanner qualities

### 1. Present-tense state visibility
Aurora distinguishes present-tense condition from stale narrative.
ASC therefore must preserve:
- last checked time
- last tick seen time
- next due time
- current market status
- recovery / restored markers where relevant

### 2. Broad-universe readiness
Aurora may later compare many symbols or use scanner pre-selection surfaces.
ASC therefore must:
- preserve the full symbol universe
- avoid early narrowing in the foundation layer
- keep summary output separate from canonical symbol truth

### 3. Honesty about nonconviction and uncertainty
Aurora doctrine distinguishes practical opportunity from weak or low-trust conditions.
ASC should not attempt to classify opportunity, but it must expose upstream evidence such as:
- uncertain market status
- stale or missing ticks
- missing trade-session information
- degraded runtime mode
- delayed recheck expectations

### 4. Stable machine-friendly publication
Aurora is designed around serializable surfaces.
ASC dossiers and continuity files should therefore remain:
- schema-versioned
- timestamped
- readable
- stable in section naming
- safe to parse without depending on archive vocabulary

## Minimum future-facing dossier fields

Aurora will likely benefit if ASC dossiers continue to preserve these scanner-owned fields:
- Symbol
- Server
- Dossier File
- Current Status
- Status Note
- Last Tick Seen
- Next Check / Next Due
- Trade Sessions Available
- Within Trade Session
- Next Session Open
- Runtime Mode
- Last Heartbeat
- Universe Sync
- Recovery Used
- Tick Present
- Tick Age Seconds

These are scanner facts, not Aurora interpretations.

## Minimum future-facing continuity fields

Runtime continuity should preserve:
- schema version
- generated-at
- runtime mode
- last heartbeat
- last universe sync
- degraded flag
- recovery-used flag
- scheduler cursor or equivalent fairness marker
- symbol count

Scheduler continuity should preserve:
- symbol
- market status
- next due
- last tick seen
- last checked
- uncertain burst count
- status note

## Anti-pollution rule

ASC bridge readiness must not be achieved by injecting:
- strategy names
- execution statuses
- trade sizing
- account exposure states
- position history
- scenario scoring
- opportunity ranking

Those are Aurora or later-system concerns, not scanner-foundation concerns.

## Runtime implications

Bridge-readiness means the runtime should continue improving in these ways:
- bounded fairness so large universes still roll forward honestly
- recovery-first boot behavior
- explicit degraded mode when budgets bind
- strong atomic write protection
- log lines that explain continuity fallback or bounded-work events

## Final contract

ASC must become a dependable sensing substrate for Aurora.
It does that by being:
- broad
- stable
- restart-safe
- explicit about freshness
- explicit about degradation
- operator-readable
- machine-parseable

It must not do that by becoming a strategy engine.
