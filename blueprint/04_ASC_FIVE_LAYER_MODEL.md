# ASC Five-Layer Model

## Purpose

This document defines the current processing model for ASC.
The layer names are internal architecture names and must remain searchable and stable.
They are not trader-facing labels.

## LAYER_1_OPEN_CLOSED_STATE

### Purpose
Determine whether each symbol is open or closed and decide when it should be checked again.

### Owns
- boot restore support for open-state continuity
- live tick reality check
- session-schedule capture use for recheck timing
- next open/closed recheck scheduling
- base symbol-file creation
- placeholder-section creation

### Does not own
- deep calculations
- filtering
- ranking
- summary creation

### Runtime law
- live tick reality first
- session schedule second
- restored persisted state as support
- closed symbols do not get pointless every-second checks forever
- closed symbols get next likely open scheduling
- near expected open, aggressive 1-second rechecks may run for up to 1 minute

## LAYER_2_OPEN_SYMBOL_SNAPSHOT

### Purpose
Capture a controlled snapshot of open symbols only.

### Owns
- open-symbol snapshot assembly
- static specs merge for open symbols
- changing Market Watch snapshot writes on controlled cadence
- atomic writes for Layer 2 owned sections

### Does not own
- filtering
- ranking
- deep analysis

### Runtime law
- specs are reboot-time or slow-refresh data
- live Market Watch fields are scheduled changing data
- changing fields should not be rewritten every second without reason
- current target cadence for changing fields is 10 seconds

## LAYER_3_FILTER

### Purpose
Reduce the open universe to symbols worth further attention using cheap checks only.

### Owns
- validity gate
- cheap tradability gate
- cheap characterization
- bucket assignment for survivors

### Does not own
- deep indicator engines
- heavy history work
- final ranking authority

### Typical cheap checks
- spread too wide
- stale or suspicious feed
- weak movement
- low activity
- missing critical values
- invalid bucket eligibility

## LAYER_4_TOP_LIST_SELECTION

### Purpose
Rank filtered symbols inside each bucket and choose the bounded active set.

### Owns
- bucket competition
- score composition for selection
- top-list cut
- anti-churn and stability controls
- final selected-set authority for Layer 5 entry

### Does not own
- full deep analysis
- raw discovery

### Runtime law
- selection remains bounded
- around 90 symbols is considered manageable for deep selective work on the largest broker
- membership should not flap constantly

## LAYER_5_DEEP_SELECTIVE_ANALYSIS

### Purpose
Maintain high-detail rolling analytics only for the final selected set from Layer 4.

### Owns
- last-minute tick memory
- tick-buffer flush scheduling
- OHLC by timeframe
- ATR by timeframe
- selective indicator refreshes by timeframe
- deep-analysis publication blocks

### Does not own
- broad-universe scanning
- cheap first-pass filtering

### Runtime law
- selected-set only
- tick data is maintained continuously in memory and written on schedule
- ATR target cadence is currently 10 seconds
- OHLC updates follow timeframe boundaries and forming-bar refresh rules
- not every field updates at the same cadence

## Cross-layer law

The five layers are ordered.
They must not collapse into one giant function.
Each layer owns its meaning and its publication blocks.
