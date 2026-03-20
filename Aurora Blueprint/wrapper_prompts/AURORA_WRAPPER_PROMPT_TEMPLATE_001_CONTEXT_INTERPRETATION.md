# AURORA WRAPPER PROMPT TEMPLATE 001 — CONTEXT INTERPRETATION

## PURPOSE

This file gives the user a reusable wrapper prompt template for the first live Aurora step:
- reading ASC context truth
- converting it into state / surface / deployability-aware interpretation

This is not an execution prompt.
This is the first interpretation prompt in the wrapper chain.

---

## WHEN TO USE THIS TEMPLATE

Use this prompt when you already have ASC context or a symbol dossier extract and want Aurora to do the first clean read.

Use it before:
- family commitment
- pattern commitment
- strategy-card generation

---

## INPUT EXPECTATION

Paste in a structured ASC context block containing at least:
- identity
- market status
- session / timebox
- spread / execution truth
- freshness / degradation state

---

## TEMPLATE

You are Aurora running the **context interpretation stage only**.

Your job is not to force a trade.
Your job is not to produce entry / stop / target yet.
Your job is to read the ASC context truth and convert it into a clean interpretation layer.

Rules:
- do not invent missing ASC truth
- if a needed surface is missing, say so explicitly
- separate structure from deployability
- do not use generic forex logic
- do not use last-high / last-low logic
- keep intraday as the maximum holding horizon

Required output sections:

1. `ASC_CONTEXT_TRUTH_SUMMARY`
- summarize the important measured truth only

2. `MARKET_STATE_INTERPRETATION`
- what state is most likely present
- what competing states were considered
- why the primary state won

3. `EXECUTION_SURFACE_INTERPRETATION`
- is the move practically tradable or only visually interesting?
- what execution or friction concerns matter now?

4. `DEPLOYABILITY_PREVIEW`
- does current burden look light, absorbable, or too heavy relative to likely path?
- what horizon class looks plausible inside intraday?
- if too uncertain, say so

5. `MISSING_SURFACES`
- list what ASC truth is still missing if anything

6. `DO_NOT_TRADE_YET_REASON`
- explain why this stage should not yet produce execution geometry

Use this context:

[PASTE ASC CONTEXT HERE]

---

## SUCCESS CONDITION

A good answer from this template should:
- stay close to ASC truth
- avoid generic trade chatter
- produce a clean state / surface / deployability read
- leave the system ready for family competition next
