# Transaction 
A process where by changes or query are made to the database 
# Atomicity 
If any query or changes fails, the entire set of processes is cancelled. 
Prevents incorrect  data entry/changes in database systems 
# Consistency 
Consistency in data 
Defined by dev 
But ensure referential integrity is consistent 
# Concurrency 
Concurrent execution of transaction should be serialisable
The output should be deterministic which is the same as the serialisation of the execution of the transactions
# Isolation 
Ability to concurrently process multiple transaction 
Process each transaction concurrently without affecting other transaction
# Durability 
DB wont fail if there is power outage and stuff 
Effects of the transaction is permanent 

