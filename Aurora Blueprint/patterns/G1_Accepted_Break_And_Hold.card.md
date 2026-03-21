# PATTERN ID
G1

# PATTERN NAME
Accepted Break And Hold

# STATUS
APPROVED_GROUP

# PARENT FAMILY / FAMILIES
- Trend Continuation
- Breakout / Compression Release

# CANONICAL THESIS
This pattern group captures structures where price breaks beyond a prior reference area and then shows enough persistence or acceptance that continuation remains stronger than immediate rejection or return-to-balance logic.

# PRIMARY MARKET HABITAT
- Directional Discovery
- Trend Expansion
- balance-to-expansion transition that is already holding

# PRIMARY STATE / SURFACE DEPENDENCIES
## State dependencies
- Directional Discovery State
- transition out of Balance when release is already credible

## Surface dependencies
- Discovery-with-Trust Surface preferred
- Structurally Valid but Low-Trust Surface may suppress or downgrade the pattern

# REQUIRED DATA SURFACES
- S1_CHART_STRUCTURE

# HIGH-VALUE SUPPORTING DATA SURFACES
- S2_ASC_INTERNAL_FEATURES
- S3_LIVE_EXECUTION_MICROSTRUCTURE
- S6_CALENDAR_SESSION_TIMEBOX

# STRUCTURAL MEANING
The meaning of this pattern is not “price crossed a line.”
Its meaning is that a local break is becoming structurally accepted rather than instantly denied.

# STRUCTURAL INVALIDATION / FAILURE LOGIC
At a high level, the pattern weakens or fails when:
- the break cannot hold
- acceptance does not develop
- reclaim back through the initiating structure becomes dominant
- trap / failed-break logic overtakes continuation logic

# MAIN MISREADS / COMPETING INTERPRETATIONS
- cheap excursion mistaken for accepted break
- failed break / trap reversal
- unresolved compression still masquerading as release
- late exhausted continuation mistaken for fresh acceptance

# PATTERN REJECTION CONDITIONS
Reject or suppress the pattern when:
- persistence beyond the break is weak
- return-to-structure logic is stronger than hold logic
- the move is dominated by wick-only excursion or unstable overlap

# FUTURE TESTING / RESEARCH NEEDS
- hold quality across environments
- distinction between early hold vs late exhausted hold
- interaction between ASC filtering and break-hold quality
- live spread / liquidity effects on deployability

# FUTURE ENRICHMENT PATH
Future books and extractions may add:
- narrower break-and-hold subtypes
- better acceptance diagnostics
- stronger breakout-quality filters
- session-conditioned variants

# LINEAGE
## Parent atlas file
- `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`

## Parent family dependencies
- `Aurora Blueprint/strategy_families/CORE/Trend_Continuation.md`
- `Aurora Blueprint/strategy_families/CORE/Breakout_Compression_Release.md`

# STAGE FIT
- Most native in `STAGE_CONFIRMED` and early `STAGE_CONTINUATION` conditions
- Can become invalid in `STAGE_LATE` or `STAGE_EXHAUSTED` conditions when hold quality is already degrading

# CURRENT JUDGMENT
Accepted Break And Hold is a valid first approved pattern group because it is one of the clearest pattern children of the current continuation and release families while still being broad enough to deepen later.
