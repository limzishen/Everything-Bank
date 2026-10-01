---
tags: [ai-edited]
---
# 1NF
Every attribute value is **atomic** (no lists/sets in a cell, no repeating groups like `phone1, phone2`), and every row is uniquely identifiable.

# 2NF
1NF + no **partial dependency**: no non-prime attribute depends on only *part* of a composite candidate key.
e.g. `(student_id, course_id) → grade` is fine, but `course_id → course_name` violates 2NF, so move it to its own table.

> [!warning] Correction
> The previous definitions (1NF = unique primary key, 2NF = join with foreign keys) weren't the actual normal forms.

# Lossless decomposition 
## How to check  
Take the intersection between 2 relation 
Check if the intersection is the superkey for the relation 

# 3NF
#3nf 
Always achievable while staying lossless **and** [[Dependecy Preservation check|dependency preserving]]
Allows small redundancies (BCNF doesn't, but may lose dependency preservation)

## Satisfying 3NF 
Left hand side of the [[Functional Dependency |fd]] is a superkey 
or 
Right hand side of the fd is a prime attribute (an attribute that appears in a key)

## Decomposition Algo 
1. Find the [[Minimal Basis]] of S (needs [[Functional Dependency]] closure)
2. Combine FD, which are the same on the left side 
3. Create a table for each remaining FDs 
4. If none of the table contains the key, create a table that contains a key 
5. Remove overlaping tables

# BCNF 
## Satisfying BCNF 
1. Derive non-trivial non decomposed fd (use closure on all permutation of attribute)
2. Each non-trivial non decomposed is a key 

Alternatively 
use **more but not all**
Find the closure of each subset 
Check if the closure is a superkey or trivial 
If not either, it violates the BCNF 

## Decomposition algo 
1. Find the subset of attibute that violates BCNF 
2. Split it into 2 relation {X}+ and X and {X'}
3. Rinse and repeat on both relation

# Related
- [[Functional Dependency]] · [[Minimal Basis]] · [[Dependecy Preservation check]] · [[Relational Model]]
