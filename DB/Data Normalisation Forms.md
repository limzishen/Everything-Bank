# 1NF 
Remove all duplicate primary key 
Basically enforcing the UNIQUE constraint 

# 2NF
Data used on multiple tables are combined with foreign keys 

# Lossless decomposition 
## How to check  
Take the intersection between 2 relation 
Check if the intersection is the superkey for the relation 

# 3NF
#3nf 
Preserve functional dependency 
Allow for small redundancies 

## Satisfying 3NF 
Left hand side of the [[Functional Dependency |fd]] is a superkey 
or 
Right hand side of the fd is a prime attribute (an attribute that appears in a key)

## Decomposition Algo 
1. Find the [[Minimal Basis]] of S 
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







