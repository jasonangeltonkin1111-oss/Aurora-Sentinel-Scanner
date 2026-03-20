# ASC TO AURORA CONTEXT CONTRACT

## PURPOSE

This file defines the minimum structured context ASC must publish so Aurora can interpret market state, execution surface, family eligibility, deployability, and later generated strategy cards without inventing missing truth.

It exists to prevent architectural drift between:
- ASC as the scanner / market-truth foundation
- Aurora as the doctrine / interpretation / wrapper layer

This file does not redesign ASC.
It converts the existing dossier / state philosophy into an explicit bridge contract.

---

# 1. ROOT LAW

ASC owns measured world truth.
Aurora consumes that truth and is not allowed to fabricate it.

If ASC has not provided a required surface, Aurora must:
- mark the surface as missing
- degrade confidence or deployability accordingly
- request the missing surface explicitly
- avoid pretending certainty

Aurora must never silently fill absent ASC truth with doctrine-shaped guesses.

---

# 2. WHAT ASC OWNS

ASC owns:
- symbol identity truth
- asset-class and bucket identity truth
- market-open / market-closed truth
- tick freshness truth
- schedule / session / next-check truth
- publication freshness truth
- execution-surface telemetry that can be measured
- spread / friction / quote-health telemetry
- runtime degradation / unavailable / stale states

ASC does not own:
- strategy doctrine
- family routing conclusions
- pattern interpretation
- trade geometry
- entry / stop / target conclusions
- wrapper narratives

---

# 3. WHAT AURORA OWNS

Aurora owns:
- market-state interpretation
- execution-surface interpretation
- hostility interpretation
- family competition and family rejection
- pattern competition and pattern rejection
- deployability interpretation using ASC truth
- generated strategy cards
- wrapper / later EA-safe output preparation

Aurora does not own:
- inventing spread, session, or tradability truth
- inventing symbol state when ASC is stale or missing
- replacing missing telemetry with narrative certainty

---

# 4. MINIMUM REQUIRED ASC CONTEXT OBJECT

Aurora should not attempt full interpretation unless ASC can provide a minimum context object per symbol.

## 4.1 Identity block
Required:
- `symbol`
- `canonical_symbol`
- `asset_class`
- `primary_bucket`
- `description` if available
- `server_identity`

## 4.2 Runtime / publication block
Required:
- `lifecycle_state`
- `runtime_mode`
- `last_seen_in_universe`
- `last_published`
- `publication_health`
- `publication_state_class`

## 4.3 Market status block
Required:
- `current_market_status`
- `status_note`
- `tick_present`
- `tick_age_seconds`
- `evidence_confidence`
- `reason_code` if degraded / unavailable

## 4.4 Schedule / session block
Required:
- `last_check`
- `next_check`
- `within_trade_session`
- `current_session_label` if known
- `next_session_open`
- `minutes_to_session_close` if known

## 4.5 Execution / friction block
Required for deployability-aware interpretation:
- `current_spread`
- `rolling_median_spread`
- `spread_state_class`
- `spread_instability_flag`
- `quote_health_state`
- `stale_tick_risk`
- `execution_continuity_state`

## 4.6 Optional but high-value block
Helpful later:
- `abnormal_gap_flag`
- `snapshot_change_rate`
- `range_expansion_state`
- `compression_state`
- `selection_rank`
- `top_list_membership`
- `cross_asset_pressure_flags`
- `event_proximity_flag`

---

# 5. CONTEXT STATE CLASSES

Any ASC field used by Aurora must be expressible as one of:
- present
- pending
- reserved
- unavailable
- unsupported
- stale
- degraded
- invalid

Aurora must preserve these classes.
It must not collapse them into:
- `0`
- empty string
- assumed normality

---

# 6. REQUIRED BRIDGE BEHAVIOR INSIDE AURORA

## 6.1 If identity truth is missing
Aurora must not create a family or pattern card.
It may only log:
- context unusable
- identity incomplete

## 6.2 If market status truth is stale or degraded
Aurora may preserve observe-only analysis, but must not promote eligibility as if market truth were fresh.

## 6.3 If execution / friction truth is missing
Aurora may still interpret structure, but must mark deployability as:
- unknown
- pending
or
- observe-only

## 6.4 If session truth is missing
Aurora must avoid time-sensitive geometry confidence and flag session surface insufficiency.

---

# 7. MINIMUM AURORA INPUT CONTRACT

Aurora should receive ASC context as a structured object or equivalent stable dossier extraction containing at least:
- `identity`
- `runtime_publication_state`
- `market_status`
- `schedule_session`
- `execution_friction`

This contract should remain machine-readable even if the dossier itself stays human-readable.

---

# 8. WHY THIS FILE EXISTS

Without this bridge file, Aurora risks becoming generic in a hidden way:
- making bucket assumptions instead of reading live truth
- making spread assumptions instead of reading measured friction
- making session assumptions instead of reading schedule state
- creating false deployability from incomplete data

This file prevents that.

---

# 9. CURRENT JUDGMENT

ASC and Aurora now have an explicit ownership bridge:
- ASC publishes measured context truth
- Aurora interprets that truth into doctrine outputs

This is the minimum contract required before deployability, generated strategy cards, and later EA-safe outputs can become trustworthy.
