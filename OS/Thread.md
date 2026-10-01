---
tags: [ai-edited]
---
# Multithreaded Program

More than one point of execution (multiple Program Counter can fetch from and executed) 
Controlled by the THread Control Block 

![[Pasted image 20260424012639.png]]
Multiple stack are placed through out the address space 
**Thread Local**, each stack will have its own stack 

## Benefits of threads 
Enables the overlaps of activies like I?O bound activities and other activities within a single program 
Threads also share an address space so its easy to share data, but that sharing is what creates races, so you need [[Locks]] / [[Semaphore]]s.

## Thread vs process
| | Thread | Process |
| --- | --- | --- |
| Address space | shared | private ([[Memory]]) |
| Creation / switch cost | low | higher (page tables, TLB) |
| Failure isolation | one crash kills all | isolated |
| Communication | shared memory | IPC (pipes, sockets, shm), see [[Pray Notes]] |

## Hardware threads vs software threads
A CPU **core** can expose 2 **hardware threads** (SMT/Hyper-Threading) that share its execution units ([[Parallelism]]). OS threads are scheduled onto those hardware threads. More OS threads than hardware threads means time-slicing and [[Context Switch]]es.
Further reading: https://www.liquidweb.com/blog/difference-cpu-cores-thread/

# Related
- [[Process]] · [[Context Switch]] · [[GIL]] · [[Threading - events]]
