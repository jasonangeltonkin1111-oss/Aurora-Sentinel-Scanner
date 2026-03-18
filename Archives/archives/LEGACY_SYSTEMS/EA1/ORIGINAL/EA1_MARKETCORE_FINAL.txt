EA1_MARKETCORE_FINAL
AUTHORITATIVE IMPLEMENTATION BLUEPRINT
FINAL STABLE FORM
EA1 SCOPE ONLY
PIE-ALIGNED
TIMER ONLY
NO CHART
NO TRADE
PER FIRM SAFE
PRIVATE CONTINUITY SAFE
CURRENT AND PREVIOUS SNAPSHOT SAFE

GOAL
Build one final stable EA1 blueprint that is phase-free, archaeology-free, truthful, bounded, deterministic, and directly aligned with the PIE multi-EA pipeline.

EA1 exists to:
- observe broker market structure truthfully
- produce the canonical symbol universe for the pipeline
- publish deterministic market-state snapshots for downstream EAs
- publish rich broker-facing symbol truth for downstream EAs
- maintain bounded private continuity for restart resilience when continuity is enabled
- remain independently useful even when no downstream EA is present
- stay safe at large scale across brokers and firms

EA1 must not:
- trade
- execute
- depend on charts
- hide missing truth
- silently omit truth that was successfully observed
- become a monolithic archive
- absorb EA2, EA3, or EA4 responsibilities
- use private continuity as the main inter-EA contract

================================================================================
1. CORE POSITION
================================================================================

EA1 is:

- MT5
- timer only
- no chart
- no trade
- deterministic
- per firm isolated
- market observability core
- canonical universe producer for PIE
- broker-facing symbol truth publisher
- spec plus session plus market-state plus tick-path plus cost plus health publisher
- HUD-capable diagnostics tool while stabilization continues
- bounded private continuity owner for its own restart continuity only

EA1 architecture is:

- OnTick empty
- all runtime work in OnTimer
- EventSetTimer(1) as the engine heartbeat
- no hidden charts
- no ChartOpen
- no ChartSetSymbolPeriod
- no chart-based hydration
- bounded round-robin engines
- bounded publish flow
- bounded continuity load and save flow
- cache-only stage and debug builders

EA1 scope boundary is:

- EA1 only
- no EA2 history metrics logic
- no EA3 intelligence logic
- no EA4 merge logic
- no multi-EA orchestration inside EA1
- explicit compatibility seams for downstream consumers through stage snapshots only

EA1 canonical role inside PIE is:

- authoritative source of universe membership and ordering
- authoritative source of raw_symbol join key population
- authoritative source of normalized symbol identity
- authoritative source of market-state truth for each symbol
- authoritative source of spec truth within EA1 scope
- authoritative source of session truth within EA1 scope
- authoritative source of snapshot-path and history-path truth within EA1 scope
- authoritative source of cost truth within bounded v1 scope
- authoritative source of continuity truth about EA1 only

================================================================================
2. DESIGN PHILOSOPHY
================================================================================

A. Truth before completeness
- Unknown stays unknown.
- Null stays null.
- Zero is used only when materially true.
- Fallback never masquerades as observed truth.
- Derived fields never overwrite raw observed fields.
- Effective fields remain separate from observed fields.
- Current trust is never inferred from historical once-seen data without freshness rules.

B. Retrieve everything truthful within scope
- If broker truth exists, is readable, and is within EA1 scope, EA1 should retrieve it.
- If retrieval fails, EA1 should say it failed.
- If truth is partial, EA1 should publish it as partial.
- Missing truth must not be collapsed into cosmetic completeness.

C. Explicit dimensions over compressed illusion
EA1 keeps these dimensions separate:
- data truth
- session truth
- tradability
- cost completeness
- publish state
- continuity state
- health state

D. Provenance is mandatory
Major effective or inferred fields must carry provenance.
Confidence alone is insufficient.

E. Bounded usefulness beats delayed perfection
EA1 begins useful calculation from valid partial inputs.
It does not wait for perfect completeness before becoming operational.

F. Broker server time is authoritative
- session logic follows broker server time
- freshness follows broker server time
- continuity aging follows broker server time
- UTC is diagnostic only
- local PC time is never authoritative

G. Timer safety outranks convenience
No feature may introduce uncontrolled full-universe blocking every second.

H. Continuity must be truthful
Continuity exists to preserve bounded restart usefulness, not to create a false appearance of uninterrupted strength.

I. Publish snapshots are the canonical handoff
Downstream EAs consume stage snapshots, not EA1 private continuity files.

J. Diagnostics must remain operational
Debug exists to make the EA testable and operable during stabilization.
Debug is intentionally very rich until EA1 is proven perfect.

K. Final form removes journey labels
The runtime blueprint and runtime identity must not depend on historical phase labels.
Only current stable behavior matters.

================================================================================
3. HARD RULES
================================================================================

1. No trading ever
Forbidden:
- OrderSend
- CTrade
- trade execution logic
- position inspection for decision purposes
- order inspection for decision purposes
- deal-history-driven execution logic

Allowed probes only:
- OrderCalcProfit
- OrderCalcMargin

2. Timer only
- EventSetTimer(1)
- all logic in OnTimer
- OnTick empty

3. No chart hydration
- no ChartOpen
- no ChartSetSymbolPeriod
- no hidden chart bootstrapping
- no chart-based market-data fallback
- only SymbolInfoTick and CopyTicks are live data paths

4. Cache-only builders
JSON builders must not call:
- SymbolInfo
- SymbolInfoSessionQuote
- SymbolInfoSessionTrade
- CopyTicks
- AccountInfo
- OrderCalcProfit
- OrderCalcMargin

Builders only serialize cached and already-derived state.

5. Determinism
- fixed symbol order
- fixed key order
- fixed float precision
- no randomness
- no nondeterministic file naming beyond deterministic minute and sequence semantics

6. IO never blocks engine progress
- warn only
- degrade safely
- retry later
- hydration and state refresh continue

7. Bounded work only
- bounded per-symbol progression
- bounded per-engine budget
- no deep loops over historical bars inside publish
- no unbounded retained history
- no unbounded disk continuity growth

8. Performance visibility required
EA1 must surface timing telemetry for:
- step total
- hydration
- build
- write tmp
- commit
- backup
- read
- validate
- parse
- persistence load
- persistence save

9. Firm isolation is mandatory
- no cross-firm contamination
- no shared continuity payloads
- no ambiguous current outputs

10. Human-facing outputs and private continuity remain separate
- stage JSON is canonical downstream handoff
- debug JSON is human diagnostics only
- persistence files are EA-private continuity only

11. Compilation safety
- no stray code at global scope
- after any function, only declarations are allowed
- zero compile errors before integration

12. Runtime identity must be stable and phase-free
The EA may expose:
- product name
- engine version
- schema version
- build channel

It must not expose transitional development phase labels as authoritative runtime identity.

13. Stage must not require a meta wrapper
- canonical stage acceptance depends on top-level stage fields
- internal meta wrappers are not canonical contract
- debug may contain extra metadata
- stage must remain directly consumable

================================================================================
4. LOCKED FOUNDATIONS
================================================================================

The following behavior is retained as final foundation behavior:

- OnTick empty
- OnTimer orchestration
- no-chart rule
- bounded round-robin engines
- observed versus derived separation
- partial symbol readiness
- session fallback for observability where appropriate
- CopyTicks as bounded rolling history path
- SymbolInfoTick as fast snapshot path
- close-only remains data-eligible
- observed zero tick_value does not invalidate the symbol
- snapshot and history path separation
- same-millisecond duplicate append rule
- bounded event ring
- bounded tick ring
- timer re-entry guard
- batched coverage recount
- cheap HUD support
- bounded writer flow
- future downstream contract through stage snapshots

Final-form lock meaning:
- these foundations are retained
- they may be corrected for truth or safety
- they may be renamed for clarity
- they must not be redesigned into a chart-based or trading system

================================================================================
5. FINAL BUILD OBJECTIVES
================================================================================

EA1 must deliver, in final stable form:

- truthful provenance model
- truthful capability model
- truthful spec model
- truthful session model
- truthful snapshot and history path model
- truthful cost model within bounded v1 scope
- truthful health and summary model
- truthful publish-state model
- truthful continuity model
- deterministic stage schema
- deterministic debug schema
- bounded private continuity when enabled
- spec hashing
- per-firm isolation
- current and previous snapshot safety
- rich canonical downstream handoff
- very rich but bounded diagnostics

EA1 must not retain transitional framing such as:
- phase names
- phase-only function names
- historical implementation-era labels
- comments that imply unfinished architecture when the blueprint defines final stable behavior

================================================================================
6. SUBSYSTEM MODEL
================================================================================

Each symbol is represented through explicit dimensions.

identity
- raw_symbol
- norm_symbol
- asset_class
- class_key
- canonical_group
- classification_source
- classification_confidence
- symbol_identity_hash

clock
- generated_at_server
- generated_at_utc
- server_time_authoritative

capabilities
- can_select
- can_snapshot
- can_copyticks
- can_sessions
- can_probe_profit
- can_probe_margin
- can_trade_full
- can_trade_close_only
- has_tick_value_observed
- has_commission_observed

spec_observed
- digits
- point
- contract_size
- tick_size
- tick_value
- volume_min
- volume_max
- volume_step
- trade_mode
- calc_mode
- margin_currency
- profit_currency
- swap_long
- swap_short
- additional directly observed broker spec fields allowed by scope

spec_derived
- tradability_class
- asset_class
- class_key
- canonical_group
- additional derived spec interpretations allowed by scope

spec_state
- spec_marketdata_ready
- volume_ready
- trade_contract_ready
- spec_trading_ready_future
- spec_confidence
- spec_completeness

spec_change
- spec_hash
- spec_change_count
- last_spec_change_time_server
- last_material_change_reason

sessions
- quote_sessions_by_day
- trade_sessions_by_day
- session_source
- session_confidence
- session_fallback
- sessions_truncated
- quote_session_open_now
- trade_session_open_now
- session_anomaly_flags when implemented

tick_snapshot
- last_snapshot_seen_msc
- last_tick_time
- last_tick_time_msc
- bid
- ask
- mid
- spread_points
- tick_valid
- snapshot_path_ok

tick_history
- last_copyticks_seen_msc
- last_copied_msc
- last_meaningful_history_msc
- tick_path_mode
- copyticks_phase
- history_path_ok
- ring_count
- ring_overwrite_count
- history_continuity_score when implemented

tick_metrics
- optional bounded metrics derived from retained continuity only
- never unbounded archival metrics

cost_model
- tick_value_effective
- tick_value_source
- value_per_tick_money
- value_per_tick_source
- value_per_point_money
- value_per_point_source
- spread_points_live
- spread_value_money_1lot
- spread_value_source
- margin_1lot_money_buy
- margin_buy_source
- margin_1lot_money_sell
- margin_sell_source
- commission_value_effective
- commission_source
- commission_confidence
- carry_source
- notional_exposure_estimate_1lot
- exposure_source
- account_currency_conversion_confidence
- spread_complete
- commission_complete
- carry_complete
- margin_complete
- friction_complete
- usable_for_costs
- cost_confidence

state_summary
- summary_state
- data_reason_code
- tradability_reason_code
- publish_reason_code
- tick_silence_expected
- tick_silence_unexpected
- usable_for_observation
- usable_for_sessions
- usable_for_costs
- usable_for_trading_future

health
- health_quote
- health_spec
- health_session
- health_cost
- health_publish
- health_continuity
- health_overall
- operational_health_score
- market_status_open_now
- expected_market_open_now

continuity
- persistence_state
- persistence_loaded
- persistence_fresh
- persistence_stale
- persistence_corrupt
- persistence_incompatible
- resumed_from_persistence
- restarted_clean
- persistence_age_sec
- continuity_origin
- continuity_last_good_server_time

runtime
- timer_tick_count
- slip_count
- cursor positions
- engine budget usage
- engine skip counts

events
- recent_event_ring

================================================================================
7. PROVENANCE MODEL
================================================================================

Use a general provenance enum:

ProvenanceValue
- PV_NONE
- PV_OBSERVED
- PV_PROBED
- PV_DERIVED
- PV_HEURISTIC
- PV_MANUAL
- PV_FALLBACK

Mandatory provenance applies to major effective or inferred fields:
- tick_value_effective
- value_per_tick_money
- value_per_point_money
- spread_value_money_1lot
- margin_1lot_money_buy
- margin_1lot_money_sell
- commission_value_effective
- carry-derived fields
- notional_exposure_estimate_1lot
- session_source
- classification_source

Rules:
- raw observed fields remain raw
- effective fields remain separate from raw observed fields
- provenance explains how an effective field was produced
- observed zero remains observed zero
- derived replacements never overwrite raw observed values
- fallback must be visibly distinct from observed truth

================================================================================
8. REASON CHANNELS
================================================================================

Use parallel reason channels.

data_reason_code
Describes data readiness and path truth, including:
- no tick
- stale snapshot
- stale history
- warmup
- degraded
- cooldown
- market closed
- dormant
- select failed
- spec partial
- cost partial where relevant

tradability_reason_code
Describes trade accessibility truth, including:
- full access
- close only
- disabled
- unknown
- not fully accessible

publish_reason_code
Describes writer and publish truth, including:
- not written yet
- ok
- write failed
- commit failed
- backup failed if surfaced
- publish lock skip if surfaced
- continuity-related restart mode when needed for truthful diagnostics

Rules:
- reason channels remain separate
- summary_state may compress for humans
- machine consumers should use explicit channels
- reason code vocabulary must remain controlled and stable

================================================================================
9. SUBSYSTEM STATES
================================================================================

Subsystem states remain separate:
- spec_state
- session_state
- tick_state
- cost_state
- trade_state
- publish_state
- persistence_state

Human-facing summary state remains:
- summary_state

Rules:
- subsystem states carry machine truth
- summary_state is presentation-oriented
- continuity state describes continuity truth without rewriting live market truth
- subsystem state truth must remain deterministic and bounded

================================================================================
10. SPEC MODEL
================================================================================

spec_marketdata_ready requires:
- digits valid
- point greater than zero
- trade_mode readable or calc_mode readable

volume_ready requires:
- volume_min valid where applicable
- volume_max valid where applicable
- volume_step valid where applicable

trade_contract_ready requires:
- contract_size greater than zero

spec_trading_ready_future requires:
- spec_marketdata_ready
- trade_contract_ready
- volume model sufficiently known
- trade mode interpretable for future execution use

Rules:
- volume is not required for pure observability
- contract size is not required for snapshot or history observability
- cost logic may require stricter inputs than market-data readiness
- spec hash changes may invalidate dependent derived truth and continuity assumptions
- observed spec truth remains primary
- if a broker field is observed within scope, it should be preserved and published
- derived spec quality does not replace raw observed fields

================================================================================
11. CLASSIFICATION MODEL
================================================================================

Keep:
- raw_symbol
- norm_symbol

Derived identity fields:
- class_key
- canonical_group
- classification_source
- classification_confidence

Classification order:
1. manual override
2. known alias family
3. symbol token patterns
4. exchange or sector cues
5. calc mode
6. contract or tick shape
7. fallback custom

Rules:
- classification is re-runnable
- classification may improve as spec quality improves
- classification must not hard-lock too early
- classification source and confidence must be published
- continuity must not blindly survive materially incompatible classification-related spec changes

================================================================================
12. SESSION MODEL
================================================================================

Internal session storage is full-week and day-grouped:
- quote_sessions_by_day[7][]
- trade_sessions_by_day[7][]

Session source values:
- PV_OBSERVED
- PV_FALLBACK
- PV_NONE

Required support:
- multiple windows per day
- crossing-midnight windows
- truncation detection
- anomaly flags when implemented

Fallback policy:
- FX and crypto: fallback allowed with moderate confidence
- metals and indices: fallback allowed with lower confidence
- stocks and similar classes: fallback only with visibly reduced confidence and caution

Rules:
- never fabricate observed sessions
- session interpretation always uses broker server time
- UTC remains diagnostic only
- absent sessions do not automatically make a symbol unusable if live data truth exists
- session fallback remains visibly distinct from observed sessions
- continuity must not overwrite current session truth

================================================================================
13. SNAPSHOT AND HISTORY MODEL
================================================================================

Tick truth remains explicitly split into:
- snapshot_path_ok
- history_path_ok

tick_path_mode values:
- NONE
- SNAPSHOT_ONLY
- COPYTICKS_ONLY
- BOTH

Use:
- SymbolInfoTick for latest snapshot and liveness path
- CopyTicks for bounded rolling continuity path

Critical rule:
Path OK means currently trustworthy, not historically once-seen.

Snapshot path rules:

snapshot_path_ok becomes false when:
- last_snapshot_seen_msc exceeds snapshot_stale_threshold
- SymbolInfoTick repeatedly fails beyond tolerance
- market_open_now is true and snapshot freshness expires
- restart occurs and no fresh snapshot has been observed yet

Rules:
- snapshot_path_ok must never remain permanently true from historical data
- snapshot freshness must be evaluated using broker server time
- stale snapshot must downgrade tick_path_mode explicitly
- stale snapshot must update data_reason_code
- stale snapshot must be visible in stage, debug, and state_summary

History path rules:

history_path_ok becomes false when:
- last_meaningful_history_msc exceeds history_stale_threshold
- CopyTicks fails repeatedly beyond tolerance
- copyticks_phase enters FAILING or COOLDOWN
- ring_count becomes zero after pruning
- restart occurs and no fresh history has been acquired

Rules:
- history_path_ok must never remain true solely because history once existed
- history freshness must be evaluated using broker server time
- stale history must downgrade tick_path_mode explicitly
- stale history must update data_reason_code
- stale history must be visible in stage, debug, and state_summary

General rule:
- snapshot and history remain independent truths
- one path must not silently overwrite the other
- summary readiness may depend on either or both
- persistence must not falsify current tick_path_mode
- stale path truth must downgrade explicitly, not silently linger

================================================================================
14. COPYTICKS LIFECYCLE MODEL
================================================================================

Use explicit CopyTicks phases:
- CT_NOT_STARTED
- CT_FIRST_SYNC
- CT_WARM
- CT_STEADY
- CT_DEGRADED
- CT_FAILING
- CT_COOLDOWN

Interpretation:
- CT_NOT_STARTED = no history acquisition yet
- CT_FIRST_SYNC = first acquisition attempt underway
- CT_WARM = usable but not yet strong
- CT_STEADY = normal bounded history acquisition
- CT_DEGRADED = weakened but not fully failed
- CT_FAILING = repeated failures before cooldown
- CT_COOLDOWN = temporary suppression after repeated failure

Rules:
- continuity may seed bounded restart hints only when fresh and valid
- continuity must not bypass truthful CopyTicks interpretation
- stale or discarded continuity must not pretend steady history strength
- partial data must still become useful as soon as validly possible
- cooldown is explicit and observable

================================================================================
15. SAME-MILLISECOND DUPLICATE RULE
================================================================================

Append a same-millisecond tick only if at least one changed:
- bid
- ask
- last
- volume_real
- flags

Reject only if all are identical:
- same time_msc
- same bid
- same ask
- same last
- same volume_real
- same flags

This rule remains exact.

================================================================================
16. CAPABILITY MODEL
================================================================================

Explicit capability flags:
- can_select
- can_snapshot
- can_copyticks
- can_sessions
- can_probe_profit
- can_probe_margin
- can_trade_full
- can_trade_close_only
- has_tick_value_observed
- has_commission_observed

Rules:
- capability flags describe current runtime capability only
- capability flags must reflect actual engine behavior

Alignment requirements:
- can_probe_margin must be true only if margin probing logic is active
- can_probe_profit must be true only if OrderCalcProfit probing is used
- can_copyticks must be false when CopyTicks consistently fails
- can_snapshot must be false when SymbolInfoTick consistently fails

Forbidden:
- capability flags contradicting actual engine actions
- capability flags remaining permanently true after repeated runtime failure

Capability flags must update dynamically when runtime conditions change.

================================================================================
17. COST MODEL
================================================================================

EA1 cost engine is intentionally bounded and truthful.

Compute in v1:
- tick_value_effective
- tick_value_source
- value_per_tick_money
- value_per_tick_source
- value_per_point_money
- value_per_point_source
- spread_points_live
- spread_value_money_1lot
- spread_value_source
- margin_1lot_money_buy
- margin_buy_source
- margin_1lot_money_sell
- margin_sell_source
- commission_value_effective where broker truth supports it
- commission_source
- commission_confidence
- carry_source
- notional_exposure_estimate_1lot
- exposure_source
- account_currency_conversion_confidence
- spread_complete
- commission_complete
- carry_complete
- margin_complete
- friction_complete
- usable_for_costs
- cost_confidence
- health_cost support fields

Rules:
- do not fabricate cost truth
- do not convert unknown into zero
- spread may be complete while commission remains incomplete
- margin completeness may remain false where probing is absent, unsupported, or disabled
- unknown commission stays unknown or null
- observed zero tick value stays observed zero
- effective replacement, if any, remains separate and tagged

friction_complete rule:
friction_complete may only be true when all required components are materially computable.

If a component such as commission or margin is intentionally unsupported in v1:
- friction_complete must remain false
- debug must state which component blocks completion
- stage must not imply full friction completeness

cost truth must respect freshness of supporting market data.
continuity must not mark cost components complete unless supporting inputs remain valid.

Deferred:
- deep commission normalization across all broker models
- deep currency conversion chains
- advanced carry projections
- heavy low-trust inference systems

================================================================================
18. EXPOSURE MODEL
================================================================================

Use:
- notional_exposure_estimate_1lot

Also publish:
- exposure_source
- account_currency_conversion_confidence

Rules:
- do not imply perfect economic exposure where broker truth is limited
- exposure remains estimate unless broker truth clearly supports stronger interpretation
- source and confidence remain explicit

================================================================================
19. HEALTH MODEL
================================================================================

Component healths:
- health_quote
- health_spec
- health_session
- health_cost
- health_publish
- health_continuity
- health_overall

Supporting truth:
- operational_health_score
- market_status_open_now
- expected_market_open_now
- tick_silence_expected
- tick_silence_unexpected

Rules:
- market closed and expected closed is not degraded by itself
- open-but-silent may be degraded
- thin but truthful symbols are not punished merely for being thin
- continuity health is separate from quote and history health
- stale or discarded continuity must not inflate health
- health scores are presentation aids
- explicit booleans, states, and reasons remain primary truth

Summary labels:
- GOOD
- PARTIAL
- DEGRADED
- WARMUP
- UNUSABLE

================================================================================
20. EVENT RING
================================================================================

EA1 keeps a small bounded recent event ring.

Examples:
- selected_ok
- select_failed
- spec_ready
- spec_refresh_ok
- spec_refresh_fail
- session_loaded
- session_fallback
- snapshot_ok
- snapshot_fail
- copyticks_sync_start
- copyticks_fail
- cooldown_enter
- publish_stage_ok
- publish_stage_fail
- publish_debug_ok
- publish_debug_fail
- commit_ok
- commit_fail
- backup_ok
- backup_fail
- temp_cleanup_ok
- temp_cleanup_fail
- spec_changed
- persistence_loaded
- persistence_saved
- persistence_missing
- persistence_discarded_stale
- persistence_discarded_corrupt
- persistence_discarded_incompatible
- persistence_resume_ok
- clean_restart_started

Rules:
- keep it bounded
- keep it deterministic
- publish recent events in debug only
- event ring is not a full logging system
- major success and failure transitions should be visible in debug
- persistence and restart truth events are mandatory

================================================================================
21. SCHEDULER MODEL
================================================================================

Heartbeat:
- EventSetTimer(1)

Core principles:
- one bounded cycle per timer event
- re-entry guard required
- round-robin cursors per engine
- no per-second deep full-universe recomputation
- coverage recount may be batched
- stage publish runs on minute cadence
- debug cadence may be independent but bounded
- persistence load and save work must be bounded
- debug generation must remain bounded

Required scheduler observability in debug:
- timer_tick_count
- slip_count
- last_timer_sec
- timer slip visibility
- cursor positions
- budget usage
- skip counts
- per-engine work counts
- performance pressure signals

================================================================================
22. TIMER SAFETY POLICY
================================================================================

Any addition to final EA1 must satisfy:
- no unbounded full-universe recalculation each second
- cost engine remains budgeted
- continuity save work remains budgeted
- continuity load work remains bounded on init and restart
- publisher output must not become the dominant timer blocker
- HUD remains cheap
- debug generation remains bounded
- continuity bookkeeping remains bounded
- retained data must remain under configured caps

================================================================================
23. FIRM ID, PATHS, AND ISOLATION POLICY
================================================================================

EA1 resolves one deterministic firm_id.

firm_id formation:
- sanitize AccountInfoString company
- optionally append sanitized suffix input
- final value is deterministic and stable for that instance

Sanitization rules:
- replace illegal path characters
- trim trailing dots, spaces, and underscores
- empty result becomes UNKNOWN_FIRM

EA1 canonical base folder:
- FILE_COMMON\FIRMS\

Canonical EA1 current outputs live directly under this folder.

Per-firm support folders live under:
- FILE_COMMON\FIRMS\<firm_id>\

Inside that base folder:
- outputs\
- persistence\
- persistence\ea1\
- tmp\
- tmp\ea1\
- locks\

Rules:
- canonical current files live directly under FILE_COMMON\FIRMS\
- this root-current placement is locked and must not be changed
- historical support files live under outputs\
- EA1 private continuity lives under persistence\ea1\
- EA1 temp files live under tmp\ea1\
- locks live under locks\
- no continuity file may be shared across firms
- no human-facing file may be mixed with private continuity files

================================================================================
24. HUMAN-FACING FILE NAMING POLICY
================================================================================

Canonical EA1 current files live directly under:
- FILE_COMMON\FIRMS\

Canonical current files:
- <firm_id>_symbols_universe.json
- <firm_id>_debug_ea1.json

Supporting human-facing files live under:
- FILE_COMMON\FIRMS\<firm_id>\outputs\

Supporting files:
- <firm_id>_symbols_universe_prev.json
- <firm_id>_symbols_universe_backup.json
- <firm_id>_debug_ea1_prev.json
- <firm_id>_debug_ea1_backup.json

Rules:
- current files are the canonical readable snapshots
- these two current files must remain directly under FIRMS exactly as specified
- prev files are mandatory safe fallback snapshots
- backup files are optional best-effort protection
- temp files are never canonical readable inputs
- downstream consumers must never read tmp files
- downstream consumers should read current first and fallback to prev if invalid

================================================================================
25. PRIVATE CONTINUITY FORMAT AND NAMING POLICY
================================================================================

EA1 private continuity lives under:
- persistence\ea1\

Authoritative v1 decision:
- JSON persistence is preferred over binary persistence for EA1 stabilization
- readability and debuggability outrank compactness during stabilization
- one symbol equals one private continuity file
- no monolithic full-universe continuity blob in v1

Recommended filename model:
- <symbol_identity_hash>.json
- <symbol_identity_hash>.bak

Optional readable variant:
- <symbol_identity_hash>_<sanitized_norm_symbol>.json

Rules:
- hash-first naming preferred
- raw symbol remains inside the persistence payload
- continuity files are EA1-private
- continuity files are not canonical inter-EA handoff
- continuity must remain bounded
- continuity should persist only bounded restart-useful state
- if later optimization proves necessary, binary may replace JSON in a later version, but JSON is the v1 stabilization format

================================================================================
26. PUBLISH MODEL
================================================================================

Canonical downstream handoff unit:
- one coherent EA1 stage snapshot per minute

Stage publish cadence:
- at most once per minute

Debug publish cadence:
- independent and bounded

minute_id:
- derived from broker server time

Required stage top-level fields:
- producer
- stage
- minute_id
- universe_fingerprint
- universe
- sector_counts
- coverage
- symbols

Required debug top-level fields:
- producer
- stage
- minute_id
- timing
- schedules
- paths
- io_last
- io_counters
- perf
- publish
- coverage
- continuity
- recent_events
- engine_counts
- failure_counts
- success_counts
- worst_symbols
- diagnostic_samples

Rules:
- deterministic key ordering
- stable JSON ordering
- builders are cache-only
- stage is canonical downstream handoff
- debug is diagnostics only
- stage and debug may publish independently
- stage should remain rich within EA1 scope
- debug should remain extremely rich but bounded

================================================================================
27. CURRENT, PREVIOUS, BACKUP SNAPSHOT POLICY
================================================================================

Each human-facing EA1 JSON class supports:
- current
- previous
- optional backup

Writer flow:
1. build payload
2. write temp file under tmp\ea1\
3. validate minimal guard
4. preserve current to previous best effort
5. commit atomically to current under FILE_COMMON\FIRMS\
6. create backup best effort under FILE_COMMON\FIRMS\<firm_id>\outputs\
7. record durations and outcome in debug

Reader expectation for downstream EAs:
1. try current
2. if current invalid, incomplete, missing, or incoherent, try previous
3. if previous valid, use previous and mark fallback state
4. if neither valid, use last_good in memory if available

Rules:
- no consumer reads tmp
- previous snapshot exists to reduce partial-read hazards
- backup is extra protection, not primary fallback
- current and previous semantics must remain deterministic

Atomic commit rule:
- stage and debug files must be written using a temp file under tmp\ea1\
- the temp file must be moved or renamed atomically into the canonical location
- canonical files must never be written directly
- readers must never observe partially written canonical files

================================================================================
28. INTER-EA COMMUNICATION POLICY
================================================================================

EA1 aligns with PIE as follows:

Canonical handoff policy:
- downstream EAs consume EA1 stage snapshots
- downstream EAs do not consume EA1 private continuity files
- current and previous stage snapshots provide coherent minute-safe handoff
- one stage snapshot is the canonical inter-EA contract unit

Minimal canonical stage contract required by PIE:
- producer
- stage
- minute_id
- universe_fingerprint
- symbols

Required per-symbol join field:
- raw_symbol

Rules:
- EA1 must preserve raw_symbol on every symbol intended for merge
- extra payload is allowed
- unknown extra keys must not break downstream readers
- debug is never a pipeline dependency
- private continuity is never the canonical merge input

================================================================================
29. EA1 CANONICAL ROLE IN THE PIPELINE
================================================================================

EA1 is the authoritative source of:
- universe membership
- universe ordering
- raw_symbol join keys
- normalized symbol identity
- sector and group classification
- spec truth
- session truth
- market status truth
- snapshot path truth
- CopyTicks path truth
- cost truth within bounded scope
- health truth within bounded scope

EA1 stage output is the pipeline anchor.
EA2, EA3, and EA4 depend on EA1 stage coherence, not on EA1 debug and not on EA1 continuity files.

================================================================================
30. EA1 STAGE CONTENT POLICY
================================================================================

EA1 stage is canonical, rich, bounded, deterministic, and truth-preserving.
It should include all marketcore data that is truthful, stable, and useful to downstream EAs within EA1 scope.

Top-level key order:
- producer
- stage
- minute_id
- universe_fingerprint
- universe
- sector_counts
- coverage
- symbols

Required top-level values:
- producer = "EA1"
- stage = "symbols_universe"

universe key order:
- first_index
- last_index
- symbol_count

sector_counts key order:
- "0" through "10"

coverage key order:
- ready_tick_count
- ready_spec_count
- spec_sanity_ok_count
- market_open_count
- market_closed_count
- expired_or_disabled_count
- dead_quote_count
- cooled_down_count
- missing_tick_count
- missing_spec_count

symbols ordered by raw_symbol ascending

Per-symbol required structure:
- raw_symbol
- norm_symbol
- sector_id
- identity
- spec
- sessions
- market_status
- market
- tick_history
- cost
- capabilities
- continuity
- state_summary
- health

identity key order:
- raw_symbol
- norm_symbol
- asset_class
- class_key
- canonical_group
- classification_source
- classification_confidence
- symbol_identity_hash

spec key order:
- digits
- point
- tick_size
- contract_size
- vol_min
- vol_max
- vol_step
- trade_mode
- calc_mode
- margin_mode when available
- profit_currency
- margin_currency
- spec_quality
- spec_sanity_ok
- spec_marketdata_ready
- trade_contract_ready
- spec_hash
- spec_change_count
- last_spec_change_time_server
- last_material_change_reason
- stops_level when available
- freeze_level when available
- exec_mode when available
- filling_mode when available
- expiration_mode when available
- order_mode when available
- swap_mode when available
- swap_long
- swap_short
- swap_triple_day when available
- commission_mode when available
- commission_value when available
- commission_per_lot_money when available
- commission_supported when available
- classification_source

sessions key order:
- session_source
- session_confidence
- session_fallback
- sessions_truncated
- quote_session_open_now
- trade_session_open_now
- quote_sessions_today
- trade_sessions_today
- quote_sessions_week_total
- trade_sessions_week_total

market_status key order:
- quote_session_open
- trade_session_open
- market_open_now
- reason_code
- last_tick_time
- hydration_attempts
- cooled_down_until

market key order:
- bid
- ask
- mid
- spread_points
- spread_ticks when available
- tick_age_sec

tick_history key order:
- last_snapshot_seen_msc
- last_tick_time
- last_tick_time_msc
- last_copyticks_seen_msc
- last_copied_msc
- last_meaningful_history_msc
- snapshot_path_ok
- history_path_ok
- tick_path_mode
- copyticks_phase
- ring_count
- ring_overwrite_count

cost key order:
- tick_value_effective
- tick_value_source
- value_per_tick_money
- value_per_tick_source
- value_per_point_money
- value_per_point_source
- spread_points_live
- spread_value_money_1lot
- spread_value_source
- margin_1lot_money_buy
- margin_buy_source
- margin_1lot_money_sell
- margin_sell_source
- commission_value_effective
- commission_source
- carry_long_1lot
- carry_short_1lot
- carry_source
- exposure_1lot_money
- exposure_source
- spread_complete
- commission_complete
- carry_complete
- margin_complete
- friction_complete
- usable_for_costs
- cost_confidence

capabilities key order:
- can_select
- can_snapshot
- can_copyticks
- can_sessions
- can_probe_profit
- can_probe_margin
- can_trade_full
- can_trade_close_only
- has_tick_value_observed
- has_commission_observed

continuity key order:
- persistence_state
- persistence_loaded
- persistence_fresh
- persistence_stale
- persistence_corrupt
- persistence_incompatible
- resumed_from_persistence
- restarted_clean
- persistence_age_sec
- continuity_origin
- continuity_last_good_server_time

state_summary key order:
- summary_state
- data_reason_code
- tradability_reason_code
- publish_reason_code
- tick_silence_expected
- tick_silence_unexpected
- usable_for_observation
- usable_for_sessions
- usable_for_costs
- usable_for_trading_future

health key order:
- health_quote
- health_spec
- health_session
- health_cost
- health_publish
- health_continuity
- health_overall
- operational_health_score
- market_status_open_now
- expected_market_open_now

Rules:
- stage must include all symbols intended for downstream merge
- every symbol in the current canonical universe must be emitted every publish cycle
- EA1 must not silently omit market state
- if market_open_now is true and live tick is unavailable, reason_code must say why
- closed, disabled, expired, no quote, warmup, degraded, and cooldown states must be explicit
- missing truth must remain explicit, not silently collapsed
- unknown values must remain null or explicit unknown
- observed values must be published whenever they were successfully retrieved
- stage has no required meta wrapper

================================================================================
31. DEBUG CONTENT POLICY
================================================================================

EA1 debug is intentionally super rich during stabilization.

EA1 debug file:
- FILE_COMMON\FIRMS\<firm_id>_debug_ea1.json

Top-level key order:
- producer
- stage
- minute_id
- timing
- schedules
- paths
- io_last
- io_counters
- perf
- publish
- coverage
- continuity
- recent_events
- worst_symbols
- engine_counts
- failure_counts
- success_counts
- symbol_failures
- symbol_successes
- subsystem_status
- scheduler_pressure
- persistence_diagnostics
- publish_diagnostics
- stage_guard_diagnostics
- temp_cleanup_diagnostics
- diagnostic_samples
- legends

Required top-level values:
- producer = "EA1"
- stage = "debug"

Debug must expose:
- timings
- counters
- cursor positions
- budget usage
- skip counts
- recent events
- publisher diagnostics
- subsystem outcomes
- timer slip
- persistence load outcomes
- persistence save outcomes
- stale discard outcomes
- restart mode truth
- worst-symbol diagnostics
- resource pressure
- resolved firm and path truth
- every tracked success and failure counter
- per-engine fail and recover visibility
- stage and debug writer success and failure visibility
- temp cleanup success and failure visibility
- continuity create, load, save, reject, and skip visibility
- symbol-level diagnostic samples for the worst bounded subset

Debug must answer:
- did EA1 resume or start clean
- was continuity loaded, discarded stale, discarded corrupt, or discarded incompatible
- is a symbol warmup, partial, degraded, or unusable
- which engine is lagging
- whether budgets are being respected
- whether publish state is healthy
- why a symbol is not yet cost-ready or history-strong
- why a stage file did or did not publish
- why a continuity file did or did not save
- whether a symbol file path was resolved correctly
- whether stage guard validation passed
- whether a tmp cleanup ran and what happened

Rules:
- debug remains bounded
- debug remains deterministic
- debug is not canonical downstream data contract
- debug changes must not break downstream merge behavior
- debug may be reduced later once EA1 is proven perfect

================================================================================
32. PRIVATE CONTINUITY POLICY
================================================================================

EA1 private continuity is a bounded restart-continuity subsystem.

Continuity goals:
- preserve useful near-term restart continuity
- reduce unnecessary first-sync shock
- support resumed bounded rolling state when still valid
- remain truthful about freshness and compatibility
- remain bounded in storage and load behavior
- remain isolated per firm and per symbol

Granularity:
- one private JSON file per symbol
- no giant monolithic continuity blob in v1

Persist only bounded continuity state actually needed for EA1 restart usefulness, such as:
- persistence schema version
- engine version
- stage schema version where required
- universe fingerprint
- raw_symbol
- symbol_identity_hash
- spec_hash
- last_copied_msc
- last_snapshot_msc
- summary_state
- data_reason_code
- tradability_reason_code
- bounded continuity fields required for sane restart

Do not persist:
- unbounded raw tick history
- giant raw archives
- oversized diagnostics
- heavy recomputable derived state with no continuity payoff
- giant full-universe blobs

Rules:
- continuity is EA1-private
- continuity is not downstream handoff
- continuity exists for bounded restart continuity only
- continuity must not redesign runtime architecture
- during stabilization, readable JSON continuity is preferred because truth and debuggability outrank compactness

================================================================================
33. CONTINUITY STALE POLICY
================================================================================

Continuity older than approximately 2 hours is stale for EA1 short-horizon restart continuity.

Rules:
- stale continuity must not be trusted as live continuity
- stale continuity must be discarded or restarted cleanly
- stale continuity must not falsely claim rolling strength
- stale age is evaluated using broker server time
- stale discard truth must be visible in debug and continuity state

================================================================================
34. CONTINUITY INTEGRITY AND COMPATIBILITY
================================================================================

A persisted symbol block is resumable only if:
- persistence schema version is supported
- engine version compatibility rules pass
- symbol identity matches
- firm isolation is preserved
- file integrity checks pass
- freshness threshold passes
- required spec-hash compatibility rules pass

Rejection reasons include:
- missing
- stale
- corrupt
- incompatible schema
- identity mismatch
- incompatible spec hash
- unreadable file

Rules:
- corrupt files are rejected cleanly
- incompatible files are rejected cleanly
- rejected files must not poison current runtime state
- clean restart after rejection must be explicit in continuity and debug truth

================================================================================
35. RESTART BEHAVIOR
================================================================================

On startup:
1. attempt bounded continuity load
2. validate per-symbol persistence
3. resume only when continuity is fresh, compatible, and valid
4. discard stale, corrupt, or incompatible continuity cleanly
5. continue with clean restart where continuity cannot be trusted
6. avoid catastrophic first-sync bursts where possible using bounded resumed hints
7. never pretend continuity that does not exist

Required continuity truth fields:
- persistence_loaded
- persistence_fresh
- persistence_stale
- persistence_corrupt
- persistence_incompatible
- resumed_from_persistence
- restarted_clean
- continuity_origin
- continuity_last_good_server_time
- persistence_age_sec

================================================================================
36. SPEC HASHING POLICY
================================================================================

EA1 tracks:
- spec_hash
- spec_change_count
- last_spec_change_time_server
- last_material_change_reason

Use spec hashing to:
- detect broker-side spec changes
- trigger dependent recompute for cost and related derived interpretations
- validate continuity compatibility at restart
- avoid unnecessary recompute when spec remains stable

Rules:
- spec hashing is additive
- spec hash changes may invalidate some continuity assumptions
- spec hash does not replace raw observed spec fields

================================================================================
37. QUIRK LAYER POLICY
================================================================================

EA1 may use a narrow table-driven quirk layer.

Allowed override types:
- classify_alias
- force_session_fallback
- ignore_zero_tick_value_for_class
- manual_commission_default
- disable_margin_probe

Rules:
- quirks may improve interpretation
- quirks must never overwrite raw observed truth
- quirks remain narrow, explicit, and auditable
- no sprawling broker maze in v1

================================================================================
38. STALE AND FRESHNESS POLICY
================================================================================

EA1 uses limited understandable freshness logic:
- class-based stale thresholds where needed
- expected silence logic
- open-now versus closed-now context
- short-horizon continuity freshness window

Rules:
- stale logic must remain understandable
- stale logic must not over-punish thin but truthful symbols
- stale logic must not hide open-but-silent problems
- stale snapshot and stale history must downgrade path truth explicitly
- readiness must always reflect current trust, not merely historical once-seen data

================================================================================
39. RING CAPACITY POLICY
================================================================================

EA1 uses bounded ring capacity.

Asset-class tuning is allowed if needed:
- FX majors, gold, crypto: larger
- indices: medium
- slower CFDs and stocks: smaller

Rules:
- no adaptive runtime resizing in v1
- no disk spool fallback
- retained continuity remains bounded
- retained structures exist only to support actual EA1 calculations

================================================================================
40. BOUNDED RETENTION POLICY
================================================================================

Retention applies to both memory and continuity.

Rules:
- retained rolling data supports only current bounded metrics and restart continuity
- older data beyond cap is pruned
- no unlimited growth over time
- memory usage remains predictable
- continuity growth remains bounded by design
- no giant raw spool develops silently

================================================================================
41. PARTIAL-DATA OPERATIONAL POLICY
================================================================================

EA1 may calculate immediately from valid partial state.

Rules:
- EA1 does not wait for perfect completeness before calculating
- partial state remains explicitly partial in stage and debug
- warmup, partial, resumed, degraded, and unusable states remain distinguishable
- stability and truth outrank cosmetic completeness

================================================================================
42. REJECTED FOR V1
================================================================================

Reject for v1:
- chart hydration
- hidden chart bootstrapping
- giant disk spooling of raw tick history
- unbounded retention
- full restart restoration of every analytic structure
- continuously adaptive ring resizing
- advanced adaptive stale auto-modeling
- overcomplicated broker-profile inference
- heavy fake-test harnesses inside the EA
- giant continuity payloads
- too many interdependent health formulas
- struct-of-arrays rewrite before real proof
- deep cost inference systems that reduce trust
- private continuity as canonical downstream contract
- multi-EA scope expansion inside EA1

Reason:
These add complexity before the first stable truthful market observability core is complete.

================================================================================
43. POSTPONED
================================================================================

Postpone to later versions:
- execution-layer activation
- persistent spread tail archives beyond bounded continuity
- full-week session export in stage if too bulky
- advanced anomaly statistics per field
- advanced adaptive stale using observed median gaps
- broker-wide capability probing beyond essentials
- universe sharding modes
- cold and hot memory layout split
- read-only API facade for future consumers
- large synthetic replay harness
- advanced cost analytics beyond essential friction truth
- binary continuity optimization if JSON continuity later proves too heavy

Do not postpone:
- bounded per-firm per-symbol continuity
- stale discard truthfulness
- restart truthfulness
- rich debug usefulness
- partial-data immediate calculation behavior
- current plus previous snapshot safety model
- explicit stale path decay
- explicit capability and probe alignment

================================================================================
44. ACCEPTANCE CRITERIA
================================================================================

TRUTH TEST A
commission unknown
- output must say unknown or null
- never imply zero unless materially true

TRUTH TEST B
tick value zero observed
- raw field preserves observed zero
- any effective replacement remains separate and tagged

TRUTH TEST C
sessions absent but ticks live
- symbol remains observation-eligible where appropriate
- session source says fallback or none
- confidence reduced appropriately

TRUTH TEST D
close-only with good tick flow
- observation eligible yes
- future trading usable no

TRUTH TEST E
snapshot good, history weak
- tick_path_mode reflects partial truth
- history truth is not overstated

TRUTH TEST F
thin symbol
- stale logic does not punish it too aggressively by default

TRUTH TEST G
cost inputs incomplete
- spread may be complete while commission and margin remain incomplete
- friction completeness reflects real component truth

TRUTH TEST H
derived money fields
- every effective money-like field exposes provenance
- unknown inputs lead to unknown outputs, not fabricated certainty

TRUTH TEST I
partial data immediate usefulness
- EA1 begins calculations immediately from valid available data
- it does not wait for perfect completeness
- partial state remains explicitly visible

TRUTH TEST J
fresh continuity resume
- valid fresh continuity resumes bounded state
- continuity state marks resume truthfully
- no false claim of stronger completeness than resumed data supports

TRUTH TEST K
stale continuity discard
- continuity older than about 2 hours is stale
- stale continuity is discarded or restarted cleanly
- no false continuity is claimed after discard

TRUTH TEST L
corrupt continuity recovery
- corrupt per-symbol continuity is rejected cleanly
- current runtime state is not poisoned
- debug clearly reports discard reason

TRUTH TEST M
incompatible continuity recovery
- incompatible schema or identity mismatch triggers clean discard
- clean restart is visible
- no false continuity is claimed

TRUTH TEST N
firm separation safety
- continuity data from one firm does not contaminate another
- multiple firms remain isolated

TRUTH TEST O
bounded retention
- old retained data beyond configured cap is pruned
- disk and memory growth remain bounded
- no giant raw spool develops silently

TRUTH TEST P
downstream handoff clarity
- current stage file is coherent when valid
- previous stage file is usable as safe fallback
- tmp files are never consumed
- private continuity files are not required for downstream consumers

TRUTH TEST Q
stale snapshot decay
- snapshot_path_ok becomes false when snapshot freshness expires
- no zombie snapshot readiness remains

TRUTH TEST R
stale history decay
- history_path_ok becomes false when history freshness expires
- no zombie history readiness remains

TRUTH TEST S
capability alignment
- capability flags do not contradict actual probe or engine behavior

TRUTH TEST T
runtime identity consistency
- engine version, schema version, and product identity do not conflict
- no authoritative runtime phase labels remain

TRUTH TEST U
all-symbol emission
- every symbol in the canonical universe is emitted each stage publish
- a symbol is not omitted merely because one subsystem is partial

TRUTH TEST V
retrieval truth
- if a field is observed successfully and is within EA1 scope, it is published
- if retrieval fails, the failure is explicit in state or debug

CLOCK TRUTH TEST
- broker server time and UTC may differ
- session decisions follow broker server time
- continuity aging follows broker server time
- UTC remains diagnostic only

RESOURCE TEST
- 1000 plus symbols
- 1 second timer
- bounded slip rate
- bounded memory
- bounded continuity growth
- no pathological blocking loops

RESTART TEST
- resumed cursors restore sanely where continuity is valid
- no catastrophic first-sync burst
- states do not falsely claim continuity
- stale or corrupt continuity produces clean restart rather than fake resume

DEBUG TEST
- debug materially explains scheduler state
- debug materially explains continuity state
- debug materially explains publish state
- debug materially explains worst-symbol problems
- debug materially explains every major success and failure path
- debug remains useful across firms

PUBLISH TEST
- stage and debug outputs are internally consistent
- deterministic ordering holds
- source tags exist for major derived fields
- no raw observed field is overwritten by effective derived value
- human-facing outputs remain separate from private continuity
- current and previous snapshot behavior is deterministic

PIPELINE TEST
- downstream EAs can consume EA1 stage using PIE minimal contract
- raw_symbol join keys remain stable
- universe_fingerprint remains coherent
- debug changes do not affect downstream consumers

================================================================================
45. FINAL IMPLEMENTATION DIRECTION
================================================================================

EA1 runtime identity should use final stable naming only.

Recommended identity fields:
- EA_NAME
- EA_ENGINE_VERSION
- EA_SCHEMA_VERSION
- EA_BUILD_CHANNEL

Recommended naming direction:
- no phase-prefixed functions
- no phase-era struct names
- no transitional identifiers in authoritative runtime surface

Recommended subsystem naming style:
- InitPersistenceSubsystem
- RunPersistenceLoadBudget
- RunPersistenceSaveBudget
- SymbolOperationalHealth
- SymbolHydrationState
- hydration_reason_code
- engine_version
- schema_version

The code should read like a finished machine, not an excavation site.

================================================================================
46. FINAL CONSOLIDATED JUDGMENT
================================================================================

Adopt strongly:
- provenance and source model
- split subsystem states
- split reason channels
- relaxed spec_marketdata_ready
- day-grouped weekly session storage
- snapshot and history separation
- same-millisecond append rule
- freshness-based path truth
- operational health versus market-open separation
- capability flags
- bounded recent event ring
- broker server time as authoritative clock
- narrow truthful cost engine
- deterministic stage schema
- deterministic debug schema
- bounded per-firm per-symbol continuity
- readable JSON continuity during stabilization
- short-horizon stale discard for continuity truth
- immediate calculation from valid partial data
- very rich debug relevance until EA1 is proven perfect
- current plus previous snapshot safety model
- EA1 stage JSON as canonical downstream handoff
- EA1 private continuity isolation
- output layout with canonical current snapshots directly under FILE_COMMON\FIRMS\
- supporting artifacts under <firm_id>\outputs and persistence\ea1

Adopt with limits:
- broker quirk layer
- asset-class ring capacities
- bounded continuity rather than giant persistence
- limited stale logic
- UTC as diagnostic-only secondary time
- margin and commission completeness only where broker truth supports it

Reject or postpone:
- chart hydration
- giant persistence
- unbounded disk spooling
- adaptive ring resizing
- advanced runtime complexity before stability
- execution logic in MarketCore
- deep low-trust cost inference
- downstream EAs reading EA1 private continuity as main contract
- multi-EA scope expansion inside EA1

This blueprint is the final authoritative version for EA1_MARKETCORE_FINAL.
It defines EA1 as a stable, truthful, bounded, timer-only, no-chart, no-trade, PIE-aligned market observability core with canonical stage output, extremely rich stabilization debug, canonical current files directly under FILE_COMMON\FIRMS\, and private bounded JSON restart continuity.