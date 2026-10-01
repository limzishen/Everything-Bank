---
tags: [ai-edited]
---
# Conditions
S is the main set of functional dependency
1. Every [[Functional Dependency|fd]] can be derived from S 
2. Every fd is non trivial and decomposed 
3. No fd in the minimal basis is redundant 
4. no attribute on the lhs is redundant 

# Algo 
1. Decomposed each fd 
2. remove redundant attribute on the lhs 
	1. For `XA → B`, try dropping A: compute X+ under S
	2. If B ∈ X+, then A is redundant, so replace the FD with `X → B`
3. Remove redundant fd: drop `X → A` if A ∈ X+ computed under the *remaining* FDs

Order matters: reduce the LHS **before** removing redundant FDs.

# Related
- [[Functional Dependency]] · [[Data Normalisation Forms]]
