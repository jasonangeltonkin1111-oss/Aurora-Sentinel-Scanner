# ARCHIVE SURGICAL MAP

## 1. Archive Areas Reviewed
- Read the active front-door and control files first: `README.md`, `INDEX.md`, `office/HQ_OPERATOR_MANUAL.md`, `office/ARCHIVE_REFERENCE_MAP.md`, `office/MODULE_OWNERSHIP.md`, `office/TASK_BOARD.md`, and `office/WORKER_RULES.md` to lock current ASC scope before touching archive meaning.
- Read the active blueprint contracts needed to judge archive fit: `blueprint/SYSTEM_OVERVIEW.md`, `blueprint/MODULE_MAP.md`, `blueprint/MARKET_IDENTITY_MAP.md`, `blueprint/SUMMARY_SCHEMA.md`, `blueprint/RUNTIME_RULES.md`, `blueprint/THREE_LAYER_SCAN_ARCHITECTURE.md`, `blueprint/SYMBOL_LIFECYCLE_AND_ACTIVATION.md`, `blueprint/ATOMIC_WRITE_AND_PERSISTENCE_RULES.md`, `blueprint/DATA_VALIDITY_AND_FAIL_FAST_RULES.md`, `blueprint/UNIVERSE_SNAPSHOT_CONTRACT.md`, `blueprint/RANKING_AND_PROMOTION_CONTRACT.md`, and `blueprint/PRODUCT_NAMING_AND_OUTPUT_LANGUAGE_RULES.md`.
- Reviewed archive governance/index files: `archives/README.md`, `archives/INDEX.md`, `archives/ARCHIVE_IMMUTABILITY.md`, `archives/BLUEPRINT_REFERENCE/README.md`, `archives/extracted_reference/README.md`, and `archives/LEGACY_SYSTEMS/EA1/README.md`.
- Reviewed legacy scanner/source clusters in depth:
  - `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`
  - `archives/LEGACY_SYSTEMS/AFS/Aegis_Forge_Scanner.mq5`
  - `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/AEGIS FORGE SCANNER.txt`
  - `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP1.txt`
- Reviewed ISSX and related legacy clusters for runtime, persistence, snapshot, scheduler, and surface/ranking ideas:
  - `archives/LEGACY_SYSTEMS/ISSX/ISSX.mq5`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_history_engine.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_scheduler.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_data_handler.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_universe_manager.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_debug_engine.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
  - `archives/LEGACY_SYSTEMS/ISSX/issx_contracts.mqh`
- Reviewed older EA experiments and extraction utilities that still preserve truth fragments:
  - `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/EA2_HistoryMetrics.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/ISSX*.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/ISS_LITE_CORR30.mq5`
  - `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
  - `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
  - `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`
- Reviewed old doctrinal text and warning material:
  - `archives/BLUEPRINT_REFERENCE/AURORA.txt`
  - `archives/BLUEPRINT_REFERENCE/AURORA — UNIVERSAL MULTI-ASSET MARK.txt`
  - `archives/BLUEPRINT_REFERENCE/AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`
  - `archives/LEGACY_SYSTEMS/New Text Document (3).txt`
  - `archives/MAPS/unclassified/Hud design.txt`
  - `archives/MAPS/unclassified/New Text Document.txt`
  - `archives/MAPS/unclassified/New Text Document (2).txt`
- Reviewed the Aurora research-library indexes and a representative sample of text files to classify the whole library safely without pretending book-level extraction that was not actually performed.

## 2. Classification-Critical Legacy Truth
- `AFS_Classification.mqh` remains the strongest legacy upstream truth source for broker symbol identity. It preserves server-specific `RawSymbol -> CanonicalSymbol` mapping, `AssetClass`, `PrimaryBucket`, sector/industry/theme layers, alias kind, and review/confidence metadata. That maps directly into ASC Market-domain translation work.
- The useful classification truth is not just the static row list. The valuable part is the lookup discipline:
  - normalize raw symbol names before matching
  - strip broker suffixes deterministically
  - match server-aware rows first
  - preserve unresolved state when no safe row exists
  - keep confidence/review notes visible instead of pretending full resolution
- `AFS_CoreTypes.mqh` confirms the classification fields that legacy systems actually expected to travel together: normalized symbol, normalized alias, canonical symbol, asset class, `PrimaryBucket`, theme bucket, subtype, alias kind, status, confidence, and review notes. That is useful for field completeness checking, not for wholesale import.
- `AEGIS FORGE SCANNER.txt` and `BP1.txt` reinforce that broker sector/class metadata was not trusted as final system truth. User-owned classification was treated as the canonical source. That is fully aligned with current ASC Market ownership.
- Older EA1/ISSX files preserve weaker but still useful identity ideas:
  - canonical uppercase normalization
  - family collapse / alias-family handling
  - deterministic alphabetical symbol ordering
  - keeping broker raw identity beside normalized identity instead of overwriting it
- Dangerous classification drift found in archives:
  - some old EA1 experiments fall back to asset-class heuristics from calc mode or ticker shape
  - ISSX identity logic uses simpler canonicalization than AFS
  - old blueprint/doctrinal texts mix scanner truth with broader research/execution concepts
- ASC conclusion:
  - **translate** AFS classification rows, normalization rules, unresolved behavior, and confidence/review fields into Market
  - **reference only** older field breadth and family-collapse vocabulary
  - **do not use** heuristic-only or execution-oriented bucket substitutions

## 3. Layer 1 / Session Truth Findings
- Legacy EA1/ISSX code preserves useful session-truth patterns:
  - direct `SymbolInfoSessionTrade` and `SymbolInfoSessionQuote` window reads
  - separate quote-session and trade-session tracking
  - explicit market-open vs quote-observable vs trade-permitted distinctions
  - deterministic recheck delays for closed or weak symbols
  - no assumption that an asset class is open just because the asset class usually trades
- `EA1_MarketCore*.mq5` is especially useful for Layer 1 because it stores session windows, computes current open/closed truth, tracks quote/trade windows separately, and derives retry delays such as snapshot closed recheck and copy-ticks retry cadence.
- `ISSX_MarketStateCore.mq5` and `issx_market_engine.mqh` add useful concepts for session truth quality:
  - session phase classes such as pre-open/open/mid/late/rollover/closed
  - minutes since open / minutes to close
  - explicit transition-penalty flags
  - session-truth confidence rather than binary certainty claims
- `AFS_HistoryFriction.mqh` adds a useful nuance: feed truth is not the same as session truth. The file distinguishes `ACTIVE_MARKET`, `THIN_BUILDING`, `QUIET_ALIVE`, `STALE_FEED`, `DEAD_FEED`, `NO_QUOTE`, and `CLOSED_SESSION`. That is valuable for fail-fast and later surface/ranking logic, but not all of it is first-slice critical.
- `MarketISS_SymbolTruth.mq5` and `ISS-X Spec Extraction EA.mq5` confirm a practical extraction pattern for one-shot session and tradability truth capture, but they are not themselves clean ASC architecture.
- ASC conclusion:
  - first-slice Layer 1 should inherit direct broker session window reading, explicit quote-vs-trade session distinction, broker-symbol-specific recheck scheduling, and unknown/closed/feed-degraded separation
  - later slices may inherit richer session-phase and confidence surfaces

## 4. Layer 1.2 / Universe Snapshot Findings
- Legacy EA1, AFS, and ISSX all confirm that a truthful universe snapshot should preserve broad broker reality before ranking or deep intelligence begins.
- Strong snapshot truths found repeatedly:
  - capture full symbol inventory from broker/Market Watch scope
  - preserve raw broker symbol identity, path, description, exchange/country where available
  - preserve contract/spec fields without guessing missing values
  - preserve quote/profit/margin currencies
  - preserve trade/calc/filling/order modes
  - preserve volume min/max/step/limit and stops/freeze levels
  - keep session metadata alongside symbol identity when available
  - retain snapshot timestamps and continuity markers
- `AFS_MarketCore.mqh` and `AFS_CoreTypes.mqh` show useful first-slice spec fields and integrity states.
- `EA1_MarketCore*.mq5` and `ISS-X Spec Extraction EA.mq5` show an older but practical pattern for reading broad symbol properties safely and preserving raw broker metadata even when some fields are unavailable.
- `issx_market_engine.mqh` adds stronger ideas about separating raw broker observation from later validated runtime truth. That is good blueprint support for keeping Layer 1.2 broad and non-dossier-like.
- `issx_universe_manager.mqh` confirms deterministic ordering and deduplication are operationally important. Sorting and unique handling should happen deterministically before snapshot publication.
- ASC conclusion:
  - first-slice should translate the broker inventory/spec/session metadata capture pattern
  - ASC blueprint already blocks Layer 1.2 from becoming a stealth dossier, which is correct
  - the remaining gap is more explicit field-level snapshot completeness guidance and continuity expectations for updates to the snapshot over time

## 5. Layer 2 / Conditions and Surface Findings
- `AFS_MarketCore.mqh` is useful for first-slice Conditions truth because it separates spec integrity, normalization status, economics trust, commission readability, and validated tick-value handling from output concerns.
- `AFS_HistoryFriction.mqh` is the most useful surface/signal-quality archive for ASC later-slice Surface truth. It contains:
  - ATR from real rates
  - M15/H1 history readiness ideas
  - movement capacity and liveliness thinking
  - spread median / max / spread-to-ATR handling
  - freshness and friction hydration state
  - weak/fail reason ladders
- `AFS_Selection.mqh` contains rankability gating and score composition ideas that are useful later for Ranking, especially:
  - cost efficiency as spread-to-opportunity logic
  - trust scoring built from multiple upstream validity surfaces
  - deterministic tie-break ordering
  - family/correlation-aware shortlist hygiene
- ISSX EA2/EA3 material adds richer later-slice ideas:
  - history finality and rewrite stability classes
  - window comparability and cross-symbol compare safety
  - hysteresis / survivor continuity to reduce shortlist churn
  - deterministic frontier and reserve handling around the top set
- Older `ISSX_DEV_Friction.mq5` shows a clean bounded runtime cadence for rolling spread sampling, snapshot export, and simple atomic write verification. Useful as a cadence/persistence reference, not as architecture.
- Dangerous drift found in this zone:
  - old AFS and ISSX surface layers are broader than first-slice ASC and can easily bloat the current milestone
  - older “intelligence” and “deep spec” code often blends surface, selection, diagnostics, and publication together
  - some archives include correlation, reserve, or deep optional intelligence far earlier than ASC first slice allows
- ASC conclusion:
  - first-slice should translate only broker conditions/spec truth, spread/tradability truth, M15/H1 requirements, and explicit invalid/weak handling
  - later-slice Surface and Ranking should preserve the richer friction hydration, history finality, shortlist continuity, and deterministic tie-break concepts

## 6. Storage / Persistence / Atomic Write Findings
- Persistence is one of the clearest archive strengths.
- `BP1.txt`, `EA1_MarketCore*.mq5`, `ISSX_DEV_Friction.mq5`, `Export_Contract_Specs_AllSymbols.mq5`, `issx_persistence.mqh`, and `issx_data_handler.mqh` all reinforce the same useful core truths:
  - load prior state first on startup
  - do not wipe good state during normal recalculation
  - use temp/candidate files and verify them before promotion
  - keep last-good or backup fallback paths when current write is bad
  - preserve continuity metadata so later runs know whether state is fresh, stale, partial, or incompatible
  - bound write frequency and avoid tight-loop retry storms
- `issx_persistence.mqh` is particularly valuable for translation patterns rather than direct structure reuse. It shows:
  - candidate/current/last-good promotion thinking
  - compatibility checking before accepting prior state
  - explicit handoff / continuity records
  - lock/lease concepts for multi-stage persistence safety
- `ISSX_SnapshotFlow` patterns visible through `ISSX.mq5` also confirm a good publication law: build candidate -> load candidate -> verify coherence -> promote candidate -> optionally preserve last good.
- `Export_Contract_Specs_AllSymbols.mq5` gives a small, concrete atomic text write pattern useful for ASC writer implementation:
  - validate basic JSON structure before promotion
  - write temp file
  - flush and re-open temp for verification
  - replace final only after temp passes
- `EA1_MarketCore*.mq5` adds budgeted persistence ideas:
  - save cadence controls
  - minimum save gaps
  - backup file paths
  - persistence freshness age limits
- ASC conclusion:
  - first-slice Storage should translate restore-first, continuity-aware load, bounded save cadence, temp-then-promote writes, and non-destructive fallback behavior
  - active dossier atomic-write law is strongly supported by the archive layer
  - ASC still lacks a fully explicit blueprint-level distinction between simple snapshot updates and full candidate/last-good recovery policy details

## 7. Output / Publisher Findings
- The archive layer consistently warns that output must consume truth, not create it.
- `AFS_OutputDebug.mqh`, `AFS_TraderIntel.mqh`, `AFS_TraderDossierEngine.mqh`, and `BP1.txt` preserve several useful publisher laws:
  - output paths and package routing should be explicit and deterministic
  - summary and dossier are downstream publication surfaces, not upstream logic owners
  - changed-only or materially changed writes reduce unnecessary churn
  - active/inactive continuity matters; old files should not be rewritten blindly
  - trader-facing output and dev/debug output must remain separate
- `Hud design.txt` provides a valuable output/presentation principle even though it is UI-oriented: the display surface should show known-now versus pending state explicitly rather than using fake zero placeholders.
- Old AFS doctrinal text supports the current ASC three-part symbol-file shape indirectly by emphasizing broker/spec data, history-derived data, and downstream calculations as distinct classes.
- Dangerous output drift found in archives:
  - large parts of AFS and ISSX publish multiple JSON/debug/dev/operator artifacts that exceed ASC’s current trader-facing output scope
  - legacy “TraderIntel”, “Module Summary”, debug routes, HUD text, and multi-file package sprawl would leak office/dev language into product surfaces if imported directly
  - some old output paths are account/server/stage-rich in a way that does not match ASC’s simpler product-facing contract
- ASC conclusion:
  - first-slice should translate writer purity, deterministic routing, active-truth-safe rewrites, and explicit pending/unknown rendering discipline
  - do not import legacy debug/profile naming, multi-surface package sprawl, or developer-facing publication contracts into ASC product outputs

## 8. Later-Slice and Future-Layer Findings
- The archive layer contains a large amount of useful later knowledge, but much of it is clearly outside current ASC first slice.
- Useful later-slice findings:
  - `AFS_HistoryFriction.mqh` for richer surface hydration, liveliness, and friction classification
  - `AFS_Selection.mqh` for ranking continuity, cost/trust composition, and deterministic shortlist tie-breaks
  - `issx_history_engine.mqh` and `issx_runtime.mqh` for history finality, rewrite risk, comparability, and warehouse-quality concepts
  - `issx_selection_engine.mqh` for top-5, reserve, and frontier continuity patterns
  - `issx_contracts.mqh` for integrity table composition and context blocks if ASC later wants richer dossier or diagnostics surfaces
  - `Hud design.txt` for future UI/readiness visibility that keeps trader-facing UI cleaner than dev diagnostics
- Future-only findings:
  - `AFS_TraderAnalyticsEngine.mqh`, `AFS_TraderIntel.mqh`, and large parts of `AFS_TraderDossierEngine.mqh` preserve deeper intelligence and dossier enrichment ideas that fit future Layer 4 expansion more than first slice
  - ISSX correlation, deep spec, optional intelligence, telemetry, menu, and UI stacks are useful as historical caution/reference but are too broad for current ASC
  - Aurora research blueprints and book library preserve long-horizon ideas about regime awareness, volatility frameworks, decision quality, and behavioral/risk discipline, but these are future-only and not safe as immediate implementation inputs
- Strong scope warning:
  - `AURORA.txt`, `AURORA — UNIVERSAL MULTI-ASSET MARK.txt`, `AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`, and `MAPS/unclassified/New Text Document*.txt` are too broad and drift toward decision OS, supervision, governance, journaling, risk, execution-feasibility, or signal surfaces. They are valuable only as “do not rebuild this now” warnings.

## 9. Archive File Classification Map

### `archives/LEGACY_SYSTEMS/AFS/AFS_Classification.mqh`
- State: TRANSLATE
- Why: It is the strongest concrete upstream source for server-aware identity/classification truth and the current ASC blueprint already relies on its meaning.
- Exact truth extracted:
  - raw-to-canonical symbol mapping
  - `AssetClass`, `PrimaryBucket`, sector, industry, theme, subtype, alias kind
  - server-aware matching order
  - symbol normalization and suffix stripping rules
  - unresolved/partial/resolved behavior and review/confidence metadata
- ASC target domain: Market
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_CoreTypes.mqh`
- State: REFERENCE ONLY
- Why: It preserves valuable field vocabulary and continuity expectations, but the struct breadth is too large and carries legacy HUD/output/testing baggage.
- Exact truth extracted:
  - useful shared field names for identity, specs, history, friction, ranking, timestamps, and persistence state
  - confirmation that classification, spec, quote, and score surfaces were treated as one shared symbol record
  - memory-shell style runtime counters that may inspire later diagnostics
- ASC target domain: Common shared contract surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_MarketCore.mqh`
- State: TRANSLATE
- Why: It preserves practical broker-spec and conditions truth handling without requiring full legacy architecture.
- Exact truth extracted:
  - reset discipline for spec/surface state
  - safe spec reads from MT5 broker properties
  - tick-value validation via `OrderCalcProfit`
  - explicit spec integrity and normalization status handling
  - economics trust inputs and commission readability handling
- ASC target domain: Conditions
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_HistoryFriction.mqh`
- State: TRANSLATE
- Why: It contains the best legacy decomposition of history readiness, friction truth, freshness, and market/feed-state classification.
- Exact truth extracted:
  - ATR-from-rates pattern
  - M15/H1 history readiness signals
  - spread median/max and spread-to-ATR discipline
  - hydration/freshness state ladder
  - explicit truth states such as active market, stale feed, dead feed, closed session, thin building, no quote
- ASC target domain: later-slice Surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_Selection.mqh`
- State: TRANSLATE
- Why: It preserves strong shortlist-quality logic and deterministic tie-break behavior, but it belongs after first-slice truth foundations exist.
- Exact truth extracted:
  - rankability gating discipline
  - cost efficiency scoring from spread-to-opportunity context
  - trust-score composition from upstream validity surfaces
  - deterministic tie-break order and shortlist stability concepts
  - family/correlation-aware reserve/finalist logic as a later reference
- ASC target domain: later-slice Ranking
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_OutputDebug.mqh`
- State: REFERENCE ONLY
- Why: It preserves routing and publication shell ideas, but it is heavily mixed with debug/trader package legacy output that should not be imported directly.
- Exact truth extracted:
  - deterministic path shell thinking
  - separation of output shell construction from core logic
  - logging/publication route discipline
- ASC target domain: Storage
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderIntel.mqh`
- State: DO NOT USE
- Why: It expands into trader-intel packaging beyond current ASC scope and would pull broader dossier/publication complexity into first-slice work.
- Exact truth extracted:
  - warning that downstream trader packages easily overgrow scanner scope
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderDossierEngine.mqh`
- State: REFERENCE ONLY
- Why: It contains dossier continuity ideas that may inform later active-symbol persistence, but the engine is much broader than ASC’s current deep-dossier contract.
- Exact truth extracted:
  - active-symbol-oriented dossier continuity concepts
  - cadence-controlled enrichment patterns
  - separation between shallow scan truth and deeper active-symbol intelligence
- ASC target domain: Storage
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/AFS/AFS_TraderAnalyticsEngine.mqh`
- State: REFERENCE ONLY
- Why: It preserves future analytics ideas but is too downstream and too broad for first-slice ASC.
- Exact truth extracted:
  - ideas for later analytical overlays, higher-timeframe completion, and dossier enrichment
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/LEGACY_SYSTEMS/AFS/Aegis_Forge_Scanner.mq5`
- State: REFERENCE ONLY
- Why: The wrapper is too large and legacy-specific to transplant, but it preserves useful orchestration, input grouping, and bounded scan cadence ideas.
- Exact truth extracted:
  - timer-driven orchestration over tick-heavy behavior
  - bounded batch sizes for broad vs deep work
  - separation between scanning, publication, HUD, and debug concerns
  - practical evidence that top-5-per-`PrimaryBucket` was already central scanner truth
- ASC target domain: Engine
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/AEGIS FORGE SCANNER.txt`
- State: REFERENCE ONLY
- Why: It is a valuable doctrine/reference file, but not an active ASC contract.
- Exact truth extracted:
  - scanner identity and anti-signal/anti-trading scope
  - top-5-per-`PrimaryBucket` doctrine
  - one-terminal/one-broker-universe thinking
  - output partitioning and module-orchestration boundaries
- ASC target domain: Common shared contract surface
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/AFS/ORIGINAL/BP1.txt`
- State: REFERENCE ONLY
- Why: It contains strong continuity/publication/persistence laws, but Phase-5 AFS doctrine is too broad to import directly.
- Exact truth extracted:
  - startup continuity and restore-first discipline
  - publication layer vs analytics layer vs presentation layer separation
  - atomic-write and continuity law reinforcement
  - warning that downstream layers must not rewrite upstream truth
- ASC target domain: Storage
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_market_engine.mqh`
- State: TRANSLATE
- Why: It preserves robust broker observation, runtime truth separation, and session/tradability state modeling that can strengthen ASC Engine/Market understanding.
- Exact truth extracted:
  - raw broker observation block design
  - session phase categories and runtime readiness distinctions
  - keeping raw broker fields separate from later validated truth
  - phase-oriented market-state pipeline ordering
- ASC target domain: Engine
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_persistence.mqh`
- State: TRANSLATE
- Why: It contains the clearest candidate/current/last-good persistence safety patterns in the archive layer.
- Exact truth extracted:
  - compatibility checks before state acceptance
  - handoff continuity metadata
  - lock/lease thinking for persistence safety
  - promotion of verified candidate output into active/current state
  - last-good fallback behavior
- ASC target domain: Storage
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_scheduler.mqh`
- State: TRANSLATE
- Why: It provides a strong bounded scheduler model for timer-driven work, budgeting, cadence types, and degraded-cycle handling.
- Exact truth extracted:
  - stage cadence categories
  - explicit budget checks before heavy work
  - essential-stage fallback when budget is low
  - tracked deferred/failed/not-ready results instead of silent retry loops
- ASC target domain: Engine
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_runtime.mqh`
- State: REFERENCE ONLY
- Why: It preserves deep runtime/history quality surfaces, but the contract breadth is far beyond current ASC first-slice needs.
- Exact truth extracted:
  - history finality, rewrite, warehouse quality, and comparability vocabulary
  - evidence that history quality and cross-symbol comparability need their own truth states
- ASC target domain: later-slice Surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_data_handler.mqh`
- State: TRANSLATE
- Why: It contains practical write/read/verification helpers that support safe persistence without dragging the full ISSX system into ASC.
- Exact truth extracted:
  - payload write atomicity helpers
  - forensic state / verification patterns
  - safe file IO behavior under failure
- ASC target domain: Storage
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_history_engine.mqh`
- State: REFERENCE ONLY
- Why: It is useful for later history quality and finality work, but too advanced for current first-slice scope.
- Exact truth extracted:
  - completed-bar safety
  - rewrite/finality handling
  - cross-timeframe history readiness and warehouse quality concepts
- ASC target domain: later-slice Surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_selection_engine.mqh`
- State: REFERENCE ONLY
- Why: It preserves shortlist stability and deterministic reserve/frontier handling, but it is a broader selection stack than current ASC needs.
- Exact truth extracted:
  - top-5 limit discipline
  - hysteresis and survivor continuity to reduce churn
  - bucket-local composite ranking and reserve/frontier staging
- ASC target domain: later-slice Ranking
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_universe_manager.mqh`
- State: TRANSLATE
- Why: It is a compact, useful source for deterministic symbol sorting, deduplication, and canonical compare order.
- Exact truth extracted:
  - deterministic uppercase canonicalization
  - stable sorting order
  - deduplication discipline before downstream processing
- ASC target domain: Market
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_debug_engine.mqh`
- State: REFERENCE ONLY
- Why: It preserves post-run and runtime diagnostics ideas, but the logging/export stack is too elaborate for ASC first slice.
- Exact truth extracted:
  - bounded debug-write budgets
  - suppression rather than infinite debug spam
  - safe path sanitization for logs
- ASC target domain: later-slice Diagnostics
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_ui.mqh`
- State: REFERENCE ONLY
- Why: It is future UI/debug material, not current ASC product output truth.
- Exact truth extracted:
  - stage/readiness visibility patterns
  - distinction between runtime health display and underlying system logic
- ASC target domain: later-slice UI
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/issx_contracts.mqh`
- State: REFERENCE ONLY
- Why: It contains rich contract/export surfaces and integrity-table ideas, but they belong to a much broader multi-stage system.
- Exact truth extracted:
  - explicit integrity-block composition
  - session/context/comparison field vocabulary
  - “unknown / unavailable / not applicable” style contract discipline
- ASC target domain: Common shared contract surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/ISSX/ISSX.mq5`
- State: REFERENCE ONLY
- Why: The wrapper proves persistence/snapshot promotion and multi-stage orchestration patterns, but the architecture is too large and split-stage-heavy for current ASC.
- Exact truth extracted:
  - stage publish flow using candidate -> verify -> promote
  - snapshot projection discipline
  - persistent stage/debug/universe artifacts separation
- ASC target domain: Engine
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/Old EAS/EA1_MarketCore*.mq5`
- State: TRANSLATE
- Why: These files preserve concrete first-slice patterns for broker inventory, session windows, market-open truth, spec reads, persistence cadence, and recheck scheduling.
- Exact truth extracted:
  - broad broker symbol inventory loading
  - session quote/trade window storage
  - market-open state derivation and recheck delay logic
  - raw broker spec snapshot fields
  - restore/save cadence and backup path discipline
- ASC target domain: Market
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/Old EAS/EA2_HistoryMetrics.mq5`
- State: REFERENCE ONLY
- Why: It is mostly later surface/history work and should not expand first-slice scope.
- Exact truth extracted:
  - history metric staging ideas
  - warning that history readiness should be kept explicit
- ASC target domain: later-slice Surface
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/Old EAS/EA3_Intelligence.mq5`
- State: DO NOT USE
- Why: It pushes toward broader intelligence/correlation layers beyond current ASC foundation.
- Exact truth extracted:
  - warning that deep intelligence stacks easily exceed scanner-first scope
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/LEGACY_SYSTEMS/Old EAS/ISS-X Spec Extraction EA.mq5`
- State: TRANSLATE
- Why: It is a useful one-shot broker-truth extraction reference for snapshot and session/spec capture.
- Exact truth extracted:
  - broad symbol property extraction pattern
  - session window export logic
  - margin-rate/spec capture ideas
  - truthful one-shot export of broker symbol truth
- ASC target domain: Market
- Slice relevance: first-slice

### `archives/LEGACY_SYSTEMS/Old EAS/ISSX*.mq5`
- State: REFERENCE ONLY
- Why: These wrappers and dev EAs preserve cadence and persistence ideas, but are tied to a larger ISSX architecture.
- Exact truth extracted:
  - bounded timer cadence
  - rolling snapshots with atomic writes
  - multi-stage separation patterns
- ASC target domain: Engine
- Slice relevance: later-slice

### `archives/LEGACY_SYSTEMS/Old EAS/ISS_LITE_CORR30.mq5`
- State: DO NOT USE
- Why: It mixes account history, open positions, correlation matrices, and ranking surfaces outside current ASC foundation.
- Exact truth extracted:
  - warning that correlation/account overlays are scope-expanding and should not enter first-slice ASC
- ASC target domain: later-slice Ranking
- Slice relevance: future-only

### `archives/LEGACY_SYSTEMS/Old EAS/PIE.MT5.mq5`
- State: REFERENCE ONLY
- Why: It contains useful spec/tick/cost truth extraction and atomic bin write patterns, but it is still a broader experimental snapshot system.
- Exact truth extracted:
  - broker spec read batching
  - tick/spec/cost truth extraction
  - atomic bin write and deterministic symbol ordering ideas
- ASC target domain: Conditions
- Slice relevance: later-slice

### `archives/EXTRACTED_REFERENCE/runtime_cadence/Export_Contract_Specs_AllSymbols.mq5`
- State: TRANSLATE
- Why: It is a compact reference for safe text-file atomic write flow and staged export verification.
- Exact truth extracted:
  - temp-write -> flush -> verify -> replace pattern
  - basic content sanity checks before promotion
  - bounded export cadence thinking
- ASC target domain: Storage
- Slice relevance: first-slice

### `archives/EXTRACTED_REFERENCE/runtime_cadence/MarketISS_SymbolTruth.mq5`
- State: REFERENCE ONLY
- Why: It is useful for one-shot truth extraction patterns, but it includes account/positions/history export surfaces outside current ASC scope.
- Exact truth extracted:
  - symbol truth export pattern
  - value-per-point and margin probe ideas
  - separation between symbol snapshot and account snapshot
- ASC target domain: Conditions
- Slice relevance: later-slice

### `archives/BLUEPRINT_REFERENCE/AURORA.txt`
- State: DO NOT USE
- Why: It is a trading OS blueprint with journaling, governance, execution feasibility, alpha ownership, and broader decision-system scope far beyond ASC.
- Exact truth extracted:
  - clear warning boundary against rebuilding Aurora inside ASC
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/BLUEPRINT_REFERENCE/AURORA — UNIVERSAL MULTI-ASSET MARK.txt`
- State: DO NOT USE
- Why: It is an even broader research/decision blueprint with telemetry, mode arbitration, account/risk, and scenario-model scope outside ASC.
- Exact truth extracted:
  - warning that research-OS and scanner-first product are not the same thing
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/BLUEPRINT_REFERENCE/AURORA-ISS — PROP-SAFE MULTI-FIRM D.txt`
- State: DO NOT USE
- Why: It is a feeder spec with many ISS/AURORA docking, account/fund/firm, timezone, and registry concerns that exceed ASC’s current mission.
- Exact truth extracted:
  - warning that feeder-safe context systems and scanner-first ASC are not equivalent
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/LEGACY_SYSTEMS/New Text Document (3).txt`
- State: REFERENCE ONLY
- Why: It preserves ISS-X cadence and snapshot doctrine ideas, but the full ecosystem design is still too broad.
- Exact truth extracted:
  - deterministic scheduler/kernel expectations
  - stage-isolated state persistence
  - top-only master snapshot concept
  - explicit atomic-write modes and hardened-read recovery ideas
- ASC target domain: Engine
- Slice relevance: later-slice

### `archives/MAPS/unclassified/Hud design.txt`
- State: REFERENCE ONLY
- Why: It is mostly future UI/HUD material, but it contains truthful display laws aligned with ASC no-fake-values rules.
- Exact truth extracted:
  - HUD/display should consume existing truth only
  - pending reasons must be explicit instead of rendered as fake numeric zeroes
  - dev HUD and trader HUD should remain distinct
- ASC target domain: later-slice UI
- Slice relevance: later-slice

### `archives/MAPS/unclassified/New Text Document.txt`
- State: DO NOT USE
- Why: It is a canonicalized Aurora decision/execution governance text and would import vault/suppression/execution scope drift.
- Exact truth extracted:
  - warning boundary against execution-governance creep
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

### `archives/MAPS/unclassified/New Text Document (2).txt`
- State: REFERENCE ONLY
- Why: It appears to be unclassified historical material with no strong current ASC-first truth recovered in this pass.
- Exact truth extracted:
  - provenance only; no load-bearing ASC truth confirmed
- ASC target domain: Common shared contract surface
- Slice relevance: future-only

### `archives/Aurora/README.md`, `archives/Aurora/ASC_PHASE1_INDEX.md`, `archives/Aurora/AURORA_FUTURE_INDEX.md`, and the Aurora library cluster
- State: REFERENCE ONLY
- Why: The library is a research reservoir, not active scanner implementation truth. The indexes are useful for future extraction discipline, but the books themselves should not drive current ASC foundation work.
- Exact truth extracted:
  - current ASC should prioritize truthful broker specs, spread/conditions, OHLC persistence, small calculation sets, and readable top-5-per-bucket output
  - later future work may mine auction/microstructure/volatility/risk texts for richer regime or surface ideas
- ASC target domain: future Layer 4 expansion
- Slice relevance: future-only

## 10. ASC Blueprint Gaps Still Remaining
- **First-slice critical:** The active blueprint is strong on high-level laws but still light on exact Layer 1 session-truth sub-states. The archive layer shows a need for more explicit blueprint guidance on:
  - quote session vs trade session distinction
  - feed-degraded vs closed-session vs no-quote handling
  - deterministic next-recheck scheduling policy
- **First-slice critical:** The active blueprint should later become more explicit about first-slice universe snapshot field scope and update behavior. Archives repeatedly show the importance of naming the minimum broker spec/session/property fields that belong in Layer 1.2.
- **First-slice critical:** The storage blueprint already states atomic-write law, but archive review shows missing specificity around candidate/last-good fallback, corruption recovery selection, and continuity acceptance rules for prior persisted files.
- **Later-slice relevant:** The blueprint is still light on surface-validity truth. Archives preserve useful distinctions such as hydration stage, stale-feed vs dead-feed, history finality, and compare-safe history quality. These should be preserved for later Surface/Ranking contracts.
- **Later-slice relevant:** The blueprint does not yet preserve ranking-stability concepts such as deterministic tie-break ladders, shortlist churn control, and reserve/frontier continuity. Those are not first-slice blockers, but the archive layer shows they will matter later.
- **Later-slice relevant:** The distinction between trader-facing output and developer/debug/diagnostic surfaces is present in current naming laws, but archive review shows future Diagnostics/UI contracts will need clearer blueprint treatment to avoid mixing product output with internal review surfaces.
- **Future-only:** The archive layer contains extensive regime-awareness, telemetry, dossier analytics, and research-OS ideas. These should be preserved as future-only references, but the active blueprint should continue to resist importing them until Layer 4 is intentionally opened.
- **Unclear / explicitly unresolved:** No single archive file cleanly solves ASC’s exact first-slice summary field list or exact active-symbol dossier file serialization layout beyond broad principles. ASC still needs its own narrower product-era contract decisions rather than pretending legacy packages can answer those directly.

## 11. Final Assessment
- Yes, the archive layer is now mapped deeply enough for ASC in the sense that HQ can tell which legacy material is safe to inherit, which material is only historical reference, and which material must stay out.
- The most valuable first-slice truths recovered are:
  - AFS classification rows and normalization/matching discipline for Market truth
  - broker session window and recheck-scheduling patterns from EA1/ISSX market-state lineage
  - broad broker-universe/spec snapshot patterns from EA1/spec-extraction archives
  - restore-first, temp-then-promote, and candidate/last-good persistence safety from ISSX/EA1/runtime-cadence archives
  - writer purity and pending/unknown rendering discipline from AFS/HUD/output archives
- The first-slice truths still missing from active understanding are mostly blueprint-detail gaps, not archive gaps:
  - exact Layer 1 sub-state contract for session/feed truth
  - exact Layer 1.2 minimum field set and update/continuity expectations
  - explicit corruption fallback / last-good acceptance policy for persisted files
- The later-slice truths that should be preserved for future work are:
  - richer friction hydration and freshness classes
  - history finality and compare-safe quality concepts
  - deterministic shortlist churn control and reserve/frontier continuity
  - future diagnostics/UI separation rules
  - regime-aware, ATR-refinement, and deeper dossier-intelligence ideas from the broader archive layer
- Final operational conclusion:
  - ASC should inherit narrow scanner truth from AFS/EA1/ISSX market-state, persistence, and classification artifacts.
  - ASC should **not** inherit old Aurora execution/research OS scope, ISS/AURORA feeder governance, account/risk systems, journaling systems, or broad trader-intelligence package sprawl.
  - Future workers can now use this map to translate legacy truth deliberately instead of importing legacy drift blindly.
