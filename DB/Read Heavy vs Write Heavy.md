## Read Heavy 
- [[Caching | Cache]]
- Database replication (reduce latency when reading)
- Content Delivery Network (cache content geographically closer to user)
- Load balancing (Distribute incoming rea request evenly across servers)
- Optimise Query ([[Optimise Query]])
- Data Partitioning [[Sharding]]
- [[Asynchronous Query]] Processing

## Write Heavy 
- Optimise database from write 
	- Consider NoSQL DBs
	- Optimise Database Schema 
- Write Batching and Buffering
	- Batch multiple write operations 
	- [[Buffer]]
- [[Asynchronous Query]]
- [[CQRS | Command Query Responsibility Segregation]]
	- Separate read and write 