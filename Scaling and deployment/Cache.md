Fast access to frequently used memory 

# Reads
Read are simple, miss it pull from db then store on cache 

## Cache aside 
Cache miss 
server read from DB 
Server write into cache 
Server return data 

The data might be slightly stale as its sent to the server before writing back to the cache 
The data can be modified by the server before writing back to the cache 

## Read Through 
Cache miss 
Cache read from db 
db writes into cache
cache sends the information to the server 

Less flexible compared to cache aside since db directly writes to the cache
# Writes 
## Write through 
Write into the cache 
then write into the db
Both have to succeed before success

Ensure consistency between cache and db 
Slow if DB is slow 
## Write back 
Write into the cache 
Asynchronously update the DB 

Faster than write through but comes with the risk of losing data if cache fails 
Dont use it for important data 

## Write Around 
Write information to the DB 
Dirty flag the cache 
Load info from DB only when there is a cache miss 

Useful in write heavy system 
For example you are writing alot of not the most important stuff but wanna keep the important read stuff on cache 
Prevents cache pollution 
Slower first read after writing 

