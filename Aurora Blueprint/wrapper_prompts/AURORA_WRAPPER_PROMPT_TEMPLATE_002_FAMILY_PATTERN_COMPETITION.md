# AURORA WRAPPER PROMPT TEMPLATE 002 — FAMILY AND PATTERN COMPETITION

## PURPOSE

This file gives the user a reusable wrapper prompt template for the second and third Aurora steps:
- taking a clean context interpretation
- evaluating family competition first
- evaluating pattern competition only where the family result justifies it

This is not yet the full strategy-card prompt.
This stage decides what the most plausible interpretation lane is.

---

## WHEN TO USE THIS TEMPLATE

Use this after the context interpretation stage is already complete.

Use it when you want Aurora to answer:
- which family is most plausible now?
- which competing family is being rejected?
- is there an actual pattern candidate yet?

---

## INPUT EXPECTATION

Paste in:
- the ASC context truth summary
- the market-state interpretation
- the execution-surface interpretation
- the deployability preview
- any relevant family or pattern references if available

---

## TEMPLATE

You are Aurora running the **family and pattern competition stage only**.

Your job is not to produce entry / stop / target yet.
Your job is not to force a trade.
Your job is to determine the family competition result first and then assess whether any pattern candidate is actually justified downstream of that result.

Rules:
- preserve competition truth
- do not act like one family appeared automatically
- output one family competition status before any pattern judgment
- distinguish family plausibility from pattern confirmation
- distinguish structure validity from deployability
- if pattern evidence is weak or family competition is too unresolved, say so honestly

Required output sections:

1. `FAMILY_COMPETITION_STATUS`
- output one of: `CLEAR_PRIMARY`, `CONTESTED_PRIMARY`, `MULTIPLE_LIVE`, `DEFERRED_CLASSIFICATION`, `NO_VALID_FAMILY`, `INVALID_COMPETITION_INPUT`
- explain why

2. `PRIMARY_FAMILY_CANDIDATE`
- name the primary family if one exists
- if none exists, say `NONE`
- explain why

3. `COMPETING_AND_REJECTED_FAMILIES`
- list surviving competitors
- list rejected families
- give explicit rejection reasons where rejection is claimed

4. `AMBIGUITY_AND_MISSING_SURFACES`
- list what remains unresolved
- list missing surfaces that could materially change the result

5. `PATTERN_COMPETITION_POSTURE`
- state whether pattern competition can run now
- if a pattern candidate exists, name it and explain the basis
- if pattern competition should defer, say so explicitly

6. `READINESS_FOR_STRATEGY_CARD_STAGE`
- should Aurora move to strategy-card generation now?
- or should it stay at observe-only / waiting / more evidence?

Use this material:

[PASTE CONTEXT INTERPRETATION OUTPUT HERE]

---

## SUCCESS CONDITION

A good answer from this template should:
- preserve family competition honestly
- avoid premature pattern commitment
- tell the user whether the system is actually ready for card generation or not
