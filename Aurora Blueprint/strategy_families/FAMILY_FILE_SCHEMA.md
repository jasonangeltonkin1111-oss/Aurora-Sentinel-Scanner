# FAMILY FILE SCHEMA

## PURPOSE

This file defines the standard structure all Aurora strategy-family files should follow.

The goal is to make the family layer:
- consistent for humans
- consistent for future GPT wrappers
- easier to translate into future EA logic

This file is a formatting and interpretation contract.

---

# 1. REQUIRED FIELDS

Each family file should contain these sections in order:

1. FAMILY NAME
2. CANONICAL IDEA
3. NATIVE HABITAT
4. ANTI-HABITAT
5. STRUCTURAL SIGNATURES
6. MAIN COMPETING INTERPRETATIONS
7. STAGE PROFILE
8. BUCKET / REGIME FIT
9. MAIN ANTI-CONFUSIONS
10. FUTURE PATTERN DEPENDENCIES
11. FUTURE WRAPPER / EA TRANSLATION VALUE
12. CURRENT JUDGMENT

---

# 2. WHY THIS MATTERS

A future GPT wrapper should be able to parse a family file and answer:
- what the family is
- where it belongs
- where it does not belong
- what stage expressions are native, degraded, or exhausted
- what buckets or regimes fit it best
- what it is commonly confused with
- what pattern or testing layers it still needs later

A future EA design layer should be able to parse a family file and answer:
- what state/surface conditions this family depends on
- what must be filtered out before activation
- what later machine-readable schema fields should be created

---

# 3. IMPORTANT NON-GOALS

Family files should not yet contain:
- fixed entries
- fixed stops
- fixed target formulas
- broker-specific execution instructions
- false precision pretending implementation is already complete

Those belong in later family cards or implementation layers.

---

# 4. CURRENT JUDGMENT

This schema exists so the strategy-family folder becomes a real build layer rather than a pile of disconnected prose.
