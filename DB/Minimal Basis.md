# Conditions
S is the main set of functional dependency
1. Every [[Functional Dependency|fd]] can be derived from S 
2. Every fd is non trivial and decomposed 
3. No fd in the minimal basis is redundant 
4. no attribute on the lhs is redundant 

# Algo 
1. Decomposed each fd 
2. remove redundant attribute on the lhs 
	1. Cover a attribute on the rhs 
	2. Check if the fd is still implied by S 
3. Remove redundant fd