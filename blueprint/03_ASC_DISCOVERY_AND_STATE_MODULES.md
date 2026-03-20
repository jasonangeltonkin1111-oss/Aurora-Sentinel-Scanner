# ASC Discovery and State Modules

## Purpose

This document defines the retrieval side of ASC.
These modules gather truth and store it.
They do not decide behavior.

## Core retrieval law

Every retrieval module follows:
- collector
- store
- accessor

### Collector
Fetches data and updates stored state.

### Store
Owns the latest in-memory record.

### Accessor
Returns one requested field cheaply from stored state.
It must never trigger full recollection.

## Canonical discovery modules

### 1. SymbolSpecs
Purpose:
Capture static and semi-static broker-defined symbol properties.

This module defines:
- what the broker says is allowed
- what the structural symbol constraints are

This module does not define:
- open/closed state
- filtering
- ranking
- selection
- session interpretation

#### Core data families
- pricing structure
- contract rules
- spread and execution rules
- trading permissions
- volume rules
- margin rules
- swap rules
- currency rules
- session capture
- optional broker metadata

#### Design rules
- query all known properties
- store raw values where possible
- leave missing fields empty or explicitly unavailable
- never invent missing values
- support broker variation

#### Scheduling
- on init
- on symbol universe change
- optional slow refresh only when justified

### 2. MarketWatchFeed
Purpose:
Capture all live observable columns from Market Watch.

This module defines:
- what the platform is currently showing
- whether the feed is present or stale

This module does not define:
- tradability policy
- filtering
- ranking
- selection
- validation against specs

#### Core data families
- bid and ask
- high and low
- bid high and bid low
- ask high and ask low
- open and close
- spread
- daily change
- last tick time
- capture time
- tick presence
- staleness state

#### Design rules
- pull latest observable data
- detect no tick
- detect stale tick
- store snapshot in memory
- do not repair missing feed data
- do not guess feed data

#### Scheduling
- heartbeat-driven
- due-based by symbol
- high cadence for relevant open symbols
- lower pressure for known closed symbols where appropriate

## Presence and completeness law

Both modules must support the difference between:
- available
- missing
- unreadable
- unsupported
- not yet collected

A zero value is not enough to express that honestly.

## State ownership law

Discovery modules own retrieval truth only.
They do not own:
- filter decisions
- top-list membership
- deep-analysis metrics
- output wording

## Accessor examples

### SymbolSpecs accessors
- `GetDigits(symbol)`
- `GetPoint(symbol)`
- `GetTickSize(symbol)`
- `GetTradeMode(symbol)`
- `GetVolumeMin(symbol)`
- `GetMarginCurrency(symbol)`

### MarketWatchFeed accessors
- `GetBid(symbol)`
- `GetAsk(symbol)`
- `GetDailyChange(symbol)`
- `GetLastTickTime(symbol)`
- `HasTick(symbol)`
- `IsStale(symbol)`

All accessors read stored state only.
