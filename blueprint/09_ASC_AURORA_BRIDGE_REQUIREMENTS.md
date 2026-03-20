# ASC Aurora Bridge Requirements

## Purpose

This file defines what ASC must provide as an upstream scanner foundation so Aurora can consume trustworthy sensing state later without forcing ASC to become an execution or intelligence system.

## Bridge boundary law

ASC and Aurora must remain different systems.

ASC owns:
- broker-facing sensing
- rolling symbol continuity
- storage discipline
- runtime continuity
- canonical dossier publication
- summary scaffolds
- scanner-side freshness and availability truth

Aurora owns:
- execution-context interpretation
- strategy-family reasoning
- thesis selection
- scenario modeling
- feasibility refinement beyond scanner truth
- any future execution or simulation workflow

ASC must never absorb Aurora execution or thesis logic just because Aurora will consume ASC outputs later.

## What ASC must produce

ASC must provide a server-scoped sensing surface that is:
- stable across restarts
- human-readable for operators
- machine-parseable for future Aurora ingestion
- honest about freshness, gaps, and degraded state
- broad across the broker universe before any later narrowing

Minimum bridge-ready output classes:
1. symbol identity continuity
2. market-state continuity
3. scheduler continuity
4. runtime health continuity
5. dossier publication continuity
6. summary publication continuity

## Minimum symbol truth Aurora will likely depend on

Aurora should be able to trust ASC to provide, when available:
- symbol name
- server identity
- dossier path / publication identity
- market status: open, closed, uncertain, unknown
- last tick seen time
- tick freshness state
- trade-session availability
- next expected recheck
- next known session open when available
- runtime mode context when the dossier was written
- degraded / recovered continuity markers
- placeholder honesty when deeper sections are not yet populated

ASC does not need to decide what these mean for execution.
ASC only needs to keep them truthful, current enough, and clearly labeled.

## Quality guarantees ASC must provide

### 1. Identity guarantee
The same broker server should resolve to the same storage root and dossier family every restart.

### 2. Freshness guarantee
ASC must distinguish:
- current
- stale
- pending
- unavailable
- restored from continuity

Aurora must not be forced to infer freshness from silence.

### 3. Continuity guarantee
If ASC restarts, it should preserve the last known good scanner state when safe and rebuild only what is missing, invalid, or due.

### 4. Degradation guarantee
If work is bounded or the platform is under pressure, ASC must say so explicitly in runtime or publication state rather than silently pretending coverage is complete.

### 5. Output integrity guarantee
Canonical dossier and summary outputs must be restart-safe and protected against partial-write corruption.

## What ASC must never do for the bridge

ASC must not:
- rank symbols for Aurora under this foundation pass
- decide strategy family suitability
- invent deployability judgments
- mix account or trade-history identity into storage paths
- hide uncertainty with placeholder zeros
- require Aurora to parse office or archive files for live truth
- leak dev-language naming into the canonical symbol dossiers

## Bridge timing expectations

ASC must make it easy for Aurora later to reason about:
- when the symbol was last checked
- when the next check is expected
- whether the market state is fresh or uncertain
- whether the scanner was in warmup, steady, recovering, or degraded mode
- whether a dossier reflects newly sensed truth or preserved prior continuity

The scanner does not need Aurora-speed microstructure.
It does need continuity and honesty about timing.

## Canonical interface direction

The preferred future bridge direction is:
- ASC writes canonical dossier files and continuity files under MT5 Common Files
- Aurora or a wrapper ingests those files as scanner truth inputs
- Aurora remains free to reject, reinterpret, or enrich that truth without forcing ASC to become a strategy engine

## File contract guidance

Bridge-friendly scanner outputs should include, directly or indirectly:
- schema version
- generated-at timestamp
- runtime mode
- degraded marker
- recovery marker when relevant
- symbol freshness fields
- clearly reserved future sections instead of fake completion
- execution-context friction or deployability surfaces as Reserved future scanner pressure

## Final rule

ASC is the trustworthy sensing and continuity layer.
Aurora is the downstream interpretation and execution-intelligence layer.
The bridge succeeds only if ASC stays honest, bounded, and stable rather than trying to become Aurora early.
