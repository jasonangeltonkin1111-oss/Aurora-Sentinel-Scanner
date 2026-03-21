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

It should operate through explicit objects whose ownership, required fields, state classes, and transformation order are clear.

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

# 3. GLOBAL OBJECT RULES

## 3.1 Required object state classes
Any object field used by downstream logic should preserve one of these conditions when relevant:
- `present`
- `pending`
- `reserved`
- `unavailable`
- `unsupported`
- `stale`
- `degraded`
- `invalid`

Aurora must not hide missingness by replacing these states with empty language that looks normal.

## 3.2 Required metadata fields
Every downstream Aurora-owned object should preserve at least:
- `object_type`
- `object_version`
- `generated_at`
- `lineage_refs`
- `source_inputs`
- `missing_surfaces`

If an object is symbol-specific, it should also preserve:
- `symbol`
- `asset_class`
- `asc_context_ref`

## 3.3 Human-only versus machine-safe rule
Each object that may later feed automation should make it clear which fields are:
- machine-safe now
- human-only now
- blocked until stronger evidence or protocol support exists

---

# 4. OBJECT DEFINITIONS

## 4.1 `ASC_CONTEXT_OBJECT`
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

Required state behavior:
- any missing or degraded field must preserve its real state class
- Aurora consumes this object and must not fabricate it

## 4.2 `AURORA_MARKET_STATE_OBJECT`
Owned by Aurora.

Contains:
- `market_state_label`
- `state_evidence_markers`
- `state_competitors_considered`
- `why_primary_state_won`
- `state_confidence_posture`
- `missing_surfaces`

This object expresses structural interpretation only.
It must not smuggle in execution geometry.

## 4.3 `AURORA_EXECUTION_SURFACE_OBJECT`
Owned by Aurora.

Contains:
- `execution_surface_label`
- `surface_trust_flags`
- `visible_vs_practical_opportunity`
- `surface_weaknesses`
- `friction_summary`
- `continuity_risks`
- `missing_surfaces`

This object interprets whether the current environment is friendly or distorted from an execution standpoint.

## 4.4 `AURORA_DEPLOYABILITY_OBJECT`
Owned by Aurora using ASC truth plus structural interpretation.

Contains:
- `deployability_class`
- `horizon_class`
- `usable_path_potential`
- `execution_burden_class`
- `spread_state_class`
- `execution_continuity_state`
- `hostility_contribution`
- `missing_surfaces`
- `why_not_fully_eligible`

This object must keep structure validity separate from execution validity.

## 4.5 `AURORA_FAMILY_COMPETITION_OBJECT`
Owned by Aurora.

Contains:
- `competition_status`
- `confidence_posture`
- `candidate_families`
- `rejected_families`
- `surviving_families`
- `primary_family_candidate` if any
- `primary_family_reason`
- `ambiguity_notes`
- `what_would_reduce_ambiguity`
- `missing_surfaces_that_would_change_result`

Canonical schema and protocol:
- `AURORA_FAMILY_COMPETITION_OBJECT_SCHEMA.md`
- `AURORA_FAMILY_COMPETITION_ENGINE_PROTOCOL.md`

This object exists so Aurora preserves competition truth instead of pretending one family appeared automatically.

## 4.6 `AURORA_PATTERN_CANDIDATE_OBJECT`
Owned by Aurora.

Contains:
- `pattern_candidate_id`
- `pattern_confirmation_conditions`
- `pattern_rejection_conditions`
- `pattern_dependencies`
- `pattern_quality_notes`
- `pattern_machine_safe_fields` if any
- `missing_surfaces`

Pattern commitment must remain downstream of family competition.

## 4.7 `AURORA_OPPORTUNITY_OBJECT`
Owned by Aurora.

Contains:
- `symbol`
- `primary_family_candidate`
- `pattern_candidate`
- `deployability_class`
- `opportunity_status`
- `revisit_trigger`
- `expiry_at`
- `why_not_top_ranked`
- `missing_surfaces`
- `hostility_objects`

This object may exist even when no strategy card is emitted.
It is the anti-starvation preservation layer.

## 4.8 `AURORA_GENERATED_STRATEGY_CARD`
Owned by Aurora.

Contains:
- identity block
- interpretation summary
- geometry block
- timebox block
- machine-safe fields
- human-only fields
- explicit blockers if no card should be emitted

This is the first object where explicit geometry is allowed.

## 4.9 `AURORA_EA_SAFE_OUTPUT_OBJECT`
Owned by Aurora only after bounded filtering.

Contains only deterministic, machine-checkable, automatable fields.
It must exclude narrative interpretation, soft overrides, and unbounded uncertainty language.

---

# 5. TRANSFORMATION RULES

## 5.1 Context before interpretation
Aurora must not interpret what ASC has not measured.

## 5.2 State before deployability
Aurora must classify structural state before deciding deployability.

## 5.3 Deployability before geometry
Aurora must know whether a setup is actually usable before generating a trade geometry.

## 5.4 Family competition before pattern commitment
Aurora must preserve family competition truth instead of acting like one family appeared automatically.
Family competition may end with a clear primary, contested primary, multiple live families, deferred classification, no valid family, or invalid competition input.
Pattern commitment must remain downstream of that result.

## 5.5 Opportunity object before strategy card
A symbol may have a preserved opportunity without having a live strategy card.

## 5.6 Strategy card before EA-safe object
No field may become automatable unless it first exists in the generated strategy-card layer and is explicitly marked machine-safe.

## 5.7 Missing-surface propagation
If an upstream object marks a required field as stale, degraded, unavailable, unsupported, or invalid, downstream objects must propagate that limitation honestly rather than overwrite it with confident language.

---

# 6. WHY THIS MODEL PREVENTS GENERICITY

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

# 7. WHY THIS MODEL PREVENTS STARVATION

Because the opportunity object exists before the strategy card, Aurora can preserve:
- observe-only candidates
- degraded but interesting candidates
- revisit triggers

without pretending every preserved opportunity is tradable now.

---

# 8. RELATIONSHIP TO EXISTING FILES

This object model depends on and links together:
- `ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `AURORA_OPPORTUNITY_INVENTORY_AND_RANKING_PROTOCOL.md`
- `AURORA_GENERATED_STRATEGY_CARD_PROTOCOL.md`
- `AURORA_EA_SAFE_OUTPUT_BOUNDARY_SPEC.md`
- `AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`
- `Aurora Blueprint/office/AURORA_OFFICE_CANON.md`

This file is the chain map that binds them into one wrapper architecture.

---

# 9. CURRENT JUDGMENT

Aurora now has an explicit wrapper object model with stronger field and state discipline.

It is no longer only:
- doctrine files
- family files
- pattern files

It now has a machine-usable object chain from ASC truth to bounded future automation, with clearer missing-surface handling and clearer machine-safe boundaries.
