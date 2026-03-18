# SYSTEM OVERVIEW

## System Name
Aurora Sentinel Core

## Core Definition
Aurora Sentinel Core is a single-EA, broker-aware, rolling market intelligence engine. It reads existing broker state first, fills gaps instead of rebuilding blindly, maintains layered market awareness, ranks symbols inside their `PrimaryBucket`, and publishes truthful broker-level outputs for trader review.

## Role
Aurora Sentinel Core is:
- a scanner
- a classification-aware market intelligence engine
- a market-awareness engine
- a ranking and shortlisting engine
- a structured output publisher

Aurora Sentinel Core is not:
- a trade executor
- a position manager
- an account-history engine
- a monolithic one-file EA

## User Workflow
1. Load one EA per terminal.
2. On start, read existing broker state from Common Files.
3. Refresh only what is missing or stale.
4. Rebuild broker-level summary truthfully.
5. Open the broker summary file and inspect the top 5 per `PrimaryBucket`.
6. Open broker symbol files for deeper symbol review.

## Non-Negotiables
- one EA only for normal use
- broker-level outputs, not account-level outputs
- rolling persistence first
- truthful values only
- writers format only
- top 5 per `PrimaryBucket` only in summary output
- symbol detail files have exactly 3 major sections
