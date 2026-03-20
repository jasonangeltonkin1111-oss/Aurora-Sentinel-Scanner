# AURORA WRAPPER WORKFLOW PACKET 001

> Historical note: this packet is superseded for active wrapper execution by `AURORA_WRAPPER_WORKFLOW_PACKET_002.md`.
> Keep this file for lineage only.

## PURPOSE

This file turns Aurora’s new prompt chain into one practical end-to-end wrapper workflow the operator can actually run.

It exists because Aurora now has:
- context contract
- deployability protocol
- geometry protocol
- object model
- generated strategy-card protocol
- wrapper prompt templates

But the operator still needs one clean flow for how to use them in order.

This file is not doctrine.
It is an operator workflow packet.

---

# 1. ROOT LAW

Run Aurora in stages.
Do not jump straight from ASC context to trade geometry.

The correct order is:
1. ASC context truth
2. context interpretation
3. family / pattern competition
4. generated strategy card if justified
5. review / diagnosis later

If one stage is weak, do not force the next stage.

---

# 2. INPUT PREREQUISITE

Before using this workflow, the operator should have one ASC context block or symbol dossier extract containing at least:
- identity
- market status
- session / timebox truth
- spread / execution truth
- freshness / degradation truth

If these are missing, the workflow should stop early and log the missing surfaces.

---

# 3. STAGE 1 — CONTEXT INTERPRETATION

Use:
- `wrapper_prompts/AURORA_WRAPPER_PROMPT_TEMPLATE_001_CONTEXT_INTERPRETATION.md`

Goal:
- convert ASC truth into:
  - `ASC_CONTEXT_TRUTH_SUMMARY`
  - `MARKET_STATE_INTERPRETATION`
  - `EXECUTION_SURFACE_INTERPRETATION`
  - `DEPLOYABILITY_PREVIEW`
  - `MISSING_SURFACES`

Pass condition:
- the result must stay close to measured ASC truth
- no geometry yet
- no forced trade language

Stop condition:
- if too many missing surfaces remain, preserve as observe-only and stop here

---

# 4. STAGE 2 — FAMILY / PATTERN COMPETITION

Use:
- `wrapper_prompts/AURORA_WRAPPER_PROMPT_TEMPLATE_002_FAMILY_PATTERN_COMPETITION.md`

Goal:
- determine the most plausible family lane
- preserve competing families honestly
- determine whether a pattern candidate actually exists

Pass condition:
- one primary family candidate is justified
- competing families are named honestly
- readiness for card generation is stated clearly

Stop condition:
- if no family or pattern is sufficiently settled, preserve as opportunity object only and stop here

---

# 5. STAGE 3 — GENERATED STRATEGY CARD

Use:
- `wrapper_prompts/AURORA_WRAPPER_PROMPT_TEMPLATE_003_GENERATED_STRATEGY_CARD.md`

Goal:
- emit a generated strategy card only if the earlier stages actually justify it

Pass condition:
- card eligibility gate says yes
- geometry comes from structural meaning plus deployability
- intraday horizon stays explicit
- machine-safe versus human-only fields stay separated

Stop condition:
- if idea is valid but geometry is not, log that clearly and do not force a card

---

# 6. STAGE 4 — REVIEW / DIAGNOSIS

Use later:
- `wrapper_prompts/AURORA_WRAPPER_PROMPT_TEMPLATE_004_REVIEW_AND_DIAGNOSIS.md`

Goal:
- learn from expired, played-out, degraded, or missed opportunities
- diagnose failure or success without hindsight fantasy

Pass condition:
- the review identifies the correct layer:
  - structure
  - deployability
  - geometry
  - timing/session
  - missing ASC truth
  - correct degradation

---

# 7. OUTPUT OBJECTS CREATED THROUGH THE WORKFLOW

This workflow should create or refine these objects in order:
- `ASC_CONTEXT_OBJECT`
- `AURORA_MARKET_STATE_OBJECT`
- `AURORA_EXECUTION_SURFACE_OBJECT`
- `AURORA_DEPLOYABILITY_OBJECT`
- `AURORA_FAMILY_COMPETITION_OBJECT`
- `AURORA_PATTERN_CANDIDATE_OBJECT`
- `AURORA_OPPORTUNITY_OBJECT`
- `AURORA_GENERATED_STRATEGY_CARD` only if justified
- `AURORA_EA_SAFE_OUTPUT_OBJECT` only much later and only from machine-safe fields

---

# 8. WHAT TO SAVE EACH TIME

For each real wrapper run, the operator should save:
- the ASC context block used
- the output of Stage 1
- the output of Stage 2
- the output of Stage 3 if any
- the review output later if any
- a short note on what remained missing or weak

This creates a usable example library over time.

---

# 9. WHAT NOT TO DO

Do not:
- skip directly to Stage 3
- let generic RR language creep in
- use last-high / last-low as universal stop or target logic
- pretend missing ASC truth does not matter
- treat every opportunity as card-ready
- treat every card as EA-ready

---

# 10. CURRENT JUDGMENT

Aurora now has an actual wrapper workflow packet.

This gives the operator a clean end-to-end path for using the system manually before pushing further toward bounded automation.
