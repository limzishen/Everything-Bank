---
tags: [ai-edited]
---
# Context Switching - threads 
## When 
- Preemptive switch 
	- Forced by kernel
	- Higher priority task runs first look [[Multi-level Feedback Queue]]
- Voluntary Switch
	- IO bound traffic, blocking on a [[Locks|mutex]] / [[Semaphore]], `sleep`, `yield`


## Mechanism
1. Kernel SysCall/interrupt 
2. Save thread A context into kernel stack -> Save kernel stack in to thread control block
3. Scheduler picks up the next threads 
4. Restore the incoming thread B context from Kernel stack from TCB
5. Switch Kernel Stack to thread B's
6. Back to user mode

## Cost
- Direct: kernel/user transition and saving/restoring registers (~1–5 µs total including scheduler work).
- Indirect (usually bigger): the incoming thread finds [[CPU Cache|L1/L2]] and branch predictors **cold**, polluted by the previous thread.
- **Process** switch (different address space): also switches page tables (CR3), so the TLB is flushed unless PCID/ASID tagging is used. A **thread** switch within the same process keeps the TLB.

> [!warning] Correction
> Caches are not *wiped* on a context switch. They stay intact but are filled with the other thread's data.


## Kernel stack 
Used during kernel interrupts 
Thread context are stored here 

## Thread context 
1. Thread register 
2. Stack pointer 
3. Programme counter 
4. Cpu States 
5. Floating Point Calculation states

# Related
- [[Thread]] · [[Process]] · [[Process Scheduling]] · [[AsyncIO]]
