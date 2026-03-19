# 06 ASC Refoundation Audit and Runtime Canon

## 1. Purpose

This file is the explicit **ASC refoundation bridge** between:
- the current ASC blueprint pack
- the archived ASC blueprint/office stack
- the archived MT5 ASC implementation
- older lineage systems such as AFS, EA1, and ISSX

It exists to do four jobs that were still underdefined elsewhere:
1. record the surviving truths worth preserving
2. record the contradictions between blueprint, office, runtime, and lineage
3. define the missing runtime functions and laws that implementation must not invent later
4. lock a complete runtime spine that can be staged without architectural collapse

This file is still **blueprint law**, not office choreography.
It defines how ASC must work.

---

## 2. What lineage survives into ASC

### 2.1 Preserve from AFS
Preserve these truths in translated form:
- heartbeat-first runtime identity
- warm-state continuity instead of restart wipe
- staged rotational coverage rather than full-universe heavy refresh
- dossier-first / summary-last publication discipline, translated into symbol-file-first / summary-last
- explicit pending / weak / stale / blocked distinctions
- trader HUD and operator HUD separation
- thin-bucket honesty: fewer than five leaders is valid
- degraded-but-honest visibility rather than cosmetic silence

### 2.2 Preserve from EA1
Preserve these truths in translated form:
- timer-driven orchestration with `OnTick()` kept empty for heavy work
- separate quote snapshot path and `CopyTicks` history path
- session truth, tick truth, and cost truth kept distinct
- independent bounded cursors instead of one monolithic pass cursor
- re-entry protection and cheap rolling update discipline
- active / closed / dormant distinctions with explicit recheck times
- restore-first persistence behavior that preserves prior useful truth

### 2.3 Preserve from ISSX
Preserve these truths in translated form:
- kernel-owned due-service runtime
- service classes with explicit priority and backlog behavior
- budget surfaces, reserved publication budget, and debt tracking
- fairness and starvation tracking by service family
- resumable continuity state with compatibility-aware restore
- degraded-mode honesty rather than pretending full health
- publish-critical fastlane behavior that never outranks foundational truth
- health telemetry that explains backlog, debt, and stage pressure

### 2.4 Reject from lineage
Reject these patterns completely:
- full-universe deep analytics on every cycle
- UI/HUD as a hidden logic owner
- dev-workflow language in trader-facing product surfaces
- giant catch-all runtime passes that discover, rank, enrich, publish, and explain at once
- active-set logic hidden inside writers or HUD text
- archive transplantation without translation
- any Aurora strategy / execution / wrapper / doctrine scope

---

## 3. Full contradiction audit

### 3.1 Blueprint pack vs archived office build order
The current blueprint pack correctly says the kernel, restore, runtime state, and publication shell must come before deeper logic.
The archived office layer often preserved an older stage model where Layer 2 summary publication, ACTIVE rights, and first-milestone output were discussed as earlier bounded deliverables.

Canonical resolution:
- the new blueprint pack wins for runtime constitution
- office planning must stage implementation around the blueprint runtime spine, not around old wave language
- no future work may treat old Wave 1/Wave 2 terms as product-runtime authority

### 3.2 Blueprint pack vs archived live ASC MT5 runtime
The archived MT5 runtime in `archives/Asc Archive/mt5/` still behaves as a collapsed engine:
- `OnInit()` enables a very large feature surface immediately
- `ASC_Engine_RunInit()` restores snapshot state and then immediately runs discovery, market truth, conditions, optional surface work, snapshot save, and publication in one pass
- publication is triggered from the same pass that performs truth mutation
- runtime snapshot fields still expose workflow-style collapse such as `PhaseText = "Layer 1 / Layer 1.2 / Surface"`
- the HUD exposes many config and workflow controls directly from live runtime config rather than from a narrower prepared runtime read model

Canonical resolution:
- the archived MT5 tree is useful evidence, not runtime law
- the canonical runtime remains boot -> restore -> warmup -> steady-state under due-service control
- product surfaces must report runtime truth, not implementation bundle names

### 3.3 Archived ASC blueprint vs current blueprint pack
The archived ASC blueprint strongly preserved:
- Layer 1 / 1.2 / 2 / activation / 3 separation
- symbol-file-first / summary-last discipline in spirit
- UI boundary law
- classification and `PrimaryBucket` truth

But it still carried older milestone constraints that are now too narrow for the refoundation target:
- exact 3-section symbol file contract tied to first-milestone surface files
- M15/H1-only deep expectation
- summary authority tied too closely to active dossier rights from the old shortlist model

Canonical resolution:
- preserve the separation laws and writer purity
- translate old “dossier” ideas into modern symbol continuity blocks
- let the new symbol file contract hold more complete runtime truth while keeping trader-facing readability

### 3.4 Current blueprint vs missing runtime implementation detail
The current blueprint pack names restore, warmup, degraded mode, service classes, debt, and publication order, but some operational laws were still implied rather than fully closed.
Examples:
- no fully explicit warmup completion algorithm
- no fully explicit publication gating matrix by runtime mode and domain readiness
- no fully explicit disappearance / broker-universe shrink law
- no full re-entry escalation law
- no summary quality floor algorithm beyond bucket-level guidance

Canonical resolution:
- sections 4 through 8 of this file close those gaps

### 3.5 Office layer vs product language boundary
The old office layer is useful for lineage recovery, but it contains strong worker/wave/packet language that must never migrate into ASC product surfaces.
The archived MT5 tree still shows this leakage pattern through terms such as:
- control-style phase text
- configuration-heavy menu rails
- runtime/UI language that feels like an operator console for build slices rather than a stable scanner product

Canonical resolution:
- office remains implementation planning only
- blueprint and runtime surfaces must use market/runtime language only

### 3.6 Whole-universe truth vs promoted-set truth
Across lineage, the biggest recurring collapse is confusion between:
- the full broker universe known to ASC
- the currently surface-eligible universe
- the currently promoted deep set
- the trader-visible summary shortlist

Canonical resolution:
- universe persistence contains all known symbols
- Layer 2 only ranks symbols eligible for active competition
- promotion only grants Layer 3 budget rights
- summary only routes attention to already-safe promoted symbol truth
- demotion must never equal symbol disappearance

### 3.7 Publication contract vs live runtime behavior
The blueprint says publication must be atomic and summary must be last.
The archived MT5 runtime still performs snapshot save and summary/mirror publication directly from the processing pass that is mutating records.
That is too tightly coupled and too eager.

Canonical resolution:
- publication becomes a separate due service
- runtime may mark records publish-ready during truth services
- only the publication service commits symbol files, universe dump, runtime state, and finally summary

### 3.8 HUD truth vs live HUD/menu behavior
Lineage repeatedly says HUD must display prepared truth only.
The archived MT5 HUD still acts as a broad configuration control rail with many toggles and action buttons bound close to the live runtime config.
Even if actions are enqueued, the UI surface remains too implementation-heavy for the target product shape.

Canonical resolution:
- operator HUD shows runtime health, debt, backlog, and publish state
- trader HUD shows shortlist state, freshness, caveats, and leader context
- config editing remains bounded and secondary
- HUD sections may not become the practical owner of runtime understanding

---

## 4. Missing runtime function audit

The following runtime/system functions were still missing or underdefined and are now mandatory.

### 4.1 Warmup completion law
Warmup completes only when all are true:
1. every known symbol has an identity block
2. every known symbol has an explicit Layer 1 outcome
3. every known symbol has a minimum Layer 1.2 snapshot outcome
4. every unresolved symbol carries pending reason, next recheck, and ownership of that recheck class
5. runtime state can explain remaining gaps without “not processed yet” ambiguity
6. symbol-file publication and runtime-state publication are safe, even if summary is still withheld

### 4.2 Re-entry guard law
If a timer pulse arrives while a prior cycle is still active:
- skip the new cycle
- increment re-entry counter
- stamp the skipped cycle in runtime state and log
- if repeated beyond threshold, enter degraded mode
- do not stack concurrent passes

### 4.3 Runtime mode transition law
Allowed modes:
- `BOOT`
- `RESTORE`
- `WARMUP`
- `STEADY_STATE`
- `DEGRADED`
- `PAUSED`
- `RECOVERY_HOLD`

`RECOVERY_HOLD` is required for cases where continuity exists but safe forward progress is blocked by repeated corruption, schema incompatibility, or write-journal ambiguity.

### 4.4 Scheduler debt law
ASC must track at least two debt classes:
- **cycle debt**: work skipped because the current cycle budget was exceeded
- **coverage debt**: work families falling behind intended full-coverage windows

These debts must never be collapsed into one generic “busy” flag.

### 4.5 Coverage debt by family
Track debt separately for:
- Layer 1 universe revisit
- Layer 1 fastlane uncertainty queue
- Layer 1.2 snapshot refresh
- Layer 2 surface revisit
- promoted Layer 3 deep refresh
- frozen/deferred slow rechecks
- publication backlog
- cleanup backlog

### 4.6 Fastlane retry law
Fastlane exists only for symbols with near-term uncertainty or instability.
It is not a second full-runtime pass.

Fastlane classes include:
- just-open / suspected-open but quote-thin
- stale-feed ambiguity
- no-quote near known open
- recent broker-mode change
- recently restored symbols lacking current quote evidence
- promoted leaders whose current market truth degraded abruptly

Fastlane retries must use bounded backoff ladders and class fallback.

### 4.7 Symbol recheck classes
Every symbol must belong to one current recheck class:
- stable open
- weak open
- pending uncertain
- closed with exact next-open
- closed without exact next-open
- disabled
- stale feed
- promoted active
- deep frozen retained
- archived inactive
- disappeared from broker universe

### 4.8 Pending-state expiry and escalation law
Pending is not allowed forever.
Each pending domain must define:
- first observed pending time
- retry ladder
- escalation threshold
- expiry threshold
- expired-pending outcome

Expired-pending does not imply deletion.
It implies transition to a slower recheck or degraded/frozen representation.

### 4.9 Promotion hysteresis law
Promotion changes require:
- bucket-relative score comparison
- minimum floor satisfaction
- deterministic tie-break fallback
- hysteresis buffer at boundary
- minimum hold period when recently promoted unless the symbol becomes unsafe

### 4.10 Demotion freeze law
When a promoted symbol loses deep rights:
- preserve the last good deep block
- stamp `DEEP_FROZEN`
- keep freshness ages visible
- stop active deep refresh
- schedule slower recheck for re-entry eligibility
- do not let summary treat frozen deep as current deep

### 4.11 File schema compatibility law
Every restore must classify files as one of:
- compatible current
- compatible degraded
- migratable
- incompatible hold
- corrupt reject

Schema handling must be block-aware where possible, not only file-level all-or-nothing.

### 4.12 Write journal / crash recovery law
Class A writes must use a journal with:
- target kind
- temp path
- final path
- previous-good path if any
- schema version
- cycle sequence
- commit started time
- commit finished time
- final outcome

Startup must inspect journals before normal restore trust is granted.

### 4.13 Asset-class session handling law
Asset class changes thresholds and caution classes, not the runtime spine.
The runtime must define separate interpretation policies for:
- 24/7-like products
- session-bound OTC products
- exchange products with auctions/lunch breaks
- expiring futures or rolling contracts
- synthetic/custom symbols

### 4.14 Classification fallback law
Unresolved classification is visible truth, not a hidden defect.
Policy must specify whether unresolved symbols are:
- visible but non-promotable
- visible and heavily penalized
- placed into explicit `UNKNOWN`
- queued for slower identity retry

### 4.15 Unknown-bucket treatment law
`UNKNOWN` bucket symbols:
- remain in universe dump
- may carry market truth and snapshot truth
- may participate in limited visibility reporting
- do not normally win promotion unless HQ opens an explicit policy override

### 4.16 Deep refresh cadence ownership law
Every deep domain must have one owner cadence and one owner freshness clock.
Examples:
- tick window: 10-second cadence
- M1 ring: 1-minute or new-bar cadence
- H4/D1 families: new-bar-only cadence
- regime persistence: depends on underlying timeframes, not its own blind timer

### 4.17 Frozen-state publication law
A symbol with frozen deep state may still publish if:
- identity is valid
- Layer 1 is explicit
- Layer 1.2 minimum snapshot exists
- publication block explains that deep context is frozen and not current

### 4.18 Summary quality floor law
A bucket may publish 0 to 5 leaders.
Each candidate must satisfy:
- explicit Layer 1 open-enough truth
- minimum snapshot sufficiency
- minimum surface validity
- minimum score floor
- no blocking contradiction state

### 4.19 Continuity-origin truth law
Continuity origin must be explicit per symbol and runtime state:
- `FRESH`
- `RESTORED_CURRENT`
- `RESTORED_LAST_GOOD`
- `MIXED`
- `FROZEN`
- `DEGRADED`
- `REBUILT_CLEAN`
- `RECOVERY_HOLD`

### 4.20 Symbol disappearance / broker shrink law
If a symbol vanishes from current broker discovery:
- do not immediately delete it
- stamp disappearance observation time
- preserve last good known state
- move it to disappearance recheck class
- require repeated confirmed absence or explicit retention expiry before archival removal

### 4.21 Broker-universe shrink protection
A bounded or partial refresh must never shrink the authoritative universe snapshot silently.
Shrink is permitted only after:
- a full discovery pass completed
- the pass was validated as complete
- disappearance policy confirmed the removals
- replacement snapshot commit passed validation

---

## 5. Canonical ASC runtime spine

### 5.1 Boot
Boot creates the runtime shell only.
Responsibilities:
- load config
- verify folders
- initialize mode shell, counters, cursors, and journals
- set heartbeat timer
- create empty runtime snapshot object

Boot does **not** run heavy discovery, ranking, or publication.

### 5.2 Restore
Restore loads last-good runtime continuity before normal work.
Responsibilities:
- inspect write journals
- repair or reject incomplete commits honestly
- load runtime state
- load universe membership
- load symbol files and domain blocks as available
- evaluate schema compatibility
- stamp continuity origin per restored domain
- reject incompatible truth without pretending success

Output of restore:
- restored runtime memory
- restore outcome summary
- unresolved restore issues queued for continuity service

### 5.3 Warmup
Warmup fills missing minimum truths without destructive rebuild.
Responsibilities:
- discover current broker universe
- merge discovery against restored universe safely
- ensure every known symbol has identity, Layer 1, and minimum Layer 1.2 ownership
- convert “not reached yet” into explicit pending states
- publish runtime state and pending-safe symbol files as soon as safe

Warmup ends only under the law in section 4.1.

### 5.4 Steady-state
Steady-state is cheap rolling maintenance.
Responsibilities:
- revisit services when due
- preserve continuity
- update only stale or newly-due domains
- maintain fair coverage and bounded fastlane behavior

### 5.5 Degraded mode
Degraded mode preserves honesty under pressure.
Priority order remains:
1. kernel safety
2. runtime state and journals
3. Layer 1
4. Layer 1.2
5. continuity-preserving writes
6. Layer 2
7. publish-critical commits
8. Layer 3
9. cosmetic UI extras

Degraded mode may publish only truth that is explicitly safe and labelled degraded where needed.

### 5.6 Paused mode
Paused mode suspends heavy scanning but not runtime presence.
Responsibilities:
- heartbeat continues
- runtime state continues
- operator HUD remains responsive
- pending operator requests may queue
- no heavy service dispatch except safe publication/continuity actions explicitly allowed

### 5.7 Recovery hold mode
Recovery hold is entered when continuity safety is too weak for honest normal progression.
Examples:
- repeated journal ambiguity
- repeated corrupt runtime-state decode with no safe fallback
- schema migration contradictions
- file identity collisions

In recovery hold:
- runtime state must explain the block explicitly
- no summary publication occurs
- only bounded recovery/inspection services may run

---

## 6. Due-service constitution

### 6.1 Service families
ASC owns these service families:
- kernel safety
- continuity restore/reconcile
- universe discovery
- Layer 1 market truth
- Layer 1 fastlane retry
- Layer 1.2 snapshot refresh
- Layer 2 surface ranking
- promotion update
- Layer 3 deep refresh
- publication commit
- cleanup/retention
- operator-request processing

### 6.2 Service classes
Use these classes:
- `BOOTSTRAP`
- `DELTA_FIRST`
- `RETRY_FASTLANE`
- `BACKLOG`
- `CONTINUITY`
- `PUBLISH_CRITICAL`
- `OPTIONAL_ENRICHMENT`
- `OPERATOR_REQUEST`

### 6.3 Independent cursors
Separate cursors are mandatory for:
- discovery merge
- Layer 1 broad pass
- Layer 1.2 broad pass
- Layer 2 bucket surface pass
- Layer 3 promoted deep pass
- frozen/deferred slow pass
- publication backlog
- cleanup backlog

### 6.4 Fairness law
The kernel must prevent monopolization by:
- one fastlane class
- one promoted bucket
- one symbol family
- one publication backlog
- one slow broken domain

### 6.5 Publication-critical rule
Publish-critical does not mean “always first.”
It means:
- once truth is already validated and ready, commit work should not starve forever
- reserved commit budget must exist
- publish-critical may not bypass missing foundational truth

---

## 7. Publication and continuity runtime law

### 7.1 Canonical publication order
1. write/update runtime state and journals as needed
2. commit validated symbol files
3. commit validated universe dump
4. commit summary last

### 7.2 Runtime-state role
Runtime state is the kernel read model for operator visibility.
It must not replace symbol truth or universe truth, but it must explain:
- mode
- restore outcome
- warmup completeness
- debt and backlog
- due services
- publication headline
- degraded/paused/recovery-hold reason

### 7.3 Symbol publication role
A symbol file is the canonical continuity container for one symbol.
It may publish pending-safe truth before deep readiness, but every pending domain must be explicit.

### 7.4 Universe dump role
The universe dump is the authoritative broad visibility layer.
It keeps full-universe truth visible even when only a small promoted subset receives deep work.

### 7.5 Summary role
The summary is attention-routing only.
It must never:
- become the hidden source of active-set truth
- imply missing symbol files exist
- claim freshness stronger than its leaders actually have
- pad weak buckets with junk

---

## 8. Canonical implementation-ready sequencing

Implementation must now assume this order:
1. canonical shared vocabulary and DTOs
2. kernel shell, mode shell, restore shell, runtime state shell
3. universe discovery and identity continuity
4. Layer 1 truth and recheck classes
5. Layer 1.2 snapshot continuity and shrink protection
6. atomic publication shell with journal and restore recovery
7. Layer 2 scoring and ranking
8. promotion hysteresis and demotion freeze
9. Layer 3 deep rolling continuity
10. final HUD/menu surfaces fed from runtime read models
11. degraded/recovery-hold hardening and retention

This is the only allowed implementation direction.
No stage may quietly borrow authority from a later stage.

---

## 9. Final canonical definition

ASC is now canonically defined as:
- a restore-first, timer-driven, due-service scanner runtime
- preserving the full broker universe at all times
- deriving explicit Layer 1 market truth and Layer 1.2 broker truth for every known symbol
- performing cheap broad competition every 10 minutes on eligible symbols
- granting deep budget only to a bounded promoted set and limited near-promoted allowance
- preserving frozen, stale, degraded, pending, disappeared, and resumed states explicitly
- writing atomic continuity-safe files with symbol-first and summary-last discipline
- exposing operator and trader surfaces that display prepared truth only

Any implementation, office plan, or future refactor that violates this file must be treated as ASC drift.
