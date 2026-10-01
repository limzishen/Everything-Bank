---
tags: [ai-edited]
---
Data Definition 

``` 
CREATE TABLE Employess(
		id INTEGER,
		name VARCHAR(50),
		age INTEGER,
		role VARCHAR(50)
);
```

## Contraints 
![[Pasted image 20251208002322.png]]
### Table constraints vs Column Contraints 
Table constraints can act on multiple column while column constraints acts on only a single column

### Named constraints vs unnamed
`CONSTRAINT emp_age_chk CHECK (age >= 18)` vs `CHECK (age >= 18)`. Named constraints show readable names in error messages and can be dropped/altered by name (`ALTER TABLE ... DROP CONSTRAINT emp_age_chk`). Unnamed ones get auto-generated names.

# Related
- [[SQL Commands]] · [[Relational Model]] · [[Relationship Exception]]
