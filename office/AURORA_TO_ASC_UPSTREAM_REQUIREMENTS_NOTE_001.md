# Aurora to ASC Upstream Requirements Note 001

## Purpose

This file is an ASC-facing note.

It exists because ASC is the foundation and battlefield selector.
Aurora must align more tightly with ASC truth rather than inventing missing context downstream.

This note does not redesign ASC.
It names the next upstream fields and surfaces ASC should expose more clearly so Aurora can grow on top of them without becoming generic.

---

## Root law

ASC is the master foundation.
ASC chooses the battlefield by publishing measured world truth.
Aurora executes only after that truth exists.

Therefore:
- when Aurora needs a surface repeatedly
- and that surface belongs upstream
- ASC should eventually expose it explicitly

Aurora should not compensate forever with guesswork.

---

## Highest-priority ASC surfaces Aurora needs

These are the clearest next upstream requirements seen from the Aurora side.

### 1. Session / timebox truth must become more explicit
Aurora now depends more heavily on intraday geometry and timebox logic.

ASC should expose clearly where possible:
- `current_session_label`
- `within_trade_session`
- `minutes_to_session_close`
- `next_session_open`
- session transition / dead-zone awareness if available

Reason:
Aurora cannot build trustworthy intraday geometry if session truth stays vague.

---

### 2. Execution / friction truth must become more explicit
Aurora now has a deployability engine and needs better upstream burden truth.

ASC should expose clearly where possible:
- `current_spread`
- `rolling_median_spread`
- `spread_state_class`
- `spread_instability_flag`
- `quote_health_state`
- `stale_tick_risk`
- `execution_continuity_state`

Reason:
Aurora must compare path potential against burden.
Without these fields, Aurora degrades to observe-only or uncertain deployability.

---

### 3. Runtime freshness / degradation truth must stay machine-clear
Aurora now depends more on knowing whether ASC truth is fresh enough to trust.

ASC should keep exposing clearly:
- `publication_health`
- `publication_state_class`
- `lifecycle_state`
- `runtime_mode`
- `reason_code` for degraded or unavailable states

Reason:
Aurora should never mistake stale truth for live truth.

---

### 4. Range / compression / expansion surfaces are now more valuable
Aurora now has explicit geometry and opportunity-preservation layers.

ASC should consider exposing more clearly over time:
- `range_expansion_state`
- `compression_state`
- `snapshot_change_rate`
- `abnormal_gap_flag`

Reason:
These are not required for the minimum bridge, but they would make deployability and geometry much stronger.

---

### 5. Selection / shortlist surfaces should remain visible downstream
ASC remains the battlefield selector.
Aurora benefits from knowing what ASC already considers more active or relevant.

ASC should expose clearly where possible:
- `selection_rank`
- `top_list_membership`
- shortlist / ranking state when available

Reason:
This helps Aurora preserve opportunities without trying to replace ASC’s scanner role.

---

## What ASC should not do

This note does not ask ASC to own:
- family selection doctrine
- pattern interpretation
- trade geometry
- entry / stop / target logic
- execution-side narratives

Those stay on the Aurora side.

ASC should only strengthen upstream truth surfaces that Aurora depends on.

---

## Practical ASC-side use

ASC-side workers should use this note as a simple question:

> Does Aurora now depend on a surface that ASC should expose more clearly upstream?

If yes:
- add or clarify the field in ASC truth surfaces
- update dossier or runtime contracts where appropriate
- do not add execution doctrine into ASC

---

## Relationship to Aurora-side files

This office note is the ASC-facing companion to:
- `Aurora Blueprint/ASC_TO_AURORA_CONTEXT_CONTRACT.md`
- `Aurora Blueprint/AURORA_DEPLOYABILITY_ENGINE_PROTOCOL.md`
- `Aurora Blueprint/AURORA_INTRADAY_GEOMETRY_PROTOCOL.md`
- `Aurora Blueprint/AURORA_WRAPPER_OBJECT_MODEL.md`

It exists so ASC can see the pressure coming from Aurora without Aurora-side files having to redesign ASC directly.

---

## Current judgment

Aurora now aligns more explicitly under ASC as foundation.

ASC lays the fields.
Aurora consumes those fields and executes downstream interpretation.

This note names the clearest next upstream requirements so ASC can grow in ways that genuinely support Aurora.
