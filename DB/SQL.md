---
tags: [ai-edited]
---
what data to store and how much data to store 

## ERD to schema 
See [[ERD Cardinality]], [[Relationship Exception]], [[DDL]].

## Features 
- Tabular Data Model 
- Fixed schema 
- [[Acid]] Compliance 
- Structured Query Language 
- Standardise query language 
- Relational 

## Query Time Complexity
- O(log N) look up by primary key (it's a B+ tree index; O(1) only with a hash index)
- O(log N) look up for indexed column ([[DB indexing]])
- O(N) look up for non indexed column (full scan)


## Optimisation 
- [[Sharding]]
- Horizontal Partitioning (Split table by rows)
- Vertical Partitioning (Split table by columns)
- Vertical scaling (improve servers)
- Replications (Dupe the db & reduce latency issue)
-  [[Read Heavy vs Write Heavy]]

# Related
- [[SQL Commands]] · [[Acid]] · [[Optimise Query]] · [[Stored Procedure and Triggers]] · [[Data Normalisation Forms]] · [[Redis]]
