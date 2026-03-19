# FILE LOCKS

## Purpose
Prevent parallel workers from editing the same file at the same time.

## Rules
- a file must be locked before a worker edits it
- only the lock owner may modify a locked file
- locks should reference the assigned project name
- locks should be released when the handoff is written

## Locked Files
| FILE | OWNER | PROJECT | STARTED |
|---|---|---|---|
| none | none | none | none |
