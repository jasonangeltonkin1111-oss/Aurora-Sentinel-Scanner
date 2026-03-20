# AURORA PILOT FAMILY LANE PACKET 001

## PURPOSE

This file is the first pilot lane scaffold for proving that Aurora’s new bridge architecture can work end to end.

It is intentionally a scaffold, not a final implementation packet.

It exists so the repo can move from:
- doctrine surfaces
- bridge protocols
- object model theory

into:
- one realistic pilot lane the user can understand and later test manually

---

# 1. WHY A PILOT LANE IS NEEDED

Aurora now has:
- context contract
- deployability protocol
- generated strategy-card protocol
- opportunity inventory protocol
- EA-safe boundary spec
- intraday geometry protocol
- wrapper object model

But those files are still architecture surfaces.

A pilot lane is needed to answer:
- what does one real family path look like through the chain?
- what should the user actually do with one symbol?
- where does ambiguity still remain?

---

# 2. FIRST PILOT LANE CHOICE

The recommended first pilot lane is:
- failed break / trap reversal style logic
- reclaim / failed break family lane

Reason:
- the repo already treats this as a strong build-ready lane conceptually
- it naturally forces distinctions between structure validity and geometry validity
- it naturally benefits from deployability, session, and execution-surface realism

This file does not redefine the family doctrine.
It only defines how that lane should be piloted through the new object chain.

---

# 3. PILOT LANE FLOW

For the pilot lane, the operator should walk the chain in this order:

## Step 1 — ASC context
Read:
- symbol identity
- market status
- tick freshness
- session truth
- spread / execution truth

## Step 2 — Market state
Ask:
- is this balance, directional discovery, failed auction, reclaim, or something else?

## Step 3 — Execution surface
Ask:
- is the move practically tradable or only visually interesting?

## Step 4 — Deployability
Ask:
- does the path meaningfully outweigh burden?
- does the symbol need standard or wider intraday handling?

## Step 5 — Family competition
Ask:
- is the failed break / trap reversal family really the best interpretation?
- what is the main competing family?

## Step 6 — Pattern candidate
Ask:
- is reclaim / failed break confirmation actually present?
- what would reject the pattern?

## Step 7 — Opportunity object
Classify:
- eligible
- eligible degraded
- observe only
- execution invalid
- structure invalid

## Step 8 — Generated strategy card
Only if enough truth exists.
Then emit:
- entry logic
- invalidation logic
- target logic
- timebox logic
- execution constraints

---

# 4. WHAT THE USER SHOULD LEARN FROM THIS PILOT

This pilot lane should teach the user:
- how one family moves through the object chain
- why not every valid idea becomes a card
- why not every card becomes EA-safe
- why deployability and geometry are separate from family doctrine

---

# 5. WHAT STILL REMAINS OPEN

This scaffold still needs later linking to:
- exact family and pattern file references once those are normalized for pilot use
- example symbol walkthroughs
- wrapper prompt templates for this lane
- later EA-safe subset examples

This is intentional.
The goal of this file is to give the user a concrete first lane without pretending the lane is fully automated already.

---

# 6. CURRENT JUDGMENT

Aurora now has a first pilot implementation scaffold.

The project can now move from architecture-only thinking into one concrete lane the user can study, run manually, and later turn into repeatable wrapper behavior.
