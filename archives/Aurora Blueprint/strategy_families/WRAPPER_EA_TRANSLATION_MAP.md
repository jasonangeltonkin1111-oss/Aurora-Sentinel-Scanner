# WRAPPER / EA TRANSLATION MAP

## PURPOSE

This file explains how the Aurora strategy-family layer can later be translated into:
- a GPT wrapper layer
- an EA logic layer

It exists so family files do not remain only human-readable doctrine.
They should become future-buildable system components.

---

# 1. WHY THIS FILE EXISTS

Family files already explain:
- what each family is
- where it belongs
- what it is commonly confused with

But a wrapper or EA will later need more explicit translation targets.

This file defines those targets.

---

# 2. FUTURE WRAPPER TASKS

A future GPT wrapper should be able to do these tasks using the family layer:

## Task A — Family eligibility explanation
Answer:
- which families are plausible now
- which families are excluded now
- why

## Task B — Missing-surface request
Answer:
- what extra data surface is needed to raise confidence
- whether ASC, live execution, macro, session, or cross-asset data would change the family ranking

## Task C — Family competition summary
Answer:
- what the main competing family interpretations are
- which one currently dominates
- which one is being rejected

## Task D — Human-readable handoff
Answer:
- state
- surface
- family candidate
- anti-family warnings
- next pattern layer or testing layer request

---

# 3. FUTURE EA TASKS

A future EA should be able to do these tasks using the family layer:

## Task A — Route by family class
Map current context into a strategy-family branch.

## Task B — Reject anti-habitat
Suppress a family if the current state/surface conflicts with its anti-habitat.

## Task C — Check data-surface sufficiency
Decide whether the family can run from chart structure alone or whether extra surfaces are required.

## Task D — Trigger deeper family module
Only after family eligibility is satisfied should later pattern/entry logic be called.

---

# 4. RECOMMENDED MACHINE-FACING FIELDS

Each family should later be translatable into structured fields such as:
- family_id
- family_name
- class_type
- primary_habitats
- anti_habitats
- required_data_surfaces
- optional_data_surfaces
- competing_families
- pattern_children
- not_ready_reasons

These fields do not need to be fully implemented now.
They are the future translation targets.

---

# 5. CURRENT JUDGMENT

Aurora strategy families are no longer just conceptual labels.

This file exists so the family layer can later become:
- wrapper-readable
- EA-routable
- machine-structured
without losing the doctrinal clarity that was built first.
