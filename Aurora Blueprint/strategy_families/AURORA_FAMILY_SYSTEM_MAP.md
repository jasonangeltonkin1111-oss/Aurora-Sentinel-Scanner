# AURORA FAMILY SYSTEM MAP

## PURPOSE

This file is the high-level system map for the Aurora strategy-family layer.

It exists to show how the family layer connects to:
- Wave 1 doctrine
- ASC scanner outputs
- live data
- macro/regime context
- future GPT wrapper logic
- future EA logic

This file is not a family definition file.
It is the architecture map for how families fit into the larger Aurora system.

---

# 1. MAIN LAYER ORDER

Aurora strategy-family use should eventually follow this order:

1. **Market-state read**
2. **Execution-context / surface read**
3. **Family eligibility filter**
4. **Family competition / ranking**
5. **Stage-profile and bucket-fit boundary**
6. **Pattern-level confirmation later**
7. **Execution / wrapper / EA translation later**
8. **Review and adaptation later**

This means families sit in the middle of the system.
They are neither raw chart labels nor raw execution commands.

---

# 2. WHAT FEEDS THE FAMILY LAYER

## Doctrine inputs
- `AURORA_MARKET_STATE_CANON_WAVE1_CONSOLIDATED.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE_WAVE1_CONSOLIDATED.md`
- `AURORA_WAVE1_CROSSLINK_MAP.md`

## Registry / organization inputs
- `AURORA_STRATEGY_FAMILY_REGISTRY.md`
- `strategy_families/STRATEGY_FAMILY_INDEX.md`
- `strategy_families/ALL_FAMILY_MATRIX.md`
- `strategy_families/STRATEGY_DATA_SURFACES.md`

## Future data inputs
- ASC scanner outputs
- live spread / liquidity / microstructure signals
- macro / event / regime state
- cross-asset relative context
- session / calendar state

---

# 3. WHAT THE FAMILY LAYER PRODUCES

The family layer should eventually produce structured outputs like:
- eligible families
- ineligible families
- native family habitat match
- anti-habitat conflict warnings
- family competition set
- recommended downstream pattern groups
- required supporting data surfaces

These outputs are what a future GPT wrapper or EA can consume.

---

# 4. CORE DESIGN RULE

A family is not a trade.
A family is a structured class of opportunity.
It should also be treated as a stage-bearing and bucket-aware class of opportunity rather than an early-entry-only shell.
It should also be treated as a stage-bearing and bucket-aware class of opportunity rather than an early-entry-only shell.

That means the family layer should answer:
- which family class best fits current conditions?
- which family classes should be excluded?
- which extra data surfaces are required before confidence rises?

It should not jump directly to:
- exact order placement
- exact stop distance
- fixed execution recipe

Those belong later.

---

# 5. AURORA SYSTEM INTERACTIONS

## With ASC
ASC can later help with:
- symbol pre-selection
- ranking and filtering
- broker-spec awareness
- internal feature outputs
- narrowing which symbols or contexts deserve family evaluation

## With live data
Live data can later help with:
- deployability refinement
- spread / liquidity realism
- microstructure-aware filtering
- live suppression of otherwise chart-valid families

## With macro/regime context
Macro/regime data can later help with:
- family suppression or weighting
- regime-conditioned family competition
- event-driven caution

## With a GPT wrapper
A wrapper can later use the family layer to:
- route from state/surface into family candidates
- explain why a family fits or does not fit
- request missing supporting surfaces
- produce human-readable decision support

## With an EA
An EA can later use the family layer to:
- map current context to family classes
- run family-specific logic branches
- suppress invalid families
- activate family-specific submodules only when conditions fit

---

# 6. CURRENT JUDGMENT

Aurora now has enough doctrine and strategy organization that the family layer can be treated as a real system layer.

This file exists so future builds do not confuse:
- market state
- family classification
- pattern confirmation
- execution logic

They are related, but they are not the same layer.
