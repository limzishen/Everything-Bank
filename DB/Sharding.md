Break data into smaller chunks and storing across several db servers 

## Drawbacks 
Higher query overhead 
Increase infrastructure cost 
Increase admin complexity 
uneven distribution of data 

## Benefits 
- Improve response time 
- Avoid total service outage 
- Scale efficiently(maintenance/upgrade can be done on each server without breaking the system)

# Implementation
## Database node 
A database to store logical shard. Basically a db to point to where your data is at. 

## How to shard 
### Range based 
Each server will store a range of data 

Might overload a specific range of data 

### Hashed sharding 
Hash function the primary key to look up the see which db is it storing it to 

difficulty to reassigning the hash value when you need more shards 

### Geo Sharding 
Store the shard based of customers location. 
Faster information lookup based on location due to proximity. 

uneven data distribution 

## How to optimise
### Cardinality 
max number of possible shards on the db 

### Frequency 
Probability of storing specific information on a particular shard 

### Monotonic change
As the input grows, how would your each db shard grows 