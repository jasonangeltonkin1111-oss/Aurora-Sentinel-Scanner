# AURORA GROUP / BUCKET / REGIME ROUTING PROTOCOL

## PURPOSE

This file corrects and locks an important Aurora-side rule.

Aurora strategy families are **not symbol-bound**.
Aurora should not behave like:
- one family = one symbol
- one packet = one pair-only ruleset
- one lane = EURUSD logic, then separate isolated logic for each other symbol

Aurora should instead route by:
- regime
- asset class
- bucket class
- group type
- correlation / related-behavior cluster when useful

This file exists to keep Aurora from drifting into symbol-specific overfitting or pair-specific tunnel vision.

---

# 1. ROOT LAW

Aurora families are cross-symbol logic classes.

A family describes:
- a structural behavior
- a failure/continuation/reversion logic class
- a deployability shape
- a geometry logic class

A symbol does not own a family.
A family may appear across many symbols if the market behavior belongs to the same regime and bucket-compatible context.

---

# 2. ROUTING ORDER

Aurora should prefer this routing order:

1. **asset class**
2. **primary bucket**
3. **group type / subtype / theme bucket when useful**
4. **regime / state**
5. **family competition**
6. **pattern competition**
7. **symbol-specific constraints only after the family lane is already plausible**

This means the normal question is not:
- “what are the EURUSD rules?”

The normal question is:
- “what regime is present?”
- “what bucket/group class is this instrument in?”
- “which family tree belongs to that regime and class?”
- “what symbol-specific constraints matter only after that?”

---

# 3. WHY THIS RULE EXISTS

The operator’s market universe is broad and classified.
The uploaded classification layer already preserves fields such as:
- `AssetClass`
- `PrimaryBucket`
- `Sector`
- `Industry`
- `ThemeBucket`
- `SubType`

That means Aurora should grow around **classification-aware routing**, not isolated symbol recipes.

This is especially important because:
- some symbols are highly correlated
- some symbols share structural behavior by bucket or subtype
- some symbols differ in friction but still belong to the same family tree
- deployability can vary without changing the underlying family class

---

# 4. WHAT A FAMILY SHOULD MEAN

A family should define:
- structural thesis
- primary market habitat
- main competing families
- failure logic
- deployability sensitivities
- geometry sensitivities
- packet logic

A family should **not** define:
- one hardcoded symbol
- one broker-specific rule set
- one pair-only identity

A family is a behavior class, not a ticker identity.

---

# 5. WHAT A SYMBOL SHOULD DO

A symbol should act as:
- one candidate member of a broader bucket/group environment
- one carrier of the current regime/state
- one instance where deployability and geometry must be checked

The symbol may add constraints such as:
- burden / friction
- session behavior
- microstructure distortion
- correlation conflicts

But the symbol does not redefine the family itself.

---

# 6. BUCKET / GROUP ROUTING LAW

Aurora should increasingly think in these layers:

## 6.1 Asset class layer
Examples:
- FX
- Stocks
- Indices
- Metals
- Energy
- Crypto

## 6.2 Primary bucket layer
Examples inside FX:
- FX_MAJOR
- FX_CROSS
- FX_EXOTIC

Examples elsewhere may include sector, index type, metal type, or other scanner-classified buckets.

## 6.3 Group / subtype / theme layer
Useful examples:
- JPY-linked crosses
- commodity-linked FX
- bank stocks
- energy-linked products
- growth versus defensives
- correlated regional themes

## 6.4 Regime / state layer
Examples:
- balance
- breakout attempt
- failed break / reclaim
- trend continuation
- unstable trap-on-trap conditions

Only after these layers should Aurora narrow to a symbol instance.

---

# 7. FAMILY TREE LAW

Aurora should think in family trees, not isolated symbol rules.

Example:
- one failed-break / reclaim family tree may apply across multiple FX majors, crosses, indices, or stocks when the structural regime is analogous
- one continuation family tree may apply across many instruments in the same regime class
- one balance-rotation family tree may apply across many instruments in range/balance conditions

This does not erase asset-class differences.
It means the family logic travels farther than one symbol.

---

# 8. CORRELATION / RELATED-BEHAVIOR LAW

Aurora should remain aware that some symbols are highly correlated or behaviorally linked.

That means later packet and worked-example design should allow:
- group examples
- sibling-symbol comparisons
- one regime tree applied across related instruments

This is stronger than building isolated symbol notebooks.

---

# 9. WHAT THIS CHANGES FOR PACKETS

Packets should increasingly be designed as:
- family-lane packets
- bucket-aware packets
- group-aware worked examples

rather than:
- symbol-only rule sheets

A worked example may still use one symbol.
But the packet should explain:
- which broader bucket/group tree the symbol belongs to
- what other related instruments could express the same lane
- what is family logic versus what is symbol-specific constraint

---

# 10. WHAT THIS CHANGES FOR STRATEGY CARDS

Generated strategy cards should remain symbol-specific outputs.

But their lineage should point back to:
- family tree
- bucket logic
- group-type logic
- regime/state interpretation

So the card is symbol-specific at output time,
while the family logic remains cross-symbol and regime-driven.

---

# 11. FORBIDDEN DRIFT

Aurora must not drift into:
- one-symbol notebooks
- pair-only doctrine trees
- rule sheets that treat each ticker as a separate strategy universe
- “EURUSD card = EURUSD-only law” thinking

That would weaken transferability and increase generic overfitting.

---

# 12. CURRENT JUDGMENT

Aurora is now explicitly locked to group / bucket / regime routing.

That means:
- families stay broad enough to travel across related instruments
- cards may still be symbol-specific outputs
- packets and examples should increasingly explain the broader tree the symbol belongs to

This is the correct path for a multi-asset, classification-aware execution-intelligence system.
