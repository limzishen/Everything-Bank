---
tags: [ai-edited]
---
#3nf #bcnf 

![[Pasted image 20260413000320.png]]

Have to check through the [[Functional Dependency|fd]] in S using the projected fds 
check if you can derive the main set of fds using the projected fds 
# Step 1
![[Pasted image 20260413001840.png]]
For each relation fragment Ri, compute the projected FDs: for every subset X ⊆ Ri, add `X → (X+ ∩ Ri)` (closure taken under the original S).

# Step 2
Union all projected FDs into F'. For every FD `X → Y` in the original S, compute X+ under F'. If `Y ⊆ X+` for all of them, the decomposition is dependency preserving.

# Shortcut (no explicit projection, polynomial)
```
for each X → Y in S:
    Z = X
    repeat until Z stops changing:
        for each fragment Ri:
            Z = Z ∪ ((Z ∩ Ri)+ ∩ Ri)     # closure under S
    if Y ⊄ Z: NOT preserved
```

Note: 3NF synthesis always preserves dependencies. BCNF decomposition may not.

# Related
- [[Functional Dependency]] · [[Data Normalisation Forms]] · [[Minimal Basis]]
