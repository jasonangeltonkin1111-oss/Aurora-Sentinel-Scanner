# ASC Layer Model Deep Spec

## Layer overview

The active ASC design is a 5-layer processing architecture.

These are **architecture ownership names**.
They are not trader-facing labels.

## Layer 1 — Open / Closed State

### Purpose
Determine whether each symbol is open, closed, uncertain, unknown, or weakly open.

### Owns
- evidence fusion for market state
- next recheck scheduling
- near-open aggressive rechecks
- minimum symbol-file creation
- continuity support for market-state persistence

### Does not own
- ranking
- summary leadership
- deep indicators
- surface scoring

### Inputs
- tick evidence
- quote evidence
- trade sessions
- permissions/trade mode
- prior continuity

### Outputs
- current status
- confidence
- next check
- next expected open
- market-state reason code

## Layer 2 — Open Symbol Snapshot

### Purpose
Maintain a controlled current snapshot for symbols that are open enough to matter now.

### Owns
- merge of live market-watch fields
- optional spec projection into open-state view
- freshness metadata for live snapshot
- snapshot publication blocks

### Does not own
- scoring
- filtering decisions
- selection
- deep analysis

### Key law
It is valid for a symbol to have a Layer 1 file block even if Layer 2 is pending.
Layer 2 should not erase Layer 1 truth.

## Layer 3 — Filter

### Purpose
Cheaply reduce the candidate set using low-cost validity and usefulness checks.

### Owns
- invalidity gates
- spread sanity gates
- stale/suspicious feed gates
- low-activity / low-usefulness gates
- cheap bucket eligibility
- survivor metadata

### Does not own
- final rank authority
- deep history pipelines
- trade strategy logic

### Typical fields
- eligible yes/no
- filter reason list
- bucket
- penalty factors
- spread state
- freshness state

## Layer 4 — Top-List Selection

### Purpose
Choose a bounded active set from filtered symbols within buckets.

### Owns
- rank scoring for promotion quality
- bucket competition
- anti-churn controls
- shortlist cap
- selected set synchronization

### Does not own
- broad-universe retrieval
- long rolling deep metrics
- trader decision logic

### Important law
Selection is not a trading recommendation.
It grants deeper computation budget.

## Layer 5 — Deep Selective Analysis

### Purpose
Maintain rolling deeper analytics only for the promoted bounded set.

### Owns
- tick buffers
- timeframe OHLC views
- ATR by timeframe
- selective indicator families
- deeper dossier blocks
- deep freshness markers

### Does not own
- full universe coverage
- cheap first-pass truth
- broad publication ownership outside its own blocks

## Layer mapping to older archive

### Old 3-layer model
- Layer 1 — Universe heartbeat
- Layer 2 — Active surface
- Layer 3 — Deep shortlist

### New 5-layer model mapping
- New Layer 1 aligns with old universe truth
- New Layer 2 is the open-snapshot split-out
- New Layer 3 and 4 together replace old active surface competition
- New Layer 5 aligns with old deep shortlist

## Dirty propagation rules

Layer transitions should be explicit.

Examples:
- Layer 2 snapshot materially changed -> mark Layer 3 dirty
- Layer 3 eligibility changed -> mark Layer 4 bucket dirty
- Layer 4 membership changed -> mark Layer 5 membership sync dirty
- Layer 5 deep update completed -> mark publication block dirty

## Churn control

Selection should not flap on tiny changes.
Use:
- hold times
- hysteresis bands
- promotion/demotion reasons
- frozen/deferred deep continuity when symbols leave the shortlist

## Layer ownership anti-patterns

Do not let:
- Layer 1 compute ATR
- Layer 2 decide bucket leaders
- Layer 3 load heavy history for all symbols
- Layer 4 rebuild broker specs
- Layer 5 silently rewrite the summary

## Recommended implementation stance

Represent each layer as:
- clear service family
- own DTO block
- own freshness/validity metadata
- own write section(s)
- own due tasks
- own downstream dirtiness triggers
