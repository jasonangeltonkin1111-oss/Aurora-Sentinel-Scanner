# AURORA OPPORTUNITY INVENTORY AND RANKING PROTOCOL

## PURPOSE

This file defines how Aurora should preserve, rank, and degrade opportunities without starving the system.

It exists because a strict trade / no-trade split is too crude for this project.
Aurora must preserve opportunities even when they are not currently deployable.

This protocol is the anti-starvation bridge between:
- ASC whole-universe continuity
- Aurora family / pattern competition
- Aurora deployability classes
- later generated strategy cards

---

# 1. ROOT LAW

Aurora must not erase potentially valid opportunities simply because they are not fully tradable right now.

Instead it should preserve them in a structured inventory and classify them honestly.

The goal is:
- more opportunities without junk expansion
- more honesty without permanent caution culture
- more continuity without fake confidence

---

# 2. WHY AN INVENTORY IS NEEDED

A symbol can be:
- structurally interesting
- but missing one key surface
- or currently execution-degraded
- or not yet pattern-confirmed

If Aurora discards these cases too early, the system starves.
If Aurora promotes them too early, the system gets noisy.

The correct answer is:
- preserve
- classify
- rank
- revisit

---

# 3. OPPORTUNITY STATUS CLASSES

Aurora should preserve opportunities using these canonical statuses:

## 3.1 `ELIGIBLE`
Structurally coherent and deployable under current intraday conditions.

## 3.2 `ELIGIBLE_DEGRADED`
Structurally coherent and deployable only under adapted geometry, stronger evidence, or wider intraday handling.

## 3.3 `OBSERVE_ONLY`
Interesting enough to preserve, but not ready for deployment now because:
- surfaces are incomplete
- confirmation is incomplete
- session quality is weak
- deployability is uncertain

## 3.4 `EXECUTION_INVALID`
Structure may be coherent, but current execution burden or continuity makes deployment invalid.

## 3.5 `STRUCTURE_INVALID`
The thesis itself is structurally broken.
The opportunity may remain archived for review, but not as an active candidate.

---

# 4. INVENTORY OBJECT

Aurora should maintain an opportunity inventory object per symbol.

At minimum it should preserve:
- `symbol`
- `generated_at`
- `market_state`
- `execution_surface`
- `family_competition_ref`
- `competition_status`
- `surviving_families`
- `primary_family_candidate` if any
- `pattern_candidate` if any
- `deployability_class`
- `opportunity_status`
- `missing_surfaces`
- `hostility_objects`
- `why_not_top_ranked`
- `revisit_trigger`
- `expiry_at`

This inventory object exists even when no generated strategy card is emitted.

---

# 5. RANKING LOGIC

Aurora should not collapse opportunity ranking into one hidden score.

Instead ranking should preserve separable judgments such as:
- structural coherence
- family competition outcome
- family fit
- pattern clarity when pattern competition has actually run
- deployability quality
- hostility burden
- surface completeness
- timebox compatibility

Aurora may later derive a practical ranking layer, but it must preserve the components behind the ranking.

---

# 6. SOFT SUPPRESSION LAW

Suppression must be soft when possible.

That means Aurora should prefer:
- degrade
- preserve as observe-only
- request missing surfaces
- widen horizon inside intraday if valid

before it chooses:
- total rejection

Hard rejection is appropriate only when:
- structure is invalid
- execution is clearly invalid for project constraints
- horizon requirement exceeds intraday

---

# 7. REVISIT TRIGGERS

Every non-eligible but preserved opportunity should carry a revisit trigger.

Examples:
- spread normalizes
- session improves
- pattern confirms
- missing surface becomes available
- hostility decays
- range expands enough to improve path potential

This is how Aurora preserves opportunities without freezing them in place.

---

# 8. RELATIONSHIP TO GENERATED STRATEGY CARDS

Not every inventory item becomes a generated strategy card.

Rule:
- inventory comes first
- strategy card generation comes only when enough truth exists

This protects the system from fake precision.

---

# 9. FORBIDDEN SHORTCUTS

Aurora must not:
- use a single hidden confidence number as the whole ranking system
- collapse observe-only into no-opportunity
- discard opportunities because one surface is missing
- preserve structurally invalid candidates as if they are still live
- turn anti-starvation into permissive garbage ranking

---


# 10. STAGE-AWARE OPPORTUNITY LAW

Every preserved opportunity should be allowed to carry an explicit opportunity-stage judgment when timing materially affects honesty.

Recommended stage fields:
- `opportunity_stage`
- `stage_justification`
- `stage_risks`
- `stage_transition_watchpoints`

Stage language must follow `AURORA_OPPORTUNITY_STAGE_TAXONOMY_PROTOCOL.md`.
Aurora should not assume early-stage opportunity is always superior.
A mature, continuation, re-entry, or late-stage case may still outrank an emergent case if the structure is cleaner, the family fit is stronger, and the remaining path still supports preservation.

# 11. MULTI-OPPORTUNITY ECOLOGY LAW

Opportunity inventory should allow multiple preserved opportunity classes at once, such as:
- one primary live case
- one degraded secondary case
- one observe-only continuation or reversal branch
- one late-join or re-entry path worth monitoring

Aurora should preserve these separately when the structure supports them instead of collapsing them into one forced winner too early.

# 12. LATE-JOIN / MID-PROGRESS LEGITIMACY LAW

A case must not be rejected merely because the market has already moved.
Reject it only when:
- structure is exhausted
- remaining path is too poor
- geometry becomes dishonest
- family logic no longer supports continuation, re-entry, or salvage

Some of Aurora's best-preserved cases will correctly appear after additional evidence, not before it.

# 13. CURRENT JUDGMENT

Aurora now has an explicit anti-starvation protocol:
- preserve opportunities
- classify them honestly
- rank them by separable components
- revisit them when context changes
- preserve stage-aware and late-join opportunity classes when the structure honestly supports them

This keeps the system opportunity-rich without becoming loose or generic.
