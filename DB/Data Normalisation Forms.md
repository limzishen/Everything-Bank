# 1NF 
Remove all duplicate primary key 
Basically enforcing the UNIQUE constraint 

# 2NF
Data used on multiple tables are combined with foreign keys 

# 3NF
#3nf 
Preserve functional dependency 
Allow for small redundancies 

## Satisfying 3NF 
Left hand side of the [[Functional Dependency |fd]] is a superkey 
or 
Right hand side of the fd is a prime attribute (an attribute that appears in a key)

## Decomposition Algo 
1. Find the minimal basis of S 
2. Combine FD, which are the same on the left side 
3. Create a table for each remaining FDs 
4. If none of the table contains the key, create a table that contains a key 
5. Remove overlaping tables




