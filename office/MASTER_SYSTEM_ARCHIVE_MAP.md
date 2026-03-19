# MASTER SYSTEM & ARCHIVE MAP

## 1. Purpose of This Document

This file is the canonical non-Aurora lineage map for Aurora Sentinel Scanner (ASC).

It exists to give future HQ, Codex, and workers a single office document that answers all of the following without requiring repeated archive rediscovery:
- what the current ASC system is
- what the current office/control layer governs
- what the active blueprint law requires
- what the major non-Aurora legacy systems were trying to solve
- which legacy ideas ASC has already recovered
- which legacy lessons ASC still lacks
- which archive material should influence future work
- which archive material should remain historical reference only
- which legacy patterns are dangerous to copy directly

This document is intentionally deep. It is not a front-door summary. It is a permanent internal orientation spine.

---

## 2. Scope and Exclusions

### In scope
- `office/`
- `blueprint/`
- `mt5/`
- `archives/` excluding Aurora folders
- non-Aurora legacy blueprints
- non-Aurora legacy systems
- non-Aurora old EAs
- extracted non-Aurora reference code
- non-Aurora map fragments relevant to scanner lineage

### Explicit exclusion
All paths under `archives/Aurora/` are excluded from this map.

That exclusion is absolute for this run. Aurora library books, PDFs, and Aurora-specific research indexing were not used to shape the conclusions below.

### Interpretation rule
- Active truth lives in `blueprint/` and current `mt5/` code.
- Office truth governs execution, sequencing, and worker boundaries.
- Archives provide provenance, translation hints, warnings, and historical lessons.
- Archive authority is directional, not direct. The proper flow remains `archives/ -> blueprint/ -> office/ -> mt5/`.

---

## 3. Current ASC System Identity

ASC is currently a broker-aware MT5 scanner and market-intelligence publisher, not a trading engine.

Its active identity is narrower and cleaner than several legacy ancestors:
- scanner-first
- classification-aware
- broker-universe aware
- persistence-aware
- shortlist-oriented
- publication-oriented
- manual-trader-facing rather than auto-execution-facing

### Current mission shape
ASC currently aims to:
1. discover the broker universe
2. translate symbol identity into canonical classification truth
3. read broker market and conditions truth
4. preserve truthful universe continuity
5. perform bounded surface evaluation
6. publish a broker summary and per-symbol files

### What ASC is deliberately not
Relative to multiple archive predecessors, ASC explicitly refuses to become:
- a trading EA
- a portfolio/risk governor
- a multi-EA orchestration framework
- a research OS
- a rulecard extraction system
- an execution supervisor
- a macro/context ingestion stack

That narrowing is not accidental simplification. It is a deliberate anti-drift correction after several archive systems expanded scope faster than product truth stabilized.

---

## 4. Current Office / Control System Map

The office layer is now a governance shell around the product, not a shadow architecture. Its job is to preserve truth, sequencing, and bounded execution.

### Control identity
The office layer currently enforces:
- the locked 7-role worker model
- current stage and ownership truth
- build order discipline
- post-run review law
- archive usage discipline
- continuity for fresh HQ chats

### Locked 7-role worker model
1. HQ
2. Engine Worker
3. Market Worker
4. Conditions Worker
5. Storage + Output Worker
6. Clerk
7. Debug

### Important office truths
- Product modules may outnumber workers.
- Surface, Ranking, Diagnostics, and UI are product domains, not automatically new worker roles.
- Clerk and Debug are post-run reviewers, not implementation workers.
- Only one build worker may run at a time.
- Archive files are preserved source memory and are not edited as implementation.

### Office layer’s real function in lineage terms
Compared with older systems, the office layer is one of ASC’s strongest innovations. Legacy systems embedded architectural policy inside code comments, filenames, ad hoc JSON schema rules, or sprawling blueprints. The office layer externalizes those governance burdens into explicit control documents so current MT5 code can stay product-facing.

---

## 5. Current Blueprint Law Map

The blueprint layer is the constitutional bridge between archives and live MT5 implementation.

### What the active blueprint locks
- system identity
- module boundaries
- classification and market identity law
- runtime order
- layer model
- lifecycle and activation law
- persistence and atomic write law
- fail-fast and explicit-unknown law
- summary/ranking publication law
- product naming and language boundary law

### Most important blueprint doctrines currently active
1. `PrimaryBucket` is the canonical grouping truth for summary, ranking, and promotion.
2. Classification is upstream truth, not a writer-side convenience.
3. Restore-first persistence is mandatory.
4. Writers format and persist only; they do not compute.
5. Missing truth must remain explicit.
6. Layer ordering is real and must not be faked by later-layer outputs.
7. Only ACTIVE symbols may receive Layer 3 rolling dossier continuation.
8. Product language must stay trader/domain oriented rather than office/dev oriented.

### Blueprint role relative to archives
The blueprint is not a summary of everything the archive ever attempted. It is a disciplined constitutional subset that selects the durable scanner-specific lessons and discards multi-system sprawl.

---

## 6. Current MT5 Product Map

### Current live files
- `mt5/AuroraSentinel.mq5`
- `mt5/ASC_Common.mqh`
- `mt5/ASC_Engine.mqh`
- `mt5/ASC_Market.mqh`
- `mt5/ASC_Conditions.mqh`
- `mt5/ASC_Storage.mqh`
- `mt5/ASC_Output.mqh`
- `mt5/ASC_Surface.mqh`
- `mt5/ASC_UI.mqh` not currently present in the main flat file set

### Product composition
The product is a flat MT5 EA with clear module segmentation:
- common contracts and types
- runtime orchestration
- market truth intake
- conditions truth intake
- storage and restoration
- output publication
- surface evaluation foundation

### Current runtime character
ASC is already stronger than many legacy artifacts in one specific way: it has a cleaner separation between data truth, persistence behavior, and publication behavior.

### Current incompleteness
ASC is still incomplete relative to blueprint ambition and legacy breadth in these areas:
- deeper ranking refinement
- explicit activation gate implementation maturity
- ACTIVE-only rolling dossier depth
- richer operator-facing UI/HUD
- broader diagnostics surface
- richer historical continuity layers

---

## 7. Current ASC Module-by-Module Understanding

### Engine
Role:
- startup order
- cadence control
- orchestrated calls across market, conditions, storage, surface, and output

Strength:
- bounded, explicit, scanner-oriented orchestration

Current gap:
- still early relative to old multi-stage orchestration systems with richer scheduling and degraded-mode telemetry

### Market
Role:
- symbol discovery
- canonical identity
- classification translation
- `PrimaryBucket` assignment
- Layer 1 eligibility truth
- session/market status inputs

Strength:
- puts classification and eligibility upstream where they belong

Current gap:
- legacy systems often tracked more nuanced session fallbacks, open/closed reasons, and asset-family heuristics

### Conditions
Role:
- spec truth
- spread and readability truth
- broker conditions intake

Strength:
- explicit readable/unreadable law and no fake zeros

Current gap:
- legacy EA1 and ISS-style systems went much deeper on derived cost truth, margin probing, and capability flags

### Storage
Role:
- restore-first loading
- gap-fill persistence
- bounded atomicity and staging

Strength:
- cleaner constitutional rules than legacy persistence systems

Current gap:
- old EA1/ISSX work explored richer restart continuity compatibility, stale discards, and bounded continuity metadata

### Output
Role:
- publish summary, symbol files, and universe mirror
- route output paths
- keep writer-only discipline

Strength:
- strong separation between truth generation and formatting

Current gap:
- current summary remains intentionally lightweight relative to legacy stage/debug publication ecosystems

### Surface
Role:
- early Layer 2 readiness check using M15/H1, quote freshness, conditions readability, and bucket presence

Strength:
- simple, understandable shortlist bridge

Current gap:
- many legacy systems had richer movement, friction, hydration, and score decomposition

---

## 8. Current Layer-by-Layer Understanding

### Layer 1 — Market Truth
Current ASC uses this layer for universe identity, classification, existence, session truth, and first eligibility decisions.

### Layer 1.2 — Universe Snapshot
ASC preserves a broker-universe continuity view so output and later layers are not forced to rediscover the world from zero each cycle.

### Layer 2 — Surface Scan
Current ASC evaluates quote freshness, spec readability, and minimum history presence for shortlist readiness.

### Activation Gate
Still more constitutional than mature in live implementation. The blueprint is clear that ACTIVE rights are meaningful and restrictive.

### Layer 3 — Deep persistent dossier
Still materially incomplete compared with blueprint intent and far behind the richest legacy persistence ideas.

### Layer 4 — Future only
Correctly blocked. Several archives over-expanded before the scanner core became stable.

---

## 9. Current Worker / Ownership Model

### Ownership map in practical terms
- Engine Worker owns orchestration and cadence.
- Market Worker owns symbol truth and classification translation.
- Conditions Worker owns broker spec and spread truth.
- Storage + Output Worker owns restore/persist/write surfaces.
- HQ owns sequencing and contradiction control.
- Clerk and Debug own post-run review integrity.

### Why this matters historically
Legacy systems often collapsed orchestration, truth capture, publication, and debug into one EA or one large module family. ASC’s ownership model is a deliberate countermeasure against that collapse.

---

## 10. Current Known Strengths

1. **System identity discipline** — ASC is no longer pretending to be an everything-engine.
2. **Blueprint clarity** — active contracts are more explicit than most legacy artifacts.
3. **Office governance** — current worker and review law sharply reduces drift.
4. **Writer-only doctrine** — stronger than many legacy publication layers.
5. **`PrimaryBucket` law** — current grouping truth is clearer than multiple older bucket attempts.
6. **Restore-first persistence doctrine** — now explicit and centrally enforced.
7. **Language boundary law** — current product naming is cleaner than older dev-heavy naming.
8. **Layer discipline** — ASC recognizes earlier truth must exist before later-layer claims.

---

## 11. Current Known Weaknesses

1. **Legacy depth not yet recovered** in cost, continuity, sessions, and diagnostics.
2. **Layer 3 remains thin** relative to both blueprint intention and EA1 continuity lessons.
3. **Activation maturity is not fully realized** in current product behavior.
4. **Operator control surface is light** compared with AFS and ISSX HUD/menu experiments.
5. **Ranking remains foundational rather than rich** compared with older shortlist engines.
6. **Historical archive learning is easy to lose** without this map because the non-Aurora archive landscape is fragmented.
7. **Current output is intentionally conservative** and therefore less information-dense than some legacy debug/stage outputs.

---

## 12. Archive Landscape Overview

The non-Aurora archive landscape falls into six practical groups:

1. **Legacy system families**
   - `archives/LEGACY_SYSTEMS/AFS/`
   - `archives/LEGACY_SYSTEMS/EA1/`
   - `archives/LEGACY_SYSTEMS/ISSX/`
   - `archives/LEGACY_SYSTEMS/Old EAS/`

2. **Legacy blueprint doctrine**
   - `archives/BLUEPRINT_REFERENCE/`

3. **Extracted runtime/code references**
   - `archives/EXTRACTED_REFERENCE/runtime_cadence/`
   - `archives/extracted_reference/README.md`

4. **Loose map fragments and UI notes**
   - `archives/MAPS/unclassified/`

5. **Archive governance/navigation**
   - `archives/README.md`
   - `archives/INDEX.md`
   - `archives/ARCHIVE_IMMUTABILITY.md`

6. **Mixed loose text material**
   - `archives/LEGACY_SYSTEMS/New Text Document (3).txt`

### Archive shape conclusion
The non-Aurora archive is not one coherent prior system. It is a layered archaeological record of several attempted scanner families, some doctrinal texts, and some experimental wrappers/tools.

---

## 13. Archive Reading Rules

For future HQ/workers, the correct non-Aurora archive reading rule is:

1. Read current office and blueprint truth first.
2. Use archive files to understand provenance, not to override active law.
3. Translate archive lessons conceptually before implementation.
4. Treat code-era naming and stage wording as historical context, not mandatory current naming.
5. Distinguish:
   - **Active Law**
   - **Translation Reference**
   - **Historical Only**
   - **Obsolete**
   - **Dangerous Legacy Pattern**

### Critical safety rule
If an archive file contains scanner truth mixed with trading, risk, account, or multi-EA orchestration logic, only the scanner truth is potentially reusable for ASC.

---

## 14. Archive Exclusions (Aurora folders excluded)

### Excluded zone
- `archives/Aurora/`

### Why exclusion matters
The Aurora subtree contains broader research and concept material that could easily re-expand ASC’s scope into a universal market OS or execution architecture. That would corrupt this mapping project.

### Resulting discipline
This map only uses non-Aurora lineage relevant to current MT5 scanner construction.

---

## 15. Archive Folder-by-Folder Map

### `archives/BLUEPRINT_REFERENCE/`
Status: **Translation Reference / Historical Doctrine**

Contains preserved prior blueprint-style texts describing larger systems and earlier scanner/market doctrines. Valuable for lineage and vocabulary recovery, but dangerous if treated as active contract because scope is far wider than current ASC.

### `archives/EXTRACTED_REFERENCE/runtime_cadence/`
Status: **Translation Reference**

Contains standalone EAs used to export or inspect truth contracts. Useful for understanding older publication schemas, spec extraction approaches, and structural cadence ideas.

### `archives/LEGACY_SYSTEMS/AFS/`
Status: **High-Leverage Translation Reference**

A rich scanner family with classification, market core, history/friction, selection, analytics, dossier, and debug/output routing. One of the strongest direct ancestors for scanner-first logic.

### `archives/LEGACY_SYSTEMS/EA1/`
Status: **Historical Bridge / Concept Reference**

Represents an earlier market-core phase with later refined blueprint text in `EA1_MARKETCORE_FINAL.txt`. Useful for continuity, stage schema, and cost/spec/session truth lessons.

### `archives/LEGACY_SYSTEMS/ISSX/`
Status: **High-Leverage but Dangerous Translation Reference**

A more ambitious consolidated wrapper/kernel ecosystem with persistence, runtime, selection, correlation, telemetry, and UI. Valuable for orchestration lessons and state decomposition, but too large and multi-EA-centric to copy directly.

### `archives/LEGACY_SYSTEMS/Old EAS/`
Status: **Mixed High/Medium Value Historical Reference**

Contains earlier one-file EA experiments. Some are direct predecessors of later modular systems; others are snapshots of exploratory approaches.

### `archives/MAPS/unclassified/`
Status: **Low/Medium Value Historical Reference**

Mostly loose concept notes and UI fragments. Useful for operator-surface lineage but not direct law.

---

## 16. Legacy Systems Map

### AFS — Aegis Forge Scanner
What it was:
- a scanner-centric MT5 system with strong emphasis on classification, market core, friction/history analysis, selection, trader analytics, dossier generation, and output/debug routing

What problem it was solving:
- how to turn a broker universe into a classified, scored, trader-usable shortlist with deeper per-symbol intelligence

What it did well:
- explicit classification table
- rich per-symbol struct design
- layered surface/history/friction/selection progression
- trader-mode vs dev-mode thinking
- output path clarity and debug logging

What it did poorly:
- substantial complexity and field sprawl
- coupled truth structures that are expensive to carry forward unchanged
- evolving path/output routes that suggest continuity drift during development

Still useful now:
- classification vocabulary and shape
- surface/history/friction decomposition
- shortlist scoring concepts
- dossier/report lineage
- operator-facing package concepts

Dangerous to copy directly:
- giant shared structs as-is
- legacy path proliferation
- score formulas without blueprint translation
- HUD/output assumptions baked into older runtime state fields

### EA1 family
What it was:
- a market-core lineage that evolved toward a highly truthful observability engine with deterministic stage/debug output and bounded continuity

What problem it was solving:
- how to build a stable market truth core that emits canonical downstream state for later EAs/systems

What it did well:
- deep spec truth
- explicit session truth and reason channels
- cost/fill/margin provenance emphasis
- continuity compatibility/staleness law
- deterministic JSON output schemas

What it did poorly:
- scope broadening toward a stage-based downstream ecosystem bigger than ASC needs
- schema density and diagnostic richness that can overwhelm first-slice scanner simplicity

Still useful now:
- continuity policy
- spec hash/change thinking
- explicit partial-data truth
- reason-code discipline
- capability flags
- stale/freshness decomposition

Dangerous to copy directly:
- giant stage/debug schemas wholesale
- multi-output contract expectations
- downstream pipeline assumptions

### ISSX family
What it was:
- a consolidated kernel/wrapper architecture coordinating multiple EA states and subsystems with persistence, selection, history, market, correlation, and UI layers

What problem it was solving:
- how to create a durable, multi-stage market intelligence wrapper around multiple upstream/downstream EA roles

What it did well:
- runtime shell discipline
- registry/runtime separation
- persistence and scheduler thinking
- universe/state consolidation
- menu/UI/operator orientation

What it did poorly:
- too much framework gravity for current ASC scope
- high conceptual overhead
- greater risk of scanner mission dilution into orchestration platform behavior

Still useful now:
- cadence/scheduler lessons
- state registration ideas
- degradation/telemetry concepts
- UI control lineage

Dangerous to copy directly:
- full wrapper model
- multi-EA state expectations
- correlation-heavy architecture before scanner core is complete

### PIE and ISS-Lite style one-file tools
What they were:
- analytics-only or observability snapshots that exported structured JSON for universe, costs, correlations, and debug

What they solved:
- early deterministic truth extraction and scoring under MT5 constraints

What they did well:
- timer-only discipline
- structured export contracts
- deterministic ordering
- broad symbol-universe introspection

What they did poorly:
- monolithic single-file growth
- weaker governance boundaries than current ASC

Still useful now:
- export contract ideas
- deterministic ordering rules
- broad spec/tick truth extraction patterns

Dangerous to copy directly:
- monolith design
- premature correlation complexity

---

## 17. AFS Deep Map

### AFS identity
AFS is the clearest scanner-first ancestor in the non-Aurora archive.

### Core files
- `AFS_CoreTypes.mqh`
- `AFS_Classification.mqh`
- `AFS_MarketCore.mqh`
- `AFS_HistoryFriction.mqh`
- `AFS_Selection.mqh`
- `AFS_TraderIntel.mqh`
- `AFS_TraderAnalyticsEngine.mqh`
- `AFS_TraderDossierEngine.mqh`
- `AFS_OutputDebug.mqh`
- `Aegis_Forge_Scanner.mq5`
- `ORIGINAL/*.txt`

### What AFS solved well
1. **Classification as an explicit artifact**
   - AFS uses embedded classification rows with fields close to current ASC identity needs: raw symbol, canonical symbol, display name, asset class, `PrimaryBucket`, sector, industry, theme bucket, subtype, alias kind, confidence, review status, notes.
   - This is a direct lineage ancestor for current ASC market identity law.

2. **Surface / history / friction separation**
   - AFS separated market surface state from historical movement and friction state.
   - Current ASC has recovered only part of that separation through Market + Conditions + Surface. It has not yet recovered AFS’s richer friction/hydration language.

3. **Selection as a separate concern**
   - AFS kept scoring and ranking separate from raw market/spec capture.
   - This strongly aligns with current ASC’s writer-only law and layered ranking law.

4. **Trader package thinking**
   - AFS was already thinking in terms of summary + dossier + logs packages.
   - Current ASC’s output model is cleaner and smaller, but this lineage is direct.

### Where AFS is stronger than current ASC
- richer surface and friction scoring
- richer shortlist/tie-break logic
- stronger trader dossier ancestry
- more developed operator-profile thinking

### Where current ASC is stronger than AFS
- cleaner constitutional governance
- cleaner separation between blueprint law and product code
- clearer archive immutability boundary
- stronger anti-drift control layer

### AFS lessons still missing in ASC
- friction-specific truth layer
- richer score decomposition suitable for ranking
- operator/HUD decisions about how shortlist context should be surfaced
- more explicit warming/degraded/weak states for surface/history quality

---

## 18. Old Blueprints Deep Map

### `archives/BLUEPRINT_REFERENCE/AURORA.txt`
This is a very broad universal trading OS blueprint. It is historically valuable for showing the older habit of building a full architecture stack with layered governance, journaling, vaults, context ingestion, and execution-facing structures.

#### Value
- shows how earlier doctrine separated observer/context layers from decision layers
- shows emphasis on deterministic law, missing-data handling, and document pointer governance
- preserves anti-fiction language that still resonates with ASC’s explicit-unknown doctrine

#### Danger
- far too broad for ASC
- heavily execution/risk/account oriented
- would reintroduce system sprawl immediately if treated as source contract

#### ASC translation use
- conceptual reminder that missing truth must be explicit
- reminder that document-layer governance matters
- not a scanner contract source

### `AURORA — UNIVERSAL MULTI-ASSET MARK.txt`
This appears to sit closer to market/scanner ambition than the universal OS file, but still belongs to a much wider conceptual system than current ASC.

### `AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`
Important for lineage because it shows the old ISS/Aurora relationship logic and multi-firm discipline. Still too broad and too prop-/firm-/execution-aware for direct scanner use.

### AFS original blueprint texts
- `AEGIS FORGE SCANNER.txt`
- `BP1.txt`
- `BP2.txt`
- `BP3.txt`
- `Blueprint suggestions.txt`

These are higher value to ASC than the giant Aurora universal texts because they focus more directly on scanner formation, module staging, shortlist logic, and trader-facing structure.

### Old blueprint conclusion
There are two legacy blueprint categories:
1. **Useful scanner doctrine** — AFS and EA1 market-core texts.
2. **Too-broad system doctrine** — Aurora universal texts and ISS/Aurora ecosystem texts.

ASC should primarily inherit from category 1.

---

## 19. Old EAs Deep Map

### EA1_MarketCore lineage
Files:
- `EA1_MarketCore.mq5`
- `EA1_MarketCore_Phase1.mq5`
- `EA1_MarketCore_Lean.mq5`
- `EA1_MarketCore_Final.mq5`
- `EA1/ORIGINAL/AURORA_StructureEA_*.mq5`
- `EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`

#### What they were solving
- universal symbol discovery
- spec/session/tick truth
- deterministic stage publication
- restart continuity
- truthful partial data handling

#### Strong contributions
- canonical state/output shape thinking
- operational health decomposition
- freshness and continuity law
- distinction between observed and effective values
- explicit source tags and reason codes

#### Weaknesses
- schema bloat
- downstream consumer assumptions not needed by ASC
- language still shaped by broader stage-ecosystem architecture

### EA2_HistoryMetrics.mq5
Likely an intermediate metrics/history layer focused on deeper analytical signals, useful mainly as a reminder of how quickly metric layers can outgrow truth-layer stability.

### EA3_Intelligence.mq5
Represents a later intelligence/consolidation layer that ingests upstream snapshots and adds leadership/correlation/basket/event logic.

#### High-value lesson
Do not build this before scanner truth and continuity are solid.

#### Current ASC translation
This file is mostly a warning about sequencing. It has useful integrity concepts, but it belongs much later than current ASC scope.

### ISSX_DEV_Friction.mq5 and ISSX_MarketStateCore.mq5
These are especially valuable because they isolate scanner-relevant layers without needing the full ISSX wrapper family.

### PIE.MT5.mq5
A deterministic one-shot analytics exporter with strong emphasis on timer-only discipline, JSON validity, and batch structuring.

---

## 20. Old Scanner / First-Step Logic Map

Across AFS, EA1, ISS-Lite, PIE, and ISSX DEV friction code, the recurring first-step scanner logic is:
1. build universe
2. normalize symbol identity
3. classify asset/sector/bucket/family
4. collect raw spec truth
5. collect current quote/tick truth
6. determine session/open/closed/eligible state
7. measure freshness/liveliness/friction
8. rank or shortlist within class/bucket
9. publish deterministic outputs
10. persist enough continuity to avoid cold restarts

### What old systems consistently got right
- first-step layers must be truth-first
- universe and identity are foundational
- specs and tick state must be separated
- missing data must be explicit
- ranking without classification is unstable

### What old systems repeatedly struggled with
- how much persistence is enough
- how much debug/state publication is too much
- how much later-layer intelligence belongs in early stages
- how to keep operator-facing output compact while preserving internal truth richness

### ASC status against this lineage
ASC has recovered steps 1–7 in a leaner way, but steps 8–10 remain thinner than the best legacy examples.

---

## 21. Old Classification / Market Truth Map

### Strongest lineage source
`archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`

This file is one of the highest-value non-Aurora archive files because it explicitly encodes a classification row with fields that map cleanly onto current ASC identity concepts.

### Legacy classification lessons
- broker raw symbols need normalization and suffix stripping
- canonical symbol identity cannot be assumed from raw symbol names
- asset class and bucket must be explicit fields
- sector/industry/theme enrichment improves downstream usability
- confidence/review status matter when translation is imperfect

### Market-truth lineage across archives
AFS, EA1, and ISSX-derived market files all treat these as distinct concerns:
- existence in broker universe
- visibility/selection status
- quote availability
- trade availability
- session openness
- freshness / liveliness
- eligibility state

### Current ASC recovery level
Recovered well:
- identity normalization and classification importance
- `PrimaryBucket` centrality
- existence/session/trade-window style truth
- eligibility gating as upstream concern

Still missing or thinner:
- confidence/review/alias richness
- richer session fallback reasoning
- broader family/theme metadata use

---

## 22. Old Spec / Conditions Truth Map

### Highest-value ancestry
- `EA1_MARKETCORE_FINAL.txt`
- `ISS-X Spec Extraction EA.mq5`
- `ISSX_MarketStateCore.mq5`
- `PIE.MT5.mq5`
- `AFS_MarketCore.mqh`

### Shared legacy lessons
1. Raw observed spec fields and derived effective values must not be conflated.
2. Tick value, point, contract size, volume step, and trade mode need explicit readability/provenance.
3. Margin/cost truth often requires careful probing and should remain tagged with sources.
4. Session truth and spec truth are related but not the same.
5. Capability flags matter because brokers differ materially.

### What legacy solved better than current ASC
- spec hash / change tracking
- margin/carry/commission completeness logic
- capability matrices
- richer trade mode / close-only / disabled distinctions

### What ASC correctly avoids
- overcommitting to low-confidence cost inference before the scanner core is complete
- pretending every broker field can be made trustworthy through aggressive derivation

### Translation recommendation
ASC should absorb the discipline of explicit source/provenance and change detection, without inheriting the full cost-engine sprawl.

---

## 23. Old Snapshot / Continuity / Persistence Map

### Strongest ancestry
EA1 and ISSX families.

### Legacy continuity lessons
- restart continuity is useful but must be bounded
- continuity must be per symbol / per firm where relevant
- stale continuity must be rejected cleanly
- corrupt continuity must not poison live runtime
- compatibility checks matter
- persistence is not the same as downstream publication

### Important recurring concepts
- schema versioning
- engine version compatibility
- identity hashes / fingerprints
- fresh vs stale thresholds
- resume vs clean restart truth
- current/previous snapshot safety behavior

### Current ASC status
ASC has constitutional restore-first and atomic write doctrine, which is excellent. However, current live implementation appears materially less mature than legacy EA1 in:
- continuity metadata richness
- stale/incompatible discard law exposure
- compatibility semantics
- resume-state transparency

### High-value conceptual lift
ASC should eventually adopt more of EA1’s bounded continuity truth model, but adapted to ASC’s much smaller scanner scope.

---

## 24. Old Summary / Output / Publication Map

### Legacy publication types
- stage JSON snapshots
- debug JSON snapshots
- trader summaries
- symbol dossiers
- logs and failure logs
- universe exports
- correlation exports

### What legacy did well
- deterministic ordering
- explicit producer/stage identity
- strong publication reasoning for debug/state consumers

### What legacy did poorly
- too many output surfaces for first usable trader value
- easy drift between internal state and external packages
- some systems optimized for downstream machines more than human trader usability

### Current ASC judgment
Current ASC is better scoped for trader-facing output. Legacy systems are still highly valuable for publication hygiene, route discipline, and explicit unknown handling.

---

## 25. Old HUD / Menu / Operator-Control Map

### Main sources
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui_test.mqh`
- `archives/MAPS/unclassified/Hud design.txt`
- AFS runtime/dev-vs-trader profile notions

### Legacy lessons
- operator surfaces were being treated as meaningful, not cosmetic
- menu/HUD ideas often bundled runtime state, mode, and diagnostic visibility
- old systems wanted explicit operator control over profile, cadence, or slice behavior

### Current ASC status
ASC currently has very light UI surface. That is acceptable for the current milestone, but legacy material shows there is a real future demand for a bounded operator-control layer.

### Warning
The old HUD/menu layer should not be rebuilt before the scanner truth and ranking flow are stable.

---

## 26. Legacy-to-ASC Translation Map

### Direct translations already visible
- AFS classification table concepts -> current market identity / `PrimaryBucket` law
- legacy scanner-first ethos -> ASC product identity
- legacy summary + dossier pairing -> ASC summary + symbol output model
- legacy restore/warm-state concern -> ASC restore-first persistence law
- legacy explicit missing truth -> ASC fail-fast and unknown-value doctrine

### Partial translations
- friction and hydration ideas -> partially visible in ASC surface scan, but still thin
- per-symbol continuity -> blueprint law recognizes persistence importance, but live ASC is lighter than EA1 lineage
- reason-code/state decomposition -> partially visible, not yet legacy-depth

### Not yet translated sufficiently
- richer capability and cost truth
- continuity compatibility/staleness semantics
- mature ranking decomposition
- operator UI/HUD boundary design

---

## 27. What ASC Already Recovered From Legacy

1. Scanner-first identity.
2. Classification-aware architecture.
3. Upstream market identity truth.
4. Summary + per-symbol publication model.
5. Restore-first persistence direction.
6. Missing truth must remain explicit.
7. Layer sequencing as real architecture, not naming theater.
8. No-trading scanner boundary.

---

## 28. What ASC Still Has Not Recovered

1. Rich continuity semantics from EA1/ISSX.
2. Friction/hydration/degraded-state richness from AFS and ISSX DEV layers.
3. Mature ranking/tie-break/scoring decomposition from AFS selection lineage.
4. Capability and cost truth provenance from EA1 / PIE / ISS spec tools.
5. Strong operator-control model from ISSX UI/HUD lineage.
6. Detailed compatibility/restart diagnostics from EA1 and ISSX.

---

## 29. What Legacy Did Better Than Current ASC

### Better in legacy
- session nuance
- cost and capability richness
- continuity diagnostics
- restart truthfulness depth
- shortlist scoring sophistication
- operator/HUD experimentation
- per-symbol partial/degraded state vocabulary

### Important nuance
Legacy often did these better locally, but not necessarily better globally. Many of those systems were also less controlled, more sprawling, or more difficult to keep truthful end-to-end.

---

## 30. What Current ASC Does Better Than Legacy

1. Stronger product identity discipline.
2. Clearer blueprint-to-product boundary.
3. Much cleaner office/control governance.
4. Better explicit archive immutability discipline.
5. Better writer-only doctrine.
6. Better resistance to multi-system scope creep.
7. Cleaner flat MT5 deployment expectation.

---

## 31. What Must Never Be Copied Directly

1. Giant legacy structs without re-deriving field ownership.
2. Full multi-EA wrapper architectures.
3. Broad execution/account/risk governance systems from old Aurora texts.
4. Correlation-heavy or intelligence-heavy later layers before scanner truth is solid.
5. Monolithic single-file mega-EAs as new implementation style.
6. Legacy stage/debug schema bloat as trader-facing output.
7. Any archive naming that leaks dev-stage or phase-era wording into the current product.

---

## 32. What Should Be Adapted Carefully

1. AFS classification vocabulary.
2. AFS friction/history concepts.
3. EA1 continuity/restart rules.
4. ISSX scheduler and runtime shell ideas.
5. PIE deterministic export/backup patterns.
6. ISS spec extraction discipline for conditions truth.
7. legacy output routing/logging patterns.

---

## 33. What Should Be Lifted Conceptually

1. Explicit provenance for derived truth.
2. Stale/fresh/incompatible persistence semantics.
3. Rich but bounded degraded-state vocabulary.
4. Deterministic ordering and publishing discipline.
5. Per-symbol operational health reasoning.
6. Clear operator-facing separation between concise summary and deeper symbol intelligence.

---

## 34. Where the New EA Still Needs Work

1. **Ranking depth** — current surface score is a start, not a mature shortlist engine.
2. **Activation law implementation** — ACTIVE rights need stronger operational realization.
3. **Layer 3 dossier persistence** — still much thinner than intended.
4. **Conditions richness** — source/provenance and broader capability truth remain limited.
5. **Continuity compatibility** — live ASC needs stronger stale/incompatible/corrupt handling semantics.
6. **UI/operator surface** — future need, currently light.
7. **Diagnostic richness** — especially around restart, persistence, and why a symbol is ineligible or only partially ready.

---

## 35. File-by-File Reference Index

### Archive governance and navigation

#### `archives/README.md`
- Role: archive front door
- Contains: brief definition of archive purpose
- Contribution: sets read-only historical reference expectations
- Relation to ASC: governance support only
- Status: **Historical Reference / Governance Support**
- Future influence: low direct implementation influence, high procedural influence

#### `archives/INDEX.md`
- Role: full archive navigation map
- Contains: top-level archive usage rules and folder roles
- Contribution: helps distinguish blueprint reference vs extracted code vs legacy systems
- Relation to ASC: safe archive navigation
- Status: **Translation Reference / Governance Support**
- Future influence: medium for future archive work discipline

#### `archives/ARCHIVE_IMMUTABILITY.md`
- Role: hardlock law for archives
- Contains: allowed vs forbidden archive actions
- Contribution: prevents lineage corruption
- Relation to ASC: ensures provenance remains stable
- Status: **Active Governance Law for archive handling**
- Future influence: high for process integrity

### Blueprint reference files

#### `archives/BLUEPRINT_REFERENCE/README.md`
- Role: brief folder descriptor
- Status: **Historical Reference**

#### `archives/BLUEPRINT_REFERENCE/AURORA.txt`
- Role: very broad universal trading OS blueprint
- Contribution: historical doctrinal context on deterministic law and missing-data handling
- Relation to ASC: conceptual only, not scanner contract
- Status: **Historical Only / Dangerous if over-applied**
- Future influence: low direct, medium conceptual caution

#### `archives/BLUEPRINT_REFERENCE/AURORA — UNIVERSAL MULTI-ASSET MARK.txt`
- Role: older market system blueprint text
- Contribution: preserves historical market-system vocabulary
- Relation to ASC: lineage context, not direct law
- Status: **Historical Reference**
- Future influence: medium only if reconciling old terminology

#### `archives/BLUEPRINT_REFERENCE/AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`
- Role: old Aurora/ISS combined doctrine
- Contribution: multi-firm and observer/decision lineage context
- Relation to ASC: indirect; useful mainly for understanding why current ASC excludes execution/prop-safety scope
- Status: **Historical Reference / Dangerous if treated as active scope**

### Extracted reference files

#### `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`
- Role: one-shot export of symbol truth/account/structure/correlation
- Contribution: shows earlier truth-export shape and helper patterns
- Relation to ASC: useful for export discipline and field ideas, not direct runtime architecture
- Status: **Translation Reference**
- Future influence: medium

#### `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- Role: structural/spec export utility with atomic write behavior and technical metrics helpers
- Contribution: useful for contract extraction, atomic output discipline, and staged export thinking
- Relation to ASC: strong conditions/output reference, but naming/scope are legacy
- Status: **Translation Reference**
- Future influence: medium/high for conditions and publication hygiene

#### `archives/extracted_reference/README.md`
- Role: lower-case folder readme for extracted reference space
- Contribution: low informational value
- Status: **Historical Reference**

### AFS files

#### `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
- Role: core structs/enums contract
- Contains: module states, profiles, runtime state, universe symbol record, memory shell, output path state, trader intel caches
- Contribution: strongest snapshot of what AFS considered the protected scanner truth surface
- Relation to ASC: important translation source for which fields belong to classification, surface, history, friction, selection, and publication layers
- Status: **High-Leverage Translation Reference**
- Future influence: high conceptually, dangerous for direct struct copy

#### `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Role: embedded classification engine/table
- Contribution: one of the best non-Aurora references for canonical identity translation
- Relation to ASC: direct lineage to current market identity and `PrimaryBucket` law
- Status: **High-Leverage Translation Reference**
- Future influence: very high

#### `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- Role: surface + spec refresh core
- Contribution: shows older handling of quote state, session state, promotion state, spread samples, and spec integrity
- Relation to ASC: strong source for market/conditions/surface enrichment
- Status: **High-Leverage Translation Reference**
- Future influence: high

#### `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Role: history and friction analysis layer
- Contribution: movement, hydration, liveliness, freshness, ATR-based readiness, friction flags
- Relation to ASC: primary source for what current Surface layer has not yet recovered
- Status: **High-Leverage Translation Reference**
- Future influence: high

#### `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Role: ranking and shortlist engine
- Contribution: cost/trust scoring, tie-breakers, correlation finalist logic
- Relation to ASC: major source for future ranking refinement
- Status: **High-Leverage Translation Reference**
- Future influence: high

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`
- Role: deeper trader-intelligence computations
- Contribution: richer downstream symbol intelligence concepts
- Relation to ASC: later Layer 2/3 conceptual source
- Status: **Translation Reference**
- Future influence: medium/high

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`
- Role: analytics layer across timeframes and metrics
- Contribution: shows how the scanner was expected to deepen into analytical dossier content
- Relation to ASC: useful for later dossier design, not current first slice
- Status: **Translation Reference / Later-slice**
- Future influence: medium

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
- Role: dossier assembly engine
- Contribution: direct ancestor of richer per-symbol intelligence packaging
- Relation to ASC: future Layer 3 reference
- Status: **Translation Reference / Later-slice**

#### `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
- Role: output routing and logging helper
- Contribution: exposes canonical vs legacy route tension and debug/logging discipline
- Relation to ASC: useful warning and pathing reference
- Status: **Medium/High Translation Reference**

#### `archives/LEGACY_SYSTEMS/AFS/Aegis_Forge_Scanner.mq5`
- Role: main AFS EA wrapper
- Contribution: integration picture for AFS modules
- Relation to ASC: useful for scanner runtime lineage, but not current style target
- Status: **Historical Translation Reference**

#### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/AEGIS FORGE SCANNER.txt`
#### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP1.txt`
#### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP2.txt`
#### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP3.txt`
#### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/Blueprint suggestions.txt`
- Role: blueprint-era scanner doctrine and evolution notes
- Contribution: records original scanner intent before later code drift
- Relation to ASC: conceptual scanner lineage
- Status: **High-Value Historical Doctrine**
- Future influence: medium/high when validating intended scanner direction

### EA1 files

#### `archives/LEGACY_SYSTEMS/EA1/README.md`
- Role: EA1 folder orientation
- Status: **Historical Reference**

#### `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/AURORA_StructureEA_Test_v0.1.mq5`
#### `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/AURORA_StructureEA_Phase1_Test.mq5`
- Role: early EA1/structure-era implementation snapshots
- Contribution: transitional origin of market-core ideas
- Relation to ASC: historical bridge only
- Status: **Historical Only**

#### `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Role: final EA1 market-core blueprint/spec text
- Contribution: one of the highest-value non-Aurora files for continuity, stage schema, conditions truth, freshness, capability, and bounded persistence lessons
- Relation to ASC: conceptual goldmine for future truth-layer hardening
- Status: **High-Leverage Translation Reference**
- Future influence: very high, but adapt carefully

### ISSX modular files

#### `archives/LEGACY_SYSTEMS/ISSX/ISSX.mq5`
- Role: consolidated wrapper EA
- Contribution: shows kernel-cycle integration and multi-state shell
- Relation to ASC: orchestration cautionary and conceptual reference
- Status: **Translation Reference / Dangerous if copied directly**

#### `issx_config.mqh`
- Role: configuration surface
- Relation to ASC: limited direct value; useful for seeing older config boundaries
- Status: **Medium Historical Reference**

#### `issx_contracts.mqh` and `ORIGINAL/issx_contracts_patched.mqh`
- Role: central contracts
- Contribution: reveals formalization attempts in ISSX
- Relation to ASC: conceptual contract discipline source
- Status: **Translation Reference**

#### `issx_core.mqh`
- Role: shared kernel/core definitions
- Contribution: core state and runtime semantics
- Relation to ASC: orchestration lineage
- Status: **Translation Reference**

#### `issx_runtime.mqh`
- Role: runtime shell behavior
- Contribution: scheduler/cycle/control flow ancestry
- Relation to ASC: useful for engine hardening ideas
- Status: **High-value Translation Reference**

#### `issx_market_engine.mqh`
- Role: market state subsystem
- Relation to ASC: scanner-relevant
- Status: **High-value Translation Reference**

#### `issx_history_engine.mqh`
- Role: history subsystem
- Relation to ASC: later Surface/Layer 3 reference
- Status: **Translation Reference**

#### `issx_selection_engine.mqh`
- Role: shortlist/selection subsystem
- Relation to ASC: ranking reference
- Status: **High-value Translation Reference**

#### `issx_correlation_engine.mqh`
- Role: correlation subsystem
- Relation to ASC: low current relevance; later-only and easy scope trap
- Status: **Historical / Dangerous for premature adoption**

#### `issx_persistence.mqh`
- Role: persistence subsystem
- Relation to ASC: high-value for persistence/restart lineage
- Status: **High-value Translation Reference**

#### `issx_universe_manager.mqh`
- Role: universe control
- Relation to ASC: scanner-relevant
- Status: **Translation Reference**

#### `issx_system_snapshot.mqh`
- Role: snapshot assembly
- Relation to ASC: snapshot and mirror lineage
- Status: **Translation Reference**

#### `issx_registry.mqh`, `issx_stage_registry.mqh`
- Role: registry/state routing
- Relation to ASC: mainly orchestration lineage
- Status: **Medium Translation Reference**

#### `issx_scheduler.mqh`
- Role: scheduling subsystem
- Relation to ASC: useful engine reference
- Status: **Medium/High Translation Reference**

#### `issx_data_handler.mqh`
- Role: shared data pipeline utility
- Relation to ASC: medium utility
- Status: **Medium Translation Reference**

#### `issx_metrics.mqh`
- Role: metrics calculations
- Relation to ASC: later ranking/diagnostic reference
- Status: **Medium Translation Reference**

#### `issx_telemetry.mqh`
- Role: telemetry surface
- Relation to ASC: diagnostic lineage
- Status: **Medium Translation Reference**

#### `issx_debug_engine.mqh`
- Role: debug subsystem
- Relation to ASC: useful for post-run/product diagnostics concepts
- Status: **Medium Translation Reference**

#### `issx_ui.mqh`, `issx_menu.mqh`, `issx_ui_test.mqh`
- Role: UI/HUD/control surfaces
- Relation to ASC: operator-control lineage only
- Status: **Medium Historical Reference**

#### `issx_memory_guard.mqh`
- Role: memory protection / boundedness helper
- Relation to ASC: interesting bounded-runtime lineage
- Status: **Medium Translation Reference**

#### `issx_error_codes.mqh`
- Role: explicit error taxonomy
- Relation to ASC: useful if later diagnostic vocabulary expands
- Status: **Medium Translation Reference**

### Old EAS files

#### `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore.mq5`
#### `EA1_MarketCore_Phase1.mq5`
#### `EA1_MarketCore_Lean.mq5`
#### `EA1_MarketCore_Final.mq5`
- Role: market-core evolution snapshots
- Contribution: code-side history of increasingly disciplined truth capture and publication
- Relation to ASC: continuity/spec/session lineage
- Status: **High-value Translation Reference**

#### `EA2_HistoryMetrics.mq5`
- Role: secondary metrics/history engine
- Relation to ASC: later analytical depth reference
- Status: **Medium Historical Reference**

#### `EA3_Intelligence.mq5`
- Role: intelligence fusion layer using upstream EA1/EA2 snapshots
- Relation to ASC: later-layer warning and concept source only
- Status: **Historical / Later-only**

#### `ISS-X Spec Extraction EA.mq5`
- Role: deep spec harvester
- Relation to ASC: high-value conditions truth reference
- Status: **High-value Translation Reference**

#### `ISSX.mq5`
- Role: wrapper copy under Old EAS
- Relation to ASC: overlaps modular ISSX family; mainly historical
- Status: **Historical Reference**

#### `ISSX_DEV_Friction.mq5`
- Role: universe + lightspec + friction + Stage A export
- Relation to ASC: high-value surface/friction ancestry
- Status: **High-value Translation Reference**

#### `ISSX_MarketStateCore.mq5`
- Role: thin wrapper around market-state core logic
- Relation to ASC: high-value market/spec classification reference
- Status: **High-value Translation Reference**

#### `ISS_LITE_CORR30.mq5`
- Role: broker-native snapshot with cost and correlation
- Relation to ASC: medium value; useful for deterministic broad-universe export patterns, low value for immediate scanner scope
- Status: **Medium Translation Reference**

#### `PIE.MT5.mq5`
- Role: deterministic analytics-only snapshot/export engine
- Relation to ASC: useful for deterministic output and broad truth extraction discipline
- Status: **Medium/High Translation Reference**

### Map fragments and misc files

#### `archives/MAPS/unclassified/Hud design.txt`
- Role: HUD/operator concept notes
- Relation to ASC: future UI/HUD inspiration only
- Status: **Historical Reference**

#### `archives/MAPS/unclassified/New Text Document.txt`
#### `archives/MAPS/unclassified/New Text Document (2).txt`
- Role: loose historical notes
- Relation to ASC: very limited direct value
- Status: **Low-value Historical Reference**

#### `archives/LEGACY_SYSTEMS/New Text Document (3).txt`
- Role: loose mixed note file
- Relation to ASC: minimal direct value
- Status: **Low-value Historical Reference**

---

## 36. High-Value Archive Files

Highest-value non-Aurora archive files for future ASC build intelligence:

1. `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
2. `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
3. `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
4. `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
5. `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
6. `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
7. `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
8. `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`
9. `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
10. `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
11. `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`
12. `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
13. `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
14. `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`

### Why these are highest value
Together they cover the missing middle between current ASC’s clean first slice and the richer legacy treatment of:
- classification
- market truth
- spec truth
- friction/history readiness
- selection/ranking
- continuity/restart semantics
- export contract discipline

---

## 37. Medium-Value Archive Files

1. `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
2. `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`
3. `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`
4. `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
5. `archives/LEGACY_SYSTEMS/ISSX/issx_scheduler.mqh`
6. `archives/LEGACY_SYSTEMS/ISSX/issx_system_snapshot.mqh`
7. `archives/LEGACY_SYSTEMS/ISSX/issx_telemetry.mqh`
8. `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
9. `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
10. `archives/LEGACY_SYSTEMS/Old EAS/ISS_LITE_CORR30.mq5`
11. `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`
12. AFS original blueprint text files

### Meaning of medium-value
These files help orientation and later refinement, but they are either later-slice, partially redundant, or burdened by extra system scope.

---

## 38. Low-Value / Historical-Only Archive Files

1. loose `New Text Document*` files
2. generic folder readmes after initial orientation
3. very broad universal Aurora blueprint files when the task is current scanner construction
4. old transitional EA snapshots that were superseded by richer EA1 market-core doctrine

Low-value does not mean useless. It means they should not drive build decisions unless a very specific provenance question arises.

---

## 39. Obsolete or Dangerous Legacy Patterns

1. **Multi-EA ecosystem creep** before scanner truth is stable.
2. **Monolithic mega-EA files** that combine truth capture, ranking, debug, and publication in one surface.
3. **Schema maximalism** where every possible field is emitted before operator value is proven.
4. **Dev-stage naming leakage** into final product identity.
5. **Correlation-first expansion** before core shortlist truth is reliable.
6. **Execution/risk/account scope bleed** from old universal-system texts.
7. **Copying giant legacy structs** instead of re-deriving bounded ASC contracts.
8. **Treating archive code as active law** without blueprint translation.

---

## 40. Recommended Future Use of Archives

### Use archives for
- validating current blueprint decisions against past lessons
- harvesting missing continuity and conditions semantics
- enriching ranking logic safely
- designing a future bounded operator-control surface
- preventing reinvention of already-solved scanner problems

### Do not use archives for
- direct code transplant into current MT5 modules
- justifying scanner scope expansion into execution/risk systems
- bypassing blueprint/office governance
- reviving deprecated naming or stage ecosystems wholesale

---

## 41. Current Build Implications

1. Market, Conditions, Surface, and Storage should remain the immediate truth-layer focus.
2. Ranking should evolve from current surface foundations using AFS/ISSX lessons, not by inventing a fresh ungrounded scheme.
3. Persistence should gradually absorb EA1-style continuity rigor.
4. Output should stay trader-compact even if internal truth becomes richer.
5. Engine growth should borrow scheduler discipline from ISSX without inheriting wrapper sprawl.

---

## 42. Current Truth-Layer Implications

### Market truth implications
- Keep classification upstream.
- Keep `PrimaryBucket` canonical.
- Preserve explicit eligibility/ineligibility reasons.
- Consider legacy confidence/alias/review semantics if classification ambiguity becomes operationally important.

### Conditions truth implications
- Add more provenance semantics before adding more derived values.
- Prefer explicit unreadable/unknown to fabricated completeness.
- Consider spec-hash/change tracking once first-slice stability is secure.

### Surface truth implications
- Current surface evaluation is a valid minimum but not a final shortlist truth layer.
- Legacy friction/history lessons are the main next enrichment source.

---

## 43. Current UI / Operator-Control Implications

1. Current ASC can remain UI-light for now.
2. When UI is opened, legacy HUD/menu material should be mined for bounded operator value rather than cosmetic complexity.
3. Operator control should expose scanner state, shortlist routing, and health—not rebuild a platform shell.
4. Old menu/HUD work proves there was real demand for operator visibility, but the product should not front-run core truth stability.

---

## 44. Current Ranking / Summary Implications

1. Summary should continue to use `PrimaryBucket` only.
2. Top-5-per-bucket remains the correct compact trader-facing surface.
3. Ranking should grow by adding better internal score decomposition, not by bloating the summary file.
4. AFS selection and ISSX/EA1 readiness vocabulary are the main archive sources for smarter ranking eligibility.

---

## 45. Current Development Risks

1. **Archive over-application risk** — importing too much legacy complexity too early.
2. **Archive amnesia risk** — forgetting high-value continuity and conditions lessons.
3. **Governance bypass risk** — letting product code absorb architecture directly from legacy files.
4. **Ranking drift risk** — inventing score logic without lineage or blueprint alignment.
5. **Persistence naivety risk** — under-building continuity compared with already-learned legacy lessons.
6. **UI temptation risk** — adding interface layers before truth layers are stable.

---

## 46. Current Missing Systems / Gaps

### High-priority gaps relative to legacy
- bounded continuity compatibility and stale-discard semantics
- richer surface/friction readiness vocabulary
- stronger ranking decomposition
- conditions/source provenance depth
- more explicit degraded/partial/restart diagnostic exposure

### Medium-priority gaps
- dossier depth for ACTIVE symbols
- future operator-control surface
- broader telemetry and health surfacing

### Low-priority current gaps
- correlation and basket intelligence
- multi-stage downstream pipeline support
- broad machine-consumer stage schemas

---

## 47. Recommended Long-Horizon Build Priorities

1. **Harden truth-layer continuity** using EA1/ISSX persistence lessons.
2. **Enrich Surface -> Ranking transition** using AFS history/friction/selection lessons.
3. **Strengthen conditions/source semantics** using EA1/ISS tools.
4. **Build bounded ACTIVE dossier continuation** using AFS dossier ancestry, not old stage-schema sprawl.
5. **Add a narrow operator-control layer** only after ranking and continuity are stable.
6. **Keep archive usage explicit**: source file named, lesson named, adaptation boundary named.

---

## 48. Final Canonical Understanding Summary

ASC is the disciplined scanner descendant of several non-Aurora lineages, especially AFS, EA1 market-core work, and parts of ISSX/ISS-derived observability tools.

Its current office and blueprint system is significantly more controlled than legacy predecessors. That governance strength is real and should be preserved.

However, the legacy archive still contains meaningful scanner intelligence that ASC has not fully recovered yet. The most important missing legacy lessons are not broad universal-system ideas. They are specific, practical scanner truths:
- richer continuity semantics
- richer friction/history readiness semantics
- richer capability/provenance semantics
- stronger shortlist/ranking decomposition
- clearer degraded/restart/operator visibility

The correct path forward is therefore:
- preserve current ASC identity and governance
- mine non-Aurora archives selectively and explicitly
- adapt legacy lessons conceptually
- refuse direct system transplantation
- continue building the scanner, not reviving the old platform sprawl

That is the canonical lineage position this repository should now hold.


---

## 49. Cross-System Link Matrix

This section is the explicit anti-ambiguity layer. It exists so future HQ can move from concept -> blueprint law -> live MT5 module -> archive lineage without inference gaps.

### 49.1 Product identity and scope boundary matrix

#### Concept: ASC is a scanner, not a trader
[LINKS]
- Blueprint: `blueprint/SYSTEM_OVERVIEW.md`, `blueprint/RUNTIME_RULES.md`, `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`
- MT5: `mt5/AuroraSentinel.mq5`, `mt5/ASC_Engine.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/BLUEPRINT_REFERENCE/AURORA.txt`, `archives/BLUEPRINT_REFERENCE/AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`, `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`

System intelligence:
- The blueprint and current MT5 product sharply narrow product identity to scanner/publisher behavior.
- The archive shows the exact opposite pressure: repeated expansion toward execution, multi-stage intelligence, portfolio state, or full operating-system ambitions.
- Future HQ should treat scope drift not as a style issue but as a historical recurrence that already happened multiple times.

#### Concept: trader-facing outputs must stay compact
[LINKS]
- Blueprint: `blueprint/SUMMARY_SCHEMA.md`, `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`
- MT5: `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`

System intelligence:
- Current ASC intentionally compresses publication into summary plus symbol files.
- Legacy systems repeatedly split publication into debug, stage, logs, dossiers, snapshots, and machine-facing outputs.
- The archive teaches output hygiene and explicit unknown handling, but not output count discipline.

### 49.2 Layer architecture matrix

#### Concept: Layer 1 market truth
[LINKS]
- Blueprint: `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/MARKET_IDENTITY_MAP.md`, `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`
- MT5: `mt5/ASC_Market.mqh`, `mt5/ASC_Common.mqh`, `mt5/ASC_Engine.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`, `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`

System intelligence:
- Blueprint defines Layer 1 as truth acquisition, not scoring.
- Current MT5 market code is the point where archive classification lineage must be translated into clean current runtime identity.
- Legacy market engines solved more nuance than ASC currently captures, especially around session/open reasons and symbol-family heuristics.

#### Concept: Layer 1.2 universe snapshot continuity
[LINKS]
- Blueprint: `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`, `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`
- MT5: `mt5/ASC_Storage.mqh`, `mt5/ASC_Output.mqh`, `mt5/ASC_Engine.mqh`
- Archive: `archives/LEGACY_SYSTEMS/ISSX/issx_system_snapshot.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

System intelligence:
- Current ASC’s universe snapshot is conceptually right but implementation-light compared with legacy continuity sophistication.
- Archive systems show why snapshot identity, freshness, and previous/current safety matter.

#### Concept: Layer 2 surface scan
[LINKS]
- Blueprint: `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`, `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
- MT5: `mt5/ASC_Surface.mqh`, `mt5/ASC_Conditions.mqh`, `mt5/ASC_Market.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`

System intelligence:
- The current MT5 surface module is the thinnest major area relative to archive ancestry.
- Legacy surface logic was not just history presence; it also reasoned about liveliness, hydration, weak/partial readiness, and friction quality.

#### Concept: Activation Gate and Layer 3 rights
[LINKS]
- Blueprint: `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`, `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`, `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`
- MT5: `mt5/ASC_Surface.mqh`, `mt5/ASC_Storage.mqh`, `mt5/ASC_Engine.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`

System intelligence:
- Blueprint is already strict about ACTIVE rights and dossier continuation.
- Current MT5 product has only partial live realization of those restrictions.
- Archive systems show the danger of implicitly deepening state before promotion/eligibility truth is firm.

### 49.3 Classification and grouping matrix

#### Concept: `PrimaryBucket` is the canonical grouping truth
[LINKS]
- Blueprint: `blueprint/MARKET_IDENTITY_MAP.md`, `blueprint/SUMMARY_SCHEMA.md`, `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`
- MT5: `mt5/ASC_Market.mqh`, `mt5/ASC_Output.mqh`, `mt5/ASC_Surface.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`

System intelligence:
- This is one of the clearest blueprint-to-archive recovery points in the repository.
- AFS and related legacy market files contain the conceptual ancestry for bucket-level grouping.
- Current ASC now enforces this centrally, which is stronger governance than legacy, but the richness of classification metadata is still reduced.

### 49.4 Conditions truth matrix

#### Concept: specs, spreads, and readable conditions truth
[LINKS]
- Blueprint: `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`, `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`, `blueprint/SUMMARY_SCHEMA.md`
- MT5: `mt5/ASC_Conditions.mqh`, `mt5/ASC_Common.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`

System intelligence:
- Conditions truth is the strongest area where current ASC is intentionally conservative.
- Archive tools prove that broader spec and cost truth can be captured, but also show how quickly the system becomes dense and brittle.

### 49.5 Persistence and restart matrix

#### Concept: restore-first persistence
[LINKS]
- Blueprint: `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`, `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
- MT5: `mt5/ASC_Storage.mqh`, `mt5/ASC_Engine.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore_Final.mq5`

System intelligence:
- Current blueprint law has already internalized the core persistence lesson from legacy: read before write, preserve continuity, and avoid blind resets.
- What remains unrecovered is not the direction of law, but the operational richness of compatibility and stale-discard semantics.

### 49.6 Output and publication matrix

#### Concept: writers do not compute
[LINKS]
- Blueprint: `blueprint/SUMMARY_SCHEMA.md`, `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`, `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`
- MT5: `mt5/ASC_Output.mqh`, `mt5/ASC_Storage.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`

System intelligence:
- Current ASC is stronger than legacy here because the doctrine is explicit and office-enforced.
- Archive output systems remain useful primarily for deterministic ordering, route hygiene, and failure logging.

### 49.7 Control-layer matrix

#### Concept: office law vs legacy code-embedded governance
[LINKS]
- Blueprint: `blueprint/MODULE_MAP.md`, `blueprint/RUNTIME_RULES.md`
- MT5: all current flat MT5 modules, especially `mt5/ASC_Engine.mqh`
- Archive: `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`, `archives/LEGACY_SYSTEMS/ISSX/issx_scheduler.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`

System intelligence:
- Legacy systems often made architecture inseparable from implementation surfaces.
- Current office/blueprint layers are a structural improvement that should not be surrendered when mining archive lessons.

---

## 50. Archive Extraction Candidates

This section identifies exact archive functions, patterns, and data shapes worth translation consideration. It is not permission to port code directly.

### 50.1 Classification extraction candidates

#### Candidate: suffix stripping + normalization pipeline
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Notable patterns: `AFS_CL_StripKnownBrokerSuffixes`, `AFS_CL_RemovePunctuation`, `AFS_CL_NormalizeSymbol`
- Why it matters: symbol identity drift is one of the root causes of false grouping and continuity mismatch.
- Current ASC replication status: **PARTIAL**
- Recommendation: **translate**, not port. Re-derive normalization rules into current market identity code and document any intentional exclusions.

#### Candidate: classification row shape
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Why it matters: current ASC already uses some of these concepts, but future classification integrity would benefit from clearer support for confidence, review status, and alias-kind lineage.
- Current ASC replication status: **PARTIAL**
- Recommendation: **adapt**. Use as schema inspiration, not as raw runtime struct import.

### 50.2 Market truth extraction candidates

#### Candidate: quote/session/promotion state separation
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- Why it matters: older AFS distinguished quote state, session state, and promotion state, which helps avoid false readiness.
- Current ASC replication status: **PARTIAL**
- Recommendation: **translate** state vocabulary conceptually into current market/surface logic.

#### Candidate: market-state heuristics and asset-family inference
- Archive source: `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`
- Why it matters: this file contains richer asset class / family / theme inference and stronger market-state decomposition than current ASC.
- Current ASC replication status: **PARTIAL**
- Recommendation: **adapt carefully**; copy no naming wholesale.

### 50.3 Surface/fallback extraction candidates

#### Candidate: hydration stage and freshness scoring
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Notable patterns: friction reset, hydration stage, freshness score, history score, weak/fail reasoning
- Why it matters: current `ASC_Surface.mqh` lacks a nuanced language for partial readiness vs actionable readiness.
- Current ASC replication status: **NO** for most nuance
- Recommendation: **translate** the concepts and thresholds qualitatively, not formula-for-formula.

#### Candidate: Stage A friction shortlist pipeline
- Archive source: `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Why it matters: this file isolates a scanner-relevant subset of ISSX logic without requiring the full wrapper ecosystem.
- Current ASC replication status: **PARTIAL**
- Recommendation: **adapt** specific readiness/freshness patterns only.

### 50.4 Selection/ranking extraction candidates

#### Candidate: cost/trust/tie-break split
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Why it matters: current ASC has surface score but no mature internal decomposition for ranking truth.
- Current ASC replication status: **NO**
- Recommendation: **translate** decomposition concepts into blueprint-aligned ranking refinement.

#### Candidate: correlation finalist logic
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`, `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- Why it matters: only future-layer relevance. Not required for current first shortlist.
- Current ASC replication status: **NO**
- Recommendation: **ignore for now**; revisit only after core ranking integrity is stable.

### 50.5 Conditions truth extraction candidates

#### Candidate: deep spec harvesting
- Archive source: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- Why it matters: exposes how far broker spec truth can go, including session probing and margin-rate-related details.
- Current ASC replication status: **PARTIAL**
- Recommendation: **adapt** provenance and capability concepts; **ban** direct import of full schema complexity into current first slice.

#### Candidate: observed vs effective value separation
- Archive source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why it matters: prevents false certainty when raw broker truth is weak or contradictory.
- Current ASC replication status: **PARTIAL**
- Recommendation: **translate** aggressively at the design level.

### 50.6 Persistence extraction candidates

#### Candidate: compatibility / stale / corrupt rejection semantics
- Archive source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Why it matters: current ASC persistence law is directionally correct but operationally thinner than legacy experience.
- Current ASC replication status: **PARTIAL**
- Recommendation: **translate** into future storage hardening work.

#### Candidate: current + previous snapshot safety behavior
- Archive source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why it matters: protects downstream consumers from half-written or degraded current-cycle files.
- Current ASC replication status: **PARTIAL** via atomic staging, but not full previous/current policy
- Recommendation: **adapt** after first-slice stability is preserved.

### 50.7 Output extraction candidates

#### Candidate: deterministic output ordering and failure logs
- Archive source: `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why it matters: improves observability without polluting trader outputs.
- Current ASC replication status: **PARTIAL**
- Recommendation: **translate** route/failure discipline, but keep writer-only contract intact.

---

## 51. Dangerous Legacy Patterns (Expanded)

This section expands the earlier warnings into specific anti-port guidance.

### 51.1 Pattern: giant shared state structs as informal architecture
- Archive files: `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`
- Danger: large shared structs become de facto architecture, causing downstream modules to read fields they do not truly own.
- Consequence if copied: current module boundaries in `mt5/ASC_*` would collapse and writer-only/output discipline would weaken.
- Port status: **BANNED as direct import**
- Safe use: field ownership analysis only.

### 51.2 Pattern: multi-EA wrapper assumptions
- Archive files: `archives/LEGACY_SYSTEMS/ISSX/ISSX.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`
- Danger: current ASC is a single scanner product, not a multi-EA constellation.
- Consequence if copied: would reintroduce orchestration complexity unrelated to current deliverable.
- Port status: **BANNED**

### 51.3 Pattern: stage/debug schema maximalism as normal runtime surface
- Archive files: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Danger: easy to confuse machine-facing completeness with trader-facing usefulness.
- Consequence if copied: output surface bloat and slow recovery from truth bugs.
- Port status: **BANNED for trader-facing output; ADAPTABLE for internal diagnostics**

### 51.4 Pattern: direct threshold and score formula transplant
- Archive files: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Danger: legacy scores were shaped by different state fields, assumptions, and output regimes.
- Consequence if copied: misleading pseudo-scientific ranking inside a changed architecture.
- Port status: **BANNED as raw formula port**

### 51.5 Pattern: execution/risk/account concepts leaking into scanner build
- Archive files: `archives/BLUEPRINT_REFERENCE/AURORA.txt`, `archives/BLUEPRINT_REFERENCE/AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`
- Danger: scanner scope gets silently subordinated to systems it is not trying to be.
- Consequence if copied: ASC loses its constrained mission and becomes another incomplete framework.
- Port status: **BANNED from current scanner implementation**

### 51.6 Pattern: monolithic single-file analytics growth
- Archive files: `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`
- Danger: code becomes inseparable from data contracts and debug logic.
- Consequence if copied: current clean module map would rot quickly.
- Port status: **BANNED as implementation style**

### 51.7 Pattern: pretending derived cost truth is observed truth
- Archive files: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Danger: operator trust collapses when effective fields are mistaken for broker-observed facts.
- Consequence if copied: ASC conditions truth would violate current explicit-unknown law.
- Port status: **BANNED unless provenance is explicit**

---

## 52. ASC Truth Integrity Map

This section maps where truth can degrade while moving through current ASC layers and where archives already proved those degradation modes are real.

### 52.1 Identity truth chain
Flow:
1. broker symbol discovery
2. normalization / canonicalization
3. classification translation
4. `PrimaryBucket` assignment
5. downstream grouping/ranking/output

[LINKS]
- Blueprint: `blueprint/MARKET_IDENTITY_MAP.md`, `blueprint/SUMMARY_SCHEMA.md`
- MT5: `mt5/ASC_Market.mqh`, `mt5/ASC_Output.mqh`, `mt5/ASC_Surface.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`

Integrity risks:
- symbol suffix/prefix noise prevents canonical match
- classification fallback is too weak or too silent
- bucket is missing but downstream output still looks complete
- identity changes break continuity mapping

Truth consequence:
- false bucket grouping
- wrong shortlist competition set
- stale persistence attached to wrong symbol identity

### 52.2 Session and tradability truth chain
Flow:
1. market-state read
2. quote/trade window interpretation
3. eligibility decision
4. surface freshness interpretation
5. output publication routing

[LINKS]
- Blueprint: `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`
- MT5: `mt5/ASC_Market.mqh`, `mt5/ASC_Surface.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`

Integrity risks:
- quote silence interpreted as closed market when feed is degraded
- trade-window truth inferred from incomplete broker fields
- stale quote age promoted into surface eligibility
- open/closed reasons missing from operator-facing surfaces

Truth consequence:
- scanner over-promotes dead symbols
- scanner hides valid symbols due to simplistic closed-state assumptions

### 52.3 Conditions truth chain
Flow:
1. raw spec read
2. readable/unreadable classification
3. optional derived interpretations
4. surface eligibility and output formatting

[LINKS]
- Blueprint: `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`, `blueprint/SUMMARY_SCHEMA.md`
- MT5: `mt5/ASC_Conditions.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

Integrity risks:
- unreadable values collapse to plausible-looking defaults
- derived effective values overwrite raw observations
- capability limitations are hidden

Truth consequence:
- misleading friction/eligibility behavior
- false trader confidence in broker terms

### 52.4 Persistence truth chain
Flow:
1. restore prior state
2. validate compatibility
3. merge new pass truth
4. write atomically
5. expose current-cycle files

[LINKS]
- Blueprint: `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
- MT5: `mt5/ASC_Storage.mqh`, `mt5/ASC_Engine.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`

Integrity risks:
- stale state treated as fresh
- incompatible shape merged silently
- current write succeeds partially but appears complete
- layer 3-like continuity implied before activation rights exist

Truth consequence:
- zombie state
- false continuity confidence
- downstream output that looks current but encodes prior-cycle assumptions

### 52.5 Output integrity chain
Flow:
1. gather already-computed truth
2. apply publication filter
3. route file paths
4. write summary and symbol files
5. remove stale symbol files

[LINKS]
- Blueprint: `blueprint/SUMMARY_SCHEMA.md`, `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`
- MT5: `mt5/ASC_Output.mqh`, `mt5/ASC_Storage.mqh`
- Archive: `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

Integrity risks:
- publication filter mistakes pending truth for publishable truth
- stale file cleanup removes the wrong symbol artifact due to identity drift
- summary looks authoritative while bucket/classification coverage is still partial

Truth consequence:
- operator sees a clean package that hides upstream uncertainty

---

## 53. Continuity & Restart Intelligence Map

### 53.1 Current ASC restart reality
Current ASC already has the correct doctrinal direction:
- restore first
- do not wipe blindly
- write atomically
- preserve broker-level continuity

But the current product is still thin in restart semantics compared with legacy systems.

[LINKS]
- Blueprint: `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`
- MT5: `mt5/ASC_Storage.mqh`, `mt5/ASC_Engine.mqh`
- Archive: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore_Final.mq5`

### 53.2 Legacy restart behavior comparison

#### EA1 lineage
- treated restart continuity as bounded but important
- tracked stale, corrupt, incompatible, resumed, and clean-restart states explicitly
- distinguished persistence from downstream publication
- used version/fingerprint ideas to avoid false resume

#### ISSX lineage
- treated persistence as part of a wider runtime shell with scheduler and registry awareness
- stronger on shell discipline, but heavier than current ASC needs

#### Current ASC
- has restore-first and atomicity principles
- has less explicit stale/corrupt/incompatible reason surfacing
- has less visible restart-state telemetry for HQ/operator diagnosis

### 53.3 Restart intelligence table

| Restart concern | Legacy treatment | Current ASC treatment | Gap severity | Guidance |
|---|---|---|---|---|
| stale continuity detection | explicit in EA1 | lighter | high | adapt EA1 stale-discard semantics |
| corrupt continuity rejection | explicit in EA1 | partially implied | high | make rejection reasons explicit |
| schema/version compatibility | explicit in EA1/ISSX | limited visibility | high | add bounded compatibility checks |
| resumed vs clean restart truth | explicit in EA1 | limited visibility | medium/high | expose restart path in diagnostics |
| current/previous snapshot safety | present in legacy | partial via atomic write | medium | extend only if needed after stability |

### 53.4 Why restart intelligence matters for ASC
Without richer restart semantics, ASC risks looking deterministic while actually carrying ambiguous historical state. That is one of the most dangerous forms of scanner drift because it is invisible at the operator layer.

---

## 54. Scanner Coverage Intelligence

This section compares what old systems covered and what current ASC intentionally leaves out.

### 54.1 Coverage categories

#### Universe coverage
- Legacy AFS/PIE/ISS-style tools often tried to cover the whole broker universe aggressively.
- Current ASC still targets full broker discovery, which is correct.
- Gap: legacy systems often had richer handling for custom symbols, disabled symbols, thin symbols, and partial readiness classes.

#### Market-state coverage
- Legacy systems often covered more explicit market-open, quote-open, trade-open, close-only, expired, disabled, or cooldown states.
- Current ASC captures a cleaner but narrower slice.

#### Conditions coverage
- Legacy systems covered more spec fields, more probing, more cost/fill semantics.
- Current ASC covers enough for first slice but is not yet deep enough for later intelligent ranking confidence.

#### History/freshness coverage
- Legacy systems used broader tick/rates/freshness/hydration logic.
- Current surface logic is intentionally lean and therefore under-covers edge cases like thin but valid symbols.

### 54.2 Coverage judgment
Legacy often covered more, but not always better. More coverage became dangerous when it outpaced truth labeling and operator clarity.

### 54.3 What better coverage would mean for ASC
Better coverage does not mean “more fields.” It means:
- more explicit degraded/partial classes
- more truthful session and quote distinctions
- better continuity compatibility
- better ranking eligibility confidence

---

## 55. Data Honesty vs Data Illusion Map

This section isolates a recurring historical failure mode: systems that look complete while actually encoding guessed, stale, or collapsed truth.

### 55.1 Honesty patterns ASC should keep
[LINKS]
- Blueprint: `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`, `blueprint/SUMMARY_SCHEMA.md`
- MT5: `mt5/ASC_Conditions.mqh`, `mt5/ASC_Output.mqh`
- Archive: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`

Keep:
- explicit `UNKNOWN`
- writer-only publication
- no fake zeros for missing truth
- clear publishable-vs-pending distinction

### 55.2 Illusion patterns found in legacy history
- effective values mistaken for observed ones
- giant debug/stage schemas giving a false impression of certainty
- ranking that appears precise but rests on mixed-quality fields
- stale continuity masquerading as current readiness
- market-closed assumptions replacing “feed degraded” uncertainty

### 55.3 Where current ASC can still create illusion
- summary can look cleaner than upstream coverage actually is
- surface eligibility can appear objective while missing richer friction nuance
- persistence can appear safe while restart-state semantics are still thin
- incomplete bucket coverage may still produce tidy output

### 55.4 Anti-illusion rule
Any future enhancement that increases apparent completeness must simultaneously increase provenance, degraded-state clarity, or explicit unknown handling.

---

## 56. Future EA Readiness Map

This section answers a narrow question: what still blocks current ASC from becoming a stronger intelligence machine without violating its scanner identity?

### 56.1 Readiness blockers

#### Blocker A: ranking integrity is still too shallow
- Missing capability: mature shortlist decomposition beyond basic surface score
- Owner: Market + Surface + future ranking packet under HQ control
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Why it matters: a scanner without trustworthy shortlist logic does not convert truth into trader action well
- Status: **blocking for mature scanner intelligence, non-blocking for first slice**

#### Blocker B: continuity semantics are too thin
- Missing capability: stale/corrupt/incompatible/resumed restart truth
- Owner: Storage + Output / Engine boundary
- Archive proof: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Why it matters: later-layer persistence and dossier behavior become unsafe without it
- Status: **blocking for serious Layer 3 maturity**

#### Blocker C: conditions provenance is incomplete
- Missing capability: richer source-aware conditions semantics and capability visibility
- Owner: Conditions
- Archive proof: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why it matters: ranking and trader trust both depend on whether broker conditions are merely read or actually interpretable
- Status: **non-blocking first slice, blocking for advanced ranking honesty**

#### Blocker D: operator insight surface is too light for richer future behavior
- Missing capability: bounded operator/control visibility for state, gaps, and restart health
- Owner: later UI/Diagnostics packet
- Archive proof: `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`, `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh`, `archives/MAPS/unclassified/Hud design.txt`
- Why it matters: deeper intelligence becomes unusable if the operator cannot inspect why the scanner believes what it believes
- Status: **future layer**

### 56.2 What does not block future readiness yet
- correlation engines
- basket intelligence
- execution/risk layers
- multi-EA pipelines

These remain out of scope for current ASC readiness.

---

## 57. UI / Operator Control Intelligence

### 57.1 What legacy operator surfaces attempted
- mode/profile switching
- runtime visibility
- status menus
- HUD overlays
- diagnostic visibility for weak/failed states

Primary sources:
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh`
- `archives/LEGACY_SYSTEMS/ISSX/issx_ui_test.mqh`
- `archives/MAPS/unclassified/Hud design.txt`
- AFS dev-vs-trader profile concepts in `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`

### 57.2 What current ASC has
- lightweight product surface only
- output files as primary operator interface
- no mature on-chart state-control intelligence layer yet

### 57.3 Structural insight
Legacy UI/HUD work proves that operator control is not merely decorative. It is tightly connected to trust and recoverability. Once ASC grows richer conditions, continuity, and ranking semantics, a bounded operator-inspection layer will become more important.

### 57.4 UI anti-drift law for future HQ
If UI work opens later, it should expose:
- scanner health
- ranking eligibility reasons
- continuity/restart state
- output routing/status

It should not expose:
- execution controls
- strategy logic
- portfolio governance
- archive-era framework modes that exceed current product identity

---

## 58. Canonical Build Guidance Layer

This section is not a task board. It is the structural guidance layer future HQ should preserve when making build decisions.

### 58.1 Structural truth 1 — preserve product narrowness while expanding depth
The correct direction is not “bigger system.” The correct direction is “deeper scanner truth.”

Implication:
- enrich ranking, continuity, and conditions provenance
- do not expand into execution/risk/platform behavior

### 58.2 Structural truth 2 — mine AFS for scanner composition, mine EA1 for truth rigor, mine ISSX for shell discipline
- AFS is the strongest source for scanner decomposition and shortlist lineage.
- EA1 is the strongest source for restart/continuity and observed-vs-effective truth discipline.
- ISSX is the strongest source for runtime shell, persistence shell, and operator-control lineage.

Future HQ should not ask one archive family to answer every problem.

### 58.3 Structural truth 3 — blueprint law is already ahead of live MT5 maturity in key areas
Specifically:
- activation rights
- Layer 3 continuity restrictions
- persistence doctrine
- summary/ranking contract clarity

Implication:
- most future work is implementation maturity and truth enrichment, not blueprint invention.

### 58.4 Structural truth 4 — the most dangerous remaining weakness is invisible false confidence
False confidence arises when:
- persistence looks healthy but resume semantics are weak
- output looks complete but coverage is partial
- surface score looks ranked but friction/readiness nuance is missing
- conditions appear readable but provenance is thin

This repository should bias toward explicit partial truth over clean illusion.

### 58.5 Structural truth 5 — build sequence must follow truth dependency, not archive excitement
Correct dependency order:
1. identity and market truth
2. conditions truth depth
3. surface/freshness/friction depth
4. ranking decomposition
5. continuity/restart depth
6. ACTIVE dossier continuation
7. operator insight surface

Archive insight should accelerate this order, not scramble it.

### 58.6 Structural truth 6 — direct archive transplantation is almost always wrong
Future HQ should require the following questions before any legacy-inspired build:
- Which exact current blueprint contract does this serve?
- Which exact current MT5 module owns it?
- Which exact archive file proves it matters?
- What part of the archive source is being rejected as out-of-scope?
- How does the translation preserve current product identity?

### 58.7 Structural truth 7 — current ASC’s biggest opportunity is not more data, but better trust geometry
“Trust geometry” means the shape of confidence across the system:
- raw truth vs derived truth
- known vs unknown
- current vs stale
- eligible vs merely visible
- publishable vs pending
- resumed vs restarted clean

Legacy systems repeatedly discovered pieces of that geometry. Current ASC has the governance to integrate them cleanly if future HQ stays disciplined.

---

## BUILD-CRITICAL GAPS

This section upgrades the earlier missing-systems discussion into module-owned, archive-proven build intelligence.

### Gap 1 — Ranking decomposition beyond simple surface score
- Missing capability: distinct readiness axes for freshness, conditions quality, bucket confidence, and historical/friction quality
- Module owner: future Ranking packet spanning `mt5/ASC_Surface.mqh` with coordination from `mt5/ASC_Market.mqh` and `mt5/ASC_Conditions.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Why ASC cannot progress cleanly without it: summary output can remain functional, but future shortlist quality will plateau and become hard to trust
- Status: **non-blocking for first slice, blocking for mature shortlist integrity**

### Gap 2 — Restart-state truth and compatibility semantics
- Missing capability: explicit fresh/stale/corrupt/incompatible/resumed/clean-restart states
- Module owner: `mt5/ASC_Storage.mqh` with orchestration exposure in `mt5/ASC_Engine.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Why ASC cannot progress cleanly without it: Layer 3 and later continuity become fragile and potentially misleading
- Status: **blocking for deep persistence maturity**

### Gap 3 — Conditions provenance and capability matrix
- Missing capability: clearer distinction between observed broker truth, unreadable broker truth, and effective/derived interpretations
- Module owner: `mt5/ASC_Conditions.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why ASC cannot progress cleanly without it: later ranking and trader-facing trust will overstate conditions confidence
- Status: **non-blocking first slice, high-leverage for later truth integrity**

### Gap 4 — Partial/degraded surface vocabulary
- Missing capability: language and state handling for thin, weak, warming, degraded, and session-ambiguous symbols
- Module owner: `mt5/ASC_Surface.mqh` with input from Market and Conditions
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Why ASC cannot progress cleanly without it: edge symbols become either falsely eligible or falsely discarded
- Status: **non-blocking current slice, blocking for robust scanner coverage**

### Gap 5 — File-level diagnostic separation from trader outputs
- Missing capability: richer internal diagnostic visibility without polluting public output files
- Module owner: future Diagnostics packet / Storage + Output support
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/ISSX/issx_debug_engine.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Why ASC cannot progress cleanly without it: richer internal truth will become harder to verify while keeping trader outputs compact
- Status: **future layer but high leverage**

### Gap 6 — Operator visibility into scanner reasoning
- Missing capability: bounded UI/control surface for health, ranking reasons, and restart state
- Module owner: future UI/Diagnostics domain
- Archive proof: `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`, `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh`, `archives/MAPS/unclassified/Hud design.txt`
- Why ASC cannot progress cleanly without it: deep scanner intelligence becomes difficult to audit operationally
- Status: **future layer**

---

## LEGACY vs ASC — BEHAVIORAL DIFFERENCES

### Market truth resolution
- Legacy did: richer raw symbol normalization, family/theme classification, and more nuanced state vocabularies.
- ASC does: cleaner upstream classification ownership and stronger constitutional placement of market truth.
- Better now: governance and centrality of `PrimaryBucket`.
- Missing now: confidence/review/alias richness and more explicit market-state categories.
- Dangerous legacy trait: classification heuristics embedded everywhere instead of in one governed location.

### Session logic
- Legacy did: more explicit quote/trade/open/closed/fallback distinctions, sometimes with richer weekly/session detail.
- ASC does: lighter session truth sufficient for current scanner foundations.
- Better now: less overbuilt complexity.
- Missing now: fallback semantics and thin/degraded session reasoning.
- Dangerous legacy trait: session assumptions mixed with market-open assumptions and probe side effects.

### Quote handling
- Legacy did: broader freshness, liveliness, silence, hydration, and cooldown reasoning.
- ASC does: bounded quote-age evaluation inside surface logic.
- Better now: more understandable minimum model.
- Missing now: richer partial-readiness behavior.
- Dangerous legacy trait: overfitting thresholds and complex rings before trust surfaces were stable.

### Spec validation
- Legacy did: deep spec extraction, capability flags, observed/effective separation, cost completeness logic.
- ASC does: readable/unreadable conditions truth with minimal derived behavior.
- Better now: lower risk of false inference.
- Missing now: provenance and capability depth.
- Dangerous legacy trait: turning weak inferred values into seemingly authoritative fields.

### Continuity behavior
- Legacy did: explicit stale/corrupt/incompatible resume semantics and per-symbol bounded continuity.
- ASC does: restore-first plus atomicity with less explicit compatibility richness.
- Better now: cleaner doctrinal simplicity.
- Missing now: reasoned restart state.
- Dangerous legacy trait: continuity systems becoming mini-platforms.

### Snapshot handling
- Legacy did: some systems maintained current/previous snapshots, stage contracts, and deterministic fallback semantics.
- ASC does: broker-level mirror + writer discipline with simpler footprint.
- Better now: smaller operator-facing surface.
- Missing now: richer fallback visibility.
- Dangerous legacy trait: snapshot ecosystems multiplying beyond their operator value.

### Ranking logic
- Legacy did: multi-axis ranking with trust/freshness/cost/finalist logic.
- ASC does: minimal surface score and eligibility bridge.
- Better now: less fake precision.
- Missing now: mature shortlist intelligence.
- Dangerous legacy trait: transplanting formulas without transplanting the underlying truth model.

### Output logic
- Legacy did: many output surfaces for machines and humans.
- ASC does: summary + symbol files + mirror.
- Better now: disciplined trader-facing surface.
- Missing now: richer internal-only diagnostics.
- Dangerous legacy trait: letting debug/stage formats define the product.

---

## SYSTEM FAILURE SURFACES

### Failure surface A — misclassification cascades into wrong ranking groups
- Files: `mt5/ASC_Market.mqh`, `mt5/ASC_Surface.mqh`, `mt5/ASC_Output.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Layer: Layer 1 -> Layer 2 -> summary output
- Cause: normalized symbol mismatch, weak classification fallback, or missing bucket truth
- Consequence: symbol competes in wrong group or is excluded from correct group

### Failure surface B — feed silence misread as market closure
- Files: `mt5/ASC_Market.mqh`, `mt5/ASC_Surface.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Layer: Layer 1 and Layer 2
- Cause: simplistic session/open logic under degraded quote conditions
- Consequence: false ineligibility or false confidence

### Failure surface C — conditions unreadability collapses into fake normality
- Files: `mt5/ASC_Conditions.mqh`, `mt5/ASC_Output.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Layer: Conditions -> output
- Cause: insufficient provenance or implicit defaults
- Consequence: trader sees plausible but untrustworthy broker conditions

### Failure surface D — restart continuity silently poisons current cycle
- Files: `mt5/ASC_Storage.mqh`, `mt5/ASC_Engine.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Layer: restore and persistence
- Cause: stale/incompatible state merged without enough explicit rejection semantics
- Consequence: scanner appears stable while carrying old truth

### Failure surface E — summary appears cleaner than actual truth coverage
- Files: `mt5/ASC_Output.mqh`
- Archive proof: `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`, `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
- Layer: publication
- Cause: compact output format hides partial upstream coverage or bucket uncertainty
- Consequence: operator overtrusts shortlist quality

### Failure surface F — later-layer ambition outruns first-layer maturity
- Files: all current MT5 modules by implication, especially future Surface/Ranking/Storage expansion
- Archive proof: `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`, `archives/BLUEPRINT_REFERENCE/AURORA.txt`
- Layer: sequencing/governance
- Cause: importing later intelligence logic before identity/conditions/continuity are solid
- Consequence: rich-looking but ungrounded scanner behavior

---

## High-Value File Intelligence Profiles

This subsection upgrades the earlier file index for the highest-leverage files.

### Profile: `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Purpose: canonical classification translation layer for scanner symbols
- Inputs: raw symbol names, server key, embedded classification rows
- Outputs: canonical symbol, asset class, `PrimaryBucket`, sector/industry/theme metadata, resolution detail
- Dependencies: `AFS_CoreTypes.mqh`
- Failure modes: unresolved symbols, suffix normalization mismatch, stale embedded mapping assumptions
- ASC replicates it: **PARTIAL**
- Recommended treatment: **translated + adapted**
- Do not do: import entire row schema blindly into current runtime types

### Profile: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Purpose: convert history/tick/spread state into readiness and friction intelligence
- Inputs: symbol record with market state, spread samples, historical bars/rates
- Outputs: movement scores, freshness score, friction state, hydration stage, weak/fail reasons
- Dependencies: `AFS_CoreTypes.mqh`
- Failure modes: threshold overfitting, insufficient data windows, treating thin symbols as broken
- ASC replicates it: **NO** for most of the nuanced layer
- Recommended treatment: **translate concepts, adapt selectively**
- Do not do: port raw scoring constants as if architecture were unchanged

### Profile: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Purpose: shortlist ranking and tie-break logic
- Inputs: classified symbol records with trust/freshness/friction/cost data
- Outputs: total scores, finalist selection, tie-break outcomes
- Dependencies: `AFS_CoreTypes.mqh`
- Failure modes: precise-looking ranking built on heterogeneous data quality
- ASC replicates it: **NO**
- Recommended treatment: **translate structure, not formulas**
- Do not do: import old correlation finalist logic before current ranking contract matures

### Profile: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Purpose: blueprint/spec for truthful market observability, bounded continuity, deterministic stage/debug schemas
- Inputs: whole-broker symbol universe, spec truth, tick truth, continuity state
- Outputs: stage schema requirements, debug requirements, continuity/restart law, truth tests
- Dependencies: none as code; doctrinal dependency on EA1 market-core lineage
- Failure modes: scope bloat if treated as active product schema, machine-facing surface overwhelming scanner simplicity
- ASC replicates it: **PARTIAL**
- Recommended treatment: **translated** for continuity/provenance logic; **ignored** for broad stage ecosystem assumptions

### Profile: `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Purpose: persistence subsystem in the ISSX runtime shell
- Inputs: runtime state bundles, symbol/state registries, snapshot timing
- Outputs: persisted runtime state and reload behavior
- Dependencies: ISSX core/runtime structures
- Failure modes: wrapper-scale assumptions too heavy for ASC, persistence coupled to wider orchestration shell
- ASC replicates it: **PARTIAL**
- Recommended treatment: **adapt** persistence shell ideas only

### Profile: `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- Purpose: deep broker spec harvester across symbols
- Inputs: broker symbol universe and MT5 symbol/session/spec properties
- Outputs: rich JSON export of spec and session data
- Dependencies: MT5 SymbolInfo/session APIs
- Failure modes: schema overload, mistaking broad extraction for publishable trader truth
- ASC replicates it: **PARTIAL**
- Recommended treatment: **adapt** provenance/capability ideas, **ban** direct schema import

### Profile: `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Purpose: universe + light spec + friction + Stage A candidate export
- Inputs: symbol universe, sample cadence, tick data, light specs
- Outputs: friction state, stage-A candidates, persistent ring buffers
- Dependencies: timer/sampling shell
- Failure modes: friction thresholds may not generalize, monolith-style coupling
- ASC replicates it: **PARTIAL**
- Recommended treatment: **adapt** readiness/freshness patterns

### Profile: `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Purpose: deterministic analytics-only exporter with strict timer discipline
- Inputs: symbol universe, ticks, specs, backfill/history, ranking helpers
- Outputs: JSON snapshots, backups, debug surfaces
- Dependencies: internal one-file batch architecture
- Failure modes: monolith expansion, output schema sprawl
- ASC replicates it: **PARTIAL**
- Recommended treatment: **adapt** deterministic publish discipline; **ignore** monolith style

### Profile: `mt5/ASC_Market.mqh`
- Purpose: current market truth intake and identity translation surface
- Inputs: broker symbols, classification sources, symbol/session properties
- Outputs: `ASC_SymbolRecord` market and identity truth, eligibility state, bucket classification
- Dependencies: `mt5/ASC_Common.mqh`, engine orchestration, archive-derived classification concepts
- Failure modes: classification miss, weak session reasoning, eligibility false positives/negatives
- Archive lineage: AFS classification + market core, ISSX market state core
- ASC replicates legacy: this is the live replacement surface
- Recommended treatment: **active product owner; future enrichment only via blueprint-aligned adaptation**

### Profile: `mt5/ASC_Conditions.mqh`
- Purpose: current broker conditions intake surface
- Inputs: MT5 symbol spec properties
- Outputs: conditions truth with readability flags
- Dependencies: `mt5/ASC_Common.mqh`, engine orchestration
- Failure modes: unreadable values under-described, low provenance richness, derived semantics still thin
- Archive lineage: ISS spec extraction, PIE, EA1 market-core doctrine
- Recommended treatment: **active product owner; enrich provenance carefully**

### Profile: `mt5/ASC_Storage.mqh`
- Purpose: current restore-first persistence and file IO boundary
- Inputs: runtime config, current symbol records, prior persisted state
- Outputs: restored snapshots and new persisted files
- Dependencies: `mt5/ASC_Common.mqh`, engine/output modules
- Failure modes: stale state ambiguity, compatibility visibility gaps, partial-write edge cases
- Archive lineage: EA1 continuity law, ISSX persistence shell
- Recommended treatment: **active product owner; high-priority hardening candidate**

### Profile: `mt5/ASC_Output.mqh`
- Purpose: writer-only publication layer
- Inputs: already-computed symbol records and broker context
- Outputs: summary file, symbol files, universe mirror
- Dependencies: storage IO helpers, common types, engine orchestration
- Failure modes: publication filter overstates readiness, tidy output hides upstream partiality
- Archive lineage: AFS output/debug routing, PIE deterministic publish discipline, EA1 explicit unknown rules
- Recommended treatment: **active product owner; preserve writer-only law**


---

## 59. Legacy Code Extraction Matrix

This section converts archive lineage into extraction-intelligence at file granularity. It is the practical bridge between legacy code bodies and current ASC module ownership.

### 59.1 AFS extraction matrix

#### `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- Candidate methods / patterns:
  - `AFS_CL_StripKnownBrokerSuffixes`
  - `AFS_CL_RemovePunctuation`
  - `AFS_CL_NormalizeSymbol`
  - `AFS_CL_FindRow`
  - `AFS_CL_ClassifySymbol`
- What they do:
  - normalize broker symbols and translate them into canonical classification truth
- ASC target module:
  - `mt5/ASC_Market.mqh`
  - support-contract enrichment in `mt5/ASC_Common.mqh`
- Adaptation need:
  - high; current ASC must keep blueprint-owned `PrimaryBucket` semantics and avoid importing AFS row sprawl unchanged
- Hidden dependencies:
  - server-key assumptions
  - embedded table shape
  - `AFS_UniverseSymbol` field naming

#### `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- Candidate methods / patterns:
  - `AFS_MC_TryValidateTickValue`
  - `AFS_MC_RefreshSpecRecord`
  - `AFS_MC_GetQuoteState`
  - `AFS_MC_GetSessionState`
  - `AFS_MC_RecordSpreadSample`
  - `AFS_MC_RefreshSurfaceRecord`
- What they do:
  - split surface-state, spec-state, quote-state, session-state, spread-sampling, and promotion readiness
- ASC target module:
  - `mt5/ASC_Market.mqh` for quote/session state
  - `mt5/ASC_Conditions.mqh` for spec validation patterns
  - `mt5/ASC_Surface.mqh` for spread/freshness readiness
- Adaptation need:
  - high; functions assume AFS-specific field inventory and promotion vocabulary
- Hidden dependencies:
  - spread-sample rings on legacy structs
  - AFS spec-integrity labels
  - AFS promotion-state semantics not identical to current activation law

#### `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Candidate methods / patterns:
  - `AFS_HF_HydrationStage`
  - `AFS_HF_IsSessionClosedHint`
  - `AFS_HF_ComputeATRFromRates`
  - `AFS_HF_MovementScore`
  - `AFS_HF_ComputeMedian`
  - `AFS_HF_ComputeFreshnessScore`
- What they do:
  - derive partial-readiness, friction quality, history sufficiency, and freshness quality from price and spread state
- ASC target module:
  - `mt5/ASC_Surface.mqh`
  - possible field additions in `mt5/ASC_Common.mqh`
- Adaptation need:
  - very high; current surface truth does not yet expose the required intermediate fields
- Hidden dependencies:
  - spread sample ring state
  - history counters on the legacy symbol record
  - session-hint logic inherited from `AFS_MarketCore`

#### `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Candidate methods / patterns:
  - `AFS_SL_IsRankable`
  - `AFS_SL_ComputeCostEfficiencyScore`
  - `AFS_SL_ComputeTrustScore`
  - `AFS_SL_ComputeTotalScore`
  - `AFS_SL_BetterTieBreak`
- What they do:
  - convert truth quality into shortlist rankability and deterministic ranking order
- ASC target module:
  - future ranking work centered on `mt5/ASC_Surface.mqh`
  - supporting bucket/identity truth remains in `mt5/ASC_Market.mqh`
- Adaptation need:
  - very high; formulas rely on rich legacy readiness fields absent in ASC
- Hidden dependencies:
  - friction/history/cost fields from multiple prior AFS steps
  - correlation finalist state not yet valid in ASC

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`
- Candidate methods / patterns:
  - stable-signature builders
  - atomic file path builders
  - cache initialization helpers
  - text read/write helpers with signature logic
- What they do:
  - file stability, cache signatures, and dossier artifact handling
- ASC target module:
  - `mt5/ASC_Storage.mqh`
  - `mt5/ASC_Output.mqh`
- Adaptation need:
  - medium; some file-stability ideas are reusable but the dossier shell is larger than current ASC
- Hidden dependencies:
  - tactical cache/dossier ecosystem

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`
- Candidate methods / patterns:
  - `AFS_TA_CoverageState`
  - `AFS_TA_HTFReadinessState`
  - `AFS_TA_FreshnessBand`
  - `AFS_TA_SpreadBand`
  - `AFS_TA_TacticalSummary`
  - `AFS_TA_ExecutionQualityState`
- What they do:
  - turn raw state into compact analytical labels
- ASC target module:
  - future Layer 3 dossier enrichment
  - bounded reuse in `mt5/ASC_Surface.mqh` for qualitative labels only
- Adaptation need:
  - high
- Hidden dependencies:
  - richer trader intel caches and tactical metrics

#### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
- Candidate methods / patterns:
  - formatting and value-state rendering helpers
  - mode/calc/swap/session meaning text functions
  - trust and lifecycle explanation builders
- What they do:
  - convert scanner truth into a human-readable dossier layer
- ASC target module:
  - future symbol-file enrichment in `mt5/ASC_Output.mqh`
- Adaptation need:
  - medium/high
- Hidden dependencies:
  - value-state vocabulary not fully represented in `ASC_Common.mqh`

#### `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
- Candidate methods / patterns:
  - route sanitization
  - append-line safety
  - write-failure logging
  - active-route selection
- What they do:
  - deterministic file routing and bounded debug logging
- ASC target module:
  - `mt5/ASC_Storage.mqh`
  - future diagnostics support for `mt5/ASC_Output.mqh`
- Adaptation need:
  - medium
- Hidden dependencies:
  - legacy route families (`dev`, `FINAL_OUTPUT`, `Trader-Data`)

### 59.2 EA1 extraction matrix

#### `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Candidate blocks / patterns:
  - continuity stale/corrupt/incompatible logic
  - observed-vs-effective value rules
  - current/previous snapshot safety model
  - explicit reason-code and health-state vocabulary
  - spec hash / change count doctrine
- What they do:
  - define the discipline needed for high-trust observability under partial data
- ASC target module:
  - `mt5/ASC_Storage.mqh`
  - `mt5/ASC_Conditions.mqh`
  - `mt5/ASC_Market.mqh`
  - `mt5/ASC_Output.mqh`
  - contract support in `mt5/ASC_Common.mqh`
- Adaptation need:
  - high; the doctrine is valuable, the stage/debug schema footprint is too large
- Hidden dependencies:
  - machine-facing stage ecosystem
  - broader health-state taxonomy than current product surface

#### `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
- Candidate methods / patterns:
  - reset-state families for spec/session/tick/cost/hydration/continuity
  - safe symbol read wrappers
  - spec hash refresh
  - publish-window and schedule clock helpers
  - classification heuristics like stock/FX detection
- What they do:
  - show how the EA1 doctrine was operationalized in code
- ASC target module:
  - reset/state vocab portions -> `mt5/ASC_Common.mqh`
  - safe property reads -> `mt5/ASC_Market.mqh` / `mt5/ASC_Conditions.mqh`
  - continuity helpers -> `mt5/ASC_Storage.mqh`
- Adaptation need:
  - high; code versions are monolithic and state-dense
- Hidden dependencies:
  - EA1-specific global state, publish windows, and stage contracts

### 59.3 ISSX extraction matrix

#### `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`
- Candidate methods / patterns:
  - budget and phase control helpers (`RemainingTotalBudget`, `CanSpend`, `SpendCommit`, `DeadlineHit`)
  - phase/state label methods
  - pulse/scheduler surface
- What they do:
  - provide a bounded runtime shell with explicit budget semantics
- ASC target module:
  - `mt5/ASC_Engine.mqh`
- Adaptation need:
  - medium/high; ASC needs the discipline, not the full phase framework
- Hidden dependencies:
  - ISSX kernel/stage phase model and queue families

#### `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
- Candidate methods / patterns:
  - normalization helpers (`Normalize`, `NormalizeSymbol`, `SafeUpper`)
  - state reads (`SafeSymbolBool/Long/Int/Double/String`)
  - session-window logic (`SecondsOfDay`, `IsWithinSessionWindow`)
  - observation load/refresh methods (`LoadRawObservation`, `RefreshTick`)
  - continuity restoration helpers
- What they do:
  - blend symbol intake, market observation, and continuity restoration
- ASC target module:
  - `mt5/ASC_Market.mqh`
  - `mt5/ASC_Storage.mqh` for restore-specific pieces
- Adaptation need:
  - high; logic is intertwined with ISSX runtime phases
- Hidden dependencies:
  - prior continuity and runtime shell assumptions

#### `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- Candidate methods / patterns:
  - lane / truth / freshness class vocabularies
  - compatibility score and toxicity score helpers
  - publishability / weak-link labels
- What they do:
  - map raw truth quality into a richer selection taxonomy
- ASC target module:
  - future ranking support in `mt5/ASC_Surface.mqh`
  - shared vocabulary support in `mt5/ASC_Common.mqh`
- Adaptation need:
  - very high
- Hidden dependencies:
  - wide ISSX score model and prior runtime truth classes

#### `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Candidate methods / patterns:
  - path safety checks (`IsSafeRelativePath`)
  - folder/file ensure helpers
  - atomic write helpers (`WriteTextAtomic`, `WriteTextIfChanged`)
  - root/shared/debug path families
- What they do:
  - enforce safe persistence routing and atomic write behavior
- ASC target module:
  - `mt5/ASC_Storage.mqh`
- Adaptation need:
  - medium
- Hidden dependencies:
  - ISSX folder hierarchy and lock/debug subsystems

#### `archives/LEGACY_SYSTEMS/ISSX/issx_system_snapshot.mqh`
- Candidate methods / patterns:
  - bounded sanitization and hydration labeling
- What they do:
  - normalize snapshot-facing text and state labels
- ASC target module:
  - `mt5/ASC_Output.mqh`
  - `mt5/ASC_Common.mqh`
- Adaptation need:
  - medium
- Hidden dependencies:
  - snapshot schema vocabulary

#### `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh` and `issx_menu.mqh`
- Candidate methods / patterns:
  - status-to-text helpers
  - HUD warning accumulation
  - stage-row rendering
  - click handling and section rendering
- What they do:
  - build bounded operator-facing visibility and control actions
- ASC target module:
  - future `mt5/ASC_UI.mqh`
- Adaptation need:
  - high
- Hidden dependencies:
  - stage rows, warning lists, and UI object lifecycle conventions

### 59.4 Old EAS and extracted reference matrix

#### `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- Candidate methods / patterns:
  - `InsideAnySessionTrade`
  - `InsideAnySessionQuote`
  - `GetInt/GetDbl/GetStr`
  - `ComputeMarginRateFlags`
- What they do:
  - robust property reads and session-bound truth checks for deep spec extraction
- ASC target module:
  - `mt5/ASC_Conditions.mqh`
  - session helper fragments in `mt5/ASC_Market.mqh`
- Adaptation need:
  - medium/high
- Hidden dependencies:
  - exporter-specific JSON pipeline and deep-schema assumptions

#### `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Candidate methods / patterns:
  - ring-state methods (`RingInit`, `PruneRing`, `RingAddSample`)
  - `ProbeTicksAll`
  - `GetATRPoints`
  - `BuildStageA`
- What they do:
  - build freshness and friction intelligence from repeated quote samples
- ASC target module:
  - `mt5/ASC_Surface.mqh`
- Adaptation need:
  - very high
- Hidden dependencies:
  - persistent ring buffers and Stage A snapshot conventions

#### `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5`
- Candidate methods / patterns:
  - `DetectAssetClass`
  - `DetectInstrumentFamily`
  - `DetectThemeBucket`
  - `CountTradeSessionsToday`
  - `CountQuoteSessionsToday`
  - `HasEconomicallyValidQuote`
- What they do:
  - derive richer market-identity and session/quote semantics from broker observations
- ASC target module:
  - `mt5/ASC_Market.mqh`
- Adaptation need:
  - high
- Hidden dependencies:
  - old theme/family vocabulary and market-state wrapper assumptions

#### `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Candidate methods / patterns:
  - `PIE_NormalizeSym`
  - `PIE_SectorClassify`
  - `PIE_ProbeValuePerPoint`
  - `PIE_ProbeMargin1Lot`
  - backup/current publish discipline helpers
- What they do:
  - combine deterministic export ordering with broad truth probing
- ASC target module:
  - `mt5/ASC_Market.mqh`
  - `mt5/ASC_Conditions.mqh`
  - `mt5/ASC_Storage.mqh`
- Adaptation need:
  - high
- Hidden dependencies:
  - PIE mode detection, one-file architecture, and backup rotation ecosystem

#### `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- Candidate methods / patterns:
  - `AtomicWriteText`
  - `ReadAllText`
  - basic JSON validation
  - rates/EMA/ADX/ATR helper blocks only as reference for later analytics
- What they do:
  - contract export and staged write safety
- ASC target module:
  - `mt5/ASC_Storage.mqh`
  - analytics helpers are later-slice only
- Adaptation need:
  - medium
- Hidden dependencies:
  - exporter file contract and DEV cadence assumptions

#### `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`
- Candidate methods / patterns:
  - `IsSymbolUsable`
  - `CalcValuePerPoint_1Lot`
  - `CalcMargin_1Lot`
- What they do:
  - broad truth export and basic cost derivation for market observability
- ASC target module:
  - `mt5/ASC_Conditions.mqh`
- Adaptation need:
  - high
- Hidden dependencies:
  - exporter-only output surface and account/structure dump context

---

## 60. Exact Function / Method Recovery Candidates

This section is method-level, not just file-level. The purpose is to let future HQ name exact legacy candidates in worker packets.

### 60.1 Symbol identity and normalization methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` | `AFS_CL_StripKnownBrokerSuffixes` | remove broker-added suffix noise | `mt5/ASC_Market.mqh` | medium | broker-specific suffix list may over-strip symbols in other environments |
| `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` | `AFS_CL_RemovePunctuation` | normalize punctuation variance | `mt5/ASC_Market.mqh` | low/medium | can erase economically meaningful separators if not bounded |
| `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh` | `AFS_CL_NormalizeSymbol` | canonical normalization pipeline | `mt5/ASC_Market.mqh` | medium | normalization law may conflict with current bucket/classification contract if imported wholesale |
| `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh` | `NormalizeSymbol` | alternate normalize path | `mt5/ASC_Market.mqh` | medium | runtime-shell assumptions and weaker lineage clarity than AFS classifier |
| `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5` | `PIE_NormalizeSym` | deterministic broad-universe symbol normalization | `mt5/ASC_Market.mqh` | medium | tied to PIE sector classification and one-file flow |

### 60.2 Session and market-state methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh` | `AFS_MC_GetSessionState` | compact session-state synthesis | `mt5/ASC_Market.mqh` | medium/high | uses legacy readiness fields and AFS labels |
| `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh` | `AFS_HF_IsSessionClosedHint` | interpret silence vs closed-market hints | `mt5/ASC_Surface.mqh` | high | depends on richer rec fields and can misclassify thin symbols if transplanted blindly |
| `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5` | `InsideAnySessionTrade` | session-window truth for trade availability | `mt5/ASC_Market.mqh` | medium | exporter context and session loops need current contract mapping |
| `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5` | `InsideAnySessionQuote` | session-window truth for quote availability | `mt5/ASC_Market.mqh` | medium | same as above |
| `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5` | `CountTradeSessionsToday` / `CountQuoteSessionsToday` | richer session density / presence view | `mt5/ASC_Market.mqh` | high | current ASC lacks matching fields in `ASC_Common.mqh` |
| `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh` | `IsWithinSessionWindow` | generalized session-window check | `mt5/ASC_Market.mqh` | medium/high | assumes ISSX observation flow and runtime-phase cadence |

### 60.3 Quote freshness and friction methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh` | `AFS_HF_ComputeFreshnessScore` | quantify quote freshness beyond binary checks | `mt5/ASC_Surface.mqh` | high | legacy scoring assumes spread/history fields not present in ASC |
| `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh` | `AFS_HF_HydrationStage` | partial-readiness vocabulary | `mt5/ASC_Surface.mqh` + `mt5/ASC_Common.mqh` | high | requires new enum/state vocabulary first |
| `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5` | `RingInit`, `PruneRing`, `RingAddSample` | maintain bounded spread-sample ring | `mt5/ASC_Surface.mqh` | high | depends on persistent ring storage and sampling cadence not yet present |
| `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5` | `ProbeTicksAll` | refresh broad quote/freshness state | `mt5/ASC_Surface.mqh` with engine cadence support | high | monolithic runtime assumptions |
| `archives/LEGACY_SYSTEMS/Old EAS/ISSX_MarketStateCore.mq5` | `HasEconomicallyValidQuote` | distinguish valid quote from meaningless tick state | `mt5/ASC_Market.mqh` | medium | needs careful alignment with current eligibility law |

### 60.4 Spec and conditions methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh` | `AFS_MC_TryValidateTickValue` | validate suspect tick value observations | `mt5/ASC_Conditions.mqh` | high | may silently replace observed zero with legacy heuristics |
| `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh` | `AFS_MC_RefreshSpecRecord` | unified spec refresh and validation flow | `mt5/ASC_Conditions.mqh` | high | assumes AFS spec status fields and promotion flow |
| `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5` | `GetInt`, `GetDbl`, `GetStr` | safe property access wrappers | `mt5/ASC_Conditions.mqh` | low/medium | low risk if kept as wrappers only |
| `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5` | `ComputeMarginRateFlags` | summarize probe coverage/flags | `mt5/ASC_Conditions.mqh` | medium/high | can bloat conditions truth before provenance fields exist |
| `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5` | `PIE_ProbeValuePerPoint` | probe value-per-point money semantics | `mt5/ASC_Conditions.mqh` | high | if moved early it can create false certainty |
| `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5` | `CalcValuePerPoint_1Lot`, `CalcMargin_1Lot` | derived cost probes for broad truth export | `mt5/ASC_Conditions.mqh` | high | exporter-level derivation not automatically publishable in ASC |

### 60.5 Persistence and restart methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh` | `WriteTextAtomic` | explicit atomic text write | `mt5/ASC_Storage.mqh` | low/medium | low if adapted to current path rules |
| `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh` | `WriteTextIfChanged` | avoid unnecessary rewrites | `mt5/ASC_Storage.mqh` | medium | can hide needed writes if compared against wrong materiality boundary |
| `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh` | `IsSafeRelativePath` | path safety filter | `mt5/ASC_Storage.mqh` | low | low risk, highly compatible |
| `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5` | `AtomicWriteText` | alternate staged write pattern | `mt5/ASC_Storage.mqh` | low/medium | exporter temp-file assumptions may differ |
| `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh` | `RestorePriorContinuity` | continuity merge/restore concept | `mt5/ASC_Storage.mqh` | high | deeply coupled to ISSX state structs |
| `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt` | stale/corrupt/incompatible logic block | continuity validity doctrine | `mt5/ASC_Storage.mqh` | high | conceptual, requires new current contract states |

### 60.6 Ranking and selection methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh` | `AFS_SL_IsRankable` | define shortlist entry gate | `mt5/ASC_Surface.mqh` | high | gate logic assumes missing legacy fields |
| `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh` | `AFS_SL_ComputeTrustScore` | summarize truth quality | `mt5/ASC_Surface.mqh` + `mt5/ASC_Common.mqh` | high | trust model depends on history/friction/cost states not yet represented |
| `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh` | `AFS_SL_BetterTieBreak` | deterministic same-score ordering | `mt5/ASC_Surface.mqh` | medium | safer than full scoring if tie inputs are redefined clearly |
| `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh` | truth/freshness class text helpers | richer rankability vocabulary | `mt5/ASC_Common.mqh` | medium/high | vocabulary import without supporting states creates dead enums |

### 60.7 Output and operator-state methods

| Archive file | Method / pattern | Purpose | ASC target module | Difficulty | Risk if copied blindly |
|---|---|---|---|---|---|
| `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh` | `AFS_OD_AppendLine` | append-safe logging/output helper | `mt5/ASC_Storage.mqh` or future diagnostics | medium | route assumptions and file-family naming |
| `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh` | `PushWarning`, `BuildStageRowJson` | UI-facing visibility of weak links | future `mt5/ASC_UI.mqh` | high | stage-row assumptions and UI object contracts |
| `archives/LEGACY_SYSTEMS/ISSX/issx_menu.mqh` | `RenderStageButton`, `HandleClick` | on-chart operator controls | future `mt5/ASC_UI.mqh` | high | stage/menu dependency model absent in current product |
| `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh` | lifecycle/trust/session meaning text builders | explain dossier truth cleanly | `mt5/ASC_Output.mqh` | medium/high | dossier semantics exceed current symbol file depth |

---

## 61. Struct / Enum / Schema Translation Candidates

### 61.1 Legacy structs that should be mined conceptually, not ported directly

#### `AFS_UniverseSymbol` from `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
- Valuable concepts to extract:
  - separated market/spec/history/friction/selection/publication fields
  - distinct “state” and “reason” pairs
  - room for weak/partial/fail status vocabularies
- Why direct port is wrong:
  - too many subsystems share it
  - ownership is diffuse
  - current ASC module boundaries would be violated
- ASC contract impact:
  - `mt5/ASC_Common.mqh` likely needs more sub-struct vocabulary rather than a giant merged record

#### EA1 symbol-state structs from `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
- Valuable concepts to extract:
  - resettable sub-state groups
  - spec/session/tick/cost/continuity decomposition
  - reason-code channels
- Why direct port is wrong:
  - monolithic globals and phase-era publishing assumptions
- ASC contract impact:
  - `ASC_Common.mqh` is too thin to represent several of these sub-state distinctions

#### ISSX runtime and selection structs from `archives/LEGACY_SYSTEMS/ISSX/*.mqh`
- Valuable concepts to extract:
  - runtime-class / publishability / weak-link vocabularies
  - persistence shell state separation
- Why direct port is wrong:
  - coupled to multi-phase runtime shell and queue families
- ASC contract impact:
  - only bounded enum/state ideas should survive translation

### 61.2 Enum vocabularies worth recovering

#### From AFS
- `AFS_ModuleStateCode`
- `AFS_SurfaceUpdatePolicy`
- `AFS_DeepUpdatePolicy`
- promote/profile enums only as conceptual history

Recoverable value:
- clear state naming and policy naming discipline

#### From ISSX selection/runtime
- publishability classes
- truth/freshness classes
- weak-link codes
- phase abort reasons

Recoverable value:
- better degraded-state and publishability vocabulary

#### From EA1 doctrine
- restart-state classes
- persistence-state classes
- capability and completeness classes

Recoverable value:
- explicit resume, stale, corrupt, incompatible semantics

### 61.3 Schema fields worth translating into `ASC_Common.mqh`

Current likely-thin areas in `ASC_Common.mqh` relative to legacy:
- restart-state vocabulary
- persistence validity reason
- provenance source for derived condition fields
- quality/completeness labels for conditions and surface truth
- degraded / warming / partial readiness vocabulary
- explicit publishability class separate from “has some truth”
- continuity compatibility / age reason fields
- operator-visible health summary fields

### 61.4 Shared-contract enrichment candidates

#### Candidate enrichment group: conditions provenance
Needed concepts:
- raw observed source vs effective/derived source
- capability support flags
- derived confidence / substitution reason

#### Candidate enrichment group: surface readiness decomposition
Needed concepts:
- freshness band
- history sufficiency band
- friction readiness band
- hydration/degraded state

#### Candidate enrichment group: persistence vocabulary
Needed concepts:
- restored_from_persistence
- restarted_clean
- persistence_stale
- persistence_incompatible
- persistence_corrupt
- compatibility_reason

---

## 62. Old Blueprint Doctrine Still Missing in Live MT5

### Doctrine 1 — explicit degraded / partial / weak readiness classes
- Source: `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`, `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Doctrine meaning:
  - systems should distinguish not-ready, weak, degraded, warming, partial, and fail states rather than only eligible/ineligible
- Current missing representation:
  - `mt5/ASC_Surface.mqh` has limited `SurfaceEligible`, `RankingEligible`, and a free-text reason, but not a formal degraded-state taxonomy
- Proper owner:
  - `mt5/ASC_Surface.mqh`
  - vocabulary support in `mt5/ASC_Common.mqh`

### Doctrine 2 — observed vs effective conditions truth provenance
- Source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`, `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Doctrine meaning:
  - raw broker fields and derived replacements must remain distinct and source-tagged
- Current missing representation:
  - `mt5/ASC_Conditions.mqh` exposes readability and values, but not a deep observed-vs-effective/provenance contract
- Proper owner:
  - `mt5/ASC_Conditions.mqh`
  - shared field support in `mt5/ASC_Common.mqh`

### Doctrine 3 — continuity compatibility states beyond restore-first
- Source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- Doctrine meaning:
  - restart continuity must explicitly track fresh/stale/corrupt/incompatible/resumed/clean-restart conditions
- Current missing representation:
  - `mt5/ASC_Storage.mqh` follows correct direction but lacks the full visible state vocabulary
- Proper owner:
  - `mt5/ASC_Storage.mqh`
  - orchestration exposure in `mt5/ASC_Engine.mqh`
  - common state fields in `mt5/ASC_Common.mqh`

### Doctrine 4 — publishability is not the same as truth presence
- Source: `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Doctrine meaning:
  - a symbol can contain some truth while still being non-publishable or only partially publishable
- Current missing representation:
  - `mt5/ASC_Output.mqh` uses `PUBLISHED`, `PENDING_SCAN`, and `UNAVAILABLE`, but the upstream contract vocabulary is still thin
- Proper owner:
  - `mt5/ASC_Output.mqh`
  - upstream publishability support in `mt5/ASC_Common.mqh`

### Doctrine 5 — deterministic tie-break discipline as contract, not ad hoc behavior
- Source: `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Doctrine meaning:
  - ranking systems need explicit deterministic ordering for equal-score candidates
- Current missing representation:
  - current surface layer has score output potential but not a mature tie-break contract
- Proper owner:
  - future ranking logic rooted in `mt5/ASC_Surface.mqh`

### Doctrine 6 — operator-facing health visibility separate from trader-facing summary
- Source: `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`, `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`, `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`
- Doctrine meaning:
  - internal health state should be inspectable without bloating the trader-facing artifact
- Current missing representation:
  - no dedicated diagnostics/UI file currently present in active MT5 set
- Proper owner:
  - future diagnostics/UI domain

### Doctrine 7 — spec change tracking as continuity input
- Source: `archives/LEGACY_SYSTEMS/EA1/ORIGINAL/EA1_MARKETCORE_FINAL.txt`, `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore_Phase1.mq5`
- Doctrine meaning:
  - spec changes should inform compatibility, cache invalidation, and condition trust
- Current missing representation:
  - current conditions/storage path lacks explicit spec hash / change count representation
- Proper owner:
  - `mt5/ASC_Conditions.mqh`
  - `mt5/ASC_Storage.mqh`

---

## 63. Archive-to-ASC Ownership Translation Map

| Legacy capability | Archive source | ASC target module | Ownership status | `ASC_Common.mqh` enrichment needed? |
|---|---|---|---|---|
| symbol normalization | AFS classification, ISSX market, PIE | `mt5/ASC_Market.mqh` | clear | low/medium |
| classification confidence / alias lineage | AFS classification | `mt5/ASC_Market.mqh` | shared with Common | yes |
| session-window truth | ISS spec extraction, ISSX market, ISSX market-state core | `mt5/ASC_Market.mqh` | clear | medium |
| degraded quote/freshness vocabulary | AFS history/friction, ISSX DEV friction | `mt5/ASC_Surface.mqh` | shared with Common | yes |
| observed-vs-effective conditions provenance | EA1 doctrine, ISS spec extraction, PIE | `mt5/ASC_Conditions.mqh` | clear | yes |
| spec hash / change tracking | EA1 doctrine, EA1 market-core code | `mt5/ASC_Conditions.mqh` + `mt5/ASC_Storage.mqh` | shared | yes |
| continuity compatibility states | EA1 doctrine, ISSX persistence | `mt5/ASC_Storage.mqh` | shared with Engine | yes |
| deterministic tie-break logic | AFS selection | `mt5/ASC_Surface.mqh` | currently missing later packet | possibly |
| writer-side route/failure diagnostics | AFS output debug, PIE | `mt5/ASC_Storage.mqh` / future diagnostics | shared | low |
| operator warning/UI state | ISSX UI/menu | future `mt5/ASC_UI.mqh` | currently missing | yes |

Ownership interpretation:
- **clear** means one current module is the obvious home.
- **shared** means the owning module needs support states or enums in `ASC_Common.mqh` and possibly orchestration visibility in `ASC_Engine.mqh`.
- **currently missing** means no live MT5 module can absorb it cleanly without new contract enrichment.

---

## 64. Method-Level Do / Adapt / Ban Matrix

### 64.1 DO TRANSLATE
These are high-confidence translation candidates if rewritten into current ownership boundaries.

- `AFS_CL_StripKnownBrokerSuffixes`
- `AFS_CL_RemovePunctuation`
- `AFS_CL_NormalizeSymbol`
- safe symbol/spec property wrappers from EA1 and ISS spec extraction code
- `IsSafeRelativePath`, `WriteTextAtomic`, `WriteTextIfChanged` style storage helpers
- deterministic tie-break concepts from `AFS_SL_BetterTieBreak`
- session-window methods such as `InsideAnySessionTrade` / `InsideAnySessionQuote`, but only after mapping to current session law

### 64.2 ADAPT CAREFULLY
These are valuable, but dangerous if imported without contract enrichment.

- `AFS_MC_RefreshSpecRecord`
- `AFS_MC_TryValidateTickValue`
- `AFS_HF_HydrationStage`
- `AFS_HF_ComputeFreshnessScore`
- `AFS_HF_MovementScore`
- `AFS_SL_IsRankable`
- `AFS_SL_ComputeTrustScore`
- `RestorePriorContinuity`
- `DetectAssetClass`, `DetectInstrumentFamily`, `DetectThemeBucket`
- `ComputeMarginRateFlags`
- `PIE_ProbeValuePerPoint`, `PIE_ProbeMargin1Lot`

### 64.3 BAN DIRECT PORT
These should not be copied as-is.

- any giant shared struct (`AFS_UniverseSymbol`, EA1 monolith state structs, ISSX selection/runtime aggregates)
- raw legacy scoring formulas and thresholds
- Stage A / stage-debug schema blocks as current trader output
- full UI/menu object systems from ISSX before a bounded ASC UI contract exists
- multi-phase queue/budget runtimes from ISSX as a direct replacement for current engine flow
- any method whose output semantics depend on legacy fields not represented in `ASC_Common.mqh`

---

## 65. Live ASC Coverage vs Legacy Method Coverage

### `mt5/ASC_Market.mqh`
- Already covers well:
  - broad identity ownership
  - classification placement
  - universe discovery
- Partially covers:
  - normalization richness
  - session/open nuance
  - theme/family inference
- Still lacks entirely:
  - confidence/review/alias lineage
  - richer session-count / fallback semantics
  - explicit economically-valid quote checks as a formal sub-state

### `mt5/ASC_Conditions.mqh`
- Already covers well:
  - readable/unreadable conditions truth
  - basic spec and spread state
- Partially covers:
  - safe property access patterns
  - conditions contribution to surface eligibility
- Still lacks entirely:
  - provenance source tags
  - observed-vs-effective separation
  - capability matrix and spec change tracking

### `mt5/ASC_Storage.mqh`
- Already covers well:
  - restore-first doctrine direction
  - atomic-write orientation
- Partially covers:
  - staged write safety
  - continuity preservation
- Still lacks entirely:
  - explicit stale/corrupt/incompatible/resume vocabulary
  - write-if-changed materiality logic
  - safe-path semantics as an explicit contract layer

### `mt5/ASC_Output.mqh`
- Already covers well:
  - writer-only discipline
  - summary/symbol publication surface
- Partially covers:
  - deterministic route cleanup
  - pending vs publishable distinction
- Still lacks entirely:
  - richer publishability classes
  - internal-only diagnostics surface
  - dossier-explanation text layers beyond the current minimal shape

### `mt5/ASC_Surface.mqh`
- Already covers well:
  - basic quote-age + history + conditions gate
- Partially covers:
  - score generation
  - surface-eligible vs ranking-eligible distinction
- Still lacks entirely:
  - hydration/degraded/weak vocabulary
  - friction decomposition
  - deterministic tie-break logic
  - richer trust decomposition

### `mt5/ASC_Engine.mqh`
- Already covers well:
  - bounded scanner orchestration
- Partially covers:
  - restore-first sequencing
- Still lacks entirely:
  - richer budget/phase concepts for heavier later truth work
  - restart-state exposure to diagnostics

### `mt5/ASC_Common.mqh`
- Already covers well:
  - baseline shared contract surface
- Partially covers:
  - common enums and record grouping
- Still lacks entirely:
  - degraded-state vocabulary
  - provenance fields
  - publishability class vocabulary
  - restart/compatibility vocabulary
  - richer selection decomposition state

---

## 66. Exact Recovery Sequence for Future Build Waves

This is the strict recovery order future HQ should follow when translating legacy intelligence into ASC.

### Wave A — Market identity and normalization hardening
1. translate normalization/suffix-stripping methods into `mt5/ASC_Market.mqh`
2. enrich `ASC_Common.mqh` only if confidence/alias/review lineage becomes necessary
3. verify `PrimaryBucket` continuity is preserved end-to-end

Reason:
- all downstream truth becomes unstable if symbol identity remains weak

### Wave B — Conditions provenance and safe property access
1. recover safe property wrapper discipline from ISS spec extraction / EA1 code
2. add provenance fields for observed vs effective conditions truth
3. do not add large derived-cost surfaces yet

Reason:
- ranking and output trust cannot improve if conditions semantics remain opaque

### Wave C — Session and quote-state enrichment
1. adapt session-window methods and quote-validity logic into `mt5/ASC_Market.mqh`
2. add bounded explicit quote/session states rather than free-form reasons only
3. verify Layer 1 eligibility remains blueprint-aligned

Reason:
- surface quality depends on more truthful upstream market-state inputs

### Wave D — Surface degraded-state vocabulary before ranking formulas
1. add hydration/degraded/partial/weak state vocabulary in `ASC_Common.mqh`
2. adapt freshness/hydration concepts into `mt5/ASC_Surface.mqh`
3. avoid formula import until supporting truth fields exist

Reason:
- formulas without state vocabulary create false precision

### Wave E — Ranking decomposition and deterministic tie-breaks
1. adapt AFS trust/rankable/tie-break concepts
2. introduce deterministic same-score ordering
3. only then consider richer score decomposition

Reason:
- shortlist integrity improves more from correct rankability and deterministic ordering than from early numeric complexity

### Wave F — Continuity compatibility and restart truth
1. translate EA1 continuity doctrine into explicit states in `ASC_Common.mqh`
2. implement storage-side compatibility/stale/corrupt logic in `mt5/ASC_Storage.mqh`
3. surface restart-path truth through engine/output diagnostics as needed

Reason:
- later Layer 3 work becomes unsafe without restart honesty

### Wave G — Internal diagnostics separation
1. recover route/failure logging concepts from AFS/PIE
2. keep trader outputs compact
3. expose internal-only diagnostics separately

Reason:
- richer scanner truth will need observability, but not in the trader summary itself

### Wave H — ACTIVE dossier enrichment and bounded UI work
1. adapt dossier explanation text methods from AFS TraderDossierEngine
2. only after continuity and ranking are stable, open bounded UI/operator visibility using ISSX UI lessons

Reason:
- dossier and UI layers should explain stable truth, not unstable foundations

---

## 67. Legacy Formula / Threshold Caution Map

### `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- Controlled: spread/freshness/history scoring and hydration stages
- Why not portable as-is:
  - depends on legacy spread samples, history bars, and session hints not yet represented in ASC
- Useful principle:
  - quality should be decomposed into freshness, history sufficiency, and friction components

### `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- Controlled: total score, trust score, cost efficiency, tie-breaks
- Why not portable as-is:
  - score inputs come from richer legacy truth surfaces than current ASC has
- Useful principle:
  - deterministic ranking should be multi-axis and tie-aware

### `archives/LEGACY_SYSTEMS/Old EAS/ISSX_DEV_Friction.mq5`
- Controlled: spike counts, ATR-point comparisons, Stage A sorting
- Why not portable as-is:
  - depends on sampling budgets, ring-state windows, and Stage A snapshot contracts
- Useful principle:
  - quote quality needs repeated-sample context, not just one-point observations

### `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- Controlled: mode detection, backfill cadence, probe-based cost calculations
- Why not portable as-is:
  - one-file architecture and universe mode logic are not current ASC architecture
- Useful principle:
  - export/probe behavior should remain deterministic and bounded

### `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- Controlled: technical metrics and percentile rank helpers
- Why not portable as-is:
  - exporter-specific structural cadence and analytics layer not yet part of current scanner mission
- Useful principle:
  - atomic writes and bounded analytics helpers can be staged later

---

## 68. Provenance and Source-Truth Recovery Map

### 68.1 Conditions provenance
Legacy strength:
- EA1 doctrine and ISS spec extraction tools were much stronger on separating observed fields from effective replacements or derived financial interpretations.

Current ASC influence:
- `mt5/ASC_Conditions.mqh` should eventually recover:
  - source tags for each derived/effective condition
  - explicit reason when a fallback replaces or augments a raw field
  - capability flags indicating whether a field is truly observed, probed, or unknown

### 68.2 Market provenance
Legacy strength:
- ISSX market-state code and AFS classification carried stronger lineage for how identity and session states were obtained.

Current ASC influence:
- `mt5/ASC_Market.mqh` should eventually recover:
  - classification confidence/review lineage where ambiguity remains
  - clearer reasons for session-open/session-unknown conditions

### 68.3 Storage provenance
Legacy strength:
- EA1 persistence doctrine clearly tagged whether continuity was resumed, rejected, stale, corrupt, or incompatible.

Current ASC influence:
- `mt5/ASC_Storage.mqh` should expose origin-of-restored-state truth instead of only acting as if persistence either existed or did not.

### 68.4 Output provenance
Legacy strength:
- richer systems distinguished publishable truth from merely known internal truth.

Current ASC influence:
- `mt5/ASC_Output.mqh` should eventually gain access to clearer publishability class fields so compact trader output does not imply stronger trust than the underlying state deserves.

---

## 69. Archive Method Dependencies and Hidden Couplings

### Coupling 1 — giant shared structs
- AFS methods often depend on `AFS_UniverseSymbol` carrying history, friction, selection, and output-routing fields all at once.
- Consequence:
  - methods like `AFS_HF_ComputeFreshnessScore` and `AFS_SL_ComputeTrustScore` cannot be lifted without first recreating or redesigning the intermediate truth they consume.

### Coupling 2 — stage/publish ecosystem assumptions
- EA1 and PIE methods often assume current/previous snapshot files, stage files, or debug files exist in a known cadence.
- Consequence:
  - publication helpers are unsafe to reuse unless current ASC explicitly wants the same fallback model.

### Coupling 3 — runtime phase shells
- ISSX runtime and market/selection methods assume kernel phases, queue families, or staged budget spending.
- Consequence:
  - phase-aware helpers must be reduced to simpler engine semantics before use in ASC.

### Coupling 4 — hidden sampling state
- ISSX DEV friction logic assumes ring buffers, sample windows, and periodic quote probes persist across cycles.
- Consequence:
  - friction methods cannot be lifted until ASC decides whether to own sample rings in Surface or Storage.

### Coupling 5 — dossier/trader package assumptions
- AFS trader intel and dossier methods assume richer downstream symbol artifacts and caches than current ASC symbol files provide.
- Consequence:
  - text-formatting helpers are portable only after dossier contract growth is explicitly opened.

### Coupling 6 — theme/family vocabularies not preserved in current contracts
- ISSX and some market-state methods return richer asset family or theme buckets than current ASC currently models downstream.
- Consequence:
  - identity methods that emit those labels will appear useless unless `ASC_Common.mqh` is enriched first.

---

## 70. High-Value Legacy Code Fragments by Current MT5 Module

### For `mt5/ASC_Market.mqh`
- `AFS_CL_NormalizeSymbol`
- `AFS_CL_ClassifySymbol` structure, not raw row import
- `AFS_MC_GetSessionState`
- `InsideAnySessionTrade` / `InsideAnySessionQuote`
- `DetectAssetClass`, `DetectInstrumentFamily`, `DetectThemeBucket`
- `HasEconomicallyValidQuote`

### For `mt5/ASC_Conditions.mqh`
- `GetInt` / `GetDbl` / `GetStr` wrappers from ISS spec extraction
- `AFS_MC_TryValidateTickValue` principle only
- `ComputeMarginRateFlags` as capability/probe-summary inspiration
- `PIE_ProbeValuePerPoint` and `PIE_ProbeMargin1Lot` principles, not direct formulas
- `CalcValuePerPoint_1Lot` / `CalcMargin_1Lot` as provenance-aware reference only

### For `mt5/ASC_Storage.mqh`
- `WriteTextAtomic`
- `WriteTextIfChanged`
- `IsSafeRelativePath`
- EA1 stale/corrupt/incompatible continuity doctrine
- AFS/TraderIntel stable-signature and atomic temp path ideas where still useful

### For `mt5/ASC_Output.mqh`
- AFS output route sanitization and write-failure logging concepts
- AFS dossier explanation text fragments after dossier scope is opened
- ISSX snapshot/hydration labeling ideas only if publishability classes are added

### For `mt5/ASC_Surface.mqh`
- `AFS_HF_HydrationStage`
- `AFS_HF_ComputeFreshnessScore`
- `AFS_HF_MovementScore`
- `AFS_SL_IsRankable`
- `AFS_SL_BetterTieBreak`
- ISSX DEV friction ring and ATR-point principles, not raw mechanics

### For `mt5/ASC_Engine.mqh`
- ISSX budget and phase-discipline concepts in reduced form
- publish-preservation / deadline-hit style guard concepts
- restart-state exposure hooks once Storage is enriched

### For future `mt5/ASC_UI.mqh`
- ISSX warning presentation helpers
- ISSX menu click/render concepts in a much smaller bounded operator shell
- HUD state exposure for restart, ranking, and scanner health only

---

## 71. What Current ASC Still Cannot Express

### 71.1 Degraded-state vocabulary
Current ASC cannot yet express a formal difference between:
- warming
- weak
- degraded
- stale-but-observable
- session-ambiguous
- friction-poor but technically alive

### 71.2 Provenance for derived conditions truth
Current contracts are too thin to express:
- raw observed vs substituted/effective values
- why a derived money or spec field is trusted
- which probe or fallback produced it

### 71.3 Restart-path truth
Current contracts are too thin to express:
- restored cleanly from compatible persistence
- restarted because persistence was stale
- restarted because persistence was corrupt
- restarted because identity/spec compatibility failed

### 71.4 Rich rankability decomposition
Current contracts are too thin to express:
- trust class
- freshness class
- weak-link cause
- publishability class
- deterministic tie-break context

### 71.5 Operator-visible health states
Current product files cannot yet represent a bounded operator health plane showing:
- why a symbol is not shortlist-worthy
- why continuity was rejected
- why conditions truth is partial
- why output is pending vs publishable

### 71.6 Identity ambiguity lineage
Current contracts are too thin to represent:
- classification confidence
- alias kind
- review-needed state
- theme/family enrichment status

---

## 72. Canonical Translation Rules for Future Codex Packets

1. Never port formulas before porting their truth model.
2. Never port structs before splitting ownership by current ASC module.
3. Always name the exact archive source file and exact method family in future extraction prompts.
4. Always map the legacy capability to one current owner module before coding.
5. If ownership is shared, enrich `mt5/ASC_Common.mqh` first instead of improvising duplicate fields in multiple modules.
6. Never let archive code override blueprint law.
7. Treat archive methods as candidates for translation, not authorities for current naming.
8. Preserve `PrimaryBucket` law even when importing richer classification lineage.
9. Keep writer-only discipline intact even if legacy output code computed more than it wrote.
10. Do not import stage/debug schema ecosystems into trader-facing output.
11. Do not import multi-EA runtime shells into current engine work.
12. If a legacy method depends on hidden rings, caches, or stage files, document that dependency before implementation begins.
13. Prefer method families in this order when extracting:
    - identity normalization
    - safe property access
    - provenance/state vocabulary
    - continuity validity
    - degraded-state vocabulary
    - deterministic tie-breaks
    - deeper score formulas only after all prior truth surfaces exist
14. Any future packet that says “recover legacy X” must also name:
    - source file
    - target module
    - required contract enrichment
    - what must not be ported from the same source
15. When in doubt, translate the principle, not the threshold.
16. If an archive method was built around a monolith, extract only the local logic and rewrite around current bounded records.
17. Future Codex runs should treat this section and Sections 59-71 as the mandatory pre-implementation bridge before touching MT5 code.
