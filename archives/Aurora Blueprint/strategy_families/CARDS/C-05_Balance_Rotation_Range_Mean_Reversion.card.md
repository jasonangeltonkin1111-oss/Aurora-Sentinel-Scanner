# CARD ID
C-05

# FAMILY NAME
Balance Rotation / Range Mean-Reversion

# STATUS
BUILD_READY

# CANONICAL THESIS
Participate when a stable balance / range condition supports return-to-value or opposite-boundary rotation more strongly than breakout continuation.

# PRIMARY MARKET HABITAT
- Balance / Range
- Range Extremes
- rotational accepted trade

# PRIMARY STATE / SURFACE DEPENDENCIES
## State dependencies
- Balance State

## Surface dependencies
- Return-to-Value / Responsive Surface often supportive
- Discovery-with-Trust Surface typically suppresses this family

# REQUIRED DATA SURFACES
- S1_CHART_STRUCTURE

# HIGH-VALUE SUPPORTING DATA SURFACES
- S2_ASC_INTERNAL_FEATURES
- S3_LIVE_EXECUTION_MICROSTRUCTURE
- S6_CALENDAR_SESSION_TIMEBOX

# STRUCTURAL ENTRY LOGIC (HIGH LEVEL ONLY)
At a high level, the family becomes plausible when:
- anchor stability is present
- repeated rejection at meaningful boundaries is visible
- rotational behavior remains stronger than sustained directional migration
- breakout acceptance is not taking control

# STRUCTURAL INVALIDATION LOGIC (HIGH LEVEL ONLY)
At a high level, the family weakens or invalidates when:
- balance becomes unstable
- breakout acceptance or directional migration becomes dominant
- overlap is widening into chaos rather than stable rotation
- return-to-value logic is replaced by persistent directional hold

# MAIN FAMILY COMPETITORS
- Breakout / Compression Release
- Failed Break / Trap Reversal
- Trend Continuation
- Trend Pullback / Pullback Continuation

# FAMILY REJECTION CONDITIONS
Reject or suppress the family when:
- breakout acceptance is emerging
- directional authority is becoming stronger than rotational rejection logic
- range stability is materially degrading
- environment is no longer best read as accepted rotation

# FUTURE PATTERN CHILDREN
- range rejection structures
- return-to-value structures
- boundary-fade structures
- internal rotational patterns

# FUTURE TESTING / RESEARCH NEEDS
- range stability diagnostics by environment
- rejection-quality studies at boundaries
- relation between ASC pre-selection and mean-reversion opportunity quality
- effect of live execution conditions near extremes
- session-dependent variation in rotational reliability

# FUTURE ENRICHMENT PATH
Future books and extractions may add:
- better balance-stability diagnostics
- stronger distinction between healthy rotation and unstable overlap
- better rejection taxonomy at extremes
- better integration of live and session data into rotational trust

# LINEAGE
## Parent family file
- `Aurora Blueprint/strategy_families/CORE/Balance_Rotation_Range_Mean_Reversion.md`

## Parent registry file
- `Aurora Blueprint/AURORA_STRATEGY_FAMILY_REGISTRY.md`

## Parent doctrine dependencies
- `Aurora Blueprint/doctrine/WAVE1/AURORA_MARKET_STATE_CANON_WAVE1_CONSOLIDATED.md`
- `Aurora Blueprint/doctrine/WAVE1/AURORA_EXECUTION_CONTEXT_SURFACE_WAVE1_CONSOLIDATED.md`

# CURRENT JUDGMENT
Balance Rotation / Range Mean-Reversion is build-ready because it directly inherits from the current Wave 1 balance doctrine while remaining highly enrichable by future balance/range, execution-context, and session-aware source work.
