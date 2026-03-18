# AURORA WAVE 1 CROSSLINK MAP

## PURPOSE

This file executes Q3 from `AURORA_EXTRACTION_QUEUE.md`.

Its job is to cross-link the two grounded Wave 1 doctrine files:
- `AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md`

This file exists so future chats can keep a clean boundary between:
- **what structural condition the auction is in**
- **how much practical deployment trust that condition deserves**

Without this boundary, Aurora risks collapsing structure and deployability into one blurry label.

---

# 1. ACTIVE WAVE 1 DOCTRINE PAIR

## Structural doctrine
- `AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md`

Use this file to answer:
- what state the market is in
- how the auction is behaving
- whether trade is rotational, discovering, failing, or unstable

## Execution-context doctrine
- `AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md`

Use this file to answer:
- how trustworthy the visible opportunity is
- whether location, conviction, and facilitation quality support deployment
- whether the condition is practically deployable or structurally valid but low-trust

---

# 2. PRIMARY BOUNDARY RULE

Aurora must apply interpretation in this order:

1. identify the structural state
2. evaluate the deployment surface
3. only then later consider family-level or tactical implications

State comes first.
Deployability comes second.
Execution-context does not replace state classification.

---

# 3. CORE STATE-TO-SURFACE RELATIONSHIPS

## 3.1 Balance State -> Location and responsiveness dominate trust

### Structural side
Balance State means the market is facilitating two-sided trade around accepted value and directional migration is not dominant.

### Execution-context side
In balance:
- location quality matters strongly
- middle-of-range opportunity is lower quality
- responsive activity is often more relevant than initiative activity
- visible movement in the middle of balance often has poor practical quality

### Cross-link rule
When Aurora labels **Balance State**, it should immediately ask:
- is this opportunity near meaningful location or just inside accepted rotation?
- is responsive activity likely to dominate here?
- is this a nonconviction / stay-out surface despite visible movement?

### Main anti-error
Do not let a valid Balance State automatically imply actionable rotation quality everywhere inside the bracket.

---

## 3.2 Directional Discovery State -> Directional trust must confirm the state

### Structural side
Directional Discovery State means the auction is migrating away from prior balance with initiative, asymmetry, and directional performance.

### Execution-context side
A directional move may still have:
- low directional trust quality
- weak facilitation quality
- inventory distortion risk
- poor location for late deployment

### Cross-link rule
When Aurora labels **Directional Discovery State**, it should immediately ask:
- is this discovery supported by acceptance?
- is directional performance strong enough to justify trust?
- is this real migration or only attempted direction?
- is the move already too extended to remain high-trust?

### Main anti-error
Do not collapse “discovery exists” into “continuation trust is high.”

---

## 3.3 Failed Break / Trap State -> Responsive-surface quality usually rises

### Structural side
Failed Break / Trap State means an attempted directional move lost acceptance and reverted back through the initiating structure.

### Execution-context side
This often aligns with:
- responsive activity
- return-to-value surface
- excess / exhaustion surface
- stronger trust in rejection than in continuation

### Cross-link rule
When Aurora labels **Failed Break / Trap State**, it should immediately ask:
- is responsive activity now dominant?
- is the move better interpreted as return-to-value than renewed continuation?
- is the surface supporting rejection logic rather than fresh breakout trust?

### Main anti-error
Do not keep breakout-quality trust after structural failure is already evident.

---

## 3.4 Transitional / Unstable State -> Nonconviction surface risk rises sharply

### Structural side
Transitional / Unstable State means the prior state is degrading and the next stable state is not yet clearly established.

### Execution-context side
This often aligns with:
- nonconviction / stay-out surface
- low directional trust quality
- weak facilitation quality
- mixed location/context signals

### Cross-link rule
When Aurora labels **Transitional / Unstable State**, it should immediately ask:
- is this a structurally mixed condition with poor deployment trust?
- is the market active enough to tempt action, but too unclear for confidence?
- should visible opportunity be discounted heavily here?

### Main anti-error
Do not force a deployable read out of structurally unresolved transition.

---

# 4. CONCEPT-TO-CONTEXT CROSSLINKS

## 4.1 Acceptance <-> Discovery-with-Trust Surface
Acceptance strengthens deployment trust in a directional condition.
A move that earns acceptance is more credible than one that merely prints outside structure.

## 4.2 Rejection <-> Return-to-Value / Responsive Surface
Rejection strengthens the case that the market is facilitating return rather than continued migration.

## 4.3 Excess <-> Excess / Exhaustion Surface
Excess reduces continuation trust and increases transition / rejection relevance.

## 4.4 Value <-> Location Quality
Location quality must always be judged in relation to value and accepted trade, not just raw pattern shape.

## 4.5 Initiative Activity <-> Directional Trust Quality
Initiative activity improves the odds of deployable directional movement only when directional performance and acceptance are also present.

## 4.6 Responsive Activity <-> Return-to-Value Surface
Responsive activity often improves the trust of return-to-value logic and reduces continuation trust.

## 4.7 Attempted Direction <-> Low-Trust Discovery Risk
Attempted direction without sufficient directional performance should map to lower deployment trust even if the structural state is trying to turn directional.

## 4.8 Inventory Imbalance <-> Inventory Distortion Risk
Inventory imbalance is one of the main reasons a visible move may be structurally interesting but practically low-trust.

---

# 5. WAVE 1 DECISION ORDER FOR FUTURE CHATS

When analyzing a Wave 1 condition, future chats should apply this order:

## Step 1 — Structural read
Use `AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md` to classify the state.

## Step 2 — Surface read
Use `AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md` to classify trust/deployability.

## Step 3 — Cross-link check
Use this file to test whether the chosen surface reading actually fits the state.

## Step 4 — Only then proceed later
Only after state and surface are consistent should future family or pattern logic be introduced.

---

# 6. MAIN FAILURE MODES THIS FILE IS PREVENTING

## Failure Mode 1 — State collapse into deployability
Example:
- calling something “good continuation” just because the state is directional

## Failure Mode 2 — Deployability overriding structure
Example:
- calling something tradable because it looks clean while ignoring that the structural state is unstable

## Failure Mode 3 — Pattern-first thinking
Example:
- starting with a visual setup before establishing state and surface relationship

## Failure Mode 4 — Opportunity inflation inside balance
Example:
- overrating movement inside accepted rotation without location-quality support

## Failure Mode 5 — Breakout trust after structural failure
Example:
- staying in breakout logic after failed directional performance and rejection are already visible

---

# 7. CURRENT WAVE 1 USE RULE

For current Wave 1 work, future chats should treat this file as the active bridge between:
- `AURORA_MARKET_STATE_CANON_Q1_INTEGRATED.md`
- `AURORA_EXECUTION_CONTEXT_SURFACE_Q1_INTEGRATED.md`

Use it whenever:
- refining state-vs-surface distinctions
- integrating future source passes into Wave 1 doctrine
- preparing for later strategy-family unlock decisions

---

# 8. NEXT ACTIONS AFTER Q3

1. update `AURORA_PROGRESS_TRACKER.md` so it explicitly records:
   - Q1 pass complete for upload set 001
   - grounded market-state canon exists
   - grounded execution-context doctrine exists
   - Wave 1 cross-link map exists

2. update control files later so they explicitly point to the integrated Wave 1 doctrine files and this bridge file

3. then prepare the next source pass or the next upload set for Wave 1 strengthening

---

# 9. CURRENT JUDGMENT

Wave 1 now has:
- grounded structural doctrine
- grounded deployability doctrine
- an explicit bridge between them

That is enough to keep future Q1 work from drifting back into scaffold-only language or pattern-first confusion.
