---
tags: [ai-edited]
---
A process is a virtualization of the machine state 
Allows the os to simulate multiple cpu running 

## Memory 
Each process has its own private [[Memory|address space]]. Stores the cpu registers, Stack and heap, programme instructions when the process is created 

## Process states 
Running - the process is running 
Ready - The program can be run be OS does not allow it to run 
[[Process Scheduling]]
Blocked - The process is waiting on an event (I/O, lock) and can't run until it completes

Transitions: Ready → Running (scheduled), Running → Ready (preempted / time slice over), Running → Blocked (I/O request), Blocked → Ready (I/O done).

# Related
- [[Fork]] · [[Thread]] · [[Context Switch]] · [[Process Scheduling]]
