# RANKING AND PROMOTION CONTRACT

## Status
Active blueprint law.

This file defines what ranking means in ASC and how symbols earn activation rights.

---

## Core Principle
Ranking is not a signal engine.
Ranking is not trade selection.
Ranking is the promotion mechanism that decides which symbols are worthy of active computation budget.

---

## What "Top 5" Means
Within each `PrimaryBucket`, the top 5 are the symbols that most deserve activation for deeper computation at the current surface-scan stage.
If fewer than five symbols in a bucket meet ranking validity, the promoted set for that bucket is the truthful smaller count, not padded output.

This does not mean:
- the five best trades
- the five biggest movers
- the five most volatile symbols in raw absolute terms

It means:
- the five strongest active-computation candidates under current broker/symbol truth and Layer 2 integrity

---

## Minimum Eligibility for Ranking
A symbol must not participate as a normal ranking candidate unless required Layer 2 truth is sufficiently valid.

Minimum requirements may include:
- Layer 1 eligibility
- resolved or policy-handled classification
- usable quote/trade surface
- required M15/H1 availability
- required spec integrity
- surface metrics integrity

Symbols failing minimum eligibility may be logged/reported separately but must not be promoted as if fully trustworthy.

---

## Score Design Rule
Ranking score must be designed around promotion quality, not trade excitement.

The score may consider things such as:
- surface integrity
- quote freshness
- spread sanity
- friction sanity
- history availability
- movement capacity / usefulness
- bucket-relative usefulness for deep follow-up

The score must not pretend to be a trade decision.

---

## Bucket Rule
Summary grouping and promotion grouping use `PrimaryBucket` from Market classification.

Forbidden:
- hardcoded replacement bucket systems in Output
- downstream bucket invention
- guessing unresolved bucket membership

If classification fails and policy allows continued visibility, bucket must remain `UNKNOWN`.

---

## Promotion Rule
A symbol becomes ACTIVE only if:
- it satisfies Layer 1 truth conditions
- it satisfies minimum ranking validity conditions
- it places within the promoted set for its `PrimaryBucket`
- no fail-fast exclusion blocks promotion

Promotion grants Layer 3 dossier rights.

---

## Non-Promotion Rule
A symbol remains INACTIVE if:
- it does not place within the promoted set
- required truth is materially incomplete or invalid
- fail-fast rules block promotion
- integrity is too weak for trustworthy continuation

---

## Tie / Overflow Rule
If more than five symbols appear equivalent near the boundary, the implementation must apply deterministic tie handling.
Do not let unstable ordering create random activation churn.
At minimum, ties that remain after score comparison must fall back to a stable symbol-identity order: canonical symbol ascending when available, otherwise normalized/raw symbol ascending.

---

## Output Rule
`SUMMARY.txt` is both:
- a trader-facing shortlist view
- the visible activation authority surface

The promoted set is decided by ranking truth before writing. Writers publish that promoted set but do not decide it.
Only promoted symbols may gain active dossier continuation rights.

---

## Completion Standard
Ranking is complete only when ASC can truthfully and consistently choose the top 5 per `PrimaryBucket` as active-computation candidates, without turning ranking into trade signaling or bucket invention.
