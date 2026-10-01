---
tags: [ai-edited]
---
# Transaction 
A process where by changes or query are made to the database 
# Atomicity 
If any query or changes fails, the entire set of processes is cancelled. 
Prevents incorrect  data entry/changes in database systems 
# Consistency 
A transaction moves the DB from one valid state to another: constraints, FKs, and [[Stored Procedure and Triggers|triggers]] hold. Mostly defined by the app/dev.
# Isolation
Ability to concurrently process multiple transactions, each one running as if it were alone.
The strongest level is **serialisable**: the result equals *some* serial order of the transactions.

> [!warning] Correction
> ACID has no separate "Concurrency" property. Serialisability is the strongest form of **Isolation**.

## Isolation levels (SQL standard) and the anomalies they allow
| Level | Dirty read | Non-repeatable read | Phantom |
| --- | --- | --- | --- |
| Read Uncommitted | yes | yes | yes |
| Read Committed (Postgres default) | no | yes | yes |
| Repeatable Read | no | no | yes (no in Postgres, which uses snapshots) |
| Serializable | no | no | no |

Implemented with locks ([[Optimistic locking vs Pessimistic locking]]) or MVCC snapshots.
# Durability 
Once committed, effects survive crashes and power loss. Implemented with a write-ahead log (WAL) fsync'd before the commit is acknowledged.

# Related
- [[SQL]] · [[Redis]] · [[Relational Model]]
