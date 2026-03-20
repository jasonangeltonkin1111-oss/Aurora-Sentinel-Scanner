# AURORA GROUP CONTEXT OBJECT EXAMPLE 001 — C-04 / G4

## PURPOSE

This file is the first concrete example artifact for `AURORA_GROUP_CONTEXT_OBJECT_SCHEMA.md`.

It is an illustrative build-phase specimen.
It is not a claim of verified live market history.
It exists to demonstrate the required object shape for the C-04 / G4 lane while preserving the difference between:
- family logic
- group/bucket/regime context
- symbol-specific constraint

---

# 1. OBJECT IDENTITY

- `group_context_id`: `AURORA_GROUP_CONTEXT_OBJECT_EXAMPLE_001_C04_G4`
- `object_type`: `AURORA_GROUP_CONTEXT_OBJECT`
- `object_version`: `1`
- `status`: `ILLUSTRATIVE_BUILD_PHASE_SPECIMEN`
- `family_anchor`: `C-04`
- `pattern_anchor`: `G4`
- `schema_ref`: `AURORA_GROUP_CONTEXT_OBJECT_SCHEMA.md`
- `context_timestamp`: `ILLUSTRATIVE_NOT_LIVE_TIMESTAMP`

---

# 2. IDENTITY FIELDS

- `asset_class`: `FX_SPOT_MAJOR`
- `primary_bucket`: `G10_FX`
- `group_type_or_subtype`: `USD-led major intraday failure/reclaim cluster`
- `theme_bucket`: `failed-break reclaim around prior intraday acceptance zone`

Interpretation note:
- this is a doctrine-routing class shell, not a claim that all G10 FX majors behave identically

---

# 3. MEMBERSHIP FIELDS

- `anchor_symbol`: `EURUSD` only as an illustrative instance shell
- `related_symbols_or_related_classes`:
  - `GBPUSD`
  - `AUDUSD`
  - `DXY-linked USD pressure context`
  - `major FX class with session-driven reclaim behavior`
- `correlation_or_relation_note`:
  - shared behavior interest comes from intraday failed-break / reclaim structure in liquid FX majors
  - membership does not imply synchronized entries or identical execution quality

---

# 4. REGIME FIELDS

- `group_regime_label`: `failed directional attempt returning toward prior acceptance/value`
- `group_regime_confidence`: `illustrative_moderate`
- `shared_state_hypothesis`:
  - the broader class is expressing rejection of an attempted directional break rather than orderly continuation
  - responsive reversal logic is becoming more relevant than extension logic
- `shared_state_risks`:
  - unresolved breakout may still be masquerading as failure
  - session transition may distort reclaim quality
  - one symbol may show cleaner reclaim than the broader class

---

# 5. ROUTING FIELDS

- `plausible_family_trees`:
  - `C-04 Failed Break / Trap Reversal` as primary illustrative family tree
  - `C-03 Breakout / Compression Release` as competing tree when failure is not yet confirmed
  - `C-01 Trend Continuation` as competing tree when reclaim is weak and continuation can reassert
- `plausible_pattern_classes`:
  - `G4 Failed Break / Reclaim`
- `rejected_family_trees`:
  - `C-05 Balance Rotation / Range Mean-Reversion` when the structure is still anchored to a failed break rather than stable balance
- `why_rejected`:
  - the illustrative case is not framed as a settled mean-reversion balance rotation first; it is framed as a failed directional attempt reclaiming prior structure

---

# 6. BOUNDARY FIELDS

- `family_logic_vs_symbol_constraint`:
  - family logic: failed break loses acceptance, prior structure is reclaimed, reversal/return-to-structure logic becomes dominant
  - symbol-specific constraint: EURUSD may show cleaner reclaim timing, tighter spread, or stronger session support than another major in the same class
- `group_constraints`:
  - reclaim quality is often session-sensitive
  - the class can degrade quickly when the failed break becomes unstable chop instead of clean rejection
  - related majors may share broad USD pressure context without sharing the same entry quality
- `instance_specific_constraints`:
  - one demonstrative symbol may be open-session clean while siblings are already late in the move
  - spread, continuity, and stale-tick risk remain ASC-owned instance truths

---

# 7. WHY THIS EXAMPLE IS SAFE

This example stays non-symbol-bound because:
- the group logic is stated at class level first
- the anchor symbol is only an instance shell
- ASC-owned execution and freshness truths are not fabricated here
- family logic is separated from symbol-specific execution constraints

---

# 8. CURRENT JUDGMENT

Aurora now has a first concrete group-context example artifact for the C-04 / G4 lane.

It is illustrative, build-phase honest, and suitable as the upstream group-context specimen for later worked examples and review packets.
