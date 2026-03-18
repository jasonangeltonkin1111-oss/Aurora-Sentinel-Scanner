# SHA LEDGER

## Purpose
Track old/new SHAs for important file changes when existing files are updated.

## Rule
For each update record:
- project name
- file path
- change type (`NEW` or `UPDATE`)
- old SHA when available
- new SHA after write
- short note

## Entries
| PROJECT | FILE | TYPE | OLD SHA | NEW SHA | NOTE |
|---|---|---|---|---|---|
| Repo tightening | multiple governance and blueprint docs | UPDATE | recorded before commit | pending write | clarify authority, flat deployment, and worker ownership |
| Worker model extension | `office/EXECUTION_PROTOCOL.md` | NEW | none | pending write | one-worker execution law and post-run sequence |
| Worker model extension | `office/CLERK_RULES.md` | NEW | none | pending write | add Clerk as idle-only post-run worker |
| Worker model extension | `office/DEBUG_RULES.md` | NEW | none | pending write | add Debug as idle-only post-run worker |
| Worker model extension | multiple office docs | UPDATE | recorded before commit | pending write | align master, worker, task, and ownership rules with Clerk/Debug model |
