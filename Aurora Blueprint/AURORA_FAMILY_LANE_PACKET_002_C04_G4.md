# AURORA FAMILY LANE PACKET 002 — C-04 / G4

## PURPOSE

This file supersedes the earlier C-04 / G4 family-lane packet with a cleaner, citation-free, machine-ready build-phase version.

It is anchored to the active family and pattern surfaces:
- `Aurora Blueprint/strategy_families/CARDS/C-04_Failed_Break_Trap_Reversal.card.md`
- `Aurora Blueprint/patterns/G4_Failed_Break_Reclaim.card.md`

This packet remains build-phase material.
It is not an automation packet.
It is an execution-side operator/use packet for one broader family tree demonstrated through one lane.

---

# 1. PACKET IDENTITY

- `packet_id`: `AURORA_FAMILY_LANE_PACKET_002_C04_G4`
- `packet_type`: `FAMILY_LANE_PACKET`
- `packet_version`: `2`
- `created_for`: `Aurora execution-side build phase`
- `scope`: `C-04 family tree with G4 child pattern group`
- `status`: `BUILD_PHASE_ACTIVE`

---

# 2. FAMILY AND PATTERN ANCHORS

## Primary family
- `family_id`: `C-04`
- `family_name`: `Failed Break / Trap Reversal`
- `family_status`: `BUILD_READY`
- canonical thesis:
  - participate when an attempted directional move loses acceptance, reclaims prior structure, and reversal or return-to-structure logic becomes dominant

## Primary pattern group
- `pattern_id`: `G4`
- `pattern_name`: `Failed Break / Reclaim`
- `pattern_status`: `APPROVED_GROUP`
- canonical thesis:
  - attempted directional break cannot sustain itself, loses acceptance, and is reclaimed back through the initiating area, shifting the meaning toward reversal or return-to-structure logic

---

# 3. ROUTING POSTURE

This family lane is not symbol-bound.

Routing should occur through:
- asset class
- bucket class
- group/subtype/theme where useful
- regime/state
- family competition
- pattern competition
- then symbol instance constraints only later

A worked example may use one symbol instance.
That instance does not define the whole family tree.

---

# 4. PRIMARY MARKET HABITAT

## Family habitat
- failed state / trap
- failed break / trap state
- false commitment reverting back through initiating structure

## Pattern habitat
- failed break / trap state
- false release reverting through initiating structure

## Required state logic
The packet is only valid when the operator can honestly say:
- the market attempted directional expansion
- continuation lost authority
- reclaim or return-through-structure logic is stronger than continuation logic

If this cannot be said honestly, the lane should remain a competitor, not the primary lane.

---

# 5. PRIMARY COMPETITORS

Main competing interpretations:
- breakout / compression release
- trend continuation
- balance rotation / range mean-reversion

Main pattern misreads:
- ordinary pullback mistaken for failed break
- unresolved breakout mistaken for clear reclaim failure
- unstable chop mistaken for meaningful trap reversal

## Packet law
This packet must preserve competition truth.
It is invalid to use this lane as if those competitors no longer exist.

---

# 6. REQUIRED INPUT OBJECTS

Before this packet is usable, the operator should have at least:
- `ASC_CONTEXT_OBJECT`
- `AURORA_GROUP_CONTEXT_OBJECT` when available
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`

Hard blockers:
- no visible break attempt
- context cannot distinguish failed break from unresolved continuation
- state reading too weak to rank the family honestly

---

# 7. STAGE ORDER FOR THIS FAMILY LANE

## Stage 1 — Context interpretation
Goal:
- determine whether the environment even permits failed-break logic to be plausible

Stop if:
- the move is still ordinary continuation
- no break attempt is actually visible
- missing surfaces make state reading too weak

## Stage 2 — Group / bucket / regime routing check
Goal:
- place the current symbol instance inside a broader behavior class
- identify related symbols or related classes if useful
- separate family logic from symbol-specific constraint

Stop if:
- the lane is only being forced because of symbol familiarity rather than regime logic

## Stage 3 — Family competition
Goal:
- determine whether `C-04` actually beats breakout, continuation, or range alternatives

Pass only if:
- reclaim / reversal logic is stronger than continuation logic

## Stage 4 — Pattern candidate check
Goal:
- determine whether `G4` is actually present

Required pattern truths:
- break attempt occurred
- continuation failed to hold
- reclaim of prior structure is real enough to matter

Reject if:
- reclaim is weak or incomplete
- continuation authority is still alive
- the move is unstable chop without clear hierarchy

## Stage 5 — Opportunity classification
Classify as one of:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

## Stage 6 — Generated strategy card only if justified
Only emit a card if:
- family is primary
- pattern candidate is real enough
- deployability is not unknown
- geometry is valid inside intraday bounds

---

# 8. COMMON GEOMETRY FAILURE MODES

This packet should explicitly watch for:
- reclaim is real, but path is too compressed relative to burden
- pattern is valid, but invalidation is too wide for intraday use
- pattern is valid, but timebox is too weak for reversal completion
- pattern is valid, but execution surface is too unstable for the entry style
- idea is valid, but geometry is not

---

# 9. COMMON DEPLOYABILITY FAILURE MODES

This lane often fails on deployability when:
- spread / burden rises while reclaim path stays small
- failed break is visible but execution continuity is poor
- the environment is structurally valid but still low-trust
- trap-on-trap instability prevents a clean hierarchy

These should usually degrade or preserve the opportunity rather than force immediate card emission.

---

# 10. GROUP-AWARE REVIEW QUESTIONS

After a completed or missed case, ask:
- was the original move truly a failed break or only a pullback?
- was reclaim actually secured?
- did continuation authority return?
- did deployability get overrated relative to burden?
- was geometry invalid even though the idea was valid?
- was the lane correctly degraded / observe-only?
- what part belonged to the family tree versus the symbol-specific constraint?
- what related instruments could have expressed the same family lane?

---

# 11. EXPECTED OUTPUTS FROM THIS PACKET

This packet should normally produce one of two outcomes:

## Outcome A — Preserved opportunity only
- opportunity object exists
- no card emitted
- reason: pattern or deployability not strong enough

## Outcome B — Generated strategy card
- only when structure, deployability, and geometry all justify it

The packet is successful even when Outcome A is the honest answer.

---

# 12. OPERATOR ATTENTION POINTS

- do not confuse pullback with failed break
- do not confuse unresolved breakout with reclaim
- do not confuse unstable chop with reversal edge
- do not force this lane just because reversals are psychologically attractive
- do not force geometry when the path is too small for current burden
- do not let one symbol instance become the whole family doctrine

---

# 13. WHAT TO SAVE AFTER RUNNING THIS PACKET

Save:
- raw ASC context used
- group context if available
- market state interpretation
- family competition output
- pattern candidate judgment
- opportunity classification
- strategy card if emitted
- later review result if available

This creates the example library the lane needs.

---

# 14. CURRENT JUDGMENT

Aurora now has a cleaner superseding family-lane packet anchored to an actual build-ready family and an approved pattern group.

This packet stays broad enough to support group / bucket / regime routing while still being practical enough for execution-side worked examples.
