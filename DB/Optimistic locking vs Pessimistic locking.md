---
tags: [ai-edited]
---
# Pessimistic locking 
Basically similar to locks in concurrency 
``` 
BEGIN TRANSACTION; 
... YOUR ACTION

COMMIT; 

```

Rows are locked when you explicitly lock them, and held until the transaction ends:
```sql
BEGIN;
SELECT balance FROM wallets WHERE user_id = 1 FOR UPDATE;  -- row lock; other writers block
UPDATE wallets SET balance = balance - 60 WHERE user_id = 1;
COMMIT;
```

> [!warning] Correction
> `BEGIN TRANSACTION` alone doesn't lock what you read. Under MVCC (Postgres, InnoDB) plain `SELECT`s take no row locks. You need `SELECT ... FOR UPDATE` / `FOR SHARE` (or SERIALIZABLE isolation).

Good when conflicts are frequent. Risks: deadlocks ([[Coffman Conditions]]) and blocked throughput.

# Optimistic locks 

```
UPDATE wallets
SET 
    balance = balance - 60,
    version = version + 1       -- increment version
WHERE 
    user_id = 1
    AND version = 0;            -- the critical check
```

Basically have an id version. Check if the version is valid before updating 
If there are Write from a different thread after read the version ID will be different 

If `UPDATE` affects **0 rows**, someone else won, so re-read and retry (or report a conflict).
Good when conflicts are rare (read-heavy, short transactions). No locks are held, but heavy contention means retry storms.
Same idea as a CPU [[Compare and Swap (CAS)|CAS]] loop.

# Related
- [[Acid]] · [[Locks]] · [[Compare and Swap (CAS)]]
