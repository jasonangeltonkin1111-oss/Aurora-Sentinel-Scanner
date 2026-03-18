# DATA VALIDITY AND FAIL-FAST RULES

## Status
Active blueprint law.

This file defines what ASC treats as valid, invalid, incomplete, unknown, or unusable truth.

---

## Core Principle
ASC must never silently convert missing, broken, stale, or uncertain data into apparently valid truth.

If truth is weak:
- mark it weak
- mark it incomplete
- mark it unknown
- defer or exclude it

Do not guess.
Do not fake.
Do not hide failure behind placeholder values.

---

## Global Laws
- No fake `0.00` placeholders for unavailable values.
- No guessed bucket assignment.
- No guessed session state.
- No guessed historical coverage.
- No silent fallback from invalid to valid.
- No promotion of symbols whose required truth is materially broken.
- If a value is unknown, encode that it is unknown.

---

## Validity Classes

### VALID
The required source exists, parsed correctly, and passes module integrity checks.

### INCOMPLETE
Some required truth is missing, but the record is still usable for limited purposes.

### STALE
The record was once valid, but freshness has expired for the intended layer.

### UNKNOWN
Truth could not be determined without guessing.

### INVALID
The record contradicts required rules, failed integrity checks, or is structurally broken.

### UNSAFE
The truth might exist, but using it would violate downstream reliability or persistence rules.

---

## Layer-Specific Fail-Fast Rules

### Layer 1
If market-open truth cannot be determined reliably:
- do not treat symbol as open by default
- mark uncertain / unknown
- do not promote to Layer 2 until policy allows retry

### Layer 1.2
If broker specs are partially unavailable:
- snapshot only what is real
- mark missing fields explicitly
- do not invent normalized values

### Layer 2
If required classification, quotes, required history, or integrity checks fail:
- exclude symbol from promotion
- preserve reason
- do not rank invalid symbols as if valid

### Layer 3
If restore, timestamp chain, gap map, or atomic staging integrity fails:
- suspend continuation
- do not overwrite active truth destructively
- preserve forensic visibility if possible

---

## Ranking Validity Rule
Ranking must operate only on symbols that meet minimum validity requirements for ranking.

Symbols with materially broken or missing required truth may appear in logs/review surfaces, but must not be treated as trustworthy promotion candidates.

---

## Output Rule
Writers may only persist already-computed truth.
Writers must not:
- invent replacement values
- patch missing calculations by guessing
- suppress invalid state markers

---

## Completion Standard
A layer is not valid merely because files were produced.
A layer is valid only when its outputs preserve truth quality honestly, including failure and uncertainty states.
