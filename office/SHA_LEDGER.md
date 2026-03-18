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
