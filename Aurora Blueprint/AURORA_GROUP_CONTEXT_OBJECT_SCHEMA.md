# AURORA GROUP CONTEXT OBJECT SCHEMA

## PURPOSE

This file creates the missing group-context object layer for Aurora.

It exists because Aurora is now explicitly routed by:
- asset class
- bucket class
- group / subtype / theme where useful
- regime / state

A symbol is an instance.
But Aurora also needs an object that captures the broader group context the symbol belongs to.

This object helps stop symbol-bound drift.

---

# 1. ROOT LAW

A generated card may be symbol-specific.
A family lane may be family-specific.
But routing should increasingly occur through a broader group-context object.

This object does not replace the symbol context.
It sits above it.

---

# 2. OBJECT PURPOSE

The `AURORA_GROUP_CONTEXT_OBJECT` should capture the shared context for:
- related symbols
- related bucket members
- related subtype/theme clusters
- correlated or behaviorally linked instruments when relevant

It exists to answer:
- what broader class is this symbol expressing?
- what related instruments belong to the same behavior cluster?
- what is family logic versus what is symbol-specific constraint?

---

# 3. REQUIRED FIELDS

## 3.1 Identity fields
- `group_context_id`
- `asset_class`
- `primary_bucket`
- `group_type_or_subtype`
- `theme_bucket` if useful
- `context_timestamp`

## 3.2 Membership fields
- `anchor_symbol`
- `related_symbols_or_related_classes`
- `correlation_or_relation_note`

## 3.3 Regime fields
- `group_regime_label`
- `group_regime_confidence`
- `shared_state_hypothesis`
- `shared_state_risks`

## 3.4 Routing fields
- `plausible_family_trees`
- `plausible_pattern_classes`
- `rejected_family_trees`
- `why_rejected`

## 3.5 Boundary fields
- `family_logic_vs_symbol_constraint`
- `group_constraints`
- `instance_specific_constraints`

---

# 4. WHY THIS OBJECT MATTERS

Without this object Aurora risks:
- treating every worked example as symbol doctrine
- making cards that lose their broader family/bucket context
- failing to explain how one family tree travels across related instruments

This object keeps the broader routing tree explicit.

---

# 5. TYPICAL USES

This object is useful for:
- family-lane packets
- worked-example packets
- later group-aware routing logic
- sibling-symbol comparisons
- future review packets comparing one family across related instruments

---

# 6. CURRENT JUDGMENT

Aurora now has an explicit schema target for the missing group-context object.

This is one of the key missing pieces required for classification-aware family routing.
