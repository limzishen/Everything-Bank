---
tags: [ai-edited]
---
# B-trees (B+ tree in practice)
Create a B-tree using the column you plan to index it
Sort the data, allows range query to be faster
- Data/pointers only in leaves, and leaves are linked, so range scans walk the leaf list.
- High fan-out (hundreds of keys per page), so depth is ~3–4 even for billions of rows: **O(log N)** lookups with few disk reads.
- Default index type in Postgres/MySQL. InnoDB's primary key *is* a clustered B+ tree (rows stored in PK order).

# Hash
Hash the columns
Good for exact match (`=`), O(1) average. Useless for ranges or `ORDER BY`.

# GiST
**Generalized Search Tree**: a framework for building balanced tree indexes over custom data types and operators. Used for geometric/PostGIS data, ranges (`&&` overlap), nearest-neighbour (`<->`), and full-text search.

> [!warning] Correction
> GiST isn't "a B+ tree that allows concurrent access". It's an extensible index framework for non-scalar data.

# Others (Postgres)
- **GIN**: inverted index for arrays, JSONB, full-text (many keys per row).
- **BRIN**: tiny block-range summaries for huge, naturally ordered tables (time series).

# Trade-offs
Every index costs write amplification and storage. See [[Optimise Query]] for composite/covering index rules and [[Read Heavy vs Write Heavy]].
