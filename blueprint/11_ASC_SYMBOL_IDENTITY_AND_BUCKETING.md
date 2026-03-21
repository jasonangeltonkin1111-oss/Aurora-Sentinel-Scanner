# ASC Symbol Identity and Bucketing

## Purpose

This file defines the ASC symbol identity and bucketing surface.

It exists to separate:
- market-state truth
from
- symbol identity truth
from
- future filtering and shortlist logic

Market State Detection answers:
- is this symbol open, closed, uncertain, or unknown?
- when should it be checked again?

Symbol Identity and Bucketing answers:
- what is this symbol really?
- how should broker-specific aliases normalize?
- what canonical identity should survive across brokers?
- what asset class, bucket, sector, industry, and theme should later capabilities consume?

This capability must remain distinct from strategy logic and must not be folded into Market State Detection.

## Why this capability exists now

ASC already needs a stable future surface for:
- bucket-aware explorer views
- later bucket-preserving shortlist logic
- later cross-bucket combined shortlist logic
- operator-readable symbol drilldown
- Aurora downstream interpretation
- canonical trade-state matching later

The legacy AFS classification system already demonstrates the required record shape and normalization law.
The legacy source includes fields such as:
- `ServerKey`
- `RawSymbol`
- `CanonicalSymbol`
- `DisplayName`
- `AssetClass`
- `PrimaryBucket`
- `Sector`
- `Industry`
- `ThemeBucket`
- `SubType`
- `AliasKind`
- `Confidence`
- `ReviewStatus`
- `Notes`

and helper logic for:
- suffix stripping
- punctuation removal
- server-aware matching
- broker alias normalization
- canonical symbol lookup

That legacy source is evidence, not active authority. ASC must preserve the contract quality without inheriting the legacy file shape blindly. 

## Capability status

Current status:
- blueprint-active
- runtime-active but provisional
- classification-driven bucket preparation is active for current Layer 1 explorer use
- runtime-owned bucket preparation now includes a compressed Layer 1 main-bucket adapter for the first operator surface
- prepared bucket truth is runtime-owned and explorer-consumed
- not yet trusted as fully mature downstream identity truth

This capability is active enough to support the current Explorer bucket flow, but Market State Detection remains the only fully working capability. Taxonomy depth, confidence posture, and publication wording still need hardening before later downstream systems should treat identity/bucketing as fully trusted identity truth.

## Capability ownership

### Owns
- raw symbol normalization
- broker suffix stripping rules
- punctuation normalization rules
- broker alias resolution
- server-aware classification matching
- canonical symbol assignment
- display-name assignment
- asset-class assignment
- primary-bucket assignment
- sector assignment
- industry assignment
- theme-bucket assignment
- subtype assignment
- alias-kind assignment
- confidence and review-status metadata
- notes and manual-review carryforward
- prepared dynamic bucket membership truth for the active runtime bucket surface
- bucket summary source data for explorer adapters and later downstream consumers

### Does not own
- market-state classification
- next-check scheduling
- dossier write timing
- due-based heartbeat rules
- candidate filtering decisions
- shortlist ranking decisions
- deep selective analysis
- execution decisions
- trade placement
- HUD-side classification or render-path bucket rebuilding

## Classification record contract

The clean ASC record should preserve at least:

- `Raw Symbol`
- `Normalized Symbol`
- `Canonical Symbol`
- `Display Name`
- `Asset Class`
- `Primary Bucket`
- `Sector`
- `Industry`
- `Theme Bucket`
- `Sub Type`
- `Alias Kind`
- `Confidence`
- `Review Status`
- `Notes`

Optional future additions may include:
- `Server Scope`
- `Exchange Region`
- `Lifecycle Class`
- `Instrument Family`
- `Canonical Group Key`

## Resolution status model

A symbol identity result should remain honest.

Suggested statuses:
- `RESOLVED`
- `PARTIAL`
- `ALIAS_MATCH`
- `SERVER_MATCH`
- `UNRESOLVED`
- `NEEDS_REVIEW`

The system must not pretend all mappings are equally trustworthy.
Confidence and review status must survive into later publication and UI surfaces.

## Identity law

Canonical identity must survive broker variation.

Examples of variation classes:
- broker suffixes such as `.nx`, `.m`, `.c`, `.pro`
- punctuation variants such as `.`, `_`, `-`
- exchange aliases such as `AAPL.OQ` versus `AAPL.US`
- server-specific raw symbol variants
- regional listing variants such as `0388.HK` versus `388.xhkg`

The classification surface must preserve both:
- the raw broker truth
- the canonical normalized truth

## Bucketing law

Bucket assignment must be stable enough for later capabilities.

It should support:
- bucket list exploration
- bucket-preserving shortlist logic
- cross-bucket diversity logic later
- later de-duplication and correlation control

Primary bucket remains the rich taxonomy truth for classification.
The first operator surface must map that richer truth into exactly six compressed Layer 1 main buckets: `FX`, `Indices`, `Metals`, `Energy`, `Crypto`, and `Stocks`.
Sector, industry, theme, and subtype remain secondary and must be preserved alongside canonical symbol metadata for future drilldown, later regional stock grouping such as `US Stocks`, `EU Stocks`, and `HK Stocks`, and Aurora context.

## Dynamic bucket preparation law

Dynamic bucket membership shown in the HUD is runtime-prepared truth.
The current runtime already prepares and caches:
- classified symbol membership by compressed Layer 1 main bucket
- membership counts and summary rollups
- identity-backed symbol cards or references for bucket detail views
- invalidation markers when runtime-owned bucket truth is refreshed

That active preparation is still provisional. Taxonomy depth, confidence posture, and publication wording remain subject to further hardening before this should be treated as fully trusted downstream identity truth.

The HUD must consume prepared bucket membership and summaries through adapters.
Prepared symbol metadata must still carry the richer classification fields (`primary_bucket`, sector, industry, theme bucket, subtype) plus canonical symbol metadata and stock secondary-group metadata even when the visible bucket page only shows the compressed Layer 1 grouping.
It must not classify symbols, rebuild active membership, or walk raw identity catalogs during render.

## Data-source law

Preferred future source order:
1. explicit active ASC classification source
2. server-aware override entries
3. trusted alias normalization rules
4. unresolved manual-review state

The system must not rely forever on one giant embedded legacy blob.
The future runtime should support:
- a seed catalog
- override layers
- review workflow later if needed

## Explorer/UI implications

The explorer HUD should consume this capability for:
- bucket list generation
- bucket summary cards
- symbol identity cards
- canonical symbol display
- sector / industry / theme drilldown
- future combined-summary grouping

The HUD must not itself perform heavy classification logic.
It should consume already prepared identity records and prepared bucket snapshots.

## Publication implications

Future dossiers should expose an active-but-provisional identity/bucketing section for current Layer 1 explorer use while keeping later capability sections reserved. That section should contain:
- raw symbol
- canonical symbol
- display name
- asset class
- primary bucket
- sector
- industry
- theme bucket
- subtype
- confidence
- review status

This should be machine-parseable and human-readable.

## Refresh and stale law

Identity and bucketing truth are not render-time derivations.
When active, they must obey the same runtime laws as other HUD-visible surfaces:
- bucket or identity fields refresh on owned cadence, not on redraw
- focused bucket or symbol views may request bounded refresh only for stale, identity-owned fields
- expensive reclassification or catalog rebuilds remain cold/background work unless the owning capability explicitly schedules them
- cached prepared membership may stay visible until invalidated or expired by owned rules

## Future build shape

Recommended future code ownership:

```text
Include/ASC/
  Identity/
    ASC_IdentityTypes.mqh
    ASC_IdentityNormalize.mqh
    ASC_IdentityLookup.mqh
    ASC_IdentityCatalog.mqh
    ASC_IdentityOverrides.mqh
```

The exact code split may evolve, but identity and bucketing should not disappear into `Common` or into Market State Detection.

## Final rule

Symbol Identity and Bucketing is the canonical ASC answer to:
- what symbol is this?
- what canonical instrument does it map to?
- what bucket and taxonomy should later capabilities consume?

It must stay separate from market-state logic and separate from strategy logic.

## Dynamic bucket view-model bridge

The explorer currently consumes a runtime-prepared dynamic bucket view-model rather than fixed bucket slots.
That view-model is classification-driven and active for current Layer 1 use, but it should still be treated as provisional runtime truth rather than final downstream identity canon.

The bucket render contract should carry at least:
- bucket id
- bucket name
- family
- posture
- note
- resolved symbol count
- dynamic symbol references
- current display mode
- snapshot freshness / invalidation metadata

Prepared symbol references must remain honest:
- canonical references are allowed
- broker tradability must not be implied beyond current runtime evidence
- unresolved symbols must stay outside prepared bucket membership until safely classified
- filtering, shortlist, Aurora interpretation, and execution logic must not be implied by this active Layer 1 surface

The HUD should be able to consume any bucket count and any per-bucket symbol count without structural rewrite.
