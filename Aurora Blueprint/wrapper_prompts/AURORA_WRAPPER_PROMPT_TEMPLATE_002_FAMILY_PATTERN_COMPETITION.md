# AURORA WRAPPER PROMPT TEMPLATE 002 — FAMILY AND PATTERN COMPETITION

## PURPOSE

This file gives the user a reusable wrapper prompt template for the second live Aurora step:
- taking a clean context interpretation
- evaluating family competition
- evaluating pattern competition where appropriate

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
Your job is to determine which family lane is most plausible and whether any pattern candidate is actually present.

Rules:
- preserve competition truth
- do not act like one family appeared automatically
- distinguish family plausibility from pattern confirmation
- distinguish structure validity from deployability
- if pattern evidence is weak, say so honestly

Required output sections:

1. `PRIMARY_FAMILY_CANDIDATE`
- name the most plausible family
- explain why it currently wins

2. `COMPETING_FAMILIES_CONSIDERED`
- list the main alternatives
- explain why they currently lose or remain secondary

3. `PATTERN_CANDIDATE`
- if a pattern candidate exists, name it
- explain what confirms it
- explain what would reject it
- if no pattern is clean yet, say so

4. `ANTI_HABITAT_WARNINGS`
- list what currently weakens the leading family or pattern

5. `MISSING_SURFACES_THAT_COULD_CHANGE_THE_RANKING`
- what extra upstream truth could materially change the result?

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
