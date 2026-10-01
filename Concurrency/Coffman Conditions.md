---
tags: [ai-edited]
---
Four conditions that must **all** hold for a deadlock. They are *necessary*; they are also *sufficient* when each resource has a single instance. Break any one to prevent deadlock.
https://cs341.cs.illinois.edu/coursebook/Deadlock

# Mutual Exclusion 
A mutex is in place where the resources can only be held by one thread

# Circular wait 
A Cyclic dependency graph is formed across threads 
look Philosopher Dining Problem 

# Hold and wait 
Once a resource is obtained, a process keeps the resource locked.

# No preemption 
A resource can't be forcibly taken away from the thread holding it; it is only released voluntarily.

> [!warning] Correction
> "No preemption" is about **resources**, not CPU scheduling. A preemptive OS scheduler still deadlocks if locks can't be revoked.

# Breaking each condition
| Condition | Prevention |
| --- | --- |
| Mutual exclusion | lock-free / immutable data ([[Compare and Swap (CAS)]], [[Left Right Crate]]) |
| Hold and wait | acquire all locks at once (`std::scoped_lock(a, b)`) |
| No preemption | `try_lock` + back off and release what you hold |
| Circular wait | global **lock ordering** (most practical) |

**Livelock**: threads keep reacting to each other (e.g. both back off and retry in lockstep) and make no progress while not blocked. Fix with randomised backoff.

# Related
- [[Locks]] · [[Semaphore]] · [[Lamport Bakery algorithm]] · [[Producer Consumer Problem]]
