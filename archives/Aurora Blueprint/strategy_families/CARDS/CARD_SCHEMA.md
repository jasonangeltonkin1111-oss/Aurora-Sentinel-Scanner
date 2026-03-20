# STRATEGY FAMILY CARD SCHEMA

## PURPOSE

This file defines the standard structure for Aurora strategy family cards.

Cards are the layer between:
- family-definition files
- future wrapper logic
- future EA orchestration logic
- future testing and pattern modules

Family files explain the family in fuller doctrine language.
Cards compress that family into a cleaner operational reference while still preserving honesty and room for future enrichment.

---

# 1. CARD DESIGN LAW

Every card must be:
- stable enough for future wrappers and EA planning
- honest about what is still provisional
- easy to enrich when more books are processed
- explicit about what data surfaces improve or extend the family

Cards must not pretend the family is final if the source base is still growing.

---

# 2. REQUIRED CARD SECTIONS

Each family card should contain these sections in order:

1. CARD ID
2. FAMILY NAME
3. STATUS
4. CANONICAL THESIS
5. PRIMARY MARKET HABITAT
6. PRIMARY STATE / SURFACE DEPENDENCIES
7. REQUIRED DATA SURFACES
8. HIGH-VALUE SUPPORTING DATA SURFACES
9. STRUCTURAL ENTRY LOGIC (HIGH LEVEL ONLY)
10. STRUCTURAL INVALIDATION LOGIC (HIGH LEVEL ONLY)
11. MAIN FAMILY COMPETITORS
12. FAMILY REJECTION CONDITIONS
13. FUTURE PATTERN CHILDREN
14. FUTURE TESTING / RESEARCH NEEDS
15. FUTURE ENRICHMENT PATH
16. LINEAGE
17. CURRENT JUDGMENT

---

# 3. STATUS VALUES

Allowed status values:
- `BUILD_READY`
- `CONDITIONAL`
- `PRESERVED_ONLY`
- `DEFERRED`

## Meaning
`BUILD_READY`
- structurally clear enough to become part of the immediate Aurora family build layer

`CONDITIONAL`
- real and preserved, but needs more surfaces, doctrine, or testing before core use

`PRESERVED_ONLY`
- important to keep, but not a current core build target

`DEFERRED`
- known but intentionally not active yet

---

# 4. EVOLUTION LAW

When more books are processed, cards should usually be:
- enriched
- sharpened
- expanded in dependencies
- updated in anti-confusions or invalidation logic

Cards should rarely be completely replaced unless the family itself is redefined.

New sources should update cards by:
- adding depth
- adding better distinctions
- adding missing surface requirements
- adding better rejection conditions
- adding better research/testing notes

This preserves continuity while allowing growth.

---

# 5. CURRENT JUDGMENT

This schema exists so the card layer becomes a durable, organized interface between strategy doctrine and future machine-usable Aurora build layers.
