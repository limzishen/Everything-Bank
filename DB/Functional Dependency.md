---
tags: [ai-drafted, 3nf, bcnf]
---
`X → Y` (X functionally determines Y): any two tuples that agree on all attributes of X must also agree on all attributes of Y.

e.g. `emp_id → name, dept`, `dept → manager`

# Terminology
- **Trivial**: `Y ⊆ X` (e.g. `AB → A`). Always holds.
- **Non-trivial**: `Y ⊄ X`.
- **Decomposed**: RHS is a single attribute (`A → BC` becomes `A → B`, `A → C`).
- **Superkey**: X is a superkey iff `X+ = all attributes` (see [[Relational Model]]).
- **Prime attribute**: appears in *some* candidate key.

# Armstrong's axioms (sound + complete)
1. **Reflexivity**: if `Y ⊆ X` then `X → Y`
2. **Augmentation**: if `X → Y` then `XZ → YZ`
3. **Transitivity**: if `X → Y` and `Y → Z` then `X → Z`

Derived rules: union (`X→Y, X→Z ⇒ X→YZ`), decomposition, pseudo-transitivity.

# Attribute closure X+
Everything X determines under a set of FDs S.
```
closure = X
repeat until no change:
    for each (L → R) in S:
        if L ⊆ closure: closure = closure ∪ R
```
Uses:
- Is X a superkey? → `X+ == R`
- Is `X → Y` implied by S? → `Y ⊆ X+`
- Find candidate keys: attributes never on any RHS **must** be in every key; start from them and grow.

# Where it's used
- [[Minimal Basis]] (canonical cover)
- [[Data Normalisation Forms]] (3NF / BCNF tests + decomposition)
- [[Dependecy Preservation check]]
