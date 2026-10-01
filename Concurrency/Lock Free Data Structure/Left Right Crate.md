---
tags: [ai-edited]
---
https://www.youtube.com/watch?v=tND-wBBZ8RY
# Issue
**Mutex** 
requires writer and reader to aquire locks on the memory to read or write 
This is slow because you can only read one at a time

**Reader writer locks**
Allow multiple reader to read concurrently 
Even though performance might seems good for High ratio of reads to writes 
There are problems with this due to the [[CPU Cache]] and the [[MESI protocol]] 
Each time a reader tries to acquire a lock, it must write the global reader count, which invalidates that cache line in every other core's private L1/L2 (L3 is usually shared)
The cross core validation is really expensive
Reader writer requires a write i.e. writing to the global count of readers

# How Left Right Crate solves this kinda 
Have 2 section of data. 
A pointer to point to the data that can be read 
The write will write to the other crate of data 
once the writer finishes writing, flip the pointer (an atomic store / [[Compare and Swap (CAS)|CAS]]), wait until no reader is still on the old copy (per-reader epoch counters), then replay the same op on the old copy.

Reads are **wait-free** and never touch a shared write location. Writers are serialised and must wait for readers, so it's not lock-free on the write side. The costs are 2× memory and every write applied twice.

# problems with this 
![[Pasted image 20260414235324.png]]

# Related
- [[Locks]] · [[Compare and Swap (CAS)]] · [[Project Idea]] · [[Summer 2026 Plans]]
