---
tags: [ai-edited]
---
Fast access to frequently used data, kept in a faster tier (in-process memory, [[Redis]], CDN) in front of a slower one (DB). Hardware analogue: [[CPU Cache]].

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
Invalidate (delete) the cache entry 
Load info from DB only when there is a cache miss 

Useful in write heavy system 
For example you are writing alot of not the most important stuff but wanna keep the important read stuff on cache 
Prevents cache pollution 
Slower first read after writing

# Eviction
LRU ([[LRU Cache]]), LFU, TTL-based expiry.

# Failure modes
- **Stampede / thundering herd**: a hot key expires and 1000 requests hit the DB at once. Fixes: request coalescing / lock per key, early probabilistic refresh, stale-while-revalidate.
- **Penetration**: repeated misses for keys that don't exist. Cache the negative result or use a Bloom filter.
- **Invalidation races** (cache-aside): stale write-back after a concurrent update. Delete on write rather than set, with short TTLs.

# Related
- [[Read Heavy vs Write Heavy]] · [[Dirty Flag]]
