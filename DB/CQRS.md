Read side and Write side can be in separated datastore 
![[Pasted image 20250919000556.png]]
On write side: 
Implement write logic 
Optimise it for transaction integrity (normalised schema, strong consistency)

On read side: 
- The **read model** can be optimised for speed (denormalised tables, caches, indexes, even search engines like Elasticsearch).

# Benefits 
- Improved security 
	- **Command side** enforces strict validation, business rules, and permissions.
	- **Query side** can expose a simpler, read-only API without worrying about accidental modifications.
- Optimised schema
	- Read will use a schema optimised for reading 
	- Write will have a schema optimised for security and reliability 
- simpler query 
