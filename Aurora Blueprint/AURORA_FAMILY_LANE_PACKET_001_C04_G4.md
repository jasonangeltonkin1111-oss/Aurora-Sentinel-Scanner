# AURORA FAMILY LANE PACKET 001 — C-04 / G4

## PURPOSE

This file is the first richer Aurora family-lane packet.

It expands the earlier pilot scaffold by anchoring the lane to the active family and pattern surfaces:
- `C-04_Failed_Break_Trap_Reversal.card.md`
- `G4_Failed_Break_Reclaim.card.md`

This packet is still build-phase material.
It is not a final automation packet.
It is a clearer operator/use packet for one real Aurora execution-side lane.

---

# 1. PACKET IDENTITY

- `packet_id`: `AURORA_FAMILY_LANE_PACKET_001_C04_G4`
- `packet_type`: `FAMILY_LANE_PACKET`
- `packet_version`: `1`
- `created_for`: `Aurora execution-side build phase`
- `scope`: `C-04 family lane with G4 pattern candidate`
- `status`: `BUILD_PHASE_ACTIVE`

---

# 2. FAMILY AND PATTERN ANCHORS

## Primary family
- `family_id`: `C-04`
- `family_name`: `Failed Break / Trap Reversal`
- `family_status`: `BUILD_READY`
- canonical thesis:
  - participate when an attempted directional move loses acceptance, reclaims prior structure, and reversal or return-to-structure logic becomes dominant fileciteturn134file0

## Primary pattern group
- `pattern_id`: `G4`
- `pattern_name`: `Failed Break / Reclaim`
- `pattern_status`: `APPROVED_GROUP`
- canonical thesis:
  - attempted directional break cannot sustain itself, loses acceptance, and is reclaimed back through the initiating area, shifting the meaning toward reversal or return-to-structure logic fileciteturn135file0

---

# 3. WHY THIS IS THE FIRST FAMILY-LANE PACKET

This lane is the correct first packet because:
- the family is already marked `BUILD_READY` fileciteturn134file0
- the child pattern is already an `APPROVED_GROUP` fileciteturn135file0
- the lane naturally forces distinction between:
  - valid failed structure
  - unresolved breakout
  - ordinary pullback
  - unstable chop
- the lane benefits strongly from deployability and execution-surface interpretation without requiring generic trend-following shortcuts

---

# 4. PRIMARY MARKET HABITAT

## Family habitat
- Failed State / Trap
- Failed Break / Trap State
- false commitment reverting back through initiating structure fileciteturn134file0

## Pattern habitat
- Failed Break / Trap State
- false release reverting through initiating structure fileciteturn135file0

## Required state logic
The packet is only valid when the operator can honestly say:
- the market attempted directional expansion
- continuation lost authority
- reclaim or return-through-structure logic is stronger than continuation logic

If this cannot be said honestly, the lane should remain a competitor, not the primary lane.

---

# 5. PRIMARY COMPETITORS

Main competing interpretations from the family card:
- Breakout / Compression Release
- Trend Continuation
- Balance Rotation / Range Mean-Reversion fileciteturn134file0

Main pattern misreads from the pattern card:
- ordinary pullback mistaken for failed break
- unresolved breakout mistaken for clear reclaim failure
- unstable chop mistaken for meaningful trap reversal fileciteturn135file0

## Packet law
This packet must preserve competition truth.
It is invalid to use this lane as if those competitors no longer exist.

---

# 6. REQUIRED INPUT OBJECTS

Before this packet is usable, the operator should have at least:
- `ASC_CONTEXT_OBJECT`
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`

Hard blocker:
- if the context cannot distinguish failed break from unresolved continuation, stop before pattern commitment

---

# 7. STAGE ORDER FOR THIS FAMILY LANE

## Stage 1 — Context interpretation
Goal:
- determine whether the environment even permits failed-break logic to be plausible

Stop if:
- the move is still ordinary continuation
- no break attempt is actually visible
- missing surfaces make state reading too weak

## Stage 2 — Family competition
Goal:
- determine whether `C-04` actually beats breakout, continuation, or range alternatives

Pass only if:
- reclaim/reversal logic is stronger than continuation logic

## Stage 3 — Pattern candidate check
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

## Stage 4 — Opportunity classification
Classify as one of:
- `ELIGIBLE`
- `ELIGIBLE_DEGRADED`
- `OBSERVE_ONLY`
- `EXECUTION_INVALID`
- `STRUCTURE_INVALID`

## Stage 5 — Generated strategy card only if justified
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
- pattern is valid, but session/timebox is too weak for reversal completion
- pattern is valid, but execution surface is too unstable for the entry style
- idea is valid, but geometry is not

This is one of the most important lessons of this lane.

---

# 9. COMMON DEPLOYABILITY FAILURE MODES

This lane often fails on deployability when:
- spread / burden rises while reclaim path stays small
- failed break is visible but execution continuity is poor
- the environment is structurally valid but still low-trust
- trap-on-trap instability prevents a clean hierarchy

These should usually degrade or preserve the opportunity rather than forcing immediate card emission.

---

# 10. TYPICAL REVIEW QUESTIONS

After a completed or missed case, ask:
- was the original move truly a failed break or only a pullback?
- was reclaim actually secured?
- did continuation authority return?
- did deployability get overrated relative to burden?
- was geometry invalid even though the idea was valid?
- was the lane correctly degraded / observe-only?

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

---

# 13. WHAT TO SAVE AFTER RUNNING THIS PACKET

Save:
- raw ASC context used
- market state interpretation
- family competition output
- pattern candidate judgment
- opportunity classification
- strategy card if emitted
- later review result if available

This creates the example library the lane needs.

---

# 14. CURRENT JUDGMENT

Aurora now has its first richer family-lane packet anchored to an actual build-ready family and an approved pattern group.

This packet is still build-phase material, but it is much closer to a real execution-side workflow than the earlier scaffold alone.
