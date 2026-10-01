---
tags: [ai-edited]
---
Remote Dictionary Server 
Redis stores data in the RAM instead of hard disk 
When persistence is needed a snapshot of the ram is made and stored on the disk 
Redis is not the more durable (ex. power outages) causing ram data to be lost 
Redis take snapshot of the ram to create save points on the hard disk

# Persistence
- **RDB**: periodic point-in-time snapshot (fork + copy-on-write, see [[Fork]]). Compact, but you lose writes since the last snapshot.
- **AOF** (append-only file): logs every write; `appendfsync everysec` loses at most ~1 s. Combine both for safety.

# Why it's fast
In-memory, single-threaded command execution (no locks), I/O multiplexing (epoll). Since 6.0 it uses I/O threads for network reads/writes.

# Common uses
[[Caching|Cache]] (with TTL + LRU/LFU eviction, see [[LRU Cache]]), sessions, rate limiters (`INCR` + `EXPIRE`), leaderboards (sorted sets, which are skip lists), pub/sub, distributed locks (Redlock, which is contested).

# Related
- [[Read Heavy vs Write Heavy]] · [[Acid]]
