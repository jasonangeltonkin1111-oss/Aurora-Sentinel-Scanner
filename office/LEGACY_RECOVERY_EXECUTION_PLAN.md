# LEGACY RECOVERY EXECUTION PLAN

## 1. Purpose of This Document

This file is the canonical execution bridge between:
- `office/MASTER_SYSTEM_ARCHIVE_MAP.md`
- future archive-to-ASC recovery packets
- future HQ sequencing decisions
- future bounded worker prompts

This document does **not** replace the master archive map.
It translates the master map’s intelligence into a recovery-oriented operating plan.

Its purpose is to answer, operationally rather than historically:
- which recovery should happen next
- which module owns it
- which archive sources justify it
- which methods or doctrine blocks matter
- which hidden couplings make it dangerous
- which prerequisites must exist first
- what future worker packets must include and forbid

---

## 2. Relationship to MASTER_SYSTEM_ARCHIVE_MAP.md

### Relationship rule
- `office/MASTER_SYSTEM_ARCHIVE_MAP.md` is the intelligence spine.
- `office/LEGACY_RECOVERY_EXECUTION_PLAN.md` is the execution spine.

### Division of labor
The master map answers:
- what the lineage is
- what the archive contains
- what is valuable or dangerous
- what current ASC still lacks

This recovery plan answers:
- what to recover first
- how to package each recovery
- who should own each recovery
- what common-contract pressure exists
- what is blocked
- what is future-only

### Authority rule
If this plan and the master map ever appear to conflict:
1. current blueprint law wins
2. current office control law wins for sequencing/ownership
3. the master map wins for lineage truth
4. this document wins for recovery packet structure and operational ordering

---

## 3. Active Scope and Exclusions

### In scope
- converting legacy intelligence into future recovery packets
- module-by-module extraction targets for:
  - `mt5/ASC_Common.mqh`
  - `mt5/ASC_Engine.mqh`
  - `mt5/ASC_Market.mqh`
  - `mt5/ASC_Conditions.mqh`
  - `mt5/ASC_Storage.mqh`
  - `mt5/ASC_Output.mqh`
  - `mt5/ASC_Surface.mqh`
  - future `mt5/ASC_UI.mqh` / diagnostics only where explicitly noted
- archive-to-module translation constraints
- readiness-now vs blocked vs future-layer distinctions

### Explicit exclusions
- no Aurora-folder archive recovery
- no blueprint rewrites
- no MT5 implementation in this pass
- no full archive re-mapping from zero
- no expansion into trading, execution, portfolio, or research-OS scope

### Product identity protection
All recovery work planned here must preserve the current product identity:
- scanner-first
- classification-aware
- writer-disciplined
- broker-output-oriented
- non-trading

---

## 4. Recovery Planning Rules

### Rule 1 — recover by module owner, not by archive family
A future packet must name a current owner module first, then name archive sources.

### Rule 2 — recover doctrines before formulas
If a legacy method assumes missing vocabulary or missing intermediate truth fields, recover the vocabulary first.

### Rule 3 — never collapse hidden couplings into “small helper” work
A method is not small if it depends on:
- shared structs not present in ASC
- runtime shells not present in ASC
- stage/debug ecosystems not present in ASC
- sampling rings or caches not present in ASC

### Rule 4 — preserve blueprint law during recovery
No recovery is valid if it violates:
- `PrimaryBucket` grouping law
- writer-only output law
- restore-first persistence law
- Layer 1 -> Layer 1.2 -> Layer 2 -> Activation -> Layer 3 order

### Rule 5 — exact source naming is mandatory
Every future packet must name:
- exact archive file(s)
- exact method family or doctrine block(s)
- exact target MT5 module
- exact blueprint contracts served

### Rule 6 — distinguish “translation” from “porting” explicitly
Each packet must label legacy candidates as one of:
- translate
- adapt carefully
- banned direct port

### Rule 7 — no later-layer intelligence before truth-layer maturity
Do not schedule:
- ranking expansion before degraded-state vocabulary exists
- Layer 3 expansion before continuity semantics exist
- UI/operator work before scanner truth is inspectable and stable

---

## 5. Recovery Sequencing Law

### Sequencing law
Recovery must follow truth dependency, not archive richness.

### Locked recovery order
1. Market identity hardening
2. Conditions provenance hardening
3. Session and quote-state nuance recovery
4. Common degraded-state vocabulary enrichment
5. Surface readiness / hydration / friction decomposition
6. Ranking gate and deterministic tie-break recovery
7. Storage continuity compatibility and restart truth
8. Output publishability and internal diagnostic separation
9. ACTIVE dossier enrichment
10. Bounded UI / diagnostics later layer

### Forbidden sequence inversions
- no friction-score recovery before the surface module can represent degraded states
- no trust-score recovery before Conditions and Surface own provenance/readiness sub-states
- no continuity-heavy Layer 3 work before Storage can express stale/corrupt/incompatible resume truth
- no UI packet before operator-visible health states exist conceptually in current contracts

---

## 6. Module Ownership Recovery Map

| Module | Recovery ownership | Recovery role |
|---|---|---|
| `mt5/ASC_Market.mqh` | primary owner | normalization, classification lineage, session and quote-state nuance |
| `mt5/ASC_Conditions.mqh` | primary owner | observed-vs-effective conditions truth, capability/provenance, safe property access |
| `mt5/ASC_Storage.mqh` | primary owner | continuity validity, path safety, write discipline, restart semantics |
| `mt5/ASC_Output.mqh` | primary owner | publishability expression, trader artifact honesty, later dossier text recovery |
| `mt5/ASC_Surface.mqh` | primary owner | hydration, degraded-state logic, friction decomposition, rankability inputs, tie-break context |
| `mt5/ASC_Engine.mqh` | primary owner | bounded scheduling discipline, orchestration prerequisites, later restart-state visibility |
| `mt5/ASC_Common.mqh` | shared-contract owner | vocabulary, enums, shared provenance and compatibility state |
| future `mt5/ASC_UI.mqh` / diagnostics | future-only owner | operator visibility and bounded internal diagnostics |

### Ownership discipline
If a recovery spans multiple areas:
- the primary truth owner must still be named explicitly
- supporting shared state goes into `ASC_Common.mqh`
- orchestration implications go into `ASC_Engine.mqh`
- writer-only formatting stays in `ASC_Output.mqh`

---

## 7. Shared Contract Pressure Map

This section identifies where `mt5/ASC_Common.mqh` is currently too thin for safe legacy recovery.

### Pressure group A — degraded-state vocabulary
Needed by:
- Surface recovery
- Ranking gate recovery
- later operator health visibility

Missing concepts:
- weak
- degraded
- warming
- partial
- session-ambiguous
- friction-poor

Status:
- **blocked pending Common enrichment** for any serious friction/rankability translation

### Pressure group B — provenance/source-truth fields
Needed by:
- Conditions recovery
- Output honesty recovery
- later diagnostics

Missing concepts:
- raw observed source
- effective/derived source
- fallback reason
- capability support flags

Status:
- **blocked pending Common enrichment** for deep observed-vs-effective recovery

### Pressure group C — continuity compatibility vocabulary
Needed by:
- Storage recovery
- Engine visibility
- Output publishability honesty

Missing concepts:
- restored_from_persistence
- restarted_clean
- persistence_stale
- persistence_corrupt
- persistence_incompatible
- compatibility_reason

Status:
- **blocked pending Common enrichment** for full continuity doctrine recovery

### Pressure group D — publishability / rankability classes
Needed by:
- Surface ranking recovery
- Output honesty recovery
- later diagnostics/UI

Missing concepts:
- publishable
- pending but truthful
- truth-known but not rankable
- blocked-by-weak-link
- deterministic tie-break context

Status:
- **blocked pending Common enrichment** for richer publishability expression

---

## 8. Immediate Recovery Candidates

Immediate means: valuable, bounded, and either ready now or close enough that only minimal shared enrichment is needed.

### Candidate 1 — market normalization hardening
- Target module: `mt5/ASC_Market.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
  - `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Method families:
  - `AFS_CL_StripKnownBrokerSuffixes`
  - `AFS_CL_RemovePunctuation`
  - `AFS_CL_NormalizeSymbol`
  - `NormalizeSymbol`
  - `PIE_NormalizeSym`
- Readiness: **READY NOW**
- Why immediate:
  - identity hardening improves every downstream layer

### Candidate 2 — safe property-read wrapper discipline for conditions
- Target module: `mt5/ASC_Conditions.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
- Method families:
  - `GetInt`
  - `GetDbl`
  - `GetStr`
  - `ReadSymbolIntegerSafe`
  - `ReadSymbolDoubleSafe`
  - `ReadSymbolStringSafe`
- Readiness: **READY NOW**
- Why immediate:
  - low-risk wrapper recovery that strengthens conditions truth before deeper provenance work

### Candidate 3 — path-safe atomic write refinements
- Target module: `mt5/ASC_Storage.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
  - `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- Method families:
  - `IsSafeRelativePath`
  - `WriteTextAtomic`
  - `WriteTextIfChanged`
  - `AtomicWriteText`
- Readiness: **READY NOW**
- Why immediate:
  - high-value, bounded, aligned with existing blueprint law

### Candidate 4 — session-window nuance recovery
- Target module: `mt5/ASC_Market.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
  - `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`
- Method families:
  - `InsideAnySessionTrade`
  - `InsideAnySessionQuote`
  - `IsWithinSessionWindow`
  - `CountTradeSessionsToday`
  - `CountQuoteSessionsToday`
- Readiness: **READY AFTER COMMON ENRICHMENT** if session-count classes are introduced; otherwise partial recovery is possible now

---

## 9. Deferred Recovery Candidates

Deferred means: important, but sequence-sensitive or blocked by missing shared contracts.

### Deferred A — degraded-state vocabulary and hydration recovery
- Target module: `mt5/ASC_Surface.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
  - `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Reason deferred:
  - requires Common contract enrichment first

### Deferred B — observed-vs-effective conditions provenance
- Target module: `mt5/ASC_Conditions.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
  - `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Reason deferred:
  - needs explicit source/provenance fields in `ASC_Common.mqh`

### Deferred C — continuity compatibility / restart-state recovery
- Target module: `mt5/ASC_Storage.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Reason deferred:
  - requires Common restart-state vocabulary

### Deferred D — tie-break and rankability decomposition
- Target module: `mt5/ASC_Surface.mqh`
- Archive sources:
  - `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- Reason deferred:
  - requires degraded-state and trust-vocabulary recovery first

---

## 10. Forbidden or Premature Recoveries

### Forbidden for current recovery horizon
- direct import of AFS, EA1, or ISSX giant structs
- direct import of AFS selection formulas
- direct import of Stage A or stage-debug publication schemas as trader-facing output
- direct import of full ISSX runtime phase shell into `ASC_Engine.mqh`
- direct import of ISSX UI/menu systems before bounded UI scope is explicitly opened

### Premature for current recovery horizon
- correlation finalist logic
- basket/intelligence layers from EA3 or ISSX later stacks
- broad machine-facing stage ecosystems
- execution/risk/account scope from broader legacy blueprints

---

## 11. Recovery Packet Framework

Every future archive-recovery worker packet should use the following structure.

### Required packet fields
1. **Module owner**
2. **Exact blueprint contracts served**
3. **Exact archive source files**
4. **Exact method families or doctrine blocks**
5. **Recovery type**
   - translate
   - adapt carefully
   - banned direct port
6. **Hidden couplings**
7. **Required Common enrichments**
8. **Prerequisites already satisfied**
9. **Success condition**
10. **Explicit non-goals**

### Packet template
- Owner module:
- Blueprint contracts served:
- Archive source files:
- Legacy methods / patterns:
- Recovery classification:
- Hidden couplings to avoid:
- Shared-contract implications:
- Must not change:
- Success condition:
- Non-goals:

### Packet quality standard
A packet is invalid if it says only “recover legacy X” without naming:
- exact methods
- exact source files
- exact module owner
- exact reasons the recovery is sequence-safe now

---

## 12. Market Module Recovery Plan

### Current module role
`mt5/ASC_Market.mqh` owns:
- symbol discovery
- normalization and canonical identity
- classification translation
- Layer 1 eligibility truth
- core session/quote/trade-window truth inputs

### Missing legacy intelligence
- stronger normalization/suffix handling
- confidence/review/alias lineage
- session-window nuance
- richer quote validity distinctions
- optional family/theme enrichment support

### Exact archive source files
- `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
- `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`
- `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

### Exact method families worth recovering
- normalization pipeline: `AFS_CL_StripKnownBrokerSuffixes`, `AFS_CL_RemovePunctuation`, `AFS_CL_NormalizeSymbol`, `NormalizeSymbol`, `PIE_NormalizeSym`
- session/window logic: `InsideAnySessionTrade`, `InsideAnySessionQuote`, `IsWithinSessionWindow`
- quote validity logic: `HasEconomicallyValidQuote`
- optional richer taxonomy logic: `DetectAssetClass`, `DetectInstrumentFamily`, `DetectThemeBucket`

### Exact concepts worth recovering
- classification ambiguity lineage
- quote-state vs session-state separation
- market-open ambiguity without overclaiming

### Hidden dependencies
- family/theme outputs require downstream contract support
- session-count ideas require new shared fields if kept beyond local reasoning
- old market-state methods often assume broader wrapper cadence

### Shared-contract implications
- minimal recovery is ready now for normalization
- confidence/review/alias/family recovery is **READY AFTER COMMON ENRICHMENT**

### Recovery readiness labels
- normalization hardening: **READY NOW**
- session-window nuance: **READY NOW** for bounded adaptation, **READY AFTER COMMON ENRICHMENT** for richer session-state classes
- classification confidence/review lineage: **READY AFTER COMMON ENRICHMENT**
- theme/family enrichment: **LATER-LAYER ONLY unless blueprint asks for it explicitly**

### What should remain outside Market ownership
- cost/provenance math
- restart compatibility semantics
- writer-side publishability decisions
- ranking formulas

---

## 13. Conditions Module Recovery Plan

### Current module role
`mt5/ASC_Conditions.mqh` owns:
- broker spec truth
- spread/state readability
- conditions-side truth consumed by Surface and Output

### Missing legacy intelligence
- observed-vs-effective distinction
- provenance tags
- capability matrix ideas
- spec hash / change tracking
- bounded probe-summary semantics

### Exact archive source files
- `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`

### Exact method families worth recovering
- safe access wrappers: `GetInt`, `GetDbl`, `GetStr`, EA1 `ReadSymbol*Safe`
- validation helpers: `AFS_MC_TryValidateTickValue`, bounded adaptation only
- capability/probe summarization: `ComputeMarginRateFlags`
- optional cost probes as reference only: `PIE_ProbeValuePerPoint`, `PIE_ProbeMargin1Lot`, `CalcValuePerPoint_1Lot`, `CalcMargin_1Lot`

### Exact concepts worth recovering
- provenance source tags
- capability support flags
- spec change tracking
- no collapse of raw observed into effective derived values

### Hidden dependencies
- cost probes are dangerous without provenance fields
- some legacy condition fields assumed large output schemas
- spec hash work touches Storage if continuity compatibility uses it

### Shared-contract implications
- safe access wrappers: no major enrichment needed
- provenance/source tags: **blocked pending Common changes**
- spec hash/change semantics: **shared with Storage**

### Recovery readiness labels
- safe property wrapper recovery: **READY NOW**
- provenance/source tagging: **READY AFTER COMMON ENRICHMENT**
- capability matrix growth: **READY AFTER COMMON ENRICHMENT**
- deeper cost/margin inference: **FUTURE LAYER ONLY unless explicitly bounded**

### What should NOT be ported
- giant spec export schema blocks
- deep derived money outputs as trader-facing truth
- any method that silently upgrades unknown broker truth into certain trader truth

---

## 14. Storage Module Recovery Plan

### Current module role
`mt5/ASC_Storage.mqh` owns:
- restore-first persistence
- file read/write behavior
- atomic staging and continuity preservation

### Missing legacy intelligence
- safe-path semantics
- write-if-changed materiality logic
- continuity validity classes
- stale/corrupt/incompatible/restarted-clean semantics
- optional current/previous snapshot safety model

### Exact archive source files
- `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
- `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`

### Exact method families worth recovering
- path/file safety: `IsSafeRelativePath`, folder/file ensure helpers
- atomic write variants: `WriteTextAtomic`, `WriteTextIfChanged`, `AtomicWriteText`
- continuity doctrine blocks from EA1: stale/corrupt/incompatible/resume logic
- stable-signature path helpers from AFS TraderIntel where bounded and useful

### Exact concepts worth recovering
- explicit restart-path truth
- continuity compatibility reasons
- bounded current/previous snapshot safety
- materiality-aware write suppression where safe

### Hidden dependencies
- continuity compatibility may require spec hash support from Conditions
- restart-state exposure may require Engine or Output visibility hooks
- current/previous snapshot discipline affects publication assumptions

### Shared-contract implications
- path safety and atomic write refinement: **READY NOW**
- continuity-state vocabulary: **READY AFTER COMMON ENRICHMENT**
- spec-hash-aware compatibility: **READY ONLY AFTER Conditions first**

### Recovery readiness labels
- atomic/path-safe refinement: **READY NOW**
- restart-state vocabulary: **READY AFTER COMMON ENRICHMENT**
- spec-aware compatibility enforcement: **READY ONLY AFTER ANOTHER MODULE FIRST**
- current/previous snapshot expansion: **DEFERRED until publishability semantics are stronger**

### What is too heavy from ISSX/EA1
- full shared/debug/lock directory hierarchies
- giant stage continuity ecosystems
- broad multi-consumer persistence schemas

---

## 15. Output Module Recovery Plan

### Current module role
`mt5/ASC_Output.mqh` owns:
- writer-only publication
- summary and symbol-file routing
- universe mirror output

### Missing legacy intelligence
- publishability classes richer than current `PUBLISHED/PENDING_SCAN/UNAVAILABLE`
- bounded internal diagnostics separation
- later dossier explanation text
- richer honesty labels without summary bloat

### Exact archive source files
- `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
- `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- `archives/LEGACY_SYSTEMS/ISSX/issx_system_snapshot.mqh`
- `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

### Exact method families worth recovering
- route safety and write-failure logging from AFS output debug
- bounded labeling/sanitization from ISSX snapshot helpers
- dossier explanation helpers from AFS TraderDossierEngine

### Exact concepts worth recovering
- publishability separate from truth presence
- compact trader output with stronger internal honesty
- later symbol-file explanatory text for ACTIVE dossier growth

### Hidden dependencies
- richer publishability depends on Common fields
- dossier explanation depends on Surface/Conditions richness first
- diagnostics separation depends on future diagnostics route decisions

### Shared-contract implications
- write-failure route ideas: **READY NOW** if kept internal
- publishability classes: **READY AFTER COMMON ENRICHMENT**
- dossier explanation layers: **READY ONLY AFTER Surface and Conditions first**

### Recovery readiness labels
- route/log safety: **READY NOW**
- publishability class enrichment: **READY AFTER COMMON ENRICHMENT**
- deeper dossier text: **READY ONLY AFTER ANOTHER MODULE FIRST**
- diagnostics package expansion: **FUTURE LAYER ONLY**

---

## 16. Surface Module Recovery Plan

### Current module role
`mt5/ASC_Surface.mqh` owns:
- Layer 2 bounded readiness evaluation
- quote age / history / bucket / conditions gate
- initial score and shortlist bridge

### Missing legacy intelligence
- hydration state
- degraded/weak/partial readiness classes
- friction decomposition
- movement readiness nuance
- deterministic tie-break context
- richer rankability gate

### Exact archive source files
- `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`

### Exact method families worth recovering
- `AFS_HF_HydrationStage`
- `AFS_HF_IsSessionClosedHint`
- `AFS_HF_ComputeFreshnessScore`
- `AFS_HF_MovementScore`
- `AFS_SL_IsRankable`
- `AFS_SL_BetterTieBreak`
- bounded truth/freshness class vocabulary from ISSX selection

### Exact concepts worth recovering
- partial readiness vs full rankability
- freshness bands
- friction-poor vs dead market distinctions
- weak-link explanation for non-rankability

### Hidden dependencies
- many legacy methods require spread sample rings and richer intermediate state
- trust/rankability logic assumes provenance-rich inputs from Conditions and session nuance from Market

### Shared-contract implications
- degraded-state vocabulary and rankability classes must exist in `ASC_Common.mqh`
- tie-break context may need shared fields if Output or later diagnostics consume it

### Recovery readiness labels
- hydration/degraded vocabulary: **READY AFTER COMMON ENRICHMENT**
- friction decomposition: **READY ONLY AFTER Market + Conditions truth first**
- deterministic tie-break logic: **READY AFTER COMMON ENRICHMENT**
- full multi-axis trust score: **DEFERRED until supporting truth fields exist**

### What should precede ranking growth
- Conditions provenance
- session nuance
- degraded-state vocabulary

---

## 17. Engine Module Recovery Plan

### Current module role
`mt5/ASC_Engine.mqh` owns:
- orchestration order
- bounded cycle cadence
- restore-first sequencing across modules

### Missing legacy intelligence
- bounded budget/phase discipline for heavier later truth work
- restart-state visibility hooks
- future guardrails for diagnostics and later-layer work

### Exact archive source files
- `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_scheduler.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh` (restore coupling only)

### Exact method families worth recovering
- reduced budget semantics from `RemainingTotalBudget`, `CanSpend`, `SpendCommit`, `DeadlineHit`
- pulse/phase guard ideas only where they support bounded scanning

### Exact concepts worth recovering
- explicit budget preservation for heavyweight later work
- restart-state exposure from Storage into orchestration diagnostics

### Hidden dependencies
- ISSX runtime helpers assume kernel/stage queue families not present in ASC
- over-importing phase models would silently redesign the engine

### Shared-contract implications
- minimal budget guard ideas: **READY NOW** conceptually
- explicit restart-state exposure: **READY ONLY AFTER Storage/Common first**

### Recovery readiness labels
- reduced guard concepts: **DEFERRED but plausible**
- deep runtime phase shell: **FORBIDDEN / PREMATURE**
- restart-state visibility hooks: **READY ONLY AFTER ANOTHER MODULE FIRST**

---

## 18. Common Contract Recovery Plan

### Current module role
`mt5/ASC_Common.mqh` is the shared contract surface.
It must not become a legacy mega-struct dump.

### Exact legacy intelligence pressure
The following concept groups are currently too thin:
1. degraded-state vocabulary
2. provenance/source-truth fields
3. restart/compatibility vocabulary
4. publishability / rankability classes
5. identity ambiguity lineage

### Exact archive source files justifying bounded enrichment
- `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_system_snapshot.mqh`

### Bounded enrichments justified
- enums or labels for degraded-state classes
- enums or labels for persistence validity / restart-state classes
- fields or flags for observed-vs-effective provenance
- fields or labels for publishability / weak-link cause
- identity ambiguity metadata where actually consumed

### Explicit anti-bloat rule
`ASC_Common.mqh` should absorb vocabulary and bounded cross-module fields, not legacy subsystem payloads.

### Recovery readiness labels
- degraded-state enums: **READY NOW** as contract work if bounded tightly
- provenance fields: **READY NOW** if kept minimal
- publishability classes: **READY NOW** if explicitly consumed by Surface/Output plans
- giant legacy record growth: **FORBIDDEN**

---

## 19. UI / Diagnostics Future Recovery Plan

### Current role status
No active `ASC_UI.mqh` file is present in the main MT5 set.
UI/diagnostics remain future-layer only.

### Archive source files
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui_test.mqh`
- `archives/MAPS/unclassified/Hud design.txt`
- `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`

### Recovery opportunity
- later operator visibility for:
  - scanner health
  - rankability reasons
  - restart-state truth
  - internal warnings

### Recovery readiness labels
- on-chart controls and HUD: **FUTURE LAYER ONLY**
- internal diagnostics route planning: **DEFERRED**
- trader-facing output changes to simulate diagnostics: **FORBIDDEN**

---

## 20. Archive Method Families by Module

### Market
- normalization methods
- session-window methods
- quote-validity methods
- classification ambiguity methods

### Conditions
- safe property access methods
- observed/effective separation methods
- capability matrix methods
- spec change tracking methods

### Storage
- path safety methods
- atomic write methods
- write-if-changed methods
- continuity validity methods

### Output
- route and failure-log methods
- publishability labeling methods
- dossier explanation methods

### Surface
- hydration methods
- freshness methods
- friction/movement methods
- rankability and tie-break methods

### Engine
- budget guard methods
- reduced phase discipline methods
- restart-visibility orchestration hooks

### UI / Diagnostics
- warning presentation methods
- bounded state-render methods
- click/section control methods

---

## 21. Archive Struct/Enum Concepts by Module

### Market
- confidence / review / alias lineage concepts from AFS classification
- optional family/theme concepts from ISSX market-state work

### Conditions
- observed-vs-effective field pairs
- capability flags
- spec-hash / spec-change counters

### Storage
- restart-state enums
- compatibility-reason enums
- persistence validity flags

### Output
- publishability class enums
- bounded hydration/publish labels

### Surface
- degraded-state enums
- freshness / weak-link / trust classes

### Engine
- minimal budget state or guard vocabulary only if later layers need it

### UI / Diagnostics
- warning severity and health-state render labels only after later-layer opening

---

## 22. Provenance Recovery Plan

### Immediate provenance work
- recover safe property wrappers for Conditions so property acquisition becomes more disciplined
- keep current explicit-unknown behavior intact

### Next provenance work after Common enrichment
- add source tags for derived/effective condition values
- add identity ambiguity lineage if classification uncertainty remains material
- add restart origin truth in Storage

### Provenance non-goals
- do not port full machine-facing provenance schemas from EA1
- do not produce trader output clutter to expose provenance details prematurely

---

## 23. Restart / Continuity Recovery Plan

### Stage 1
- tighten path-safe, atomic-write discipline in Storage
- keep restore-first law unchanged

### Stage 2
- add Common restart-state vocabulary
- add storage-side stale/corrupt/incompatible/resumed distinctions

### Stage 3
- if Conditions gains spec hash/change support, incorporate that into compatibility reasoning

### Stage 4
- only later consider current/previous snapshot safety extensions if needed for output honesty

### Recovery status
- Stage 1: **READY NOW**
- Stage 2: **READY AFTER COMMON ENRICHMENT**
- Stage 3: **READY ONLY AFTER ANOTHER MODULE FIRST**
- Stage 4: **DEFERRED**

---

## 24. Ranking / Decomposition Recovery Plan

### Required order
1. degraded-state vocabulary
2. session and conditions nuance
3. hydration / freshness / weak-link classes
4. tie-break logic
5. only then richer ranking decomposition

### Archive source files
- `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- bounded label support from `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`

### Recovery statuses
- weak-link and degraded-state vocabulary: **READY AFTER COMMON ENRICHMENT**
- deterministic tie-breaks: **READY AFTER COMMON ENRICHMENT**
- richer total-score decomposition: **READY ONLY AFTER Market + Conditions + Surface truths first**

---

## 25. Publication Honesty Recovery Plan

### Core publication-honesty objective
Keep trader output compact while reducing false confidence.

### Recovery opportunities
- route and write-failure discipline from AFS OutputDebug
- richer upstream publishability classes
- internal diagnostic separation from trader artifacts

### Recovery constraints
- no stage/debug schema import into summary output
- no writer-side computation creep
- no fake “complete” symbol status when upstream state is still partial

### Recovery statuses
- route/log safety: **READY NOW**
- richer publishability labels: **READY AFTER COMMON ENRICHMENT**
- internal diagnostics package: **FUTURE LAYER ONLY**

---

## 26. Operator Visibility Recovery Plan

### Purpose
Future operator visibility should explain scanner health without mutating product identity.

### Archive lineage
- ISSX UI/menu family
- AFS output/debug family
- EA1 diagnostic doctrine

### What later operator visibility should expose
- continuity/restart state
- why a symbol is not rankable
- why conditions truth is partial
- output route/write failure state

### What it must not expose
- trading controls
- strategy execution controls
- portfolio state machines
- archive-era framework shell modes

### Recovery status
- bounded operator visibility: **FUTURE LAYER ONLY**

---

## 27. Recovery Dependencies and Prerequisites

### Dependency A
Market normalization should precede any confidence or family enrichment.

### Dependency B
Conditions provenance should precede any trust-score or advanced rankability growth.

### Dependency C
Common degraded-state vocabulary should precede hydration/friction recovery.

### Dependency D
Continuity compatibility semantics should precede deeper Layer 3 persistence growth.

### Dependency E
Publishability classes should precede any richer output honesty labeling.

### Dependency F
Internal diagnostics separation should precede any bounded UI/operator layer.

---

## 28. Hidden Couplings and Trapdoors

### Trapdoor 1 — method appears local but consumes missing state
Example:
- `AFS_HF_ComputeFreshnessScore`
- actually depends on spread/history/session assumptions absent in current Surface contract

### Trapdoor 2 — exporter method looks reusable but encodes exporter schema assumptions
Examples:
- deep spec extractors
- MarketISS export cost methods

### Trapdoor 3 — ranking helper looks generic but rests on absent truth model
Examples:
- `AFS_SL_ComputeTrustScore`
- ISSX selection truth classes

### Trapdoor 4 — continuity logic depends on hidden version/fingerprint ecosystem
Examples:
- EA1 continuity doctrine
- ISSX persistence shell

### Trapdoor 5 — UI helper depends on stage-row / warning-list ecosystem
Examples:
- ISSX UI/menu methods

---

## 29. What Each Future Worker Prompt Must Include

1. exact current owner module
2. exact blueprint contracts served
3. exact archive source files
4. exact methods or doctrine blocks to translate
5. do/adapt/ban classification
6. hidden couplings
7. shared-contract implications
8. recovery readiness label
9. explicit success condition
10. explicit non-goals

---

## 30. What Each Future Worker Prompt Must Forbid

1. no direct struct import from legacy monoliths
2. no raw formula or threshold port without supporting truth model
3. no blueprint rewrites unless a real contradiction is discovered
4. no MT5 module boundary drift
5. no writer-side computation creep in Output
6. no stage/debug schema port into trader-facing artifacts
7. no UI/operator shell work before later-layer authorization
8. no recovery packets that fail to name exact archive sources

---

## 31. Suggested Future Recovery Waves

### Wave 1 — Market + Conditions safety hardening
- market normalization hardening
- conditions safe property wrappers
- storage path/atomic-write hardening

### Wave 2 — Common contract enrichment
- degraded-state vocabulary
- provenance/source fields
- restart-state vocabulary
- publishability/rankability classes

### Wave 3 — Market and Surface truth nuance
- session-window nuance
- quote validity nuance
- hydration/degraded-state recovery

### Wave 4 — Conditions and Storage truth maturity
- observed-vs-effective conditions provenance
- continuity stale/corrupt/incompatible semantics
- spec hash/change tracking if justified

### Wave 5 — Ranking and publication honesty
- tie-break logic
- rankability decomposition
- publishability class usage in output honesty

### Wave 6 — Later symbol intelligence and operator visibility
- dossier explanation layers
- bounded diagnostics
- bounded operator visibility

---

## 32. Exact High-Leverage Next Build Targets

### Target 1
**Market normalization hardening** in `mt5/ASC_Market.mqh` using AFS normalization lineage.

Why highest leverage:
- strengthens all downstream truth with low structural risk.

### Target 2
**Conditions safe property wrapper recovery** in `mt5/ASC_Conditions.mqh` using ISS spec extraction and EA1 read-wrapper lineage.

Why highest leverage:
- immediately improves data honesty without forcing major schema growth.

### Target 3
**Storage path-safe atomic write refinement** in `mt5/ASC_Storage.mqh` using ISSX persistence and extracted export-cadence helpers.

Why highest leverage:
- aligns directly with blueprint persistence law and is safely bounded.

### Target 4
**Common degraded-state / provenance / restart vocabulary enrichment** in `mt5/ASC_Common.mqh`.

Why highest leverage:
- unlocks most blocked high-value recoveries.

### Target 5
**Surface hydration and deterministic tie-break groundwork** in `mt5/ASC_Surface.mqh` after Common enrichment.

Why highest leverage:
- converts current shortlist bridge into a more truthful selection surface without overreaching into full ranking complexity.

---

## 33. Canonical Guidance for HQ

### HQ guidance 1
Use the master map to justify recovery.
Use this execution plan to sequence and package recovery.

### HQ guidance 2
Issue one bounded module-centric recovery packet at a time.
Do not ask a worker to recover multiple legacy subsystems in one prompt unless the shared-contract boundary is the point of the packet.

### HQ guidance 3
Before opening any recovery packet, check whether it is:
- ready now
- ready after Common enrichment
- ready only after another module first
- future layer only

### HQ guidance 4
Prefer the next wave to be:
1. Market normalization
2. Conditions safe wrappers
3. Storage path-safe atomic refinement
4. Common contract enrichment

### HQ guidance 5
Do not let archive excitement distort build order.
The correct question is not “what is coolest in legacy?”
The correct question is “what recovery strengthens current scanner truth safely now?”

---

## 34. Final Recovery Summary

The repository now has two canonical non-Aurora archive office documents:
- `office/MASTER_SYSTEM_ARCHIVE_MAP.md` for lineage and translation intelligence
- `office/LEGACY_RECOVERY_EXECUTION_PLAN.md` for future execution structure

The highest-value current recoveries are not the biggest legacy subsystems.
They are the smallest bounded truths that unlock safe downstream growth:
- market normalization
- safe conditions reads
- path-safe atomic storage refinement
- bounded Common vocabulary enrichment

The most important blockers are not lack of archive material.
They are thin shared contracts and hidden couplings.

Future HQ should therefore recover legacy intelligence in this order:
- strengthen current truth surfaces first
- enrich shared vocabulary second
- recover degraded/rankability/restart nuance third
- only then expand dossier, diagnostics, and operator visibility

That is the canonical execution position this repository should now use for legacy-to-ASC recovery.
