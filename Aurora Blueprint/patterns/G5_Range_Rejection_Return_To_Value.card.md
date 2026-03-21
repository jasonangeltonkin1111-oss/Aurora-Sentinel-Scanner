# PATTERN ID
G5

# PATTERN NAME
Range Rejection / Return To Value

# STATUS
APPROVED_GROUP

# PARENT FAMILY / FAMILIES
- Balance Rotation / Range Mean-Reversion

# CANONICAL THESIS
This pattern group captures local structures where rejection at a meaningful boundary supports return-to-value or opposite-boundary rotation more strongly than breakout continuation.

# PRIMARY MARKET HABITAT
- Balance / Range
- stable accepted rotational trade
- meaningful range extremes

# PRIMARY STATE / SURFACE DEPENDENCIES
## State dependencies
- Balance State

## Surface dependencies
- Return-to-Value / Responsive Surface often supportive
- Discovery-with-Trust Surface typically suppresses the pattern

# REQUIRED DATA SURFACES
- S1_CHART_STRUCTURE

# HIGH-VALUE SUPPORTING DATA SURFACES
- S2_ASC_INTERNAL_FEATURES
- S3_LIVE_EXECUTION_MICROSTRUCTURE
- S6_CALENDAR_SESSION_TIMEBOX

# STRUCTURAL MEANING
The meaning of this pattern is that the market is rejecting excursion away from accepted rotational structure and favoring return-to-value or continued range logic.

# STRUCTURAL INVALIDATION / FAILURE LOGIC
At a high level, the pattern weakens or fails when:
- rejection at the boundary is weak or unstable
- breakout acceptance begins taking control
- range stability degrades materially
- directional migration becomes stronger than rotational return logic

# MAIN MISREADS / COMPETING INTERPRETATIONS
- early breakout acceptance mistaken for rejection
- failed break / reclaim mistaken for pure rotation
- unstable overlap mistaken for stable balance rejection

# PATTERN REJECTION CONDITIONS
Reject or suppress the pattern when:
- balance is unstable
- breakout acceptance is emerging
- rotational logic is no longer dominant over migration
- environment is degrading into chaotic overlap

# FUTURE TESTING / RESEARCH NEEDS
- range-stability diagnostics
- rejection quality at boundaries
- relation between ASC filtering and mean-reversion quality
- effect of live execution conditions near extremes
- session-dependent range behavior

# FUTURE ENRICHMENT PATH
Future books and extractions may add:
- narrower rejection subtypes
- stronger range-quality diagnostics
- better distinction between healthy rotation and unstable overlap
- better integration of live and session data into rejection quality

# LINEAGE
## Parent atlas file
- `Aurora Blueprint/AURORA_SETUP_PATTERN_ATLAS.md`

## Parent family dependencies
- `Aurora Blueprint/strategy_families/CORE/Balance_Rotation_Range_Mean_Reversion.md`

# STAGE FIT
- Most native in `STAGE_CONFIRMED` and `STAGE_MATURE` balance conditions
- Can remain legitimate as a later range-edge re-engagement only while balance integrity still holds

# CURRENT JUDGMENT
Range Rejection / Return To Value is a valid first approved pattern group because it is the clearest foundational child of the balance-rotation family and preserves one of the main mean-reversion pattern classes in the current Aurora stack.
