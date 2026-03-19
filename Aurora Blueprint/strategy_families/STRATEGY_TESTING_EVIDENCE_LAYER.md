# STRATEGY TESTING / EVIDENCE LAYER

## PURPOSE

This file defines how Aurora strategy families and pattern groups should be tested, enriched, and disciplined over time.

It exists because the strategy side now has enough structure that the next major risk is no longer missing organization.
The next major risk is accumulating strategy descriptions without a clear evidence layer.

This file therefore defines:
- what kinds of evidence matter
- how evidence should relate to families and pattern groups
- how future books should deepen rigor instead of only deepening prose
- how chart structure, ASC outputs, live data, macro, and other surfaces can participate in testing later

This file is not a final backtesting implementation manual.
It is the doctrine-level testing and evidence layer for the strategy system.

---

# 1. ROOT LAW

A strategy family becomes stronger in Aurora not only when it is described more clearly, but when it is:
- distinguished more cleanly from competing families
- tested more honestly in its native habitat
- invalidated more cleanly in its anti-habitat
- enriched by the right data surfaces without false certainty

Therefore:
- more description alone is not more evidence
- more books alone are not more evidence
- more categories alone are not more evidence

Evidence must improve discrimination.

---

# 2. WHAT MUST BE TESTED

Aurora strategy testing should not begin with micro-optimizing entries.

Testing should begin in this order:

## Level 1 — Family discrimination
Test whether the family is actually separable from its main competitors.

Examples:
- Trend Continuation vs Breakout / Compression Release
- Trend Pullback / Pullback Continuation vs Failed Break / Trap Reversal
- Balance Rotation / Range Mean-Reversion vs Breakout / Compression Release

## Level 2 — Habitat validity
Test whether the family behaves materially better in its claimed native habitat than in its anti-habitat.

## Level 3 — Pattern child usefulness
Test whether the pattern children improve the family’s discrimination or only rename the same vague structure.

## Level 4 — Data-surface uplift
Test whether extra data surfaces actually improve family trust or only add noise and overfitting risk.

Examples:
- does ASC ranking improve family filtering?
- does live microstructure improve trust?
- does macro/regime context improve suppression or weighting?

## Level 5 — Later implementation details
Only after the family proves discriminable should later entry, execution, or deployment details be studied more aggressively.

---

# 3. EVIDENCE TYPES

Aurora should preserve multiple evidence types.

## E1 — Structural evidence
Evidence that a family or pattern is meaningfully different in structure from its competitors.

Examples:
- failed break structures reclaiming prior zones
- balance rotation holding stable rejection at boundaries
- break-and-hold structures persisting beyond cheap excursion

## E2 — Habitat evidence
Evidence that a family performs better or remains more coherent in its claimed habitat than elsewhere.

## E3 — Anti-habitat evidence
Evidence showing where a family should be suppressed.

This is critical because good rejection boundaries often matter more than extra activation detail.

## E4 — Surface-trust evidence
Evidence about whether the execution-context surface strengthens or weakens the family materially.

## E5 — Data-surface uplift evidence
Evidence about whether extra surfaces such as ASC, live data, macro, or session context genuinely improve signal quality.

## E6 — Negative evidence
Evidence that a presumed distinction is weak, unstable, or not worth keeping.

This must be preserved honestly.

---

# 4. FAMILY TESTING TEMPLATE

Each family should later be testable through the following questions:

## Question 1 — What is this family trying to distinguish?
A family is only useful if it separates one structural interpretation from its alternatives.

## Question 2 — What is the family’s native habitat?
If the habitat is vague, the family is not ready.

## Question 3 — What is the family’s anti-habitat?
If Aurora cannot say where the family should be rejected, the family remains too soft.

## Question 4 — Which pattern children improve the family meaningfully?
Pattern children must increase discrimination, not just decorate the family.

## Question 5 — Which extra data surfaces genuinely help?
Additional surfaces must be treated as hypotheses to test, not automatic upgrades.

---

# 5. PATTERN TESTING TEMPLATE

Each pattern group should later be tested through the following questions:

## Question 1 — Which family is this pattern a child of?
If the pattern is not family-attached, it remains too loose.

## Question 2 — What main misread competes with it?
Examples:
- accepted break-and-hold vs failed break
- orderly pullback vs deterioration
- range rejection vs breakout acceptance

## Question 3 — Does the pattern sharpen the family or merely restate it?
If it does not sharpen the family, it may not deserve a separate pattern card.

## Question 4 — Does the pattern remain meaningful across conditions, or only in narrow windows?
This helps decide whether a pattern should stay broad or split into narrower children later.

---

# 6. ROLE OF ASC IN TESTING

ASC is one of Aurora’s major future evidence surfaces.

ASC can later contribute to testing by helping answer:
- does symbol ranking improve family filtering?
- do bucket comparisons improve family selection across symbols?
- do broker-spec or condition differences explain family degradation?
- can scanner outputs reduce false positives before deeper family logic runs?

ASC belongs mainly to:
- S2 — ASC Scanner / Internal Feature Surface

ASC evidence should be treated as uplift evidence, not as automatic truth.

---

# 7. ROLE OF LIVE DATA IN TESTING

Live execution / microstructure data can later help test:
- spread burden effects
- liquidity effects
- breakout trust vs fake release
- reclaim quality in failed breaks
- whether execution-context degradation materially changes family viability

This belongs mainly to:
- S3 — Live Execution / Microstructure Surface

Live data should usually be treated first as trust-refinement evidence, not as permission to skip structural family logic.

---

# 8. ROLE OF MACRO / REGIME DATA IN TESTING

Macro / regime data can later help test:
- whether trend families behave differently in hostile macro conditions
- whether mean-reversion logic is more or less viable in certain regimes
- whether session/calendar families need macro suppression or weighting

This belongs mainly to:
- S4 — Macro / Regime Surface

Macro evidence should usually refine family weighting or suppression rather than replace structural family identity.

---

# 9. ROLE OF CROSS-ASSET AND SESSION DATA IN TESTING

## Cross-asset / relative testing
Can later help test:
- cross-sectional momentum
- pairs / spread families
- intermarket confirmation or contradiction

Belongs mainly to:
- S5 — Cross-Asset / Relative Surface

## Session / calendar testing
Can later help test:
- ORB variants
- intraday momentum families
- session-conditioned failure / breakout logic
- time-of-day or calendar-conditioned family behavior

Belongs mainly to:
- S6 — Calendar / Session / Timebox Surface

---

# 10. WHEN FUTURE BOOKS SHOULD UPDATE THIS LAYER

Future books should update this testing/evidence layer when they materially add:
- stronger family discrimination logic
- clearer anti-habitat logic
- stronger testing methodology
- stronger evidence handling rules
- stronger warnings against overfitting or false transfer

Future books should usually **not** create a new testing doctrine file unless the current layer becomes too broad to hold the new rigor safely.

---

# 11. WHAT THIS FILE SHOULD FEED NEXT

This file should later feed:
- family-specific evidence notes
- pattern-specific evidence notes
- wrapper confidence or ranking logic
- future EA validation modules
- research / testing expansions later

Likely future children:
- a family evidence note template
- a pattern evidence note template
- a wrapper-routing examples file

---

# 12. CURRENT JUDGMENT

Aurora now has enough strategic structure that a testing / evidence layer is mandatory.

This file provides the first disciplined answer to that need.
It ensures Aurora can continue growing in two dimensions at once:
- richer family and pattern knowledge
- stronger evidence discipline

without letting the strategy side become a large, elegant, untested archive.
