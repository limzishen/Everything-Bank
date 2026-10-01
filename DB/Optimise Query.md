---
tags: [ai-drafted]
---
The workflow is *measure, then change*. Don't guess.

# 1. Read the plan
```sql
EXPLAIN ANALYZE SELECT ...;   -- Postgres: actual rows, timings, loops
```
Look for:
- `Seq Scan` on a large table with a selective `WHERE` → missing index
- estimated rows far from actual rows → stale statistics (`ANALYZE`)
- `Nested Loop` with a large outer side → needs a hash/merge join or an index on the inner join key
- spills to disk on sort/hash → raise `work_mem` or shrink the input

# 2. Indexing ([[DB indexing]])
- Index columns used in `WHERE`, `JOIN ... ON`, and `ORDER BY`.
- **Composite index order matters**: `(a, b)` serves `a = ?` and `a = ? AND b = ?`, but not `b = ?` alone (leftmost-prefix rule).
- **Covering index** (`INCLUDE` cols) → index-only scan, so no heap lookups.
- An index is skipped if you wrap the column: `WHERE LOWER(email) = ?` needs an expression index; `WHERE created::date = ?` breaks a range index on `created`.
- Every index slows writes, so it's a [[Read Heavy vs Write Heavy]] trade-off.

# 3. Write the query so it can use them
- `SELECT` only the columns you need (enables covering indexes, less I/O).
- Make predicates *sargable*: `col >= x` rather than `f(col) = y`; avoid leading-wildcard `LIKE '%x'`.
- `EXISTS` over `IN (subquery)` for large sets (most modern planners treat them the same, so check the plan).
- Keyset pagination (`WHERE id > last_id LIMIT n`) instead of a large `OFFSET`.
- Kill **N+1** queries from ORMs: batch them or use a `JOIN`.

# 4. Schema / system level
- Denormalise or use materialised views for hot read paths ([[CQRS]]).
- Caching layer ([[Caching]], [[Redis]]).
- Partitioning / [[Sharding]] once a single node is the bottleneck.
- Connection pooling (PgBouncer) when connection churn dominates.

# Related
- [[SQL]] · [[SQL Commands]] · [[Asynchronous Query]]
