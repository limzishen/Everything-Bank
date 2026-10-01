---
tags: [ai-edited]
---
# Multithreading
Multiple threads share the same code and heap but run on different registers and stacks ([[Thread]])
Good for IO bound processes
Interleave tasks on the same processor
The [[GIL]] prevents parallel execution of Python bytecode (except in free-threaded 3.13+ builds)

## Memory Sharing
All threads see the same objects, so sharing is free but needs [[Locks]] / `threading.Lock`, `Event` ([[Threading - events]]).

# Multiprocessing
More overhead compared to multithreading (process spawn, pickling for IPC)
Each process has its **own interpreter, own GIL, and own address space**, so CPU-bound work runs truly in parallel.

> [!warning] Correction
> Processes don't share a heap because they are separate OS processes with isolated address spaces ([[Memory]]), **not** because of the GIL.

## Memory Sharing
Opt-in only: `Pipe`/`Queue` (pickled copies), `Manager` proxies (message passing), `Value`/`Array`/`shared_memory` (real shared pages via mmap). Full breakdown in [[Pray Notes]].

## Start methods
`fork` (Linux legacy default, copies the parent, unsafe with threads, see [[Fork]]), `spawn` (fresh interpreter; macOS/Windows default), `forkserver` (Linux default since 3.14).

# Rule of thumb
| Workload | Use |
| --- | --- |
| Many concurrent I/O waits | [[AsyncIO]] (or threads) |
| Blocking I/O libs | threads |
| CPU-bound pure Python | processes (or C ext / free-threaded build) |
