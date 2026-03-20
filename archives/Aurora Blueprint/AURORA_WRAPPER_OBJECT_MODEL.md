# AURORA WRAPPER OBJECT MODEL

## PURPOSE

This file defines the machine-usable object chain that connects:
- ASC scanner truth
- Aurora doctrine interpretation
- deployability logic
- family and pattern competition
- generated strategy cards
- bounded EA-safe outputs

It exists so Aurora can evolve from doctrine surfaces into a coherent wrapper architecture without turning into a generic chat layer.

---

# 1. ROOT LAW

Aurora should not operate as one giant hidden reasoning blob.

It should operate through explicit objects whose ownership and transformation order are clear.

This object model exists to preserve:
- auditability
- machine usability
- anti-drift boundaries
- bounded later automation

---

# 2. OBJECT CHAIN OVERVIEW

Aurora should transform information in this order:

1. `ASC_CONTEXT_OBJECT`
2. `AURORA_MARKET_STATE_OBJECT`
3. `AURORA_EXECUTION_SURFACE_OBJECT`
4. `AURORA_DEPLOYABILITY_OBJECT`
5. `AURORA_FAMILY_COMPETITION_OBJECT`
6. `AURORA_PATTERN_CANDIDATE_OBJECT`
7. `AURORA_OPPORTUNITY_OBJECT`
8. `AURORA_GENERATED_STRATEGY_CARD`
9. `AURORA_EA_SAFE_OUTPUT_OBJECT`

This order matters.
Aurora must not jump straight from ASC context to an execution plan.

---

# 3. OBJECT DEFINITIONS

## 3.1 `ASC_CONTEXT_OBJECT`
Owned by ASC.

Contains measured world truth such as:
- identity
- asset class
- bucket prior
- market status
- session / schedule truth
- spread / execution truth
- freshness / continuity truth
- publication health

Aurora consumes this object and must not fabricate it.

## 3.2 `AURORA_MARKET_STATE_OBJECT`
Owned by Aurora.

Contains:
- market state label
- state evidence markers
- state competitors considered
- why primary state won

This object expresses structural interpretation only.

## 3.3 `AURORA_EXECUTION_SURFACE_OBJECT`
Owned by Aurora.

Contains:
- execution surface label
- surface trust flags
- visible opportunity vs practical opportunity distinction
- surface weaknesses

This object interprets whether the current environment is friendly or distorted from an execution standpoint.

## 3.4 `AURORA_DEPLOYABILITY_OBJECT`
Owned by Aurora using ASC truth plus structural interpretation.

Contains:
- deployability class
- horizon class
- burden model summary
- path potential summary
- hostility contribution
- missing surfaces
- why not fully eligible

## 3.5 `AURORA_FAMILY_COMPETITION_OBJECT`
Owned by Aurora.

Contains:
- ranked family candidates
- excluded families
- why primary family won
- why competitors lost
- missing surfaces that would change the ranking

## 3.6 `AURORA_PATTERN_CANDIDATE_OBJECT`
Owned by Aurora.

Contains:
- pattern candidate id
- pattern confirmation conditions
- pattern rejection conditions
- pattern dependencies
- pattern quality notes

## 3.7 `AURORA_OPPORTUNITY_OBJECT`
Owned by Aurora.

Contains:
- symbol
- primary family / pattern candidate
- deployability class
- opportunity status
- revisit trigger
- expiry
- why not top-ranked

This object may exist even when no strategy card is emitted.

## 3.8 `AURORA_GENERATED_STRATEGY_CARD`
Owned by Aurora.

Contains:
- lineage refs
- interpretation summary
- geometry block
- timebox block
- machine-safe fields
- human-only fields

This is the first object where explicit geometry is allowed.

## 3.9 `AURORA_EA_SAFE_OUTPUT_OBJECT`
Owned by Aurora only after bounded filtering.

Contains only deterministic, machine-checkable, automatable fields.
It must exclude narrative interpretation and soft overrides.

---

# 4. TRANSFORMATION RULES

## 4.1 Context before interpretation
Aurora must not interpret what ASC has not measured.

## 4.2 State before deployability
Aurora must classify structural state before deciding deployability.

## 4.3 Deployability before geometry
Aurora must know whether a setup is actually usable before generating a trade geometry.

## 4.4 Family competition before pattern commitment
Aurora must preserve family competition truth instead of acting like one family appeared automatically.

## 4.5 Opportunity object before strategy card
A symbol may have a preserved opportunity without having a live strategy card.

## 4.6 Strategy card before EA-safe object
No field may become automatable unless it first exists in the generated strategy-card layer and is explicitly marked machine-safe.

---

# 5. WHY THIS MODEL PREVENTS GENERICITY

Generic wrappers collapse everything into:
- chart read
- signal label
- stop and target guess

This object model prevents that by forcing:
- measured context
- structural interpretation
- execution interpretation
- deployability classification
- family competition
- pattern qualification
- only then generated geometry

That is the correct anti-generic order.

---

# 6. WHY THIS MODEL PREVENTS STARVATION

Because the opportunity object exists before the strategy card, Aurora can preserve:
- observe-only candidates
- degraded but interesting candidates
- revisit triggers

without pretending every preserved opportunity is tradable now.

---

# 7. RELATIONSHIP TO EXISTING FILES

This object model depends on and links together:
- `ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `AURORA_OPPORTUNITY_INVENTORY_AND_RANKING_PROTOCOL.md`
- `AURORA_GENERATED_STRATEGY_CARD_PROTOCOL.md`
- `AURORA_EA_SAFE_OUTPUT_BOUNDARY_SPEC.md`
- `AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`

This file is the chain map that binds them into one wrapper architecture.

---

# 8. CURRENT JUDGMENT

Aurora now has an explicit wrapper object model.

It is no longer only:
- doctrine files
- family files
- pattern files

It now has a machine-usable object chain from ASC truth to bounded future automation.
